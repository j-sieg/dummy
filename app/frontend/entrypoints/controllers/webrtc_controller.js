import { Controller } from "@hotwired/stimulus"
import { cable } from "@hotwired/turbo-rails"

export default class WebrtcController extends Controller {
  static targets = ["callButton", "video"]
  static values = {
    channel: String,
    channelName: String
  }

  async connect() {
    this.config = {
      isPolite: false,
      isMakingOffer: false,
      isIgnoringOffer: false,
      isSettingRemoteAnswerPending: false,
      rtcConfig: null,
      mediaConstraints: {audio: false, video: true}
    }
    this.peer = { connection: new RTCPeerConnection(this.config.rtcConfig) }
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
        break;

      case "Leave Call":
        await this.leaveCall()
        this.callButtonTarget.textContent = "Join Call"
        break;
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
    // TODO: disable the camera
  }

  /**
   * Consumer Functions
   */
  setupConsumerCallbacks() {
    this.consumer.connected = this.handleConnected.bind(this)
    this.consumer.disconnected = this.handleDisconnected.bind(this)
    this.consumer.received = this.handleReceived.bind(this)
  }

  // Connected to the signaling server
  handleConnected() {
    console.log("connected")
    this.establishCallFeatures(this.peer)
  }

  handleDisconnected() {
    console.log("disconnected")
  }

  handleReceived(data) {
    const eventName = data.event_name

    switch(eventName) {
      case "peer_joined":
        this.handlePeerJoined(data)
        break;
      case "peer_left":
        this.handlePeerLeft(data)
        break;
    }
  }

  handlePeerJoined(data) {
    if (this.isBroadcastingToSelf(data.peer_id)) return

    // Make yourself the polite one if you were here first
    this.config.isPolite = true
  }

  handlePeerLeft(data) {
    console.log("handlePeerLeft", data)
  }

  /**
   * User-Media Functions
   */
  async requestUserMedia() {
    this.stream = new MediaStream()
    const media = await navigator.mediaDevices.getUserMedia(this.config.mediaConstraints)
    const mediaTracks = media.getTracks()
    this.stream.addTrack(mediaTracks[0])
    this.displayStream("#" + this.videoTarget.id, this.stream)
  }

  addStreamingMedia(peer, stream) {
    if (stream) {
      for(let track of stream.getTracks()) {
        peer.connection.addTrack(track)
      }
    }
  }

  displayStream(selector, stream) {
    document.querySelector(selector, stream).srcObject = this.stream
  }

  /**
   * Peer WebRTC Functions and Callbacks
   */
  registerRtcCallbacks(peer) {
    peer.connection.onnegotiationneeded = this.handleRtcConnectionNegotiation.bind(this)
    peer.connection.onicecandidate = this.handleRtcIceCandidate.bind(this)
    peer.connection.ontrack = this.handleRtcPeerTrack.bind(this)
  }

  handleRtcPeerTrack() {
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

  /**
   * Call Features & Reset Functions
   */
  establishCallFeatures(peer) {
    this.registerRtcCallbacks(peer)
    this.addStreamingMedia(peer, this.stream)
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
