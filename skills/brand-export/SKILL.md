# brand-export

**Phase 5: PDF-Export, Figma-Push, Frontend-Handoff-Package**

Invoked via: `/brand-export`

## Input

| Parameter | Pflicht | Beschreibung |
|-----------|---------|-------------|
| `brand_slug` | Ja | Slug des Brand-Outputs (z.B. "acme-corp") |
| `export_format` | Ja | "pdf" / "figma" / "handoff" / "all" |
| `figma_file_key` | Nur für Figma | Figma File Key (aus URL) |
| `handoff_profile` | Nein | "developer" / "designer" / "marketing" (Default: "developer") |

## Output

```
.output/{{brand_slug}}/export/brand-guidelines.pdf   # format="pdf" oder "all"
.output/{{brand_slug}}/export/figma-tokens.json      # format="figma" oder "all"
.output/{{brand_slug}}/export/handoff-package.zip    # format="handoff" oder "all"
.output/{{brand_slug}}/state.json                    # 5_export: completed
```

## 5a: PDF Export

```
Vorbedingung: scripts/check-deps.sh ausführen → verfügbares Tool ermitteln

Fallback-Kette (Reihenfolge):
  1. Puppeteer (bevorzugt):
     → npx puppeteer print .output/{{brand_slug}}/brand-guidelines.html \
         .output/{{brand_slug}}/export/brand-guidelines.pdf
     → Prüfe: Datei > 0 Bytes? → Fertig

  2. wkhtmltopdf:
     → wkhtmltopdf --enable-local-file-access \
         .output/{{brand_slug}}/brand-guidelines.html \
         .output/{{brand_slug}}/export/brand-guidelines.pdf
     → Prüfe: Datei > 0 Bytes? → Fertig

  3. Playwright MCP:
     → browser_navigate: file://.output/{{brand_slug}}/brand-guidelines.html
     → browser_evaluate: window.print()
     → PDF über Print-Dialog speichern
     → Prüfe: Datei > 0 Bytes? → Fertig

  4. @media print Fallback (letzter Ausweg):
     → Ausgabe an User:
       "PDF-Tool nicht verfügbar. Manuelle Alternative:
        1. Öffne: .output/{{brand_slug}}/brand-guidelines.html im Browser
        2. Strg+P (Cmd+P) → 'Als PDF speichern'
        Die HTML-Datei enthält optimierte @media print Styles."
```

## 5b: Figma Token Push

```
Vorbedingung: Figma MCP verbunden + figma_file_key angegeben

Aktion:
  1. design-tokens.json lesen (.output/{{brand_slug}}/design-tokens.json)

  2. In Figma Variables Format konvertieren:
     Farben    → Color Variables (Mode: Light)
     Fonts     → String Variables (Font Family)
     Spacing   → Number Variables (px-Werte)
     Radien    → Number Variables (px-Werte)

  3. Figma MCP aufrufen:
     → get_variable_defs(file_key={{figma_file_key}})
       Bestehende Variablen lesen (nicht überschreiben)
     → send_code_connect_mappings(...)
       Token-Mappings pushen

  4. figma-tokens.json schreiben:
     .output/{{brand_slug}}/export/figma-tokens.json

Fallback (Figma MCP nicht verbunden):
  → figma-tokens.json mit manuellem Import-Format schreiben
  → Anleitung an User:
    "Figma Tokens Plugin → Import → figma-tokens.json auswählen"
```

## 5c: Frontend-Handoff Package

```
scripts/handoff-package.sh --profile={{handoff_profile}}

Profil "developer" (Default):
  Files:
    - design-tokens.css          (CSS Custom Properties)
    - design-tokens.json         (JSON Token-Format)
    - brand-guidelines.html      (Vollständige Guidelines)
    - components.html            (falls vorhanden)
    - dark-mode.css              (falls vorhanden)
    - README.md                  (Token-Verwendung, Naming, Beispiele)
  ZIP: handoff-package.zip

Profil "designer":
  Files:
    - brand-guidelines.pdf       (falls vorhanden, sonst HTML)
    - figma-tokens.json          (Figma Variables Format)
    - assets/                    (Logo + Mockups falls vorhanden)
    - Styleguide-Summary.md      (1-Seiter: Farben, Fonts, Spacing)
  ZIP: handoff-package.zip

Profil "marketing":
  Files:
    - brand-guidelines.pdf       (falls vorhanden, sonst HTML)
    - Social-Media-Specs.md      (Format-Größen, Farbcodes, Font-Empfehlungen)
    - assets/                    (Logo-Varianten falls vorhanden)
  ZIP: handoff-package.zip

Handoff README.md Template (developer):
  # Brand Design System — {{brand_name}}
  ## Design Tokens
  CSS: import 'design-tokens.css'
  JS/JSON: import tokens from 'design-tokens.json'
  ## Token-Naming
  --color-primary, --color-secondary, --color-accent, --color-bg ...
  --font-heading, --font-body
  --space-xs bis --space-4xl (8px-Grid)
  --text-xs bis --text-5xl (modular scale 1.25)
  ## Verwendungsbeispiel
  .button-primary { background: var(--color-primary); padding: var(--space-sm) var(--space-md); }

Social-Media-Specs.md Template (marketing):
  # Social Media Specs — {{brand_name}}
  ## Farben
  Primary: {{color_primary}} | Secondary: {{color_secondary}}
  ## Formate
  Instagram Post: 1080×1080px | Story: 1080×1920px
  LinkedIn Banner: 1584×396px | Post: 1200×628px
  Twitter/X Header: 1500×500px | Post: 1200×675px
  ## Schriften
  Heading: {{font_heading}} | Body: {{font_body}}
```

## state.json Update

```json
{
  "5_export": {
    "status": "completed",
    "completed_at": "{{ISO8601}}",
    "formats": ["pdf", "figma", "handoff"],
    "handoff_profile": "{{handoff_profile}}"
  }
}
```

## Fehlerfall

- Alle PDF-Tools fehlgeschlagen: @media print Fallback + Anleitung
- Figma MCP nicht verbunden: figma-tokens.json + manueller Import
- ZIP-Erstellung fehlgeschlagen: Einzelne Dateien ausgeben + Anleitung

## Externe Abhängigkeiten

- Puppeteer oder wkhtmltopdf (für PDF)
- Figma MCP (für Token-Push)
- scripts/check-deps.sh (Pre-Flight-Check)
- scripts/handoff-package.sh (ZIP-Erstellung)
