---
name: brand-extend
description: "Phase 4: UI-Komponenten, Landing Pages und Dark Mode generieren"
arguments:
  - name: brand_name
    description: "Name des Unternehmens"
    required: true
  - name: scope
    description: "Was generieren: components, landing-page, dark-mode, oder all"
    required: false
---

Fuehre Phase 4 (UI Extension) des Brand Design Systems aus.

## Aufgabe

Erweitere die Brand Guidelines von `$ARGUMENTS.brand_name` um UI-Komponenten, Landing Page und/oder Dark Mode.

## Scope-Optionen

### components (Default)
- Buttons (Primary, Secondary, Ghost, Disabled)
- Input Fields, Cards, Navigation
- Alerts, Badges, Modals
- Referenz: `references/layout-patterns.md`, `references/accessibility-rules.md`

### landing-page
- Hero Section, Features Grid, Testimonials, CTA, Footer
- Vollstaendig responsiv (Mobile-First)
- Verwendet bestehende Design Tokens

### dark-mode
- Automatische Token-Invertierung
- Manual Toggle via CSS Custom Properties
- Referenz: `references/extended-tokens.md` (Dark Mode Sektion)

### all
- Alle drei Scopes ausfuehren

## Output

- `.output/{{brand_slug}}/components.html`
- `.output/{{brand_slug}}/landing-page.html`
- `.output/{{brand_slug}}/dark-mode.css`
- `.output/{{brand_slug}}/state.json` mit `"4_extension": "completed"`
