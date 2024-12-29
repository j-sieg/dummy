import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["linkToFollow"]

  click(event) {
    const el = event.target

    if (["A", "BUTTON"].includes(el.tagName)) {
      if (el != this.linkToFollowTarget) {
        // Run with the default behavior
      } else {
        this.followLink()
      }
    } else {
      this.followLink()
    }
  }

  followLink() {
    this.linkToFollowTarget.click()
  }
}
