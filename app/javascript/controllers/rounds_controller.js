import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="rounds"
export default class extends Controller {
  static values = {
    activePlayerId: String
  }

  static targets = [ "activePlayerClass" ]

  get currentPlayerId() {
    return document.querySelector('meta[name="current_player_id"]').content
  }

  get isActivePlayer() {
    return this.currentPlayerId == this.activePlayerIdValue
  }

  connect() {
  }

  activePlayerClassTargetConnected(element) {
    if (this.isActivePlayer) {
      element.classList.add(element.dataset.roundsActivePlayerClass)
    }
  }
}
