import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["dialog"]

  connect() {
    const value = this.data.get("value");
    if (value == "true") {
      this.dialogTarget.showModal();
    }
  }

  close() {
    this.dialogTarget.close();
  }
}
