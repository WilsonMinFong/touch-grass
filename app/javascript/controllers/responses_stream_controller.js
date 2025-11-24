import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["list"]

    connect() {
        console.log("Responses stream connected")
        this.handleNewResponse = this.handleNewResponse.bind(this)
        this.handleReactionUpdateEvent = this.handleReactionUpdateEvent.bind(this)

        document.addEventListener('room:new_response', this.handleNewResponse)
        document.addEventListener('room:reaction_update', this.handleReactionUpdateEvent)
    }

    disconnect() {
        document.removeEventListener('room:new_response', this.handleNewResponse)
        document.removeEventListener('room:reaction_update', this.handleReactionUpdateEvent)
    }

    handleNewResponse(event) {
        const data = event.detail
        console.log("New response event:", data)

        if (data.type === 'new_response') {
            this.handleNewResponseData(data)
        }
    }

    handleReactionUpdateEvent(event) {
        const data = event.detail
        this.handleReactionUpdate(data)
    }

    handleNewResponseData(data) {
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
            <div class="chat-bubble chat-bubble-primary flex flex-col gap-1 min-w-[120px]">
              <div>${this.escapeHtml(data.response_text)}</div>
              <div class="self-end -mb-1 -mr-1">
                <button 
                  class="btn btn-ghost btn-xs gap-1 text-white hover:bg-white/20"
                  data-controller="reaction"
                  data-reaction-id-value="${data.response_id}"
                  data-reaction-liked-value="false"
                  data-reaction-count-value="0"
                  data-action="click->reaction#toggle"
                  title="I relate to this!"
                >
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 transition-transform duration-200 text-white/70" data-reaction-target="icon" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M10.5 1.875a1.125 1.125 0 012.25 0v8.219c.517.017 1.02.066 1.5.146V2.25a1.125 1.125 0 012.25 0v8.219c.517.017 1.02.066 1.5.146V4.875a1.125 1.125 0 012.25 0V15a9.75 9.75 0 01-9.75 9.75c-.385 0-.765-.019-1.138-.057a1.125 1.125 0 01-1.009-1.238l.345-3.454a3 3 0 00-.879-2.121L3.75 14.25a1.125 1.125 0 011.59-1.59l3.543 3.543a.53.53 0 00.75-.75V1.875z" />
                  </svg>
                  <span data-reaction-target="count" class="text-xs">0</span>
                </button>
              </div>
            </div>
          </div>
        `
                list.insertAdjacentHTML('beforeend', html)

                // Add animation
                const newElement = document.getElementById(`response-${data.response_id}`)
                if (newElement) {
                    const bubble = newElement.querySelector('.chat-bubble')
                    bubble.classList.add('animate-bounce-in')
                }
            }
        }
    }

    handleReactionUpdate(data) {
        const responseElement = document.getElementById(`response-${data.question_response_id}`)
        if (responseElement) {
            const countTarget = responseElement.querySelector('[data-reaction-target="count"]')
            if (countTarget) {
                countTarget.textContent = data.count
            }

            // Also update the controller value if it exists
            const controllerElement = responseElement.querySelector('[data-controller="reaction"]')
            if (controllerElement) {
                controllerElement.dataset.reactionCountValue = data.count
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
