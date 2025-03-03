import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="write-response"
export default class extends Controller {
  connect() {
    console.log('hello from write-response.')
    this.element.click();
  }
}
