import { Controller } from "@hotwired/stimulus"
import { cable } from "@hotwired/turbo-rails"
import { VideoFX } from "../video_fx/index"

// We need this for listening to RTCPeerConnection's onconnectionstatechange
import "webrtc-adapter"

export default class WebrtcController extends Controller {
  static targets = ["callButton", "video"]
  static values = {
    channel: String,
    channelName: String
  }

  async connect() {
    this.videoFx = new VideoFX()
    this.config = {
      isPolite: false,
      isMakingOffer: false,
      isIgnoringOffer: false,
      isSettingRemoteAnswerPending: false,
      rtcConfig: null,
      mediaConstraints: {audio: false, video: true}
    }
    this.peer = { connection: new RTCPeerConnection(this.config.rtcConfig) }
    window.peer = this.peer
    this.requestUserMedia()
  }

  async disconnect() {
    if (this.consumer) this.leaveCall()
  }

  /**
   * DOM Functions
   */
  async handleCallButton() {
    const buttonText = this.callButtonTarget.textContent.trim()
    switch(buttonText) {
      case "Join Call":
        await this.joinCall()
        this.callButtonTarget.textContent = "Leave Call"
        break

      case "Leave Call":
        await this.leaveCall()
        this.callButtonTarget.textContent = "Join Call"
        break
    }
  }

  async joinCall() {
    this.consumer = await cable.subscribeTo({ channel: this.channelValue, name: this.channelNameValue })

    if (!this.consumer) {
      console.log("Failed to join call")
      return
    }

    this.setupConsumerCallbacks()
  }

  async leaveCall() {
    await this.consumer.unsubscribe()
    this.resetPeer(this.peer)
  }

  resetPeer(peer) {
    this.displayStream("#peer", null)
    peer.connection.close()
    peer.connection = new RTCPeerConnection(this.config.rtcConfig)
  }

  /**
   * Consumer Functions
   */
  setupConsumerCallbacks() {
    this.consumer.connected = this.handleConnected.bind(this)
    this.consumer.disconnected = this.handleDisconnected.bind(this)
    this.consumer.received = this.handleReceived.bind(this)
  }

  handleConnected() {
    console.log("connected to the signaling server")
    this.establishCallFeatures(this.peer)
  }

  handleDisconnected() {
    console.log("disconnected from the signaling server")
    this.resetPeer(this.peer)
  }

  handleReceived(data) {
    const eventName = data.event_name

    switch(eventName) {
      case "peer_joined":
        this.handlePeerJoined(data)
        break
      case "peer_left":
        this.handlePeerLeft(data)
        break
      case "signal":
        this.handleSignal(data)
        break
    }
  }

  handlePeerJoined(data) {
    if (this.isBroadcastingToSelf(data.peer_id)) return

    // This is triggered by the next person to come in, making the
    // first the "polite" one. This value is used in setting up the
    // peer connection.
    this.config.isPolite = true
  }

  handlePeerLeft(data) {
    console.log("handlePeerLeft", data)
    this.resetPeer(this.peer)
    this.establishCallFeatures(this.peer)
  }

  // Setting up peer connection
  async handleSignal(broadcastData) {
    if (this.isBroadcastingToSelf(broadcastData.peer_id)) return

    const { data } = broadcastData
    const { description, candidate } = data

    // Work with an incoming description
    if (description) {
      const readyForOffer =
        this.config.isMakingOffer &&
        (this.peer.connection.signalingState === "stable" || this.config.isSettingRemoteAnswerPending)

      const offerCollision = description.type == "offer" && !readyForOffer

      this.config.isIgnoringOffer = !this.config.isPolite && offerCollision

      // Note: Only impolite peers ignore offers
      if (this.config.isIgnoringOffer) {
        return
      }

      this.config.isSettingRemoteAnswerPending = description.type === "answer"
      await this.peer.connection.setRemoteDescription(description)
      this.config.isSettingRemoteAnswerPending = false

      // Respond to offer signals
      if (description.type === "offer") {
        await this.peer.connection.setLocalDescription()
        this.consumer.perform("signal", {description: this.peer.connection.localDescription})
      }
    }
    // Work with an incoming ICE candidate
    else if (candidate) {
      try {
        await this.peer.connection.addIceCandidate(candidate)
      } catch(e) {
        if (!this.config.isIgnoringOffer && candidate.candidate.length > 1) {
          console.error("Unable to add ICE candidate for peer:", e)
        }
      }
    }
  }

  /**
   * User-Media and Data Channel Functions
   */
  async requestUserMedia() {
    // https://developer.mozilla.org/en-US/docs/Web/API/MediaStream
    // Adding a MediaStreamTrack to the MediaStream
    this.stream = await navigator.mediaDevices.getUserMedia(this.config.mediaConstraints)
    this.displayStream("#" + this.videoTarget.id, this.stream)
  }

  // https://developer.mozilla.org/en-US/docs/Web/API/RTCPeerConnection/addTrack
  // "... adds a new media track to the set of tracks which will be transmitted to the other peer"
  addStreamingMedia(peer, stream) {
    if (stream) {
      for (let track of stream.getTracks()) {
        peer.connection.addTrack(track, stream)
      }
    }
  }

  displayStream(selector, stream) {
    document.querySelector(selector, stream).srcObject = stream
  }

  addChatChannel(peer) {
    peer.chatChannel = peer.connection.createDataChannel("text_chat", {
      negotiated: true, id: 50
    })

    peer.chatChannel.onmessage = (event) => {
      this.appendMessage("peer", "#chat-log", event.data)
    }

    peer.chatChannel.onclose = (_event) => {
      console.log("Chat channel closed")
    }
  }

  /**
   * Peer WebRTC Functions and Callbacks
   */
  registerRtcCallbacks(peer) {
    peer.connection.ondatachannel = this.handleRtcDataChannel.bind(this)
    peer.connection.onconnectionstatechange = this.handleRtcConnectionStateChange.bind(this)
    peer.connection.onnegotiationneeded = this.handleRtcConnectionNegotiation.bind(this)
    peer.connection.onicecandidate = this.handleRtcIceCandidate.bind(this)
    peer.connection.ontrack = this.handleRtcPeerTrack.bind(this)
  }

  handleRtcPeerTrack({ track, streams: [stream] }) {
    console.log("Attempting to display media from peer")
    this.displayStream("#peer", stream)
  }

  /**
   * Reusable WebRTC Functions
   */
  handleRtcIceCandidate({ candidate }) {
    console.log("Handling the ICE candidate...")
    this.consumer.perform("signal", {candidate: candidate})
  }

  async handleRtcConnectionNegotiation() {
    this.config.isMakingOffer = true
    console.log("Making an offer...")
    await this.peer.connection.setLocalDescription()
    this.consumer.perform("signal", {description: this.peer.connection.localDescription})
    this.config.isMakingOffer = false
  }

  handleRtcConnectionStateChange() {
    const connectionState = this.peer.connection.connectionState
    console.log(`The connection state is now ${connectionState}`)
    document.querySelector("body").className = `connection-state-${connectionState}`
  }

  handleRtcDataChannel({ channel }) {
    const label = channel.label
    console.log(`Data channel added for ${label}`)

    if (label.startsWith("filter-")) {
      document.querySelector("#peer").className = label
      channel.onopen = () => channel.close()
    } else {
      console.log(`Opened ${label} channel with an ID of ${channel.id}`)
    }
  }

  /**
   * Call Features & Reset Functions
   */
  establishCallFeatures(peer) {
    this.registerRtcCallbacks(peer)
    this.addChatChannel(peer)
    this.addStreamingMedia(peer, this.stream)
  }

  /**
   * Video Effect Functions
   */

  handleSelfVideo(event) {
    if (this.peer.connection.connectionState !== "connected") return
    const filterName = this.videoFx.cycleFilter()

    const filterDataChannel = this.peer.connection.createDataChannel(`filter-${filterName}`)
    filterDataChannel.onclose = () => {
      console.log(`Remote peer has closed the ${filterName} data channel`)
    }

    event.currentTarget.className = `filter-${filterName}`
  }

  /**
   * Chat-related Functions
   */

  handleMessageForm(event) {
    event.preventDefault()
    const input = document.getElementById("chat-msg")
    const message = input.value

    if (message === "") return

    this.appendMessage("self", "#chat-log", message.trim())
    this.peer.chatChannel.send(message)
    input.value = ""
  }

  appendMessage(sender, logElement, message) {
    const log = document.querySelector(logElement)
    const li = document.createElement("li")
    li.className = sender
    li.textContent = message
    log.appendChild(li)

    if (log.scrollTo) {
      log.scrollTo({
        top: log.scrollHeight,
        behavior: "smooth"
      })
    }
  }

  /**
   * Helpers
   */
  isBroadcastingToSelf(peerId) {
    return this.currentUserId == peerId
  }

  get currentUserId() {
    return document.querySelector("meta[name='current-user-id']").content
  }
}
