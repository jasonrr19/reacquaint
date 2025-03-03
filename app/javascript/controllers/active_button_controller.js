import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="active-button"
export default class extends Controller {
  static targets = ["link"];
  connect() {
  }
  toggle(event) {
    // remove the active class from all the links
    this.linkTargets.forEach((link) => {
      link.classList.remove("active");
    });
    // add the active class to the one link
    event.currentTarget.classList.add("active");
  }
}
