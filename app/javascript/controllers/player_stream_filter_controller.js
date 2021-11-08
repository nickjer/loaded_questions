import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="player-stream-filter"
export default class extends Controller {
  get currentPlayerId() {
    return document.querySelector('meta[name="current_player_id"]').content
  }

  connect() {
    document.addEventListener('turbo:before-stream-render', async (event) => {
      await this.filterStream(event)
    })
  }

  filterStream(event) {
    const unlessPlayerId =
      event.target.templateContent.firstElementChild.dataset.unlessPlayerId
    console.log(this.currentPlayerId)
    console.log(unlessPlayerId)
    if (this.currentPlayerId == unlessPlayerId) {
      console.log("terminated")
      event.preventDefault()
    }
  }
}
