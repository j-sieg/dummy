import { Controller } from "@hotwired/stimulus"
import { cable } from "@hotwired/turbo-rails"

export default class WebrtcController extends Controller {
  static targets = ["callButton"]
  static values = {
    channel: String,
    channelName: String
  }

  async disconnect() {
    if (this.consumer) this.leaveCall()
  }

  /*
    DOM functions
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
  }

  /*
    Consumer functions
  */
  setupConsumerCallbacks() {
    this.consumer.connected = this.handleConnected
    this.consumer.disconnected = this.handleDisconnected
    this.consumer.received = this.handleReceived
  }

  handleConnected() {
    console.log("connected", this)
  }

  handleDisconnected() {
    console.log("disconnected", this)
  }

  handleReceived(data) {
    console.log("received", data)
  }
}
