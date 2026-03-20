---
name: brand-export
description: "Phase 5: Export — PDF, Figma Token Push, Frontend Handoff Package"
arguments:
  - name: brand_name
    description: "Name des Unternehmens"
    required: true
  - name: format
    description: "Export-Format: pdf, figma, handoff, oder all (Default: all)"
    required: false
  - name: handoff_profile
    description: "Handoff-Profil: developer, designer, marketing (Default: developer)"
    required: false
---

Fuehre Phase 5 (Export) des Brand Design Systems aus.

## Aufgabe

Exportiere die Brand Guidelines von `$ARGUMENTS.brand_name` in die gewuenschten Formate.

## Export-Formate

### pdf
- HTML → PDF Konvertierung via Fallback-Chain (Puppeteer → wkhtmltopdf → Prince → Chrome)
- Script: `scripts/export-pdf.sh`

### figma
- Design Tokens als Figma Variables pushen via Figma Console MCP
- Verwendet `mcp__figma-console__figma_setup_design_tokens` fuer atomares Setup
- Oder `mcp__figma-console__figma_batch_create_variables` fuer bestehende Collections
- Script (REST API Fallback): `scripts/export-figma.sh`

### handoff
- ZIP-Package mit CSS, JSON, HTML, Fonts, Assets
- Rolle-basierte Dokumentation (Developer/Designer/Marketing)
- Script: `scripts/handoff-package.sh`

### all
- Alle drei Formate exportieren

## Figma-Push Workflow (Primaer via MCP)

1. `mcp__figma-console__figma_get_status` → Verbindung pruefen
2. `mcp__figma-console__figma_list_open_files` → Zieldatei identifizieren
3. `design-tokens.json` laden und in Figma-Format konvertieren
4. `mcp__figma-console__figma_setup_design_tokens` → Tokens pushen
5. `mcp__figma-console__figma_take_screenshot` → Ergebnis verifizieren

## Output

- `.output/{{brand_slug}}/export/brand-guidelines.pdf`
- `.output/{{brand_slug}}/export/figma-tokens.json`
- `.output/{{brand_slug}}/export/handoff-package.zip`
- `.output/{{brand_slug}}/state.json` mit `"5_export": "completed"`
