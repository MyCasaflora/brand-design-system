# brand-intelligence

**Phase 0: Markt-Research, Wettbewerber-Analyse, ICP, Brand Strategy Brief**

Invoked via: `/brand-intelligence`

## Input

| Parameter | Pflicht | Beschreibung |
|-----------|---------|-------------|
| `brand_name` | Ja | Name des Unternehmens |
| `industry` | Ja | Branche (z.B. "B2B SaaS", "Fintech", "Retail") |
| `website_url` | Nein | Firmen-Website für tiefere Analyse |
| `brand_description` | Nein | Kurzbeschreibung falls keine URL |
| `logo_path` | Nein | Pfad zum Logo für visuelle Analyse |
| `existing_colors` | Nein | Bereits definierte Markenfarben |

## Output

```
.output/{{brand_slug}}/brand-strategy-brief.md    # Human-readable
.output/{{brand_slug}}/brand-strategy-brief.json  # Maschinenlesbar
.output/{{brand_slug}}/state.json                 # 0_intelligence: completed
```

## Workflow (9 Schritte)

### Schritt 1: Markt-Analyse (5–10 Min)
**Tools:** WebSearch, WebFetch
```
WebSearch: "{{brand_name}} {{industry}} market positioning 2026"
WebSearch: "{{industry}} brand design trends 2026"
Falls website_url: WebFetch → Homepage + About-Seite analysieren
Output: market_context (Größe, Wachstum, Reife, Disruption-Grad)
```

### Schritt 2: Wettbewerber-Audit (10–15 Min)
**Tools:** WebSearch, (optional) Apollo MCP
```
WebSearch: "{{industry}} top companies 2026 design brands"
Ziel: 3–5 direkte Wettbewerber identifizieren
Pro Wettbewerber: Visual Style, Tone of Voice, Positionierungs-Achsen
Output: competitor_matrix (Tabelle: Wettbewerber × Dimensionen)
HINWEIS: Apollo MCP liefert Firmendaten, KEINE Psychographics — WebSearch für ToV
```

### Schritt 3: Perceptual Map (5 Min)
```
Dimensionen (2 Achsen wählen nach Branche):
  - Traditional ↔ Progressive
  - Minimal ↔ Expressive
  - Corporate ↔ Human
  - Premium ↔ Accessible
Positionierung: Wettbewerber einordnen → Whitespace für {{brand_name}} finden
Output: perceptual_map (Text-Darstellung + Positionierungs-Empfehlung)
```

### Schritt 4: Zielgruppen-Research (5–10 Min)
**Tools:** WebSearch, icp-templates.md (→ references/)
```
WebSearch: "{{industry}} buyer persona 2026"
WebSearch: "{{brand_name}} customers target audience"
ICP-Template aus references/icp-templates.md auswählen (nach Branche)
Font-Lizenzen PRÜFEN wenn Schriftart-Empfehlungen gemacht werden (OFL/Apache bevorzugt)
Output: icp_profile (Primary ICP ausgefüllt nach Template)
```

### Schritt 5: Tone-of-Voice Benchmark (5 Min)
**Referenz:** voice-and-tone.md (→ references/)
```
WebSearch: "{{industry}} brand tone of voice examples"
Achsen aus voice-and-tone.md anwenden:
  Formal ↔ Casual | Technical ↔ Simple | Bold ↔ Subtle
Wettbewerber-ToV einordnen → Whitespace für {{brand_name}}
Output: voice_profile (4 Achsen-Scores + Begründung)
```

### Schritt 6: Visueller Benchmark (5–10 Min)
**Tools:** OpenRouter (via openrouter-skill-v3), WebFetch
```
Falls logo_path: → openrouter-skill-v3 aufrufen:
  Modell: google/gemini-3.1-flash-image-preview
  Prompt: "Analysiere dieses Logo: Formsprache, Farben, Stilrichtung, Zielgruppe"
  → color_analysis, style_direction extrahieren
Falls website_url: Screenshot via WebFetch → Visuelle Analyse
Output: visual_benchmark (Stil-Klassifikation + Farb-Extraktion)
```

### Schritt 7: Trend-Kontext (5 Min)
**Tools:** WebSearch
```
WebSearch: "design trends 2026 {{industry}}"
Trend-Bewertungs-Matrix (eingebettet):
  - Substanz-Check: Löst dieser Trend ein echtes Problem? (1-10)
  - Haltbarkeit: > 3 Jahre Perspektive? (1-10)
  - Passung: Passt zum Brand-Archetypus? (1-10)
  Nur Trends mit Score ≥ 7/10 empfehlen
WICHTIG: Trends als KONTEXT nutzen, nicht als Vorlage. Anti-Trend-Jagen.
Fallback: Statische Trend-Liste 2026 (Brutalist Reduction, Quiet Luxury, Neomorphic Flat)
Output: trend_block (3–5 Trends mit Bewertung)
```

### Schritt 8: Synthese → Brand Strategy Brief
```
brand-strategy-brief.md erstellen:
  1. Executive Summary (3 Sätze)
  2. Markt-Kontext + Positionierung
  3. Wettbewerber-Matrix (Tabelle)
  4. Perceptual Map + Whitespace-Empfehlung
  5. ICP/Persona (ausgefüllt)
  6. Tone-of-Voice Profil
  7. Visueller Stil (Farb-Richtung, Typografie-Empfehlung, Ästhetik)
  8. Trend-Empfehlungen (nur Score ≥ 7)
  9. Design-Implikationen (Konkrete Empfehlungen für Phase 1)

brand-strategy-brief.json erstellen:
  { brand_name, industry, color_direction, font_direction,
    brand_archetype, voice_profile, icp_primary, competitor_matrix }
```

### Schritt 9: Rechtliche Prüfung (5–10 Min)
```
Font-Lizenz: Empfohlene Fonts → OFL/Apache prüfen (Google Fonts bevorzugt)
Farbmarken: Bekannte Farbmarken in der Branche prüfen (WebSearch)
Disclaimer: "Rechtliche Prüfung ist Empfehlung, kein Rechtsrat"
Output: legal_notes (Abschnitt in brand-strategy-brief.md)
```

## state.json Update

```json
{ "0_intelligence": { "status": "completed", "completed_at": "{{ISO8601}}" } }
```

## Fehlerfall

- WebSearch nicht erreichbar → Weiter mit statischen Templates aus references/icp-templates.md
- website_url nicht erreichbar → Brandfetch API als Fallback (WebSearch "{{brand_name}} logo colors")
- Logo-Analyse schlägt fehl → Visuellen Benchmark überspringen, Hinweis in Output

## Referenzen geladen

- `references/voice-and-tone.md` — Voice-Dimensionen und Achsen
- `references/icp-templates.md` — 6 ICP/Persona-Templates nach Branche
- `references/image-generation.md` — OpenRouter Prompts für Logo-Analyse
