# brand-generator

**Phase 1+2: Design Token Extraktion + Single-Pass HTML Brand Guidelines Generation**

Invoked via: `/brand-generate`

## Input

| Parameter | Pflicht | Beschreibung |
|-----------|---------|-------------|
| `brand_name` | Ja | Name des Unternehmens |
| `color_primary` | Nein* | Primärfarbe (Hex) — *oder brand-strategy-brief.json |
| `industry` | Nein | Branche (für Token-Defaults) |
| `logo_path` | Nein | Logo für Farb-Extraktion via OpenRouter |
| `brand_description` | Nein | Fallback wenn kein Brief vorhanden |

*Minimal: `brand_name` + `color_primary` ODER `brand_name` + `brand-strategy-brief.json` aus Phase 0

## Output

```
.output/{{brand_slug}}/design-tokens.css       # Phase 1: CSS Custom Properties (:root)
.output/{{brand_slug}}/design-tokens.json      # Phase 1: JSON Token-Format
.output/{{brand_slug}}/brand-guidelines.html   # Phase 2: Vollständige HTML Guidelines
.output/{{brand_slug}}/state.json              # 1_tokens + 2_generation: completed
```

## Phase 1: Constraint Layer (Token-Extraktion)

### Token-Quelle bestimmen

```
Priorität:
  1. brand-strategy-brief.json → Design-Implikationen lesen (Farben, Fonts, Ästhetik)
  2. logo_path → OpenRouter Farb-Extraktion:
       openrouter-skill-v3: google/gemini-3.1-flash-image-preview
       "Extrahiere die 3 dominanten Farben aus diesem Logo als Hex-Codes"
  3. color_primary → Komplementärfarben berechnen (60-30-10 Regel)
  4. brand_description + 3 Adjektive → Palette ableiten (User-Abfrage)
```

### Token-Schema (nach references/design-tokens.md)

```css
:root {
  /* Farben — 60-30-10 Regel */
  --color-primary:    {{color_primary}};      /* 10% — Akzent, CTAs */
  --color-secondary:  {{color_secondary}};    /* 30% — Supporting */
  --color-accent:     {{color_accent}};       /* Highlight-Farbe */
  --color-bg:         {{color_bg}};           /* 60% — Hintergrund */
  --color-surface:    {{color_surface}};      /* Cards, Panels */
  --color-text:       {{color_text}};         /* Primärer Text */
  --color-text-muted: {{color_text_muted}};   /* Sekundärer Text */
  --color-border:     {{color_border}};       /* Borders, Divider */

  /* Typografie */
  --font-heading: {{font_heading}}, sans-serif;
  --font-body:    {{font_body}}, sans-serif;

  /* Schriftgrößen (9 Stufen, modular scale 1.25) */
  --text-xs:  0.75rem;   /* 12px */
  --text-sm:  0.875rem;  /* 14px */
  --text-base: 1rem;     /* 16px */
  --text-lg:  1.25rem;   /* 20px */
  --text-xl:  1.563rem;  /* 25px */
  --text-2xl: 1.953rem;  /* 31px */
  --text-3xl: 2.441rem;  /* 39px */
  --text-4xl: 3.052rem;  /* 49px */
  --text-5xl: 3.815rem;  /* 61px */

  /* Spacing (8px-Grid, 8 Stufen) */
  --space-xs:  0.5rem;   /* 8px */
  --space-sm:  1rem;     /* 16px */
  --space-md:  1.5rem;   /* 24px */
  --space-lg:  2rem;     /* 32px */
  --space-xl:  3rem;     /* 48px */
  --space-2xl: 4rem;     /* 64px */
  --space-3xl: 6rem;     /* 96px */
  --space-4xl: 8rem;     /* 128px */

  /* Radien */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 16px;

  /* Schatten */
  --shadow-sm: 0 1px 3px rgba(0,0,0,0.12);
  --shadow-md: 0 4px 12px rgba(0,0,0,0.15);
  --shadow-lg: 0 8px 32px rgba(0,0,0,0.18);
}
```

### Qualitätsprüfung

```
WCAG AA Kontrast: --color-text auf --color-bg ≥ 4.5:1
Akzentfarbe: max 10% Flächenanteil (Constraint-First-Prinzip)
Font-Lizenz: OFL/Apache bevorzugt (Google Fonts: fonts.google.com)
```

**Constraint-First-Prinzip (eingebettet):**
Tokens ZUERST definieren, DANN HTML generieren. Die Tokens sind Constraints, nicht Dekorationen.
Jede visuelle Entscheidung im HTML MUSS auf einem Token basieren. Keine Hardcoded-Werte.

## Phase 2: Single-Pass HTML Generation

### Prompt (eingebettet)

```
Du generierst eine vollständige, professionelle Brand Guidelines HTML-Datei.
PFLICHT: Alle Farb-, Spacing- und Typografie-Werte NUR via CSS Custom Properties aus design-tokens.css.
KEINE hardcodierten Werte. Kein Tailwind. Reines semantisches HTML + CSS.

Struktur (16 Sektionen):
  1. Cover — Brand Name, Tagline, Logo-Platzhalter
  2. Brand Story — Warum existiert die Brand? Mission, Vision
  3. Brand Values — 3–5 Kernwerte mit Erläuterungen
  4. Target Audience — ICP/Personas aus Phase 0
  5. Brand Voice — Tone-of-Voice Profil (Achsen, Beispiele)
  6. Logo Usage — Regeln, Schutzraum, Varianten
  7. Color System — Primär-, Sekundär-, Akzentfarben + Verwendung
  8. Typography — Schriftpaare, Hierarchie, Größen-Skala
  9. Spacing & Layout — Grid-System, Spacing-Tokens
  10. Imagery — Fotografie-Stil, Illustration-Richtung
  11. Iconography — Icon-Stil, Größen
  12. Components — Basis-Komponenten (Button, Card, Input)
  13. Don'ts — 5 konkrete Verbote
  14. Competitive Positioning — Perceptual Map (text-basiert)
  15. Blind Spots — Aus references/blind-spots-checklist.md (top 5)
  16. Appendix — Token-Referenz, Font-Links

Anti-KI-Regeln (Creative-Guardrails, eingebettet):
  - KEIN "Elevate your brand" oder generische Marketing-Sprache
  - KEINE Stock-Photo-Beschreibungen ("diverse team laughing")
  - Spezifische, eigenständige Sprache für jeden Brand
  - 60-30-10 Farbregel IMMER einhalten
  - Mindestens 3 brand-spezifische Design-Entscheidungen begründen

@media print {{
  /* Print-Styles MÜSSEN enthalten sein für PDF-Fallback */
  body {{ font-size: 12pt; }}
  .no-print {{ display: none; }}
  a {{ text-decoration: none; color: inherit; }}
  page-break-after: always; /* Pro Hauptsektion */
}}
```

### Ausführung

```
1. design-tokens.css lesen
2. brand-strategy-brief.json lesen (falls vorhanden)
3. HTML in EINEM Pass generieren (keine iterativen Teil-Writes)
4. design-tokens.css inline in <style>-Block einbetten
5. Alle 16 Sektionen vollständig ausschreiben
6. Output: .output/{{brand_slug}}/brand-guidelines.html
```

## state.json Update

```json
{
  "1_tokens":     { "status": "completed", "completed_at": "{{ISO8601}}" },
  "2_generation": { "status": "completed", "completed_at": "{{ISO8601}}" }
}
```

## Fehlerfall

- Keine Farbe definiert + keine Brand-Brief: User nach 3 Adjektiven fragen → Palette ableiten
- OpenRouter für Logo-Analyse nicht verfügbar: Manuelle Farb-Eingabe anfordern
- HTML > 200KB: Sektionen 10–16 in separater Datei (brand-guidelines-appendix.html)

## Referenzen geladen

- `references/design-tokens.md` — Token-Schema, Naming, Dokumentation (Owner: designer)
- `references/design-tokens-template.css` — CSS :root Template mit {{PLATZHALTER}}-Syntax (Owner: designer)
- `references/token-generation-logic.md` — Schritt-für-Schritt Token-Ableitung aus Brand-Input (Owner: designer)
- `references/voice-and-tone.md` — Voice-Dimensionen für Sektion 5
- `references/blind-spots-checklist.md` — Für Sektion 15
- `references/extended-tokens.md` — Dark Mode, Social Media, Print, Motion Tokens (Owner: designer)
- `references/accessibility-rules.md` — WCAG AA Regeln für HTML-Generation (Kontrast, Semantik, aria)
