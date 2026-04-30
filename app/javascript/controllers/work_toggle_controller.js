import { Controller } from "@hotwired/stimulus"

// Manages the collapsible "Work" section in the left sidebar.
//
// Values:
//   onWorkPage (Boolean) — true when the current page is a work show page.
//                          Set from ERB so the list auto-expands on page load.
//
// Targets:
//   trigger  — the <button> element labelled "Work"
//   list     — the <ul> that wraps all project links (collapsible container)
//
// Color behaviour (matches existing 4-color system):
//   The project list opens automatically on work pages and stays compact on
//   profile pages such as Speaking.
//   When the list is open and NO individual project is active, "Work" is colored.
//   When the list is open and a project IS active, "Work" returns to black
//   (the active project link already carries the color).
//   The color assigned to "Work" when open is color-active0 (blue #0170C0),
//   chosen as a neutral accent that doesn't conflict with the per-project cycling.

const OPEN_COLOR_CLASS = "color-active0"

export default class extends Controller {
  static targets = ["trigger", "list"]
  static values  = { onWorkPage: Boolean }

  connect() {
    // Keep project links expanded on work pages only; profile pages stay compact.
    const shouldOpen = this.onWorkPageValue
    if (shouldOpen) {
      this._open(false) // instant, no animation on first render
    } else {
      this._close(false)
    }
  }

  toggle() {
    if (this.listTarget.classList.contains("is-open")) {
      this._close(true)
    } else {
      this._open(true)
    }
  }

  // ── private ──────────────────────────────────────────────────────────────

  _open(animate) {
    if (!animate) {
      this.listTarget.style.transition = "none"
      // Force reflow so transition removal takes effect before class change.
      this.listTarget.offsetHeight // eslint-disable-line no-unused-expressions
    }
    this.listTarget.classList.add("is-open")
    if (!animate) {
      // Restore transition after the instant open.
      requestAnimationFrame(() => {
        this.listTarget.style.transition = ""
      })
    }
    // Only color "Work" when no child link is currently active.
    if (!this._hasActiveWork()) {
      this.triggerTarget.classList.add(OPEN_COLOR_CLASS)
    }
  }

  _close(animate) {
    if (!animate) {
      this.listTarget.style.transition = "none"
      this.listTarget.offsetHeight // eslint-disable-line no-unused-expressions
    }
    this.listTarget.classList.remove("is-open")
    if (!animate) {
      requestAnimationFrame(() => {
        this.listTarget.style.transition = ""
      })
    }
    this.triggerTarget.classList.remove(OPEN_COLOR_CLASS)
  }

  // Returns true if any child link inside the list carries an active color class.
  _hasActiveWork() {
    return this.listTarget.querySelector('[class*="color-active"]') !== null
  }
}
