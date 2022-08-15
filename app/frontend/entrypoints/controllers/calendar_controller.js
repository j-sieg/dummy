import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class CalendarController extends Controller {
  initialize() {
    if (this.isPreview) return
    this.visitAgendaDate = this.visitAgendaDate.bind(this)
  }

  connect() {
    if (this.isPreview) return

    this.visitableTableCells.forEach(td => {
      td.addEventListener("click", this.visitAgendaDate)
    })
  }

  disconnect() {
    if (this.isPreview) return

    this.visitableTableCells.forEach(td => {
      td.removeEventListener("click", this.visitAgendaDate)
    })
  }

  visitAgendaDate(event) {
    const agendaDate = event.currentTarget.dataset.agendaDate
    const url = new URL(document.location)
    url.searchParams.set("date", agendaDate)
    Turbo.visit(url)
  }

  get visitableTableCells() {
    return this.element.querySelectorAll("td[data-agenda-date]:not([class='not--month'])")
  }

  get isPreview() {
    return document.documentElement.hasAttribute("data-turbo-preview")
  }
}
