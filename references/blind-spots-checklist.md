# Blind Spots Checklist
## Was in Brand Guidelines oft vergessen wird — TEIL 13

---

## Warum dieses Dokument existiert

Die meisten Brand Guidelines fokussieren auf Logo, Farben, Fonts. Die folgenden 10 Bereiche werden systematisch vergessen — und verursachen dann in der Praxis die groessten Inkonsistenz-Probleme.

**Verwendung im Plugin:** Diese Checkliste wird als Abschluss-Pruefung nach der Single-Pass Generation durchgefuehrt. Jeder Punkt der nicht abgedeckt ist, erzeugt einen expliziten Hinweis an den Nutzer.

---

## 1. Dark Mode

**Problem:** Farben einfach invertieren funktioniert nicht. Ein eigenes Token-Set ist noetig.

**Regel:** Dark Mode ist kein "invertiertes Light Mode". Es ist eine separate Farbpalette die denselben Kontrast-Anforderungen genuegt.

```css
[data-theme="dark"], .dark {
  --color-bg:          #0A0A0B;
  --color-bg-subtle:   #141416;
  --color-text:        #EDEDEF;
  --color-text-muted:  #8B8B8D;
  --color-border:      #2A2A2D;

  /* Primary/Secondary/Accent bleiben GLEICH */
  --color-primary-subtle: rgba(var(--color-primary-rgb), 0.15);

  /* Schatten muessen verstaerkt werden im Dark Mode */
  --shadow-sm: 0 1px 3px rgba(0,0,0,0.3);
  --shadow-md: 0 4px 12px rgba(0,0,0,0.4);
  --shadow-lg: 0 8px 24px rgba(0,0,0,0.5);
}
```

**Checkliste:**
- [ ] Dark-Mode-Token-Set definiert (bg, surface, text, text-muted, border)
- [ ] Primary/Accent auf dunklem Hintergrund kontrastgeprueft
- [ ] Schatten-Werte fuer Dark Mode angepasst
- [ ] `prefers-color-scheme: dark` Media Query implementiert
- [ ] Manueller Toggle via `.dark` Klasse optional vorhanden

---

## 2. Social Media Format-Specs

**Problem:** Brand Guidelines ohne Social-Media-Spezifikationen werden in der Praxis nicht konsistent angewendet.

**Pflicht-Formate:**

| Plattform | Format | Aufloesung | Besonderheit |
|-----------|--------|-----------|--------------|
| Instagram Post | Quadrat | 1080×1080px | Safe Zone: 100px rings |
| Instagram Story | Hochformat | 1080×1920px | Text-Safe: 250px oben/unten |
| LinkedIn Post | Querformat | 1200×627px | — |
| LinkedIn Story | Hochformat | 1080×1920px | — |
| Twitter/X | Querformat | 1600×900px | Safe Zone: 100px rings |
| OG Image (Web) | Querformat | 1200×630px | Fuer Link-Vorschauen |
| YouTube Thumbnail | Querformat | 1280×720px | Text lesbar ab 50% Groesse |

**Checkliste:**
- [ ] Mindestens 3 Social-Formate mit Farbpalette demonstriert
- [ ] Schriftgroessen-Minimum fuer Mobile kommuniziert (min. 24px sichtbare Schrift)
- [ ] Logo-Mindestgroesse in Social-Kontext definiert
- [ ] Hintergrundfarb-Praeferenz fuer Social-Inhalte angegeben

---

## 3. Data Visualization

**Problem:** Marken die Dashboards, Reports oder Charts nutzen, brauchen chart-spezifische Token.

**Token-Erweiterung:**

```css
:root {
  /* Chart-Farben — konsistente Reihenfolge */
  --chart-1: var(--color-primary);
  --chart-2: var(--color-secondary);
  --chart-3: var(--color-accent);
  --chart-4: #6B7280;   /* Neutral fuer 4. Datenserie */
  --chart-5: rgba(var(--color-primary-rgb), 0.4);

  /* Chart-Infrastruktur */
  --chart-grid-color:  var(--color-border);
  --chart-label-color: var(--color-text-muted);
  --chart-label-font:  var(--font-mono);
  --chart-label-size:  var(--text-xs);
}
```

**Regeln:**
- Farbblindheits-Sicherheit: Serien 1+2 muessen bei Deuteranopie unterscheidbar sein
- Niemals Farbe allein als einzige Unterscheidung — immer auch Form oder Muster
- Negative Werte: Konventionell Rot/Dunkel, aber konsistent mit Brand-Palaette

**Checkliste:**
- [ ] Chart-Token-Set definiert (mind. 5 Datenserien-Farben)
- [ ] Grid/Label-Farben angegeben
- [ ] Farbblindheits-Kompatibilitaet sichergestellt
- [ ] Dark-Mode-Variante fuer Charts bedacht

---

## 4. Empty / Error / Loading States

**Problem:** Diese States werden beim Design vergessen — und dann sieht die App ploetzlich "un-branded" aus wenn etwas schief laeuft.

**Die vier States:**

```css
/* Empty State */
.empty-state {
  text-align: center;
  padding: var(--space-3xl);
  color: var(--color-text-muted);
}

/* Error State */
.error-state {
  border-left: 3px solid var(--color-error, #EF4444);
  padding: var(--space-md) var(--space-lg);
  background: rgba(239, 68, 68, 0.05);
  color: var(--color-text);
}

/* Skeleton Loading */
.skeleton {
  background: linear-gradient(
    90deg,
    var(--color-border) 25%,
    var(--color-surface) 50%,
    var(--color-border) 75%
  );
  background-size: 200% 100%;
  animation: skeleton-shimmer 1.5s infinite;
  border-radius: var(--radius-sm);
}

/* Disabled State */
[disabled], .disabled {
  opacity: 0.4;
  cursor: not-allowed;
  pointer-events: none;
}
```

**Checkliste:**
- [ ] Empty State (leere Liste, keine Ergebnisse) gestaltet
- [ ] Error State (Fehlermeldung, Validation) gestaltet
- [ ] Loading State (Skeleton oder Spinner) gestaltet
- [ ] Disabled State fuer interaktive Elemente definiert
- [ ] Alle States nutzen Brand-Token (kein hartkodiertes Rot)

---

## 5. Icon-System

**Problem:** Gemischte Icon-Sets zerstoeren visuelle Konsistenz staerker als fast alles andere.

**Regeln:**
- EINE Icon-Library waehlen: Lucide, Phosphor oder Heroicons (nicht mischen)
- Stroke-Width konsistent: 1.5px (leicht) oder 2px (stark) — einmal festlegen, nie wechseln
- Groessen-System: 16px (inline/Text), 20px (Button), 24px (Navigation), 32px (Feature/Hero)
- Farbe: Immer `currentColor` — niemals hardcoded
- Farbige Icons: Nur in Badges und Status-Indikatoren erlaubt

```css
/* Icon-Token */
--icon-sm:   16px;
--icon-md:   20px;
--icon-lg:   24px;
--icon-xl:   32px;
--icon-stroke: 1.5px;   /* oder 2px */
```

**Checkliste:**
- [ ] Icon-Library ausgewaehlt und dokumentiert
- [ ] Stroke-Width festgelegt
- [ ] Groessen-System definiert
- [ ] Verwendungsregeln fuer farbige vs. monochrome Icons angegeben

---

## 6. Print-Spezifikationen

**Problem:** Digitale Designs werden direkt in den Druck gegeben — mit falschen Farbwerten und zu niedrigen Aufloesungen.

**Pflicht-Spezifikationen:**

| Wert | Standard |
|------|---------|
| Farbraum | CMYK fuer Druck, sRGB fuer Screen |
| Aufloesung | 300 DPI minimum |
| Anschnitt | 3mm alle Seiten |
| Sicherheitsabstand | 5mm vom Rand |
| Schwarzton | Rich Black: C60 M40 Y40 K100 |
| Weiss auf Druck | Kein Weiss drucken — Papier lassen |

**CMYK-Konvertierungs-Hinweis:**
- Helle, saettigte Digitalfarben verlieren im Druck an Leuchtkraft
- Hex-zu-CMYK-Konvertierung ergibt oft NICHT das gewuenschte Ergebnis
- Fuer Druck: CMYK-Werte explizit definieren (nicht aus Hex ableiten lassen)

**Checkliste:**
- [ ] CMYK-Aequivalente fuer alle Brand-Farben angegeben
- [ ] Mindest-Aufloesung kommuniziert
- [ ] Anschnitt/Sicherheitsabstand dokumentiert
- [ ] Print-Stylesheet in HTML-Output vorhanden (`@media print`)

---

## 7. Motion / Animation

**Problem:** Animationen ohne System wirken inkonsistent — mal schnell, mal langsam, mal spruenghaft.

**Animation-Token:**

```css
:root {
  --duration-fast:   150ms;   /* Hover, Focus */
  --duration-normal: 250ms;   /* Transitions, Fades */
  --duration-slow:   400ms;   /* Page Transitions, Modals */

  --easing-default: cubic-bezier(0.4, 0, 0.2, 1);   /* Allgemein */
  --easing-in:      cubic-bezier(0.4, 0, 1, 1);      /* Einblenden */
  --easing-out:     cubic-bezier(0, 0, 0.2, 1);      /* Ausblenden */
}

/* Accessibility: Animationen bei Nutzer-Praeferenz deaktivieren */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

**Regeln:**
- Keine Animation laenger als 400ms (wirkt traege)
- Keine Bounce/Elastic-Easings (wirkt verspielt/unprofessionell)
- `prefers-reduced-motion: reduce` ist PFLICHT (Accessibility)
- Hover: `--duration-fast` (150ms) — schnelle Rueckmeldung
- Modal/Overlay: `--duration-normal` (250ms)
- Page-Transitions: `--duration-slow` (400ms) — max

**Checkliste:**
- [ ] Duration-Tokens definiert (fast/normal/slow)
- [ ] Easing-Tokens definiert
- [ ] `prefers-reduced-motion` implementiert
- [ ] Maximale Animation-Dauer dokumentiert

---

## 8. Favicon & App-Icons

**Problem:** Favicons werden als Nachgedanke behandelt — dabei sind sie hochfrequente Brand-Touchpoints.

**Pflicht-Groessen:**

| Kontext | Groesse | Format |
|---------|---------|--------|
| Browser Favicon | 32×32px | .ico oder .png |
| Apple Touch Icon | 180×180px | .png (kein Transparenz) |
| Android Chrome | 192×192px | .png |
| Android Chrome (gross) | 512×512px | .png |
| OG Image (Social/Link) | 1200×630px | .png oder .jpg |
| PWA Maskable | 512×512px | .png (mit Padding) |

**Design-Regeln:**
- Favicon muss bei 16×16px noch erkennbar sein (kein komplexes Logo)
- Monochromes Piktogramm oder erster Buchstabe sind besser als Voll-Logo
- Background-Farbe: Primaerfarbe oder Weiss/Schwarz
- Kein Text ausser einem einzigen Buchstaben

**Checkliste:**
- [ ] Favicon-Variante fuer 16×16px definiert
- [ ] Apple Touch Icon dokumentiert
- [ ] OG Image als Social-Sharing-Standard definiert
- [ ] PWA-Anforderungen bedacht (falls relevant)

---

## 9. Responsive Verhalten

**Problem:** Brand Guidelines ohne Responsive-Angaben fuehren zu inkonsistenter Mobile-Umsetzung.

**Pflicht-Breakpoints:**

```css
:root {
  --breakpoint-sm: 640px;    /* Kleine Smartphones */
  --breakpoint-md: 768px;    /* Tablets */
  --breakpoint-lg: 1024px;   /* Laptop */
  --breakpoint-xl: 1280px;   /* Desktop */
}
```

**Responsive-Verhalten-Matrix:**

| Element | Mobil (<640px) | Tablet (640-1023px) | Desktop (≥1024px) |
|---------|----------------|---------------------|-------------------|
| Container | 100% - 2×16px | 100% - 2×24px | max-width: 1200px |
| Navigation | Hamburger Menu | Hamburger oder Tab | Horizontal Nav |
| Grid | 1 Spalte | 2 Spalten | bis 12 Spalten |
| Heading H1 | 32px | 40px | 48px |
| Section Padding | 32px | 48px | 64px |
| Cards | Stacked (100%) | Grid 2 Spalten | Grid 3 Spalten |

**Checkliste:**
- [ ] Breakpoints dokumentiert
- [ ] Navigation-Verhalten auf Mobil definiert
- [ ] Typografie-Groessen fuer Mobil angepasst (H1 nicht 64px auf 375px Breite)
- [ ] Container-Verhalten auf allen Breakpoints definiert

---

## 10. Mehrsprachigkeit

**Problem:** Designs die nur auf Englisch oder Deutsch getestet werden, brechen in anderen Sprachen.

**Kritische Kennzahlen:**
- Deutsche Texte sind ~30% laenger als Englisch → UI-Elemente muessen das aushalten
- Arabisch/Hebraeisch: RTL-Layout (Right-to-Left) — komplett anderes Layout-System
- Japanisch/Chinesisch: Kein Wortzwischenraum — andere Umbruch-Logik

**Datumsformate:**
- DE: DD.MM.YYYY → "13.03.2026"
- EN-US: MM/DD/YYYY → "03/13/2026"
- ISO: YYYY-MM-DD → "2026-03-13" (empfohlen fuer technische Kontexte)

**Zahlenformate:**
- DE: Punkt als Tausender, Komma als Dezimal → "1.000,00"
- EN-US: Komma als Tausender, Punkt als Dezimal → "1,000.00"

**Design-Regeln fuer Mehrsprachigkeit:**
- Buttons: Mindest-Breite statt fester Breite (DE-Text braucht mehr Platz)
- Navigation-Labels: Maximal 10 Zeichen EN — aber 13 Zeichen DE einplanen
- Keine Text-in-Image-Kombi wenn mehrsprachig (dann muessen Bilder mehrfach erstellt werden)

**Checkliste:**
- [ ] Soll die Marke mehrsprachig sein? (Entscheidung dokumentieren)
- [ ] Buttons mit `min-width` statt `width` wenn mehrsprachig
- [ ] Datumsformat-Konvention angegeben
- [ ] RTL-Support bedacht (falls relevant: Arabisch, Hebraeisch, Persisch)

---

## Zusammenfassung: Blind-Spot-Score

Nach der Guideline-Erstellung:

```
BLIND-SPOT-CHECK: {{brand_name}}
──────────────────────────────────
1. Dark Mode:             [ ] Abgedeckt / [ ] Fehlt / [ ] N/A
2. Social Media Formate:  [ ] Abgedeckt / [ ] Fehlt / [ ] N/A
3. Data Visualization:    [ ] Abgedeckt / [ ] Fehlt / [ ] N/A
4. Error/Empty/Loading:   [ ] Abgedeckt / [ ] Fehlt / [ ] N/A
5. Icon-System:           [ ] Abgedeckt / [ ] Fehlt / [ ] N/A
6. Print-Spezifikationen: [ ] Abgedeckt / [ ] Fehlt / [ ] N/A
7. Motion/Animation:      [ ] Abgedeckt / [ ] Fehlt / [ ] N/A
8. Favicon & App-Icons:   [ ] Abgedeckt / [ ] Fehlt / [ ] N/A
9. Responsive Verhalten:  [ ] Abgedeckt / [ ] Fehlt / [ ] N/A
10. Mehrsprachigkeit:     [ ] Abgedeckt / [ ] Fehlt / [ ] N/A

Fehlende Bereiche: [Liste der "Fehlt"-Punkte]
Empfehlung: [Welche Erweiterungen werden als naechstes empfohlen]
```

---

*Quelldokument: Brand-Design-System-Komplett.md, TEIL 13 | Owner: writer*
