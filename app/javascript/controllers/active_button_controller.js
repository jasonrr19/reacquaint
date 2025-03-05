import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="active-button"
export default class extends Controller {
  static targets = ["icon", "link"];
  connect() {}
  toggle(event) {
    // remove the active class from all the links
    this.linkTargets.forEach((link) => {
      link.classList.remove("fw-normal");
      link.classList.add("fw-lighter");
    });
    this.iconTargets.forEach((icon) => {
      icon.classList.remove("text-primary");
      icon.classList.add("text-secondary");
    });
    // add the active class to the one link
    console.log(event.currentTarget.previousElementSibling);
    event.currentTarget.previousElementSibling.classList.remove(
      "text-secondary"
    );
    event.currentTarget.previousElementSibling.classList.add("text-primary");
    event.currentTarget.classList.add("fw-normal");
  }
}
