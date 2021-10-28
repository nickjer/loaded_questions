import { Controller } from "@hotwired/stimulus"
import { Sortable, Swap } from "sortablejs"

export default class extends Controller {
  connect() {
    Sortable.mount(new Swap())

    var list_items = this.element.children
    for (var i = 0; i < list_items.length; i++) {
      this.sortable = Sortable.create(list_items[i], {
        group: "sortable",
        draggable: ".draggable-item",
        swap: true,
        onEnd: this.end.bind(this)
      })
    }
  }

  end(event) {
    console.log(event)
  }
}
