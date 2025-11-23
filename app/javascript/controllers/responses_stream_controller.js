import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["list"]

    connect() {
        console.log("Responses stream connected")
        this.handleNewResponse = this.handleNewResponse.bind(this)
        document.addEventListener('room:new_response', this.handleNewResponse)
    }

    disconnect() {
        document.removeEventListener('room:new_response', this.handleNewResponse)
    }

    handleNewResponse(event) {
        const data = event.detail
        console.log("New response event:", data)

        // Find the list for this question
        const list = this.listTargets.find(t => t.dataset.questionId == data.question_id)
        if (list) {
            // Remove empty message if present
            const emptyMsg = list.querySelector('.empty-message')
            if (emptyMsg) {
                emptyMsg.remove()
            }

            // Check if response already exists (for updates)
            const existing = document.getElementById(`response-${data.response_id}`)
            if (existing) {
                existing.querySelector('.chat-bubble').textContent = data.response_text
                // Add animation class
                existing.classList.add('animate-pulse')
                setTimeout(() => existing.classList.remove('animate-pulse'), 1000)
            } else {
                const html = `
          <div class="chat chat-start" id="response-${data.response_id}">
            <div class="chat-bubble chat-bubble-primary animate-bounce-in">${this.escapeHtml(data.response_text)}</div>
          </div>
        `
                list.insertAdjacentHTML('beforeend', html)

                // Remove animation class after animation completes (optional, if using CSS animation)
                const newElement = document.getElementById(`response-${data.response_id}`)
                if (newElement) {
                    // Just a simple fade in effect could be done via CSS classes if they exist
                }
            }
        }
    }

    escapeHtml(text) {
        if (!text) return ""
        const div = document.createElement('div')
        div.textContent = text
        return div.innerHTML
    }
}
