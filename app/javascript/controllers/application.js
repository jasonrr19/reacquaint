import { Application } from "@hotwired/stimulus"
import DropzoneController from '@kanety/stimulus-dropzone';

const application = Application.start()
application.register('dropzone', DropzoneController);

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
