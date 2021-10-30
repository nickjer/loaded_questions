import { Controller } from "@hotwired/stimulus"
import { Sortable, Swap } from "sortablejs"

Sortable.mount(new Swap())

export default class extends Controller {
  static targets = [ "item" ]
 static values = { url: String }

  connect() {
  }

  itemTargetConnected(item_element) {
    Sortable.create(item_element, {
      group: this.element.id,
      draggable: ".swap-item",
      swap: true,
      sort: false,
      onEnd: this.end.bind(this)
    })
  }

  end(event) {
    const csrfToken = document.getElementsByName("csrf-token")[0].content

    let data = new FormData()
    data.append("item_id", event.item.dataset.id)
    data.append("swap_item_id", event.swapItem.dataset.id)

    // Rails.ajax({
    //   url: this.urlValue,
    //   type: "POST",
    //   data: data
    // })
    // fetch(this.urlValue, {
    fetch('/games', {
      method: 'POST',
      body: JSON.stringify(data),
      headers: {
        "X-CSRF-Token": csrfToken
      },
    })
      .then(response => response.text())
      .then(html => this.element.innerHTML = html)
  }
}
