import { Controller } from "@hotwired/stimulus"
import { Sortable, Swap } from "sortablejs"

Sortable.mount(new Swap())

export default class extends Controller {
  static targets = [ "item" ]
  static values = {
    name: String,
    url: String
  }

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
    let item_name = `${this.nameValue}_swapper[${this.nameValue}_id]`
    let swap_item_name = `${this.nameValue}_swapper[swap_${this.nameValue}_id]`
    data.append(item_name, event.item.dataset.id)
    data.append(swap_item_name, event.swapItem.dataset.id)

    fetch(this.urlValue, {
      method: 'POST',
      body: data,
      headers: {
        "X-CSRF-Token": csrfToken
      },
    })
      .then(response => {
        if (!response.ok) {
          console.log(response)
        }
      })
  }
}
