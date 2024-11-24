import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['submitButton', 'spinnerButton'];

  connect() {
    this.element.addEventListener('turbo:submit-start', this.handleSubmitStart.bind(this));
    this.element.addEventListener('turbo:submit-end', this.handleSubmitEnd.bind(this));
  }

  disconnect() {
    this.element.removeEventListener('turbo:submit-start', this.handleSubmitStart.bind(this));
    this.element.removeEventListener('turbo:submit-end', this.handleSubmitEnd.bind(this));
  }

  handleSubmitStart() {
    this.submitButtonTarget.style.display = "none";
    this.spinnerButtonTarget.style.display = "inline-flex";
  }

  handleSubmitEnd(event) {
    if (event.detail.success) {
      this.submitButtonTarget.style.display = "inline-flex";
      this.spinnerButtonTarget.style.display = "none";
    }
  }
}