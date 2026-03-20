# Brand Analysis Prompt
## Analyse bestehender Logos, Assets und Websites

---

## Variable Registry

Alle Variablen die in diesem Prompt verwendet werden:

| Variable | Beschreibung | Beispiel |
|----------|-------------|---------|
| `{{brand_name}}` | Name der Marke | "Acme Corp" |
| `{{industry}}` | Branche / Marktbereich | "B2B SaaS / HR Software" |
| `{{website_url}}` | URL der bestehenden Website | "acmecorp.com" |
| `{{assets_description}}` | Beschreibung vorhandener Assets | "Logo (PNG), 3 Marketing-PDFs, Farbpalette" |
| `{{existing_colors}}` | Bekannte Markenfarben | "#1E3A5F, #F4A61D" |
| `{{existing_fonts}}` | Bekannte Schriften | "Inter, Georgia" |
| `{{target_output}}` | Gewuenschtes Analyse-Ergebnis | "Brand Voice Profil + Token-Vorschlaege" |

---

## Der Prompt

```
Du analysierst die bestehende Markenpraesenz von {{brand_name}} ({{industry}}).

## DEINE AUFGABE

Erstelle ein vollstaendiges Brand Analysis Dokument. Arbeite durch alle Abschnitte sequenziell.

---

## SCHRITT 1: VISUELLES AUDIT

Analysiere folgende vorhandenen Assets:
{{assets_description}}

Wenn eine Website vorhanden ist ({{website_url}}), rufe sie ab und analysiere:
- Hero-Sektion: Welche Farben dominieren? Welche Schriften?
- Navigation: Welche Hierarchie? Welche Abstände?
- Content-Bereich: Welcher Bildstil? Welche Tonalitaet?
- Footer: Welche Informationen? Welcher Farbkontrast?

**Output Abschnitt 1:**
```
VISUELLES PROFIL: {{brand_name}}
─────────────────────────────────
Aktuelle Primaerfarbe(n): [Hex-Codes]
Aktuelle Schriften:        [Font-Namen]
Dominanter Stil:           [Beschreibung in 1 Satz]
Staerken:                  [2-3 Punkte]
Schwaechstellen:           [2-3 Punkte]
```

---

## SCHRITT 2: BRAND VOICE ANALYSE

Analysiere alle verfuegbaren Texte (Website-Copy, Marketing-Materialien, Social Media).

Bewerte auf diesen 4 Achsen (Skala 1-5):

- **Formalitaet** (1=sehr informell, 5=sehr formal)
- **Perspektive** (1=Wir-zentriert, 5=Produkt-zentriert)
- **Komplexitaet** (1=sehr einfach, 5=sehr technisch)
- **Emotionalitaet** (1=kalt/neutral, 5=sehr emotional)

**Output Abschnitt 2:**
```
VOICE PROFIL: {{brand_name}}
─────────────────────────────
Formalitaet:    [1-5] — "[Begruendung mit Textbeispiel]"
Perspektive:    [1-5] — "[Begruendung mit Textbeispiel]"
Komplexitaet:   [1-5] — "[Begruendung mit Textbeispiel]"
Emotionalitaet: [1-5] — "[Begruendung mit Textbeispiel]"

Voice-Leitsatz: "[3 Adjektive]"
Staerkster Satz gefunden: "[Zitat aus den Materialien]"
Schwaechster Satz gefunden: "[Zitat] — Problem: [Erklaerung]"
```

---

## SCHRITT 3: DESIGN TOKEN EXTRAKTION

Extrahiere oder schlage vor:

Bekannte Ausgangswerte:
- Farben: {{existing_colors}}
- Schriften: {{existing_fonts}}

Ergaenze fehlende Tokens mit begruendeten Vorschlaegen basierend auf Branche und visuellem Stil.

**Output Abschnitt 3:**
```css
/* EXTRAHIERTE DESIGN TOKENS: {{brand_name}} */
:root {
  /* Farben — aus vorhandenen Assets */
  --color-primary:    [Hex];   /* [Herkunft/Begruendung] */
  --color-secondary:  [Hex];   /* [Herkunft/Begruendung] */
  --color-accent:     [Hex];   /* [Herkunft/Begruendung] */
  --color-bg:         [Hex];   /* [Herkunft/Begruendung] */
  --color-text:       [Hex];   /* [Herkunft/Begruendung] */
  --color-text-muted: [Hex];   /* [Herkunft/Begruendung] */

  /* Schriften */
  --font-heading: '[Font]', sans-serif;   /* [Herkunft] */
  --font-body:    '[Font]', sans-serif;   /* [Herkunft] */

  /* Spacing — 8px Grid */
  --space-sm:  8px;
  --space-md:  16px;
  --space-lg:  24px;
  --space-xl:  32px;
  --space-2xl: 48px;

  /* Radius — abgeleitet aus bestehendem Stil */
  --radius-md: [4px/8px/16px];   /* [Begruendung: scharf/mittel/weich] */
}
```

---

## SCHRITT 4: BRAND BEWERTUNG

**Output Abschnitt 4:**
```
BRAND HEALTH SCORE: {{brand_name}}
────────────────────────────────────
Visuelle Konsistenz:    [1-10] / Kommentar: "..."
Voice-Konsistenz:       [1-10] / Kommentar: "..."
Professionalitaet:      [1-10] / Kommentar: "..."
Differenzierung:        [1-10] / Kommentar: "..."
Token-Reife:            [1-10] / Kommentar: "..."
─────────────────────────────────────────────────
Gesamt:                 [Durchschnitt]

TOP 3 SOFORT-MASSNAHMEN:
1. [Konkrete Massnahme mit Wirkung]
2. [Konkrete Massnahme mit Wirkung]
3. [Konkrete Massnahme mit Wirkung]
```

---

Gewuenschtes Ergebnis: {{target_output}}
```

---

## Fallback-Logik bei fehlenden Variablen

Nicht alle Marken kommen mit vollstaendigen Assets. Der Prompt behandelt fehlende Inputs explizit:

| Fehlende Variable | Fallback-Verhalten |
|-------------------|--------------------|
| `{{website_url}}` leer | "Keine Website vorhanden. Ueberspringe Schritt 1 (Visuelles Audit). Starte direkt mit Schritt 2 basierend auf assets_description." |
| `{{assets_description}}` = "keine" | "Keine Assets vorhanden. Erstelle Token-Vorschlaege AUSSCHLIESSLICH basierend auf Branche ({{industry}}) und Best Practices. Kennzeichne alle Vorschlaege als 'Branchenstandard-Default, nicht aus Assets abgeleitet'." |
| `{{existing_colors}}` leer | "Keine Farben bekannt. Schlage 3 Farbpalletten-Optionen vor: (A) neutral/professionell, (B) warm/zugaenglich, (C) kuehn/modern. Nutzer waehlt." |
| `{{existing_fonts}}` leer | "Keine Schriften bekannt. Empfehle kostenfreie Google Fonts passend zur Branche. Nenne Begruendung." |
| `{{industry}}` unklar (z.B. "verschiedenes") | "Branche unklar. Stelle 3 Rueckfragen: (1) Wer ist der Hauptkunde? (2) B2B oder B2C? (3) Digital oder physisch? Fahre nach Antwort fort." |
| Startup ohne Logo | "Kein Logo vorhanden. Sektion 4 (Logo-System) erstellt Platzhalter-Varianten aus Initialen + Primaerfarbe. Markiere als 'Vorlaeufig — ersetzt durch finales Logo'." |

**Mindest-Input-Validierung:**
```
BEVOR der Prompt ausgefuehrt wird:
IF {{brand_name}} ist leer:
  → STOP. "Bitte gib einen Markennamen an. Ohne Namen kann keine Analyse erstellt werden."
IF {{industry}} ist leer UND {{brand_description}} ist leer:
  → STOP. "Bitte beschreibe kurz was die Marke tut oder in welcher Branche sie taetig ist."
ELSE:
  → Fahre fort. Alle anderen fehlenden Variablen werden mit Fallbacks behandelt.
```

---

## Verwendung

Dieser Prompt wird in **Phase -1** (Brand Intelligence) und vor **Phase 0** (Constraint Layer) eingesetzt.

**Inputs:**
- Mindest-Input: `{{brand_name}}` + `{{industry}}`
- Optimal-Input: Alle Variablen befuellt + Screenshot/URL der Website

**Outputs fliessen in:**
- `brand-strategy-prompt.md` (Positionierung)
- `single-pass-generation-prompt.md` (extrahierte Tokens)

---

*Prompt-Familie: Brand Analysis | Owner: writer*
