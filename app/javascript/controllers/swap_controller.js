import { Controller } from "@hotwired/stimulus"
import { Sortable, Swap } from "sortablejs"

Sortable.mount(new Swap())

export default class extends Controller {
  connect() {
    Sortable.create(this.element, {
      group: this.data.get("group"),
      draggable: ".swap-item",
      swap: true,
      onEnd: this.end.bind(this)
    })
  }

  end(event) {
    console.log(event)
  }
}
