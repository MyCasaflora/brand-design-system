---
name: brand-review
description: "Phase 3: Art Director Loop — visuelles QA mit Screenshot-Analyse"
arguments:
  - name: brand_name
    description: "Name des Unternehmens (fuer .output/ Zuordnung)"
    required: true
  - name: reference_brand
    description: "Referenz-Marke fuer Vergleich (Default: Stripe)"
    required: false
  - name: max_iterations
    description: "Maximale Review-Runden (Default: 3)"
    required: false
---

Fuehre Phase 3 (Art Director Review) des Brand Design Systems aus.

## Aufgabe

Starte den Art Director Loop fuer die Brand Guidelines von `$ARGUMENTS.brand_name`.

## Ablauf

1. **Screenshot erstellen**: HTML Brand Guidelines im Browser oeffnen, Screenshot via Playwright
2. **Art Director Analyse**: Screenshot an OpenRouter senden (Vision-Modell)
   - Visuelle Hierarchie bewerten
   - Whitespace und Balance pruefen
   - Typografie-Konsistenz bewerten
   - Farbharmonie und Kontrast pruefen
3. **Feedback umsetzen**: Konkrete CSS/HTML-Aenderungen ableiten
4. **Erneut screenshotten und vergleichen**
5. **Maximal 3 Iterationen** (konfigurierbar)

## Referenz

Der Art Director Agent ist definiert in `agents/art-director/AGENT.md`.
Die Review-Kriterien folgen `references/blind-spots-checklist.md`.

## Output

- `.output/{{brand_slug}}/screenshots/review-v1.png` (pro Iteration)
- `.output/{{brand_slug}}/brand-guidelines.html` (aktualisiert)
- `.output/{{brand_slug}}/state.json` mit `"3_review": "completed"`
