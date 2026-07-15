import { Controller } from "@hotwired/stimulus"

// Generic drag & drop for kanban boards (CRM leads, Studio projects, Dev tickets).
// Each column carries data-kanban-stage-param with its stage id; each card carries
// data-kanban-id-param with its record id. On drop, a PATCH request is sent to the
// board's move URL template and the Turbo Stream response resyncs the affected columns.
export default class extends Controller {
  static values = { moveUrlTemplate: String, filter: String }

  dragStart(event) {
    event.dataTransfer.setData("text/plain", event.params.id)
    event.dataTransfer.effectAllowed = "move"
  }

  dragOver(event) {
    event.preventDefault()
  }

  drop(event) {
    event.preventDefault()
    const id = event.dataTransfer.getData("text/plain")
    const stage = event.params.stage
    if (!id || !stage) return

    const url = `${this.moveUrlTemplateValue.replace("__ID__", id)}?stage=${encodeURIComponent(stage)}&filter=${encodeURIComponent(this.filterValue || "")}`

    fetch(url, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        Accept: "text/vnd.turbo-stream.html"
      }
    })
      .then((response) => response.text())
      .then((html) => Turbo.renderStreamMessage(html))
  }
}
