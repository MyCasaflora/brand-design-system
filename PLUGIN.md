# brand-design-system Plugin

Vollautomatisches Brand Design System — von Research bis Export.

## Installation

```bash
# Plugin nach ~/.claude/plugins/ kopieren
cp -r brand-design-system ~/.claude/plugins/

# Abhängigkeiten prüfen
bash ~/.claude/plugins/brand-design-system/scripts/check-deps.sh
```

**Voraussetzung:** `openrouter-skill-v3` muss installiert sein unter `~/.claude/skills/openrouter-skill-v3/`

## Commands

| Command | Phase | Beschreibung |
|---------|-------|-------------|
| `/brand-intelligence` | 0 | Markt-Research, Wettbewerber, ICP-Analyse |
| `/brand-generate` | 1+2 | Design Tokens + HTML Brand Guidelines generieren |
| `/brand-review` | 3 | Art Director Loop (visuelles QA, max 3 Iterationen) |
| `/brand-extend` | 4 | UI-Komponenten, Landing Pages, Dark Mode |
| `/brand-export` | 5 | PDF, Figma-Push, Frontend-Handoff-Package |
| `/brand-full` | 0→5 | Vollständiger Durchlauf (mit Resume-Support) |

## Schnellstart (Minimal-Flow)

```
/brand-generate brand_name="Acme Corp", color_primary="#2563EB", industry="SaaS"
/brand-export format="pdf"
```

## Vollständiger Flow

```
/brand-full brand_name="Acme Corp", industry="B2B SaaS", website_url="https://acme.com"
```

Oder schrittweise:
```
/brand-intelligence brand_name="Acme Corp", industry="B2B SaaS", website_url="https://acme.com"
/brand-generate brand_name="Acme Corp"
/brand-review reference_brand="Stripe"
/brand-extend scope="all"
/brand-export format="all", handoff_profile="developer"
```

## Resume nach Unterbrechung

Falls der Prozess unterbrochen wird, einfach erneut aufrufen — der Workflow setzt an der letzten offenen Phase fort (via `state.json`):

```
/brand-full brand_name="Acme Corp"
```

## Output-Struktur

```
.output/
└── acme-corp/
    ├── state.json                    # Phasen-Status (Resume-Info)
    ├── brand-strategy-brief.md       # Phase 0: Research-Ergebnis
    ├── brand-strategy-brief.json     # Phase 0: Maschinenlesbar
    ├── design-tokens.css             # Phase 1: CSS Custom Properties
    ├── design-tokens.json            # Phase 1: JSON (Token-Format)
    ├── brand-guidelines.html         # Phase 2: Vollständige Guidelines
    ├── screenshots/                  # Phase 3: Review-Screenshots
    ├── components.html               # Phase 4a: Komponenten-Bibliothek
    ├── landing-page.html             # Phase 4b: Landing Page
    ├── dark-mode.css                 # Phase 4c: Dark Mode Tokens
    └── export/
        ├── brand-guidelines.pdf      # Phase 5a: PDF-Export
        ├── figma-tokens.json         # Phase 5b: Figma Variables
        └── handoff-package.zip       # Phase 5c: Frontend-Handoff
```

## Orchestrierung: /brand-full

```
Schritt 1: state.json prüfen
  → Existiert mit completed Phasen? → Resume ab nächster offener Phase
  → Existiert nicht? → Neu starten

Schritt 2: /brand-intelligence (Phase 0)
  → Prüfe: brand-strategy-brief.json existiert?
  → state.json updaten: 0_intelligence = completed

Schritt 3: /brand-generate (Phase 1+2)
  → Prüfe: design-tokens.css + brand-guidelines.html existieren?
  → state.json updaten: 1_tokens + 2_generation = completed

Schritt 4: /brand-review (Phase 3)
  → Score ≥ 7? → Weiter | Score < 7: Warnung + trotzdem weiter
  → state.json updaten: 3_review = completed

Schritt 5: /brand-extend scope=all (Phase 4)
  → Prüfe: components.html existiert?
  → state.json updaten: 4_extension = completed

Schritt 6: /brand-export format=all (Phase 5)
  → state.json updaten: 5_export = completed

Schritt 7: Zusammenfassung
  "Brand Guidelines für {{brand_name}} fertig.
   - HTML:    .output/{{brand_slug}}/brand-guidelines.html
   - PDF:     .output/{{brand_slug}}/export/brand-guidelines.pdf
   - Handoff: .output/{{brand_slug}}/export/handoff-package.zip
   - Score:   X/10 | Blind-Spot-Score: Y/10"
```

**Context-Window-Schutz:** Jede Phase liest/schreibt auf Disk. Kein Context-Carry-Over zwischen Phasen erforderlich. Bei Context-Overflow: `/brand-full` erneut aufrufen → Resume via state.json.

## Modell-Zuordnung (via openrouter-skill-v3)

| Aufgabe | Modell | Begründung |
|---------|--------|------------|
| Logo/Screenshot-Analyse | `google/gemini-3.1-flash-image-preview` | Schnell, günstig, multimodal |
| Brand Strategy Synthese | `google/gemini-2.5-pro-preview` | Reasoning-Qualität |
| HTML-Generation | `claude-sonnet` (nativ) | Beste Code-Qualität |
| Art Director Review | `claude-opus` (nativ) | Höchste visuelle Urteilskraft |
| Image Generation | `google/gemini-3.1-flash-image-preview` | Nano Banana 2 (OpenRouter) |

## Smoke-Test (/brand-test)

Schnell-Validierung ohne echten API-Aufruf:

```
/brand-test

Prüft:
  1. check-deps.sh → Dependency-Status
  2. state-template.json lesbar?
  3. Alle SKILL.md vorhanden?
  4. openrouter-skill-v3 installiert?
  5. references/ vollständig (7 Dateien)?

Output: "Plugin OK — bereit" oder Liste fehlender Komponenten
```

## Deinstallation

```bash
# Plugin entfernen
rm -rf ~/.claude/plugins/brand-design-system/

# Optional: Runtime-Outputs löschen (ACHTUNG: Brand-Daten gehen verloren)
rm -rf .output/

# openrouter-skill-v3 bleibt installiert (wird von anderen Plugins genutzt)
```

## scripts/token-generator.js — Standalone vs. SKILL.md

`token-generator.js` ist ein **optionales Standalone-Tool** — nicht der primäre Weg.

| Modus | Wann | Wie |
|-------|------|-----|
| Primär | Innerhalb des Workflows | SKILL.md orchestriert → Claude generiert Tokens direkt |
| Standalone | Manuell / CI/CD | `node token-generator.js --primary="#2563EB" --brand="Acme"` |

**SKILL.md ist die Referenz.** token-generator.js bietet denselben Output für automatisierte Pipelines ohne Claude-Aufruf.

## Fehlerbehandlung

- Jede Phase schreibt Output auf Disk **BEVOR** state.json upgedated wird
- Bei Fehler: Letzte Phase als `failed` in state.json → Retry möglich
- PDF-Export: Fallback-Kette (Puppeteer → wkhtmltopdf → Playwright → @media print)
- Figma-Push: Fallback → figma-tokens.json schreiben + manuelle Import-Anleitung
- WebSearch nicht verfügbar → Phase 0 mit statischen Templates (icp-templates.md)

## Prompt-Templates — Source of Truth

Die Dateien in `prompt-templates/` sind **Referenz-Kopien** der Writer-Deliverables.
Kanonische Quelle: `workspace/deliverables/prompt-templates/`
Bei Änderungen: Writer-Version anpassen → in Plugin kopieren (nicht umgekehrt).
