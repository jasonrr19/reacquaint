import { Controller } from "@hotwired/stimulus"
import Typed from 'typed.js'

// Connects to data-controller="typed"
export default class extends Controller {
  connect() {
    new Typed(this.element, {
      strings: ["Reacquaint is thinking about it ..."],
      typeSpeed: 50,
      loop: true,
    });
  }
}
