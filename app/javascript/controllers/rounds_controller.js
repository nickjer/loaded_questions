import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="rounds"
export default class extends Controller {
  static values = {
    activePlayerId: String
  }

  static targets = [ "activePlayer", "notActivePlayer", "activePlayerClass" ]

  get currentPlayerId() {
    return document.querySelector('meta[name="current_player_id"]').content
  }

  get isActivePlayer() {
    return this.currentPlayerId == this.activePlayerIdValue
  }

  connect() {
  }

  activePlayerTargetConnected(element) {
    if (!this.isActivePlayer) {
      element.remove()
    }
  }

  notActivePlayerTargetConnected(element) {
    if (this.isActivePlayer) {
      element.remove()
    }
  }

  activePlayerClassTargetConnected(element) {
    if (this.isActivePlayer) {
      element.classList.add(element.dataset.roundsActivePlayerClass)
    }
  }
}
