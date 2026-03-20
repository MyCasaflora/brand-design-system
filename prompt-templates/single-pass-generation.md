# Single-Pass Generation Prompt
## Hauptprompt fuer die vollstaendige HTML-Generierung der Brand Guidelines

---

## Variable Registry

Konsistente Variablen mit allen anderen Prompts:

| Variable | Beschreibung | Beispiel |
|----------|-------------|---------|
| `{{brand_name}}` | Name der Marke | "Acme Corp" |
| `{{industry}}` | Branche | "B2B SaaS / HR Software" |
| `{{color_primary}}` | Haupt-Hex-Farbe | "#1E3A5F" |
| `{{color_secondary}}` | Sekundaer-Hex-Farbe | "#E8F0F7" |
| `{{color_accent}}` | Akzent-Hex-Farbe | "#F4A61D" |
| `{{color_bg}}` | Hintergrund-Hex | "#FFFFFF" |
| `{{color_text}}` | Text-Hex | "#1A1A1A" |
| `{{font_heading}}` | Heading-Schriftfamilie | "Inter" |
| `{{font_body}}` | Body-Schriftfamilie | "Inter" |
| `{{brand_voice}}` | Voice-Profil (aus brand-analysis) | "Formalitaet:4, Perspektive:3, Komplexitaet:3, Emotionalitaet:2" |
| `{{brand_tagline}}` | Haupttagline | "HR-Software die einfach funktioniert" |
| `{{brand_values}}` | 3-5 Markenwerte | "Einfachheit, Verlässlichkeit, Menschlichkeit" |
| `{{reference_brand}}` | Visuelles Referenz-Benchmark | "Stripe + Notion" |
| `{{radius_style}}` | Ecken-Stil | "scharf (4px) / mittel (8px) / weich (16px)" |
| `{{strategy_brief}}` | Output aus brand-strategy-prompt | "[Kompaktes Brand Strategy Summary]" |

---

## Der Prompt

```
Du erstellst JETZT eine vollstaendige Brand Guideline fuer {{brand_name}} als EINE einzige HTML-Datei.

## KRITISCHE REGEL: SINGLE-PASS PRINZIP
Erstelle ALLES in einem einzigen Output. Keine Rueckfragen. Keine Schritte.
EINE HTML-Datei. ALLE Sektionen. JETZT.

Grund: 1 Datei = 1 Kontext = 0 Kontextverlust. Inkonsistenz entsteht nur bei mehreren Passes.

---

## DESIGN TOKENS (UNVERAENDERLICH — nutze diese exakt)

```css
:root {
  --color-primary:    {{color_primary}};
  --color-secondary:  {{color_secondary}};
  --color-accent:     {{color_accent}};
  --color-bg:         {{color_bg}};
  --color-surface:    [leicht abweichend von bg, z.B. #F8FAFC];
  --color-text:       {{color_text}};
  --color-text-muted: [50% dunkler/heller als text];
  --color-border:     [subtil, 10% dunkler als bg];

  --font-heading: '{{font_heading}}', sans-serif;
  --font-body:    '{{font_body}}', sans-serif;

  --text-xs:   12px; --text-sm: 14px; --text-base: 16px;
  --text-lg:   20px; --text-xl: 24px; --text-2xl:  32px;
  --text-3xl:  40px; --text-4xl: 48px; --text-5xl:  64px;

  --space-xs: 4px;  --space-sm:  8px;  --space-md:  16px;
  --space-lg: 24px; --space-xl:  32px; --space-2xl: 48px;
  --space-3xl: 64px; --space-4xl: 96px;

  --radius-sm: 4px; --radius-md: 8px; --radius-lg: 16px;

  --shadow-sm: 0 1px 3px rgba(0,0,0,0.08);
  --shadow-md: 0 4px 12px rgba(0,0,0,0.10);
  --shadow-lg: 0 8px 24px rgba(0,0,0,0.12);
}
```

VERBOT: Kein einziger Hex-Wert, keine einzige px-Angabe ausserhalb von :root.
Immer: `color: var(--color-primary)` — NIEMALS `color: #1E3A5F`

---

## BRAND KONTEXT

- Marke: {{brand_name}} ({{industry}})
- Tagline: {{brand_tagline}}
- Werte: {{brand_values}}
- Voice-Profil: {{brand_voice}}
- Referenz-Benchmark: {{reference_brand}}
- Strategie-Kontext: {{strategy_brief}}

---

## ZU ERSTELLENDE SEKTIONEN (alle in einer HTML-Datei)

### Sektion 1 — Cover / Titelseite
- Grossformatiger Markenname mit --font-heading in --text-5xl
- Tagline: {{brand_tagline}}
- Primaerfarbe als Hero-Hintergrund
- "Brand Guidelines [Jahr]" als Unterzeile

### Sektion 2 — Inhaltsverzeichnis
- Alle Sektionen aufgelistet
- Navigierbar (Anchor-Links)
- Stil: Clean, minimalistisch

### Sektion 3 — Unser Warum (Mission & Values)
- Mission Statement (1-2 Saetze)
- Markenwerte: {{brand_values}} — jeder mit Icon-Platzhalter + 2-Satz-Erklaerung
- Voice: Nutze das Voice-Profil {{brand_voice}} konsequent

### Sektion 4 — Logo-System
- Logo-Platzhalter (SVG-Rectangle mit Markenfarbe + Markenname als Text)
- Verwendungsregeln: Minimalgroesse, Schutzzone, erlaubte Varianten
- Verbotene Verwendungen (visuell demonstriert): Strecken, Farbaenderung, Rotation

### Sektion 5 — Farbpalette
- Alle Farben als grosse Farbfelder mit Hex-Code, RGB, CMYK-Aequivalent
- Primaer-, Sekundaer-, Akzent-, Text-, Hintergrundfarben
- Verwendungsbeispiele: "Wann welche Farbe" als kurze Regel

### Sektion 6 — Typografie-System
- Heading-Font ({{font_heading}}): Display alle Gewichte
- Body-Font ({{font_body}}): Regular, Medium, Bold
- Type Scale: alle --text-Groessen visuell demonstriert
- Verwendungsregeln: Was ist H1, H2, Body, Caption?

### Sektion 7 — Spacing & Grid
- 8px Grid visuell erklaert
- Alle --space-Tokens als visuelle Referenz
- Abstand-Beispiele: "Button padding", "Section padding", "Card padding"

### Sektion 8 — Tone of Voice
- Voice-Profil auf den 4 Achsen
- 3 Beispielpaare: "Wir sagen... Wir sagen nicht..."
- Verbotene Woerter / Phrasen
- Tonalitaet nach Kontext-Tabelle

### Sektion 9 — Bildsprache & Fotografie
- Stilrichtlinien: Was passt, was nicht
- Farb-Behandlung: Filter / Tinting
- Beispiel-Beschreibungen (Placeholder-Texte die echte Bilder beschreiben)

### Sektion 10 — Anwendungsbeispiele
- Business Card Mockup (HTML/CSS)
- E-Mail Header Mockup
- Social Media Post Mockup (quadratisch)
- Website Hero-Sektion Mockup

---

## QUALITAETS-CONSTRAINTS

Bevor du den Code generierst, stelle sicher:

1. TOKENS: Kein hardcoded Wert — alles var(--...)
2. SPACING: Kein Wert ausserhalb des 8px-Grids
3. FARBVERHALTNIS: Akzentfarbe auf max 10% der Flaeche
4. KONTRAST: Body-Text min 4.5:1 gegen Hintergrund
5. KONSISTENZ: Alle Buttons gleich, alle Cards gleich, alle H2 gleich
6. WEISSRAUM: Section-Padding mindestens --space-2xl (48px)
7. ANTI-KI-LOOK: Kein Gradient-Overload, keine Glow-Effekte, keine 3D-Schatten
8. REFERENZ-KALIBRIERUNG: Wuerde {{reference_brand}} dieses Design abnicken?

---

## OUTPUT-FORMAT

Eine einzelne HTML-Datei:
- Doctype HTML5
- Google Fonts Import fuer {{font_heading}} und {{font_body}}
- Alle CSS in einem <style>-Block (kein externes CSS)
- Alle Sektionen in <section>-Tags mit id="[name]"
- Print-Stylesheet fuer PDF-Export (am Ende des <style>-Blocks)
- Kommentare nur wo die Logik nicht selbsterklärend ist

Dateiname: brand-guidelines-{{brand_name}}.html
```

---

## Fallback-Logik bei fehlenden Variablen

| Fehlende Variable | Fallback-Verhalten |
|-------------------|--------------------|
| `{{color_primary}}` leer | PAUSE. "Primaerfarbe ist Pflicht. Gib einen Hex-Code an (z.B. #1E3A5F) oder beschreibe die Farbe in einem Wort (z.B. 'Navyblau')." |
| `{{font_heading}}` leer | "Verwende 'Inter' als professionellen Default. Kennzeichne in Guideline als Placeholder." |
| `{{font_body}}` leer | "Verwende denselben Font wie {{font_heading}} oder 'Inter'." |
| `{{color_secondary}}` leer | "Leite ab: 10% hellere Variante von {{color_primary}} oder neutrales #F4F6F8." |
| `{{color_accent}}` leer | "Leite ab: Komplementaerfarbe zu {{color_primary}} oder warmes #F4A61D als Default." |
| `{{brand_tagline}}` leer | "Erstelle 3 Tagline-Optionen basierend auf {{brand_name}} + {{industry}}. Nutzer waehlt." |
| `{{brand_values}}` leer | "Verwende Branchen-Defaults als Placeholder. Kennzeichne als 'Placeholder — bitte anpassen'." |
| `{{brand_voice}}` leer | "Verwende neutralen Ausgangspunkt: Formalitaet 3, Perspektive 3, Komplexitaet 3, Emotionalitaet 2." |
| `{{reference_brand}}` leer | "Standard-Benchmark: Stripe (Tech/SaaS) oder Notion (Consumer/Productivity)." |
| `{{strategy_brief}}` leer | "Generiere ohne Markt-Kontext. Hinweis in Guideline: 'Positionierungs-Kontext fehlt — empfehle brand-strategy-prompt vor finaler Version'." |
| Alle Farben fehlen | "Frage: 'Beschreibe deine Marke in 3 Adjektiven.' Leite komplette Palaette ab und dokumentiere Begruendungen." |

**Mindest-Input-Validierung:**
```
IF {{brand_name}} leer → STOP. "Markenname benoetigt."
IF {{color_primary}} leer → PAUSE. "Primaerfarbe oder 3 beschreibende Adjektive benoetigt."
ELSE → Alle anderen Luecken mit obigen Fallbacks fuellen und im Output kennzeichnen.
```

---

## Verwendung

Dieser Prompt wird in **Phase 1** (Single-Pass Generation) eingesetzt.

**Inputs (Pflicht):**
- `{{brand_name}}` + `{{color_primary}}`

**Inputs (Empfohlen):**
- Alle Token-Variablen (`{{color_*}}`, `{{font_*}}`)
- `{{brand_tagline}}` + `{{brand_values}}`
- `{{brand_voice}}` aus `brand-analysis-prompt.md`
- `{{strategy_brief}}` aus `brand-strategy-prompt.md`

**Output:**
- Eine einzige HTML-Datei ~ 800-1200 Zeilen
- Direkt oeffenbar im Browser
- Druckbar als PDF (via @media print)

---

*Prompt-Familie: Single-Pass Generation | Owner: writer*
