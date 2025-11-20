import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="question-response"
export default class extends Controller {
  static targets = ["form", "textarea", "submitBtn", "success", "successAlert", "error", "responseText", "errorText"]
  static values = { questionId: Number, roomCode: String }

  async submit(event) {
    event.preventDefault()

    const formData = new FormData(this.formTarget)

    this.submitBtnTarget.disabled = true
    this.submitBtnTarget.textContent = "Submitting..."
    this.hideError()

    try {
      const response = await fetch(this.formTarget.action, {
        method: 'POST',
        body: formData,
        headers: {
          'Accept': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        }
      })

      const data = await response.json()

      if (response.ok) {
        this.showSuccess(this.textareaTarget.value)
      } else {
        this.showError(data.error || 'Something went wrong')
      }
    } catch (error) {
      this.showError('Network error. Please try again.')
    } finally {
      this.submitBtnTarget.disabled = false
      this.submitBtnTarget.textContent = "Submit Response"
    }
  }

  showSuccess(responseText) {
    this.responseTextTarget.textContent = responseText
    this.hideForm()
    this.successTarget.classList.remove('hidden')

    // Show the success alert temporarily
    this.successAlertTarget.classList.remove('hidden')

    // Hide the success alert after 3 seconds
    setTimeout(() => {
      this.successAlertTarget.classList.add('hidden')
    }, 3000)
  }

  showError(errorMessage) {
    this.errorTextTarget.textContent = errorMessage
    this.errorTarget.classList.remove('hidden')
  }

  hideError() {
    this.errorTarget.classList.add('hidden')
  }

  hideForm() {
    this.formTarget.classList.add('hidden')
  }

  showExistingResponse(responseText) {
    this.responseTextTarget.textContent = responseText
    this.hideForm()
    this.successTarget.classList.remove('hidden')
  }
}