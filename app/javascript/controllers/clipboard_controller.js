import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "button"]
  static values = {
    successMessage: { type: String, default: "Copied!" },
    originalMessage: { type: String, default: "Copy" }
  }
  
  connect() {
    if (this.hasButtonTarget) {
      this.originalText = this.buttonTarget.textContent || this.originalMessageValue
    }
  }
  
  copy(event) {
    event.preventDefault()
    
    navigator.clipboard.writeText(this.sourceTarget.value || this.sourceTarget.textContent).then(() => {
      if (this.hasButtonTarget) {
        this.buttonTarget.textContent = this.successMessageValue
        
        // Reset the button text after 2 seconds
        setTimeout(() => {
          this.buttonTarget.textContent = this.originalText
        }, 2000)
      }
    })
  }
}