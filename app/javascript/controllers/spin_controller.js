import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ 'spinner', 'message' ]
    static values = {
      example: String
    }

    connect() {
      console.log("Connecting...");
    }
    display(event) {
      console.log(event);
      this.spinnerTarget.classList.remove("d-none");
      this.messageTarget.classList.remove("d-none");
    }
  }
