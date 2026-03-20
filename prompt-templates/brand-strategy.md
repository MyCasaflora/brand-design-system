# Brand Strategy Prompt
## Strategie-Erstellung: Positionierung, Voice und Values

---

## Variable Registry

Konsistente Variablen mit `brand-analysis-prompt.md`:

| Variable | Beschreibung | Beispiel |
|----------|-------------|---------|
| `{{brand_name}}` | Name der Marke | "Acme Corp" |
| `{{industry}}` | Branche / Marktbereich | "B2B SaaS / HR Software" |
| `{{website_url}}` | Website fuer Wettbewerber-Kontext | "acmecorp.com" |
| `{{brand_description}}` | Kurzbeschreibung was die Marke tut | "HR-Software fuer KMU" |
| `{{target_market}}` | Grobe Zielmarkt-Beschreibung | "Unternehmen 10-200 MA, DACH" |
| `{{existing_analysis}}` | Output aus brand-analysis-prompt | "[Brand Health Score + Tokens]" |
| `{{differentiator}}` | Bekannte Staerke / USP | "Einfachste Onboarding-Zeit im Markt" |
| `{{tone_preference}}` | Gewuenschte Tonalitaet | "Professionell aber zugaenglich" |

---

## Der Prompt

```
Du erstellst eine Brand Strategy fuer {{brand_name}} ({{industry}}).

Kontext:
- Was die Marke tut: {{brand_description}}
- Zielmarkt: {{target_market}}
- Bekannte Staerke: {{differentiator}}
- Ton-Praeferenz: {{tone_preference}}
{{#if existing_analysis}}
- Bestehendes Analyse-Ergebnis: {{existing_analysis}}
{{/if}}

## SCHRITT 1: MARKT-ANALYSE

Analysiere den Markt fuer {{industry}}:

1. **Marktgroesse und Wachstum**: Wie gross ist der Markt? Was treibt ihn?
2. **Marktreife**: Fruehmarkt / Wachstum / Reife / Saettigung?
3. **Kaufentscheidung**: Wer kauft? Wer beeinflusst? Wer bezahlt?
4. **Pain Points**: Was frustriert Kunden im aktuellen Markt?

**Output:**
```
MARKT-KONTEXT: {{industry}}
────────────────────────────
Marktgroesse:    [Einschaetzung]
Wachstumstreiber: [2-3 Faktoren]
Marktphase:      [Fruehmarkt/Wachstum/Reife]
Haupt-Pain-Points: [3 konkrete Punkte]
```

---

## SCHRITT 2: WETTBEWERBER-AUDIT

Finde 5-7 direkte Wettbewerber zu {{brand_name}}.

Fuer jeden Wettbewerber:
- Name + Website
- Tagline / Positioning Statement
- Visuelle Sprache (Farben, Stil, Aesthetik) — ein Satz
- Tone of Voice — ein Satz
- Zielgruppe — ein Satz
- Hauptschwaeche

**Output:**
```
WETTBEWERBER-MATRIX:
────────────────────────────────────────────────────────
| Brand | Positionierung | Visuell | Voice | Zielgruppe |
|-------|----------------|---------|-------|------------|
| [W1]  | [...]          | [...]   | [...] | [...]      |
| [W2]  | [...]          | [...]   | [...] | [...]      |
| [W3]  | [...]          | [...]   | [...] | [...]      |
```

---

## SCHRITT 3: POSITIONIERUNGS-KARTE

Erstelle eine 2x2 Positionierungs-Matrix:

X-Achse: [modern ←→ traditionell] (oder branchenspezifisch sinnvollere Achse)
Y-Achse: [premium ←→ zugaenglich] (oder branchenspezifisch sinnvollere Achse)

Platziere alle Wettbewerber auf der Karte.
Identifiziere: Wo ist die Luecke? Wo koennnte {{brand_name}} einzigartig positioniert sein?

**Output:**
```
POSITIONIERUNGS-MAP:
                    PREMIUM
                       │
         [W2]          │        [W3]
                       │
  TRADITIONELL ────────┼──────── MODERN
                       │
         [W1]          │   [LUECKE]
                       │
                   ZUGAENGLICH

Empfohlene Position fuer {{brand_name}}: [X-Koordinate, Y-Koordinate]
Begruendung: "[Warum diese Luecke strategisch sinnvoll ist]"
```

---

## SCHRITT 4: ZIELGRUPPEN-PERSONAS

Erstelle 2-3 konkrete Personas fuer {{target_market}}.

Fuer jede Persona:
- Name + Rolle + Unternehmengroesse
- Demographik: Alter, Erfahrung, Tech-Affinitaet
- Pain Points: Was nervt sie gerade?
- Kaufmotivation: Was wuerde sie ueberzeugen?
- Sprache: Wie sprechen sie ueber das Problem?
- Tone-Praeferenz: Formell oder locker?

**Output:**
```
PERSONA 1: [Name]
─────────────────
Rolle:            [Titel bei Unternehmen X]
Alter:            [Range]
Pain Point:       "[In ihrer eigenen Sprache]"
Kaufmotivation:   "[Was sie ueberzeugt]"
Tone-Erwartung:   [Formalitaet 1-5] — [Begruendung]
```

---

## SCHRITT 5: UNIQUE VALUE PROPOSITION

Basierend auf Markt-Analyse, Wettbewerber-Luecke und Zielgruppen:

**UVP-Formel:**
```
Fuer [Persona] die [Problem hat],
bietet {{brand_name}} [Loesung]
anders als [Alternative] weil [Differenzierung].
```

**Messaging-Hierarchie:**
- **Headline** (max 8 Woerter): Der staerkste Satz
- **Sub-Headline** (max 20 Woerter): Die Erklaerung
- **Body-Copy Leitlinie** (3 Saetze): Wie wir kommunizieren

---

## SCHRITT 6: DESIGN-IMPLIKATIONEN

Das Strategie-Ergebnis beeinflusst ALLE Design-Entscheidungen (Bridge zu Phase 0):

**Output:**
```
DESIGN-IMPLIKATIONEN: {{brand_name}}
──────────────────────────────────────
Farbrichtung:      "[z.B. Blautöne weil 80% der Konkurrenten Gruen nutzen]"
Font-Richtung:     "[z.B. Geometrische Sans-Serif fuer Tech-Positionierung]"
Aesthetik:         "[z.B. Minimalistisch weil Zielgruppe Klarheit schaetzt]"
Tonalitaet:        "[z.B. Technisch aber zugaenglich, nicht arrogant]"
Dark/Light Mode:   "[z.B. Light Default weil Entscheider-Zielgruppe]"
Referenz-Brands:   "[z.B. Stripe (Klarheit) + Notion (Zugaenglichkeit)]"
Zone 2 Default:    "[z.B. SaaS/Tech, moderate Zone 2 center]"

Brand Voice Empfehlung:
  Formalitaet:    [1-5]
  Perspektive:    [1-5]
  Komplexitaet:   [1-5]
  Emotionalitaet: [1-5]
```

---

ZUSAMMENFASSUNG in maximal 5 Saetzen die den Brand Strategy Brief zusammenfassen.
```

---

## Fallback-Logik bei fehlenden Variablen

| Fehlende Variable | Fallback-Verhalten |
|-------------------|--------------------|
| `{{website_url}}` leer | "Keine Website. Wettbewerber-Audit basiert ausschliesslich auf Web-Search fuer '{{industry}} Wettbewerber'." |
| `{{differentiator}}` leer | "Kein bekannter USP. Schritt 5 (UVP) generiert 3 Differenzierungs-Hypothesen basierend auf der Positionierungs-Luecke. Nutzer validiert." |
| `{{target_market}}` leer | "Kein Zielmarkt definiert. Leite Zielgruppe aus Branche ({{industry}}) und Wettbewerber-Audit ab. Kennzeichne als 'Hypothese — bitte validieren'." |
| `{{tone_preference}}` leer | "Kein Ton angegeben. Empfehle Voice basierend auf Branchenstandard aus TEIL 11 Tone-of-Voice-Benchmark." |
| `{{existing_analysis}}` leer | "Kein Brand-Analysis-Output. Schritt 6 (Design-Implikationen) basiert auf Strategie-Ergebnis ohne visuellen Input. Token-Vorschlaege sind Branchenstandard-Defaults." |
| Branche zu breit (z.B. "Tech") | "Branche zu unspezifisch. Praezisiere: (A) B2B SaaS, (B) Consumer App, (C) Hardware/IoT, (D) Developer Tools? Fahre nach Auswahl fort." |

**Abgrenzung zum Researcher-Deliverable:**
Dieser Prompt liefert einen **Brand Strategy Brief** (Positionierung, Voice, Design-Implikationen).
Der Researcher liefert ein **Brand Intelligence Modul** (tiefere Markt-Daten, ICP-Templates, Apollo-Daten).
Beide koennen parallel laufen. Der Brand Strategy Brief ist schneller verfuegbar und reicht fuer Phase 0.

**Mindest-Input-Validierung:**
```
IF {{brand_name}} leer → STOP. "Markenname benoetigt."
IF {{industry}} leer UND {{brand_description}} leer → STOP. "Branche oder Beschreibung benoetigt."
ELSE → Alle anderen Luecken werden mit Fallbacks behandelt.
```

---

## Verwendung

Dieser Prompt wird in **Phase -1** (Brand Intelligence) eingesetzt.

**Inputs:**
- Minimaler Input: `{{brand_name}}` + `{{industry}}` + `{{brand_description}}`
- Optimaler Input: Alle Variablen + Output aus `brand-analysis-prompt.md`

**Outputs fliessen in:**
- `single-pass-generation-prompt.md` (Design-Implikationen als Kontext)
- `constraint-first-guide.md` (Token-Werte werden begruendet)

---

*Prompt-Familie: Brand Strategy | Owner: writer*
