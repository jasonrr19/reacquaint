import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="remove-hide"
export default class extends Controller {
static targets = ['objective']
  remove(event) {
    this.objectiveTarget.classList.remove("d-none");
    event.currentTarget.remove();
  }
}
