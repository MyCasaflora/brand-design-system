---
name: brand-generate
description: "Phase 1+2: Design Tokens generieren und HTML Brand Guidelines erstellen"
arguments:
  - name: brand_name
    description: "Name des Unternehmens"
    required: true
  - name: color_primary
    description: "Primaerfarbe als Hex-Code (z.B. #2563EB)"
    required: false
  - name: industry
    description: "Branche fuer Token-Defaults"
    required: false
  - name: logo_path
    description: "Pfad zum Logo fuer Farb-Extraktion"
    required: false
---

Fuehre Phase 1 (Design Tokens) und Phase 2 (HTML Generation) des Brand Design Systems aus.

## Aufgabe

Generiere ein vollstaendiges Design Token System und eine HTML Brand Guideline fuer `$ARGUMENTS.brand_name`.

## Phase 1: Constraint Layer (Design Tokens)

1. **Token-Quelle bestimmen** (Prioritaet):
   - `brand-strategy-brief.json` aus Phase 0 (falls vorhanden)
   - `logo_path` → Farb-Extraktion via OpenRouter
   - `color_primary` → Komplementaerfarben (60-30-10 Regel)
   - User-Input als Fallback

2. **Token-Schema generieren** nach `references/design-tokens.md`:
   - Farben (Primary, Secondary, Accent, BG, Text, Grays)
   - Typografie (Font Family, Sizes, Weights, Line Heights)
   - Spacing (4px-Raster)
   - Borders, Shadows, Transitions

3. **WCAG-Validierung**: Alle Farbkombinationen auf AA-Kontrast pruefen

## Phase 2: Single-Pass HTML Generation

Generiere eine vollstaendige HTML Brand Guideline mit eingebettetem CSS.
Nutze das Template aus `references/design-tokens-template.css`.

## Output

- `.output/{{brand_slug}}/design-tokens.css`
- `.output/{{brand_slug}}/design-tokens.json`
- `.output/{{brand_slug}}/brand-guidelines.html`
- `.output/{{brand_slug}}/state.json` mit `"1_tokens": "completed"`, `"2_generation": "completed"`
