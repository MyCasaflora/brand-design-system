---
name: brand-full
description: "Vollstaendiger Brand Design System Durchlauf (Phase 0-5) mit Resume-Support"
arguments:
  - name: brand_name
    description: "Name des Unternehmens"
    required: true
  - name: industry
    description: "Branche (z.B. B2B SaaS, E-Commerce)"
    required: false
  - name: website_url
    description: "Website-URL fuer automatische Analyse"
    required: false
  - name: color_primary
    description: "Primaerfarbe als Hex-Code (optional, wird sonst abgeleitet)"
    required: false
---

Fuehre den vollstaendigen Brand Design System Workflow aus (Phase 0 bis 5).

## Aufgabe

Erstelle ein komplettes Brand Design System fuer `$ARGUMENTS.brand_name`.

## Resume-Logik

Pruefe zuerst `.output/{{brand_slug}}/state.json`:
- Falls vorhanden: Setze an der letzten offenen Phase fort
- Falls nicht vorhanden: Starte bei Phase 0

## Phasen

### Phase 0: Brand Intelligence
→ Invoke Skill `brand-intelligence`

### Phase 1+2: Design Tokens + HTML Generation
→ Invoke Skill `brand-generator`

### Phase 3: Art Director Review
→ Invoke Skill `brand-reviewer` mit Agent `art-director`

### Phase 4: UI Extension
→ Invoke Skill `brand-ui-extension` mit scope="all"

### Phase 5: Export
→ Invoke Skill `brand-export` mit format="all"

## Zwischen den Phasen

- State nach jeder Phase in `state.json` aktualisieren
- Bei Fehler: Phase als `"failed"` markieren, Fehler loggen, User fragen ob fortfahren

## Output

Vollstaendige Output-Struktur unter `.output/{{brand_slug}}/`:
```
state.json, brand-strategy-brief.md/.json, design-tokens.css/.json,
brand-guidelines.html, screenshots/, components.html, landing-page.html,
dark-mode.css, export/brand-guidelines.pdf, export/figma-tokens.json,
export/handoff-package.zip
```
