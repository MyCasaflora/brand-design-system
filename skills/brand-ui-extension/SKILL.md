# brand-ui-extension

**Phase 4: UI-Komponenten, Landing Pages, Dark Mode**

Invoked via: `/brand-extend`

## Input

| Parameter | Pflicht | Beschreibung |
|-----------|---------|-------------|
| `brand_name` | Ja | Name des Unternehmens |
| `brand_slug` | Ja | Ordner-Slug (z.B. "acme-corp") |
| `scope` | Nein | "components" / "landing-page" / "dark-mode" / "all" (Default: "components") |
| `component_list` | Nein | Komma-sep. Liste (Default: Standard-Set) |
| `page_type` | Nein | "saas-landing" / "pricing" / "about" / "dashboard" (Default: "saas-landing") |
| `content_brief` | Nein | Texte für Landing Page |

**Pflicht-Voraussetzung:** `.output/{{brand_slug}}/design-tokens.css` muss existieren

## Output

```
.output/{{brand_slug}}/components.html    # scope="components" oder "all"
.output/{{brand_slug}}/landing-page.html  # scope="landing-page" oder "all"
.output/{{brand_slug}}/dark-mode.css      # scope="dark-mode" oder "all"
.output/{{brand_slug}}/state.json         # 4_extension: completed
```

## Scope-Ausführung

### scope = "components" — Prompt A

```
Aufgabe: Vollständige Komponenten-Bibliothek in einer HTML-Datei

PFLICHT: Alle Werte via CSS Custom Properties aus design-tokens.css
KEINE Tailwind-Klassen, KEIN Framework — reines semantisches HTML + CSS

Standard-Komponenten (falls component_list nicht definiert):
  Navigation:  Navbar (Desktop + Mobile), Sidebar, Breadcrumb
  Inputs:      Text Input, Select, Checkbox, Radio, Toggle, Textarea
  Buttons:     Primary, Secondary, Ghost, Danger, Icon-Button, Loading-State
  Feedback:    Alert (Info/Success/Warning/Error), Toast, Badge, Tag
  Cards:       Basic Card, Feature Card, Pricing Card, Testimonial Card
  Layout:      Container, Section, Grid (2/3/4-col), Divider
  Typography:  Heading-Skala (H1–H6), Body, Caption, Code
  Forms:       Login-Form, Contact-Form, Newsletter
  Data:        Table, Stats-Block, Progress-Bar
  Media:       Avatar, Logo-Block, Image-Placeholder

Anti-KI-Guardrails (eingebettet):
  - KEIN generisches "blue button" Design
  - Komponenten müssen Brand-Charakter haben
  - Alle States dokumentieren (hover, focus, disabled, active)
  - Accessibility: aria-labels, focus-visible, color-not-only

Output: .output/{{brand_slug}}/components.html
```

### scope = "landing-page" — Prompt B

```
Aufgabe: Vollständige Landing Page für {{page_type}}

Sektionen für "saas-landing":
  Hero:        Headline, Sub, CTA (2 Buttons), Hero-Visual-Placeholder
  Social Proof: Logos-Bar (5 Firma-Platzhalter), Stats (3 Zahlen)
  Features:    3-Grid Feature-Cards (Icons, Heading, Text)
  How it Works: 3-Schritt Prozess (Nummern, Pfeile)
  Testimonials: 3 Quotes (Avatar, Name, Firma)
  Pricing:     3 Tiers (Free/Pro/Enterprise) mit Feature-Liste
  FAQ:         5 Fragen (Accordion)
  CTA-Banner:  Abschluss-CTA
  Footer:      Links, Social, Copyright

content_brief → Texte einsetzen | Fallback: Brand-spezifische Platzhalter
KEIN "Lorem ipsum" — immer branchenspezifischer Platzhaltertext

Output: .output/{{brand_slug}}/landing-page.html
```

### scope = "dark-mode" — Prompt C

```
Aufgabe: Dark Mode Token-Mapping als CSS-Override

Vorgehen:
  1. design-tokens.css lesen → alle --color-* Tokens identifizieren
  2. Dark Mode Äquivalente ableiten:
     --color-bg:      Helles Pendant → Dunkles Pendant (z.B. #FFFFFF → #0F172A)
     --color-surface: Mid-Tone → Dunkel-Surface
     --color-text:    Dunkel → Hell (≥ 4.5:1 Kontrast auf neuem bg)
  3. Accent/Primary-Farben: Sättigung leicht reduzieren für Dark Mode

Format:
  @media (prefers-color-scheme: dark) {
    :root {
      --color-bg:      {{dark_bg}};
      --color-surface: {{dark_surface}};
      --color-text:    {{dark_text}};
      /* ... alle angepassten Tokens */
    }
  }
  /* Optionale .dark-mode Klasse für manuellen Toggle */
  .dark-mode { /* gleiche Overrides */ }

Qualität: WCAG AA für alle Text-Farb-Kombinationen im Dark Mode
Referenz: references/extended-tokens.md (Dark Mode Tokens)

Output: .output/{{brand_slug}}/dark-mode.css
```

### scope = "all"

```
Ausführung: components → landing-page → dark-mode (sequenziell)
Alle 3 Outputs schreiben.
```

## Optionaler Review

Phase 4 Outputs können durch brand-reviewer geprüft werden:
```
/brand-review target_file="components.html"
```
Standardmäßig KEIN automatischer Review — Komponenten basieren auf bereits reviewten Tokens.

## state.json Update

```json
{
  "4_extension": {
    "status": "completed",
    "completed_at": "{{ISO8601}}",
    "scope": "{{scope}}"
  }
}
```

## Fehlerfall

- design-tokens.css fehlt: STOP mit Fehler "Bitte zuerst /brand-generate ausführen"
- Playwright für Screenshot-Preview nicht verfügbar: Nur HTML-Output ohne Preview
- content_brief zu kurz: Branchenspezifische Placeholder generieren

## Referenzen geladen

- `references/accessibility-rules.md` — WCAG AA, aria-Regeln (Owner: designer)
- `references/extended-tokens.md` — Dark Mode + Social Media + Print + Motion Tokens (Owner: designer)
- `references/design-tokens.md` — Token-Schema für Komponenten (Owner: designer)
- `references/layout-patterns.md` — Grid + Page Templates + Print-Layout (Owner: designer)

## Prompt-Quellen (eingebettet)

Prompts A, B, C sind direkt in diesem SKILL.md eingebettet.
