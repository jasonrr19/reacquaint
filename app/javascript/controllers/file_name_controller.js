import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="file-name"
export default class extends Controller {
  static targets = ['text', 'icon']
  connect() {
    console.log("connected")
  }

  filePreview(event) {
    let pdffile = event.target.files[0]
    console.log(event)
    if(pdffile) {
      this.textTarget.innerHTML = pdffile.name
      this.iconTarget.classList.remove("fa-cloud-arrow-up")
      this.iconTarget.classList.remove("fa-solid")
      this.iconTarget.classList.add("fa-file-pdf")
      this.iconTarget.classList.add("fa-regular")
    }
  }
}
