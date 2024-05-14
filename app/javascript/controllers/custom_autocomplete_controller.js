import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "hidden"];

  connect() {
    this.inputTarget.addEventListener('input', this.updateHidden.bind(this));
  }

  updateHidden() {
    this.hiddenTarget.value = this.inputTarget.value;
  }
}
