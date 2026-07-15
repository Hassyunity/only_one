import { Controller } from "@hotwired/stimulus"

// Generic show/hide toggle between a "panel" (e.g. a dialog, a quick-add form,
// an expanded kanban column) and an "alt" trigger shown while the panel is closed
// (e.g. an "Ajouter une carte" button, a collapsed column strip). Used with no
// alt target at all for simple dialogs.
export default class extends Controller {
  static targets = ["panel", "alt"]

  open() {
    this.panelTargets.forEach((el) => { el.hidden = false })
    this.altTargets.forEach((el) => { el.hidden = true })
  }

  close() {
    this.panelTargets.forEach((el) => { el.hidden = true })
    this.altTargets.forEach((el) => { el.hidden = false })
  }

  closeOnBackdrop(event) {
    if (event.target === event.currentTarget) this.close()
  }
}
