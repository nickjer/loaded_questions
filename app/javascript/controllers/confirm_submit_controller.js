import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

// Connects to data-controller="confirm-submit"
export default class extends Controller {
  static targets = [ "modal" ]

  connect() {
  }

  modalTargetConnected(element) {
    this.modal = new Modal(this.modalTarget)
  }

  showModal(event) {
    event.preventDefault()
    this.modal.show()
  }

  closeModal(event) {
    this.modal.hide()
  }

  submitForm(event) {
    this.element.submit()
    this.modal.hide()
  }
}
