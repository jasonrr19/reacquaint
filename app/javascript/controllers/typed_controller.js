import { Controller } from "@hotwired/stimulus"
import Typed from 'typed.js'

// Connects to data-controller="typed"
export default class extends Controller {
  connect() {
    new Typed(this.element, {
      strings: ["A.I. is building your response ..."],
      typeSpeed: 50,
      loop: true,
    });
  }
}
