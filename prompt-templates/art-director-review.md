# Art Director Review Prompt
## Visueller Self-Review Loop nach der HTML-Generierung

---

## Variable Registry

Konsistente Variablen mit allen anderen Prompts:

| Variable | Beschreibung | Beispiel |
|----------|-------------|---------|
| `{{brand_name}}` | Name der Marke | "Acme Corp" |
| `{{html_file_path}}` | Pfad zur generierten HTML-Datei | "brand-guidelines-acme.html" |
| `{{reference_brand}}` | Visuelles Referenz-Benchmark | "Stripe + Notion" |
| `{{iteration_number}}` | Aktuelle Iteration (1-3) | "1" |
| `{{screenshot_path}}` | Pfad zum Screenshot der gerenderten Datei | "/tmp/screenshot.png" |
| `{{previous_issues}}` | Gefundene Probleme der letzten Iteration | "[Liste]" |

---

## Prompt A: Visueller Art Director Pass (Subagent)

*Dieser Subagent bekommt NUR den Screenshot — keinen Code-Zugriff.*

```
Du bist ein Senior Art Director der professionelle Brand Guidelines bewertet.

Du siehst einen Screenshot einer Brand Guideline fuer {{brand_name}}.
Du hast KEINEN Zugriff auf den HTML/CSS Code.
Dein Urteil basiert AUSSCHLIESSLICH auf dem visuellen Eindruck.

## DEINE AUFGABE

Nenne GENAU 5 konkrete, umsetzbare Verbesserungen.

Keine Philosophie. Keine allgemeinen Ratschlaege.
Jede Verbesserung muss spezifisch genug sein, dass ein Entwickler sie direkt umsetzen kann.

## FORMAT

Fuer jede Verbesserung:
```
VERBESSERUNG [1-5]:
Problem:     [Was genau sieht falsch aus / fuehlt sich falsch an?]
Ort:         [Welche Sektion / welches Element?]
Massnahme:   [Was genau soll geaendert werden?]
Prioritaet:  [HOCH / MITTEL / NIEDRIG]
```

## BEWERTUNGS-KRITERIEN (in dieser Reihenfolge pruefen)

1. Spacing-Rhythmus: Sind Abstaende konsistent? Gibt es gequetschte Bereiche?
2. Typografie-Hierarchie: Ist auf Anhieb klar was H1, H2, Body ist?
3. Farbverhaltnis: Dominiert eine Farbe zu stark? Ist der Akzent uebermaessig eingesetzt?
4. Kontrast: Ist jeder Text muehelos lesbar?
5. Alignment: Sind Elemente sauber ausgerichtet?
6. Visuelles Gewicht (Squint-Test): Wohin geht der Blick zuerst — ist das richtig?
7. Weissraum: Atmet das Design? Oder ist es voll?
8. Konsistenz: Sehen gleiche Elemente gleich aus?
9. Senior-Designer-Feeling: Was fehlt um es auf das Niveau von {{reference_brand}} zu bringen?
10. Anti-KI-Check: Gibt es Anzeichen von KI-typischen Aesthetik-Problemen?

Referenz-Brand fuer Kalibrierung: {{reference_brand}}
Iteration: {{iteration_number}} / 3

[SCREENSHOT HIER EINGEBETTET: {{screenshot_path}}]
```

---

## Prompt B: QA-Polish-Check (Mechanisch)

*Dieser Schritt prueft Code-Ebene — kein visuelles Urteilen.*

```
Du fuehrst einen mechanischen Polish-Check an der Brand Guideline durch.
Datei: {{html_file_path}}

## PRUEFE FOLGENDE PUNKTE (ja/nein + Fundstellen)

1. TOKENS-ONLY REGEL
   [ ] Existieren hardcoded Hex-Werte ausserhalb von :root?
   [ ] Existieren px-Werte ausserhalb von :root die keine Token nutzen?
   → Suche nach: `color: #`, `background: #`, `border-color: #`
   → Suche nach: `padding: [0-9]`, `margin: [0-9]`, `font-size: [0-9]`

2. 8PX-GRID PRUEFUNG
   [ ] Sind alle Padding/Margin-Werte Vielfache von 8 (oder Token)?
   → Suche nach ungeraden Werten: 3px, 5px, 10px, 12px, 15px, 22px

3. TYPOGRAFIE-TOKENS
   [ ] Werden alle font-size Werte als var(--text-*) angegeben?

4. KONSISTENZ-CHECK
   [ ] Haben alle .button-Elemente identisches Styling?
   [ ] Haben alle .card-Elemente identisches Styling?
   [ ] Haben alle h2-Elemente identisches Styling?

5. WCAG-KONTRAST (Einschaetzung)
   [ ] Ist Body-Text auf hellem Hintergrund dunkel genug (geschaetzte Pruefung)?
   [ ] Ist Text auf farbigem Hintergrund kontrastreich genug?

## OUTPUT FORMAT

```
POLISH-CHECK ERGEBNIS: {{brand_name}} (Iteration {{iteration_number}})
─────────────────────────────────────────────────────────────────────
Token-Verstoss:    [Anzahl] Fundstellen — [konkrete Zeilen oder "Keine"]
Grid-Verstoss:     [Anzahl] Fundstellen — [konkrete Werte oder "Keine"]
Typografie:        [BESTANDEN / VERSTOSS: konkrete Fundstellen]
Konsistenz:        [BESTANDEN / VERSTOSS: konkrete Elemente]
Kontrast:          [BESTANDEN / ACHTUNG: konkrete Bereiche]

STATUS: [BESTANDEN / KORREKTUR NOTWENDIG]
Naechster Schritt: [Referenz-Vergleich ODER Korrekturen auflisten]
```
```

---

## Prompt C: Referenz-Vergleich (Letzter 2%-Check)

*Wird nur einmal durchgefuehrt — nach bestandenem QA-Check.*

```
Du vergleichst eine Brand Guideline visuell mit {{reference_brand}}.

Deine Aufgabe:
Nenne 3 konkrete Dinge die {{reference_brand}} in ihren Designs hat,
die in dieser Brand Guideline noch fehlen oder schlechter umgesetzt sind.

Keine allgemeinen Prinzipien. Nur konkrete, sichtbare Unterschiede.

Format:
```
REFERENZ-VERGLEICH: {{brand_name}} vs. {{reference_brand}}
──────────────────────────────────────────────────────────
1. [Was {{reference_brand}} hat / macht]:
   Aktueller Stand: [Was diese Guideline zeigt]
   Empfehlung:      [Konkrete Massnahme]

2. [...]
3. [...]

FAZIT: [Ist das Qualitaets-Niveau nahe genug an {{reference_brand}}?
        Ja/Nein + ein Satz Begruendung]
```

[SCREENSHOT HIER EINGEBETTET: {{screenshot_path}}]
```

---

## Gesamt-Ablauf

```
Start: HTML-Datei aus single-pass-generation-prompt generiert
  ↓
Schritt 1: Screenshot erstellen ({{screenshot_path}})
  ↓
Schritt 2: Prompt A — Subagent Art Director (nur Screenshot)
           → 5 visuelle Verbesserungen
  ↓
Schritt 3: Haupt-Agent wendet Verbesserungen im HTML an
  ↓
Schritt 4: Prompt B — QA-Polish-Check (mechanisch)
           → Bestanden? → Weiter | Nicht bestanden? → Fix + zurueck zu Schritt 2
  ↓
Schritt 5: Prompt C — Referenz-Vergleich (einmalig)
           → 3 finale Verfeinerungen
  ↓
Schritt 6: Finaler Screenshot → Qualitaet akzeptiert?
           → Ja: Export | Nein: Iteration (max 3x gesamt)
```

---

## Fallback-Logik bei fehlenden Variablen

| Fehlende Variable | Fallback-Verhalten |
|-------------------|--------------------|
| `{{screenshot_path}}` leer | STOP. "Screenshot ist Pflicht fuer den visuellen Review. Rendere die HTML-Datei im Browser und erstelle einen Screenshot. Pfad angeben." |
| `{{html_file_path}}` leer | STOP. "HTML-Datei-Pfad fuer QA-Check (Prompt B) fehlt. Gib den Pfad zur generierten Brand-Guideline-HTML an." |
| `{{reference_brand}}` leer | "Kein Referenz-Brand angegeben. Nutze Standard-Benchmark: Stripe (Tech/SaaS), Notion (Consumer), Linear (Developer Tools). Waehle passend zur Branche." |
| `{{iteration_number}}` leer | "Annahme: Iteration 1. Wenn dies eine Wiederholung ist, gib die aktuelle Iteration-Nummer an (max 3)." |
| `{{previous_issues}}` leer | "Kein Vorgaenger-Feedback. Starte Review ohne Vorbedingungen — vollstaendige Analyse aller 10 Kriterien." |
| Screenshot nicht lesbar | "Screenshot zu klein oder unscharf. Mindest-Anforderung: 1200px Breite, 72 DPI. Bitte Screenshot neu erstellen." |
| Nach 3 Iterationen kein BESTANDEN | "Max. 3 Iterationen erreicht. Aktuelle Qualitaet dokumentieren. Ausstehende Probleme als 'Manuell zu pruefen' markieren. Export trotzdem ermoeglichen." |

**Mindest-Input-Validierung:**
```
IF {{screenshot_path}} leer → STOP. "Screenshot fuer Prompt A benoetigt."
IF {{html_file_path}} leer UND Prompt B gewuenscht → STOP. "HTML-Pfad fuer QA-Check benoetigt."
IF {{iteration_number}} > 3 → "Max. Iterationen erreicht. Fahre mit Export fort."
```

---

## Verwendung

Diese Prompts werden in **Phase 2** (Visual Self-Review Loop) eingesetzt.

**Reihenfolge:**
1. Prompt A — Art Director (visuell)
2. Prompt B — QA-Check (mechanisch)
3. Prompt C — Referenz-Vergleich (einmalig nach Bestehen)

**Qualitaets-Gate:**
- Max 3 Iterationen von Prompt A+B
- Prompt C nur einmal (nach der letzten Iteration)

---

*Prompt-Familie: Art Director Review | Owner: writer*
