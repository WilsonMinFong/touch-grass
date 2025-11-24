import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["icon", "count"]
    static values = {
        id: Number,
        liked: Boolean,
        count: Number
    }

    connect() {
        this.updateUI()
    }

    async toggle(event) {
        event.preventDefault()

        // Optimistic UI update
        this.likedValue = !this.likedValue
        this.countValue += this.likedValue ? 1 : -1
        this.updateUI()

        // Add animation
        this.iconTarget.classList.add('scale-125')
        setTimeout(() => this.iconTarget.classList.remove('scale-125'), 200)

        try {
            const method = this.likedValue ? "POST" : "DELETE"
            const response = await fetch(`/question_responses/${this.idValue}/reaction`, {
                method: method,
                headers: {
                    "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
                    "Accept": "application/json"
                }
            })

            if (!response.ok) {
                throw new Error("Network response was not ok")
            }
        } catch (error) {
            console.error("Error updating reaction:", error)
            // Revert optimistic update on error
            this.likedValue = !this.likedValue
            this.countValue += this.likedValue ? 1 : -1
            this.updateUI()
        }
    }

    updateUI() {
        if (this.likedValue) {
            this.iconTarget.classList.add("text-blue-500", "fill-current")
            this.iconTarget.classList.remove("text-white/70")
        } else {
            this.iconTarget.classList.remove("text-blue-500", "fill-current")
            this.iconTarget.classList.add("text-white/70")
        }
        this.countTarget.textContent = this.countValue
    }
}
