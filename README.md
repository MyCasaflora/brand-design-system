# Brand Design System v1.1

Vollautomatisches Brand Design System Plugin fuer [Claude Code](https://claude.ai/claude-code) — von Market Research bis Figma Export.

Generiert aus minimalen Inputs (Markenname + Farbe) ein komplettes Design System: Strategy Brief, Design Tokens, HTML Brand Guidelines, UI-Komponenten, Landing Pages, Dark Mode, PDF-Export und Figma-Push.

## Features

- **6-Phasen-Workflow** mit Resume-Support (Phase 0-5)
- **Brand Intelligence** — Markt-Research, Wettbewerber, ICP-Profiling
- **Design Token Engine** — HSL Color Math, 60-30-10 Regel, WCAG AA Validierung
- **Single-Pass HTML Generation** — Vollstaendige Brand Guidelines als Self-Contained HTML
- **Art Director Loop** — Screenshot-basiertes visuelles QA (max 3 Iterationen)
- **UI Extension** — Komponenten-Bibliothek, Landing Pages, Dark Mode
- **Multi-Format Export** — PDF, Figma Variables, Frontend Handoff Package
- **Figma Bridge Integration** — Direct Token Push via Figma Console MCP

## Architektur

```
User Input (Name + Farbe)
    |
    v
Phase 0: Brand Intelligence ──── Market Research, ICP, Wettbewerber
    |
    v
Phase 1: Constraint Layer ────── Design Tokens (CSS Custom Properties)
    |
    v
Phase 2: HTML Generation ─────── Single-Pass Brand Guidelines
    |
    v
Phase 3: Art Director Loop ───── Screenshot → Vision AI → Fix → Repeat
    |
    v
Phase 4: UI Extension ────────── Components, Landing Page, Dark Mode
    |
    v
Phase 5: Export ───────────────── PDF, Figma Push, Handoff ZIP
```

## Installation

```bash
# Plugin nach ~/.claude/plugins/ kopieren
cp -r brand-design-system ~/.claude/plugins/

# Abhaengigkeiten pruefen
bash ~/.claude/plugins/brand-design-system/scripts/check-deps.sh
```

### Voraussetzungen

| Abhaengigkeit | Zweck | Pflicht |
|---------------|-------|---------|
| `openrouter-skill-v3` | LLM-Zugriff (Bildanalyse, Deep Research) | Ja |
| Figma Console MCP | Token Push via Desktop Bridge | Fuer Figma-Export |
| Offizielle Figma MCP | Design Context lesen | Fuer Figma-Export |
| Playwright MCP | Screenshots fuer Art Director Loop | Fuer Phase 3 |
| Node.js >= 18 | Token Generator Script | Ja |

## Commands

| Command | Phase | Beschreibung |
|---------|-------|-------------|
| `/brand-intelligence` | 0 | Markt-Research, Wettbewerber, ICP-Analyse |
| `/brand-generate` | 1+2 | Design Tokens + HTML Brand Guidelines |
| `/brand-review` | 3 | Art Director Loop (visuelles QA) |
| `/brand-extend` | 4 | UI-Komponenten, Landing Pages, Dark Mode |
| `/brand-export` | 5 | PDF, Figma-Push, Frontend-Handoff |
| `/brand-full` | 0-5 | Vollstaendiger Durchlauf mit Resume |

## Schnellstart

### Minimal (2 Commands)
```
/brand-generate brand_name="Acme Corp", color_primary="#2563EB", industry="SaaS"
/brand-export format="pdf"
```

### Vollstaendig (1 Command)
```
/brand-full brand_name="Acme Corp", industry="B2B SaaS", website_url="https://acme.com"
```

### Schrittweise
```
/brand-intelligence brand_name="Acme Corp", industry="B2B SaaS"
/brand-generate brand_name="Acme Corp"
/brand-review reference_brand="Stripe"
/brand-extend scope="all"
/brand-export format="all", handoff_profile="developer"
```

## Output-Struktur

```
.output/
  acme-corp/
    state.json                     # Phasen-Status (Resume-Info)
    brand-strategy-brief.md        # Phase 0: Research
    brand-strategy-brief.json      # Phase 0: Maschinenlesbar
    design-tokens.css              # Phase 1: CSS Custom Properties
    design-tokens.json             # Phase 1: JSON Token-Format
    brand-guidelines.html          # Phase 2: Vollstaendige Guidelines
    screenshots/                   # Phase 3: Review-Screenshots
    components.html                # Phase 4a: Komponenten-Bibliothek
    landing-page.html              # Phase 4b: Landing Page
    dark-mode.css                  # Phase 4c: Dark Mode Tokens
    export/
      brand-guidelines.pdf         # Phase 5a: PDF
      figma-tokens.json            # Phase 5b: Figma Variables
      handoff-package.zip          # Phase 5c: Frontend-Handoff
```

## Plugin-Struktur

```
brand-design-system/
  plugin.json                      # Manifest
  PLUGIN.md                        # Ausfuehrliche Dokumentation
  commands/                        # 6 Slash Commands
    brand-intelligence.md
    brand-generate.md
    brand-review.md
    brand-extend.md
    brand-export.md
    brand-full.md
  skills/                          # 5 Skills (Phasen-Logik)
    brand-intelligence/SKILL.md
    brand-generator/SKILL.md
    brand-reviewer/SKILL.md
    brand-ui-extension/SKILL.md
    brand-export/SKILL.md
  agents/                          # 1 Agent
    art-director/AGENT.md
  scripts/                         # 5 Utility Scripts
    check-deps.sh
    token-generator.js
    export-pdf.sh
    export-figma.sh
    handoff-package.sh
  references/                      # 10 Reference Documents
    design-tokens.md
    design-tokens-template.css
    token-generation-logic.md
    extended-tokens.md
    voice-and-tone.md
    accessibility-rules.md
    layout-patterns.md
    blind-spots-checklist.md
    image-generation.md
    icp-templates.md
  prompt-templates/                # 5 Prompt Templates
    brand-analysis.md
    brand-strategy.md
    single-pass-generation.md
    art-director-review.md
    ui-extension.md
  .output/                         # Generated Output (gitignored)
    state-template.json
  docs/                            # Design System Dokumentation
    design-tokens/
    ui-components/
    html-templates/
```

## MCP-Server Integration

### Figma Console MCP (Schreiben)

Verbindung via WebSocket Desktop Bridge (Port 9223).
Kein API-Token noetig — laeuft lokal ueber die Figma Desktop App.

```
Workflow:
1. figma_get_status          → Verbindung pruefen
2. figma_list_open_files     → Zieldatei waehlen
3. figma_setup_design_tokens → Token-System atomar erstellen
4. figma_take_screenshot     → Ergebnis verifizieren
```

**Tools genutzt:** `figma_setup_design_tokens`, `figma_batch_create_variables`,
`figma_create_variable`, `figma_get_variables`, `figma_take_screenshot`,
`figma_execute`, `figma_get_status`, `figma_list_open_files`

### Offizielle Figma MCP (Lesen)

Cloud-basiert via Figma REST API.

**Tools genutzt:** `get_design_context`, `get_screenshot`, `get_metadata`,
`get_variable_defs`

### OpenRouter (LLM)

Zugriff auf 300+ Modelle fuer Bildanalyse, Deep Research und Textgenerierung.

**Primaer genutzt:**
- `google/gemini-3.1-flash-image-preview` — Logo-Farbextraktion
- Vision-Modelle — Art Director Screenshot-Analyse
- Deep Research — Brand Intelligence Phase

### Playwright MCP (Browser)

Screenshot-Generierung fuer den Art Director Review Loop.

### Filesystem MCP

Datei-Operationen fuer Output-Verwaltung.

## Design Token System

### Token-Kategorien

| Kategorie | Beispiel-Tokens |
|-----------|----------------|
| **Farben** | Primary, Secondary, Accent, BG, Text, Grays (50-900) |
| **Typografie** | Font Family, Sizes (xs-4xl), Weights, Line Heights |
| **Spacing** | 4px-Raster (xs=4px bis 4xl=64px) |
| **Borders** | Radius, Width, Farben |
| **Shadows** | sm, md, lg, xl |
| **Transitions** | Duration, Easing |
| **Dark Mode** | Automatische Token-Invertierung |
| **Social Media** | Format-Specs (OG, Twitter, Instagram, LinkedIn) |
| **Print** | CMYK-Mapping, Sicherheitszonen |
| **Motion** | Easing-Kurven, Dauer-Stufen |
| **Icons** | Stroke-Width, Groessen-Stufen |
| **Data Viz** | Sequentielle/Kategorische Farbskalen |

### WCAG-Validierung

Alle Farbkombinationen werden automatisch auf WCAG AA Kontrast geprueft:
- Normal Text: >= 4.5:1
- Large Text: >= 3:1
- UI Components: >= 3:1

## Art Director Loop

Der Art Director Agent fuehrt screenshot-basiertes visuelles QA durch:

```
HTML rendern → Screenshot → Vision AI Analyse → Fixes → Repeat (max 3x)
```

**Pruefkriterien:**
- Visuelle Hierarchie und Blickfuehrung
- Whitespace-Balance und Proportionen
- Typografie-Konsistenz (Schriftgroessen, Zeilenhoehen)
- Farbharmonie und Kontraste
- Responsive Verhalten
- Accessibility (Kontrast, Touch-Targets)

## Roadmap

- [x] Figma Bridge End-to-End Test (Token Push + Verifikation)
- [ ] Figma PAT mit `file_variables` Scope fuer REST API Fallback
- [x] Plugin Deployment nach `~/.claude/plugins/`
- [ ] End-to-End Test mit `/brand-full`
- [ ] CI/CD Pipeline fuer automatische Validierung
- [ ] Marketplace-Listing

## Changelog

### v1.1.0 (2026-03-21)

**Figma Integration + System Deployment**

- Figma Desktop Bridge Schreibzugriff verifiziert (Token Push erfolgreich)
- Plugin nach `~/.claude/plugins/` deployed und Smoke-Test bestanden
- Erster Real-World-Test: WFDE Brand Guidelines generiert (Design Tokens + 16-Sektionen HTML)
- Dependency Check Script (`check-deps.sh`) validiert: Node.js, Playwright MCP, Figma MCP, OpenRouter
- GitHub Repository synchronisiert

### v1.0.1 (2026-03-20)

- Fix: Executable Permissions fuer alle Plugin Scripts

### v1.0.0 (2026-03-20)

**Initial Release**

- 6-Phasen-Workflow (Intelligence → Generate → Review → Extend → Export → Full)
- 6 Slash Commands mit YAML Frontmatter und Argument-Definitionen
- 5 Skills (brand-intelligence, brand-generator, brand-reviewer, brand-ui-extension, brand-export)
- 1 Agent (art-director mit Vision AI Loop)
- 5 Utility Scripts (check-deps, token-generator, export-pdf, export-figma, handoff-package)
- 10 Reference Documents (Design Tokens, Accessibility, Voice & Tone, etc.)
- 5 Prompt Templates (Analysis, Strategy, Generation, Review, UI Extension)
- Design Token System mit HSL Color Math und WCAG Validierung
- Figma Console MCP Integration (WebSocket Desktop Bridge)
- Offizielle Figma MCP Integration (Cloud REST API)
- OpenRouter Integration (300+ Modelle)
- Resume-Support via state.json
- HTML Brand Guidelines Template
- UI-Komponenten-Bibliothek
- Dark Mode Token-System
- Multi-Format Export (PDF, Figma, Handoff ZIP)

## Lizenz

MIT
