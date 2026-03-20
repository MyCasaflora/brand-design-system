# UI Extension Prompt
## Prompt fuer die UI/UX-Erweiterung: Komponenten, Patterns und Webseiten

---

## Variable Registry

Konsistente Variablen mit allen anderen Prompts:

| Variable | Beschreibung | Beispiel |
|----------|-------------|---------|
| `{{brand_name}}` | Name der Marke | "Acme Corp" |
| `{{tokens_file}}` | Pfad zur design-tokens.css | "design-tokens-acme.css" |
| `{{guidelines_file}}` | Pfad zur generierten Brand Guideline HTML | "brand-guidelines-acme.html" |
| `{{extension_scope}}` | Was soll erstellt werden | "Komponenten-Bibliothek / Landingpage / Dashboard" |
| `{{component_list}}` | Gewuenschte Komponenten | "Buttons, Cards, Forms, Navigation, Footer" |
| `{{page_type}}` | Art der Zielseite | "SaaS Landingpage / Pricing / About" |
| `{{reference_brand}}` | Visuelles Benchmark | "Stripe + Linear" |
| `{{content_brief}}` | Inhalte fuer die Seite | "Hero: 'Effortless HR', 3 Features, Testimonial, CTA" |

---

## Prompt A: Komponenten-Bibliothek (Phase 2)

```
Du erweiterst das bestehende Brand Design System von {{brand_name}} um eine UI-Komponenten-Bibliothek.

Basis: Die bestehenden Design Tokens aus {{tokens_file}}
Referenz: Die Brand Guidelines aus {{guidelines_file}}

## KRITISCHE REGEL
Kein einziger Token wird neu definiert oder ueberschrieben.
Alle Komponenten NUTZEN die bestehenden :root-Variablen.
Neue Tokens werden NUR ergaenzt, nie geaendert.

## NEUE TOKENS (ergaenzend zu :root)

Ergaenze den bestehenden :root-Block:
```css
:root {
  /* Buttons */
  --btn-height:          40px;
  --btn-height-sm:       32px;
  --btn-height-lg:       48px;
  --btn-padding:         var(--space-sm) var(--space-lg);
  --btn-radius:          var(--radius-md);
  --btn-font-size:       var(--text-sm);
  --btn-font-weight:     500;

  /* Inputs */
  --input-height:        44px;
  --input-padding:       var(--space-sm) var(--space-md);
  --input-border:        1px solid var(--color-border);
  --input-radius:        var(--radius-md);
  --input-focus-ring:    0 0 0 3px rgba(var(--color-primary-rgb), 0.15);

  /* Cards */
  --card-padding:        var(--space-lg);
  --card-radius:         var(--radius-lg);
  --card-border:         1px solid var(--color-border);
  --card-shadow:         var(--shadow-sm);
  --card-shadow-hover:   var(--shadow-md);

  /* Navigation */
  --nav-height:          64px;
  --nav-padding:         var(--space-lg);
}
```

## ZU ERSTELLENDE KOMPONENTEN: {{component_list}}

Erstelle jede Komponente als eigenstaendige CSS-Klasse + HTML-Markup-Beispiel.

Fuer JEDEN Komponenten-Typ:

### Buttons
- `.btn-primary` — Hauptaktion (--color-primary als Background)
- `.btn-secondary` — Sekundaer (outline mit --color-border)
- `.btn-ghost` — Tertiaer (transparent, nur Hover)
- `.btn-sm` / `.btn-lg` — Groessen-Varianten
- Alle Hover-States und Focus-States
- Accessibility: `role`, `aria-*` Attribute

### Forms
- `.input` — Standard Text-Input
- `.input-label` — Label oberhalb
- `.input-error` — Fehlerzustand (--color-error oder Rot-Ton)
- `.input-success` — Erfolg
- `.select` — Dropdown
- `.checkbox` + `.radio` — Custom Styled

### Cards
- `.card` — Base Card
- `.card-header` / `.card-body` / `.card-footer`
- `.card-interactive` — Klickbare Card mit Hover
- `.card-featured` — Hervorgehobene Card (--color-primary border-left)

### Navigation
- `.nav` — Top-Navigation
- `.nav-logo` — Logo-Bereich
- `.nav-links` — Navigations-Links
- `.nav-cta` — CTA-Button in der Navigation
- Mobile: Hamburger-Toggle (CSS-only wenn moeglich)

### Tabellen / Listen (fuer Guidelines)
- `.table` — Datentabelle mit Zebra-Streifen
- `.list-feature` — Feature-Liste mit Icons
- `.list-do-dont` — Do/Don't Gegenuebersteuung

## OUTPUT

Eine HTML-Datei `components-{{brand_name}}.html` mit:
1. :root Ergaenzungen
2. Alle Komponenten-CSS-Klassen
3. Visueller Showcase: Jede Komponente dargestellt
4. Code-Snippets: `<!-- Markup fuer [Komponente] -->` Kommentare
```

---

## Prompt B: Landingpage / Webseite (Phase 3)

```
Du erstellst eine vollstaendige {{page_type}} fuer {{brand_name}}.

Basis:
- Design Tokens: {{tokens_file}}
- Brand Guidelines: {{guidelines_file}}
- Komponenten: components-{{brand_name}}.html

Content-Brief: {{content_brief}}

## KRITISCHE REGEL
Diese Seite nutzt AUSSCHLIESSLICH:
1. Tokens aus :root
2. Komponenten aus der Komponenten-Bibliothek
3. Kein neues CSS ausserhalb von Token-Kombinationen

## SEKTIONS-STRUKTUR fuer {{page_type}}

### SaaS Landingpage:
1. Navigation (sticky, .nav + .nav-links + .nav-cta)
2. Hero-Sektion (grosser Claim, Subline, 2 CTAs, optional Screenshot/Mockup)
3. Social Proof Bar (Logos von Kunden oder Zahlen)
4. Feature-Sektion (3-6 Features mit .card oder .list-feature)
5. How It Works (Nummerierte Schritte)
6. Testimonials (Quote-Karten)
7. Pricing-Teaser (optional, Link zu Pricing)
8. CTA-Sektion (finaler Aufruf zur Aktion)
9. Footer (.footer mit Links, Social, Legal)

### Anpassung basierend auf {{page_type}}:
- Passe Sektionen an den spezifischen Seitentyp an
- Nutze Content-Brief: {{content_brief}}

## QUALITAETS-CONSTRAINTS (identisch mit single-pass-generation-prompt)

1. Alle Werte als var(--...) — KEIN hardcoded CSS
2. Spacing: Nur 8px-Grid-Werte
3. Farbverhaltnis 60-30-10
4. Kontrast WCAG AA
5. Konsistenz: Gleiche Komponenten sehen gleich aus
6. Weissraum: Section-Padding min var(--space-3xl)
7. Anti-KI-Look: Keine Glow-Effekte, kein Gradient-Overload
8. Referenz-Kalibrierung: {{reference_brand}}-Standard

## OUTPUT

Dateiname: {{page_type}}-{{brand_name}}.html
Format: Vollstaendige HTML-Datei, responsive, printfaehig
```

---

## Prompt C: Dark Mode Erweiterung

```
Du erweiterst das Token-System von {{brand_name}} um Dark Mode.

Basis: {{tokens_file}} (Light Mode ist der bestehende :root Block)

## ANFORDERUNGEN

1. Alle Light-Mode-Tokens bleiben unveraendert (rueckwaerts-kompatibel)
2. Dark-Mode-Tokens in @media (prefers-color-scheme: dark)
3. Optional: Manueller Toggle via .dark class auf <html>

## TOKEN-MAPPING

Definiere fuer Dark Mode:
```css
@media (prefers-color-scheme: dark) {
  :root {
    --color-bg:         #0F1117;   /* [Begruendung: tief-dunkler Hintergrund] */
    --color-surface:    #1A1D2E;   /* [Begruendung: leicht heller als bg] */
    --color-text:       #E8EBF0;   /* [Begruendung: Off-White, kein reines Weiss] */
    --color-text-muted: #8B929E;   /* [Begruendung: reduzierte Opazitaet] */
    --color-border:     #2D3142;   /* [Begruendung: subtile Trennung] */
    /* --color-primary bleibt identisch oder wird angepasst */
    /* --color-accent bleibt identisch oder wird aufgehellt */
  }
}
```

## REGELN FUER DARK MODE FARBEN

- Kein reines Schwarz (#000000) — zu hart
- Kein reines Weiss (#FFFFFF) im Dunkelmodus — zu hart
- Primary-Farbe pruefen: Wirkt sie auf dunklem Hintergrund?
- Schattierungen invertieren (helle Schatten in dark mode oft ausblenden)
- WCAG AA muss auch im Dark Mode eingehalten werden

## OUTPUT

Erweiterte :root Variablen-Datei + Showcase-Seite mit Hell/Dunkel-Toggle
```

---

## Fallback-Logik bei fehlenden Variablen

| Fehlende Variable | Fallback-Verhalten |
|-------------------|--------------------|
| `{{tokens_file}}` leer | STOP. "Tokens-Datei ist Pflicht. Fuehre zuerst single-pass-generation-prompt aus — die :root-Tokens werden dort definiert." |
| `{{guidelines_file}}` leer | "Keine bestehende Guideline. Erstelle Komponenten ohne visuellen Referenz-Kontext. Empfehle: Erst single-pass-generation-prompt, dann ui-extension." |
| `{{component_list}}` leer | "Keine Komponenten-Liste. Erstelle Standard-Set: Buttons (3 Varianten), Cards, Forms (Input, Select, Checkbox), Navigation, Footer." |
| `{{page_type}}` unklar | "Seitentyp unklar. Erstelle generische Marketing-Landingpage als sichersten Default. Anpassbar nach Fertigstellung." |
| `{{content_brief}}` leer | "Kein Content-Brief. Verwende Placeholder-Texte mit Brand-Name und Branche. Kennzeichne alle Texte als '[PLACEHOLDER — ersetzen]'." |
| `{{extension_scope}}` leer | "Kein Scope definiert. Starte mit Prompt A (Komponenten-Bibliothek) als kleinstem sinnvollen Schritt." |
| Tokens-Datei nicht kompatibel | "Tokens-Format unbekannt. Lese :root-Block aus der HTML-Datei oder frage nach den wichtigsten Werten: Primaerfarbe, Heading-Font, Spacing-Base." |

**Mindest-Input-Validierung:**
```
IF {{brand_name}} leer → STOP. "Markenname benoetigt."
IF {{tokens_file}} leer UND {{guidelines_file}} leer:
  → STOP. "Token-Quelle benoetigt. Entweder tokens_file oder guidelines_file angeben."
ELSE → Fehlende optionale Variablen mit Fallbacks fuellen und kennzeichnen.
```

---

## Verwendung

### Wachstumsphasen im Plugin:

```
Phase 1 (Standard):  single-pass-generation-prompt
                     → brand-guidelines-{{brand_name}}.html

Phase 2 (Erweiterung): ui-extension-prompt Prompt A
                       → components-{{brand_name}}.html

Phase 3 (Webseite):  ui-extension-prompt Prompt B
                     → [pagetype]-{{brand_name}}.html

Phase 4 (Dark Mode): ui-extension-prompt Prompt C
                     → dark-mode-{{brand_name}}.css
```

**Inputs:**
- Mindest-Input: `{{brand_name}}` + `{{tokens_file}}` + `{{extension_scope}}`
- Optimal: `{{guidelines_file}}` + `{{component_list}}` + `{{content_brief}}`

**Outputs:**
- Komponenten-HTML (Phase 2)
- Webseiten-HTML (Phase 3)
- Dark-Mode-CSS (Phase 4)

---

*Prompt-Familie: UI Extension | Owner: writer*
