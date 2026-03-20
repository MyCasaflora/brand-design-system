# brand-reviewer

**Phase 3: Art Director Loop — Visuelle Qualitätssicherung**

Invoked via: `/brand-review`

## Input

| Parameter | Pflicht | Beschreibung |
|-----------|---------|-------------|
| `brand_slug` | Ja | Slug des Brand-Outputs (z.B. "acme-corp") |
| `reference_brand` | Nein | Vergleichsmarke (Default: "Stripe") |
| `target_file` | Nein | Zu reviewende Datei (Default: brand-guidelines.html) |

## Output

```
.output/{{brand_slug}}/brand-guidelines.html        # Verbesserte Version (in-place)
.output/{{brand_slug}}/screenshots/iteration-N.png  # Screenshot pro Iteration
# Stdout: Review-Report (Score, Blind-Spot-Ergebnisse, Verbesserungen)
.output/{{brand_slug}}/state.json                   # 3_review: completed
```

## Ablauf (max. 3 Iterationen)

### Schritt 1: Screenshot erstellen
```
Tool: Playwright MCP (browser_take_screenshot) ODER Puppeteer MCP
  → browser_navigate: file://.output/{{brand_slug}}/brand-guidelines.html
  → browser_take_screenshot
  → Speichern: .output/{{brand_slug}}/screenshots/iteration-{{N}}.png
Fallback: "Screenshot-Tool nicht verfügbar — visuellen Review überspringen"
```

### Schritt 2: Art Director Agent (Subagent)
```
Agent: art-director (→ agents/art-director/AGENT.md)
Input: NUR der Screenshot-Pfad — KEIN Code, KEIN HTML, KEIN CSS

Erwarteter Output (5 Verbesserungen):
  WAS: [Konkretes Problem]
  WO:  [Sektion/Bereich]
  WIE: [Spezifische CSS-Anweisung]
  PRIORITÄT: KRITISCH | HOCH | MITTEL

  Score: [1-10]
  Bestanden: [Ja bei ≥ 7]
```

### Schritt 3: Verbesserungen anwenden
```
Art Director Feedback → HTML/CSS anwenden:
  - KRITISCH: MUSS umgesetzt werden
  - HOCH: Soll umgesetzt werden
  - MITTEL: Bei Kapazität umsetzen

Regel: NUR CSS Custom Properties anpassen — KEINE Token-Werte hardcoden
```

### Schritt 4: QA-Polish-Check (mechanisch)
```
Token-Compliance:
  → Kein hardcodierter Hex-Wert im HTML (alle via var(--color-*))
  → Kein hardcodierter px-Spacing-Wert (alle via var(--space-*))

Kontrast-Check (WCAG AA):
  → text auf bg: ≥ 4.5:1 (berechnen via Luminanz-Formel)
  → Text auf farbigem Hintergrund: extra prüfen

Spacing-Konsistenz:
  → Gleiche Sektionen = gleicher Padding
  → 8px-Grid: Alle Spacing-Werte durch 8 teilbar

Anti-KI-Signals:
  → Kein "Elevate your brand" / "Unlock your potential"
  → Keine Stock-Photo-Beschreibungen
  → Mindestens 3 brand-spezifische Begründungen vorhanden
```

### Schritt 5: Referenz-Vergleich
```
WebSearch: "{{reference_brand}} brand guidelines visual style"
Vergleich auf 3 Dimensionen:
  1. Professioneller Eindruck (1-10)
  2. Visuelle Konsistenz (1-10)
  3. Brand-Eigenständigkeit (1-10)

Gesamtscore = (Art Director Score + QA Score) / 2
```

### Schritt 6: Blind-Spots-Check
```
Referenz: references/blind-spots-checklist.md
Jeden der 10 Blind Spots prüfen:
  ✓ Abgehakt wenn vorhanden
  ✗ Fehlend wenn nicht vorhanden → Hinweis an User (KEIN Stopper)

Blind-Spot-Score: X/10 (wieviele der 10 Bereiche abgedeckt)
```

### Iterations-Logik
```
Score ≥ 7 → BESTANDEN → Weiter zu Phase 4/5
Score < 7 → Neue Iteration (max 3x gesamt)
Nach 3 Iterationen mit Score < 7 → WARNUNG + trotzdem weiter
  Meldung: "Score {{score}}/10 nach 3 Iterationen.
             Empfehle manuelle Überarbeitung. Fortfahren? [Ja/Nein]"
```

## Review-Report Format

```markdown
## Art Director Review — {{brand_name}} — Iteration {{N}}

### Art Director Score: {{score}}/10 — {{BESTANDEN|NICHT BESTANDEN}}

**Verbesserungen umgesetzt:**
1. [Verbesserung 1]
2. [Verbesserung 2]
...

### QA-Polish-Check
- Token-Compliance: ✓/✗
- WCAG AA Kontrast: ✓/✗ (Ratio: X:1)
- 8px-Grid: ✓/✗
- Anti-KI-Signals: ✓/✗

### Blind-Spot-Score: X/10
Fehlende Bereiche: [Liste]

### Referenz-Vergleich vs {{reference_brand}}
- Professioneller Eindruck: X/10
- Visuelle Konsistenz: X/10
- Brand-Eigenständigkeit: X/10

### Empfehlung: [Weiter zu Phase 4 | Manuelle Überarbeitung empfohlen]
```

## state.json Update

```json
{
  "3_review": {
    "status": "completed",
    "completed_at": "{{ISO8601}}",
    "final_score": 8,
    "iterations": 2,
    "blind_spot_score": 9
  }
}
```

## Fehlerfall

- Screenshot-Tool nicht verfügbar: QA-Polish-Check + Blind-Spots ohne visuellen Review
- Art Director Agent nicht erreichbar: Lokaler Inline-Review mit eingebettetem Checklist
- Score < 7 nach 3 Iterationen: Warnung + User-Entscheidung

## Referenzen geladen

- `references/blind-spots-checklist.md` — 10 oft vergessene Bereiche
- `references/accessibility-rules.md` — WCAG AA Regeln (Owner: designer)

## Prompt-Quellen (eingebettet)

Alle Review-Prompts (A: Visueller Pass, B: QA-Polish, C: Referenz-Vergleich) sind direkt in
diesem SKILL.md eingebettet — nicht in separaten Template-Dateien.
