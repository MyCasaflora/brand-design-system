---
name: brand-intelligence
description: "Phase 0: Market Research, Wettbewerber-Analyse und ICP-Profiling"
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
---

Fuehre Phase 0 (Brand Intelligence) des Brand Design Systems aus.

## Aufgabe

Analysiere die Marke `$ARGUMENTS.brand_name` und erstelle ein Brand Strategy Brief.

## Schritte

1. **Markt-Research**: Branche, Trends, Zielgruppe recherchieren
2. **Wettbewerber-Analyse**: 3-5 direkte Wettbewerber identifizieren, deren visuelle Identitaet bewerten
3. **ICP-Profiling**: Ideal Customer Profile mit Demographics, Psychographics, Pain Points erstellen
4. **Brand Positioning**: Einzigartige Positionierung und Differenzierung definieren
5. **Design-Implikationen**: Farb-Assoziationen, Typografie-Empfehlungen, visuellen Stil ableiten

## Referenzen

Nutze die ICP-Templates aus `references/icp-templates.md` und die Blind-Spots-Checklist aus `references/blind-spots-checklist.md`.

## Output

Schreibe die Ergebnisse nach:
- `.output/{{brand_slug}}/brand-strategy-brief.md` (menschenlesbar)
- `.output/{{brand_slug}}/brand-strategy-brief.json` (maschinenlesbar fuer Phase 1)
- `.output/{{brand_slug}}/state.json` mit `"0_intelligence": "completed"`
