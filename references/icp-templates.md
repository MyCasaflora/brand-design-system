# ICP- und Persona-Templates
## Wiederverwendbare Templates für Brand Intelligence

**Version:** 1.1
**Owner:** researcher
**Status:** COMPLETED (nach DA/BSA Review)
**Letzte Aktualisierung:** 2026-03-13

---

## Übersicht

Diese Datei enthält sofort einsetzbare Templates für:
1. [B2B] Ideal Customer Profile (ICP)
2. [B2C] Ideal Customer Profile (ICP)
3. [Multi-Sided Platform / Marketplace] ICP (D2C, Two-Sided Markets)
4. Buyer Persona (B2B + B2C)
5. Brand Personality Profil
6. Wettbewerber-Vergleichsmatrix
7. Positionierungs-Statement (Value Proposition)

Jedes Template enthält: Struktur + Platzhalter + Beispiel-Ausfüllung.

---

## 1. B2B — Ideal Customer Profile (ICP)

### 1.1 Template

```markdown
# B2B Ideal Customer Profile: [MARKENNAME]
Erstellt: [DATUM] | Version: [X]

## FIRMOGRAPHICS (Das Unternehmen)

| Kriterium | Wert | Notizen |
|-----------|------|---------|
| **Unternehmensgröße** | [z.B. 50–500 Mitarbeiter] | [Warum diese Größe?] |
| **Jahresumsatz** | [z.B. €5M–€50M] | [Revenue-Qualifier] |
| **Industrie/Vertikale** | [z.B. SaaS, Professional Services, Manufacturing] | [Primär + Sekundär] |
| **Geographie** | [z.B. DACH, EU, Global] | [Primärmarkt] |
| **Unternehmensstruktur** | [z.B. Private / VC-backed / Corporate] | |
| **Tech-Stack-Reife** | [z.B. Cloud-First / Hybrid / Legacy] | |
| **Wachstumsphase** | [z.B. Scale-up / Established / Transformation] | |

## PSYCHOGRAPHICS (Das Unternehmen als Entität)

**Unternehmenskultur:**
- [Bullet: z.B. Innovationsbereit, experimentierfreudig]
- [Bullet: z.B. Prozessorientiert, compliance-bewusst]
- [Bullet]

**Kaufverhalten:**
- Entscheidungsgeschwindigkeit: [z.B. Schnell <1 Monat / Mittel 1–3 Monate / Langsam >3 Monate]
- Entscheidungsstruktur: [z.B. Einzelentscheider / Komitee / Procurement-Prozess]
- Budget-Mentalität: [z.B. ROI-fokussiert / Strategisch / Kostenbewusst]

## TECHNOGRAPHIC

| Dimension | Details |
|-----------|---------|
| Bestehende Tools | [z.B. Salesforce, HubSpot, Slack] |
| Integration-Anforderungen | [z.B. Muss mit Existing CRM verbinden] |
| Daten-Sensibilität | [z.B. GDPR-kritisch, on-premise bevorzugt] |

## TRIGGER-EVENTS (Wann kaufen sie?)

**Positive Trigger:**
- [z.B. Neue Funding-Runde abgeschlossen]
- [z.B. Neuer CMO/CTO eingestellt]
- [z.B. Wachstumsziel für nächstes Quartal gesetzt]

**Pain-Trigger:**
- [z.B. Aktuelles Tool skaliert nicht mit]
- [z.B. Compliance-Anforderung tritt in Kraft]
- [z.B. Wettbewerber gewinnt Marktanteile]

## IDEAL-BUYER-PERSONA (Kontakt im Unternehmen)

| Dimension | Wert |
|-----------|------|
| Jobtitel | [z.B. Head of Marketing, VP Growth, CMO] |
| Seniority | [z.B. Director-Level / C-Level] |
| Hauptverantwortung | [z.B. Pipeline-Wachstum, Brand-Awareness] |
| KPIs unter denen er/sie leidet | [z.B. CAC zu hoch, Conversion sinkt] |
| Budget-Verfügung | [z.B. Ja, bis €50k / Nein, braucht CFO-Sign-off] |

## DISQUALIFIZIERER (Wen wir NICHT wollen)

- [z.B. Unternehmen unter 10 Mitarbeiter — zu klein für ROI]
- [z.B. Pure Freelancer ohne Team]
- [z.B. Branchen mit Compliance-Konflikt]

## SUCCESS METRICS (Woran messen wir einen guten Kunden?)

- [z.B. LTV > 3× CAC]
- [z.B. NPS > 50]
- [z.B. Expansion Revenue > 20% nach Jahr 1]
```

### 1.2 Beispiel-Ausfüllung (B2B SaaS)

```markdown
# B2B ICP: BrandFlow AI (fiktiv)
Erstellt: 2026-03-13 | Version: 1.0

## FIRMOGRAPHICS

| Kriterium | Wert | Notizen |
|-----------|------|---------|
| Unternehmensgröße | 50–500 Mitarbeiter | Klein genug für Agilität, groß genug für Budget |
| Jahresumsatz | €5M–€100M | Seed/Series-A-Phase abgeschlossen |
| Industrie | B2B SaaS, Digital-Agencies, E-Commerce | Primär SaaS |
| Geographie | DACH + UK | Erstmarkt DACH |
| Unternehmensstruktur | VC-backed oder profitable Bootstrapper | |
| Tech-Stack-Reife | Cloud-First | API-Integration möglich |
| Wachstumsphase | Scale-up | Schnelles Wachstum, braucht Effizienz |

## PSYCHOGRAPHICS

**Unternehmenskultur:**
- Bewegt sich schnell, toleriert Iteration
- Sieht Brand als Wachstumshebel, nicht als Kostenstelle
- Hat bereits schlechte Erfahrungen mit teuren Agenturen gemacht

**Kaufverhalten:**
- Entscheidungsgeschwindigkeit: Mittel (2–6 Wochen)
- Entscheidungsstruktur: Founder / Head of Marketing entscheidet
- Budget-Mentalität: ROI-fokussiert, aber bereit für Tool-Investment

## TRIGGER-EVENTS

**Positive Trigger:**
- Series A abgeschlossen, Brand-Refresh geplant
- Neues Marktsegment wird erschlossen
- Rebrand nach Pivot notwendig

**Pain-Trigger:**
- Freelancer-Branding ist nicht skalierbar
- Team wächst, Inkonsistenz im Brand nimmt zu
- Agentur-Angebote sind zu teuer (>€20k)

## IDEAL-BUYER-PERSONA

| Dimension | Wert |
|-----------|------|
| Jobtitel | Head of Marketing, Growth Lead, Founder |
| Seniority | VP/Director oder Founder (10–15 Mitarbeiter im Team) |
| KPIs | Brand-Awareness, Content-Output-Volumen, Time-to-Market |
| Budget | Ja, eigenständig bis €5k/Monat |

## DISQUALIFIZIERER

- Enterprises >2000 Mitarbeiter (brauchen dediziertes Brand-Team)
- Unternehmen ohne digitalem Touchpoint
- Branchen: Pharma (zu viel Compliance), Rüstung
```

---

## 2. B2C — Ideal Customer Profile (ICP)

### 2.1 Template

```markdown
# B2C Ideal Customer Profile: [MARKENNAME]
Erstellt: [DATUM] | Version: [X]

## DEMOGRAPHISCH

| Kriterium | Primäre Zielgruppe | Sekundäre Zielgruppe |
|-----------|-------------------|---------------------|
| **Alter** | [z.B. 28–45] | [z.B. 18–27] |
| **Geschlecht** | [z.B. 60% weiblich] | |
| **Einkommen (netto/Monat)** | [z.B. €2.500–€5.000] | |
| **Bildungsstand** | [z.B. Hochschulabschluss] | |
| **Beruf** | [z.B. Angestellte in Kreativberufen] | |
| **Wohnort-Typ** | [z.B. Städtisch, Großstadt] | |
| **Familienstand** | [z.B. Keine Kinder / Kleinkinder] | |

## PSYCHOGRAPHISCH

**Werte & Überzeugungen:**
- [z.B. Nachhaltigkeit als echter Wert, nicht Trend]
- [z.B. Qualität über Quantität]
- [z.B. Eigenständigkeit und Selbstausdruck]

**Lifestyle:**
- [z.B. Aktiv, reist 3–5x/Jahr, nutzt primär Mobile]
- [z.B. Kauft bewusst, recherchiert vor Kauf]

**Marken-Loyalität:**
- [z.B. Brand-conscious, bereit für Premium-Preise]
- [z.B. Community-getrieben, empfiehlt aktiv weiter]

## BEHAVIORAL

**Kaufentscheidungs-Prozess:**
1. [z.B. Trigger: Problem/Inspiration auf Social Media]
2. [z.B. Research: Google + Reviews + YouTube]
3. [z.B. Validierung: Freundes-Empfehlung oder Influencer]
4. [z.B. Kauf: Website oder App]
5. [z.B. Post-Purchase: Teilt Erlebnis auf Instagram]

**Informationskanäle:**
- Primär: [z.B. Instagram, TikTok, Newsletter]
- Sekundär: [z.B. Google, Podcasts]
- Trust-Signal: [z.B. UGC > Branded Content]

**Preissensibilität:**
- [z.B. Bereit für 20–30% Aufpreis vs. Generic für Qualität]

## PAIN POINTS & MOTIVATIONEN

| Pain Point | Motivation (Gegenteil) |
|-----------|----------------------|
| [z.B. Zu viel Auswahl, Entscheidungs-Stress] | [Kuratiert und einfach] |
| [z.B. Gekaufte Bewertungen, kein echtes Trust] | [Authentische Community] |
| [z.B. Produkt hält Versprechen nicht] | [Ehrlichkeit, Transparenz] |

## SPRACHE DER ZIELGRUPPE

**Wörter die sie verwenden:**
[z.B. "intentional", "minimal", "slow living", "curated", "investment piece"]

**Wörter die sie NICHT mögen:**
[z.B. "exklusiv" (klingt arrogant), "revolutionär" (Buzzword), "nachhaltig" (überstrapaziert)]

**Content-Formate die resonieren:**
[z.B. Authentische Behind-the-Scenes, HOW-TO, Real Reviews, Educational]
```

### 2.2 Beispiel-Ausfüllung (B2C Premium Beauty)

```markdown
# B2C ICP: Naturkosmetik Brand "Forma" (fiktiv)

## DEMOGRAPHISCH
- Alter: 27–42, Primär weiblich (75%)
- Einkommen: €2.800–€6.000 netto/Monat
- Bildung: Hochschule / FH
- Wohnort: Berlin, München, Hamburg, Wien, Zürich

## PSYCHOGRAPHISCH
- Werte: Wissenschaftlich fundiert + natürlich (kein Greenwashing)
- Lifestyle: Fit, bewusste Ernährung, Yoga oder Cardio, Reist
- Loyalität: Wechselt selten, empfiehlt aktiv → NPS-Potential hoch

## BEHAVIORAL
- Discovery: Instagram (Reels > Posts), Newsletter-Kuratierung
- Research: INCI-Listen prüfen, Beauty-Blogger, Reddit
- Trust-Signal: Gründerin sichtbar, Formulierung transparent
- Kauf: Website (Mobile 70%), auch bei Parfümerie

## PAIN POINTS
- "Kenne die Inhaltsstoffe nicht" → Lösung: Radikale Transparenz
- "Günstig = funktioniert nicht" → Lösung: Premium ohne Prestige-Aufschlag
- "Zu viele Optionen" → Lösung: Kuratiertes Kernsortiment

## SPRACHE
- ✅ "Wirkstoff-fokussiert", "klinisch validiert", "minimal formuliert"
- ❌ "natürlich" (allein), "grün", "eco-friendly" (ohne Beweis)
```

---

## 3. Multi-Sided Platform / Marketplace ICP

Plattformen, Marketplaces und D2C-Brands haben zwei oder mehr Zielgruppen mit unterschiedlichen Bedürfnissen. Das ICP muss für jede Seite separat definiert werden.

### 3.1 Template

```markdown
# Multi-Sided Platform ICP: [PLATTFORMNAME]
Erstellt: [DATUM] | Modell: [Marketplace / D2C / Two-Sided / Multi-Sided]

## PLATTFORM-MODELL

| Seite | Bezeichnung | Rolle | Primäre Motivation |
|-------|-------------|-------|-------------------|
| Seite A | [z.B. "Anbieter" / "Seller" / "Creator"] | [Wer bietet an?] | [z.B. Reichweite, Einnahmen] |
| Seite B | [z.B. "Käufer" / "Consumer" / "Brand"] | [Wer konsumiert/kauft?] | [z.B. Auswahl, Vertrauen] |
| Seite C (falls vorhanden) | [z.B. "Advertiser"] | [Rolle] | [Motivation] |

**Henne-Ei-Problem:** [Welche Seite muss zuerst gewonnen werden, damit die andere folgt?]
**Monetarisierungs-Seite:** [Welche Seite zahlt? Beide? Freemium?]

---

## SEITE A: [ANBIETERS-BEZEICHNUNG] ICP

### Firmographics / Demographics
[Verwende B2B ICP Template (Abschnitt 1) oder B2C ICP Template (Abschnitt 2) je nach Anbieter-Typ]

### Kern-Motivation für Plattform-Beitritt
- [z.B. Zugang zu Zielgruppe die sie allein nicht erreichen]
- [z.B. Reduktion von Akquise-Kosten]
- [z.B. Infrastruktur die sie nicht selbst aufbauen wollen]

### Threshold-Anforderung (wann joinen sie?)
[z.B. "Mindestens X aktive Käufer auf Plattform bevor Seller beitritt"]

### Abwanderungs-Risiko
[z.B. "Wenn Plattform eigene Produkte einführt (Amazon-Problem)"]

---

## SEITE B: [KÄUFERS-BEZEICHNUNG] ICP

### Firmographics / Demographics
[Verwende B2B ICP Template oder B2C ICP Template]

### Kern-Motivation für Plattform-Nutzung
- [z.B. Größte Auswahl an einem Ort]
- [z.B. Vertrauens-Signal durch Plattform-Kuration]
- [z.B. Einfacherer Vergleich / bessere Preise]

### Trust-Anforderung
[z.B. "Käufer braucht Käuferschutz und verifizierte Anbieter"]

### Switch-Kosten
[z.B. "Niedrig — wechselt bei besserer Auswahl woanders"]

---

## NETZWERKEFFEKT-ANALYSE

| Typ | Beschreibung | Stärke |
|-----|-------------|--------|
| Direct (same-side) | Mehr Käufer → besser für andere Käufer | [Stark / Mittel / Schwach] |
| Indirect (cross-side) | Mehr Seller → besser für Käufer (und umgekehrt) | [Stark / Mittel / Schwach] |
| Data | Mehr Nutzung → bessere Empfehlungen | [Stark / Mittel / Schwach] |

**Kritische Masse:** [Wie viele Nutzer auf welcher Seite braucht die Plattform zum Funktionieren?]

---

## BRAND-IMPLIKATION FÜR MULTI-SIDED PLATFORMS

| Herausforderung | Brand-Lösung |
|----------------|-------------|
| Zwei Zielgruppen mit anderen Bedürfnissen | Separate Messaging-Tracks, gemeinsame übergeordnete Brand-Vision |
| Anbieter ≠ Konsument-Kommunikation | Gleiche Visual Identity, unterschiedliche Tonalität je Kontext |
| Trust auf beiden Seiten nötig | Brand als neutraler Vermittler positionieren |
| Henne-Ei Bootstrapping | Kommunikation priorisiert zuerst [Seite A / B] |
```

### 3.2 Beispiel-Ausfüllung (Freelancer-Marktplatz)

```markdown
# Multi-Sided Platform ICP: "CreativeHive" (fiktiv)
Modell: Two-Sided Marketplace

## PLATTFORM-MODELL
| Seite | Bezeichnung | Rolle | Motivation |
|-------|-------------|-------|-----------|
| Seite A | Freelancer (Creative) | Bieten Services an | Projekte + stabiles Einkommen |
| Seite B | Unternehmen (Buyer) | Kaufen Kreativ-Services | Schneller Zugang zu verifizierten Talenten |

Henne-Ei: Freelancer zuerst — ohne Talentpool kommen keine Unternehmen.
Monetarisierung: Provision von Seite A (15%) + Premium-Listing Seite A.

## SEITE A: FREELANCER ICP
- Selbstständig, 1–5 Jahre Erfahrung, Design/Text/Video
- Motivation: Planbare Pipeline, kein Kaltakquise-Stress
- Threshold: >200 aktive Projektausschreibungen/Monat
- Abwanderung: Wenn Direktkontakt mit Kunden blockiert wird

## SEITE B: UNTERNEHMEN ICP
- KMU 10–200 MA, Marketing-Team 1–5 Personen
- Motivation: Vorgescreente Talente, schnelle Besetzung (<48h)
- Trust: Portfolio-Verifikation + Bewertungssystem essentiell
- Switch-Kosten: Mittel — wechselt wenn Pool woanders größer

## NETZWERKEFFEKT
- Indirect: Stark — mehr Freelancer = schnellere Besetzung = mehr Unternehmen
- Data: Mittel — Matching-Algorithmus verbessert sich mit Volumen

## BRAND-IMPLIKATION
- Freelancer-Kommunikation: Empowerment, Freiheit, Kontrolle ("Dein Business, deine Regeln")
- Unternehmens-Kommunikation: Effizienz, Verlässlichkeit, Speed ("Talent, wenn du es brauchst")
- Übergeordnete Brand-Vision: "Die faire Plattform für kreative Arbeit"
```

---

## 4. Buyer Persona Template

### 4.1 Template (universell B2B + B2C)

```markdown
# Buyer Persona: [PERSONA-NAME]
Für Marke: [MARKENNAME] | Typ: [B2B / B2C] | Priorität: [Primär / Sekundär]

## STECKBRIEF

**Name (fiktiv):** [z.B. "Pragmatic Paula" / "Ambitious Andreas"]
**Alter:** [X]
**Beruf/Rolle:** [z.B. Head of Marketing bei SaaS-Startup]
**Wohnort:** [z.B. Berlin, 2-Zimmer-Wohnung im Prenzlauer Berg]
**Familienstand:** [z.B. Keine Kinder, Beziehung]
**Einkommen:** [z.B. €65.000/Jahr]
**Zitat das diese Person sagt:**
> "[Authentisches Zitat, das ihren Mindset beschreibt]"

## EIN TAG IM LEBEN

06:30 — [Morgen-Routine, Tech-Nutzung]
09:00 — [Arbeitsbeginn, Hauptaufgaben]
12:00 — [Mittagspause, Informationskonsum]
15:00 — [Herausforderungen des Tages]
19:00 — [Feierabend-Verhalten, Hobbies]
22:00 — [Letzte Mediennutzung, Apps]

## GOALS & MOTIVATIONS

**Beruflich:**
- [Ziel 1: z.B. Nächste Beförderung in 18 Monaten]
- [Ziel 2: z.B. Effizientere Prozesse ohne mehr Headcount]

**Persönlich:**
- [Ziel 1: z.B. Work-Life-Balance verbessern]
- [Ziel 2: z.B. Als Experte wahrgenommen werden]

## PAIN POINTS

**Hauptproblem:**
[1 Satz — das eine Problem das diese Person nachts wachhält]

**Sekundäre Probleme:**
- [Pain 2]
- [Pain 3]

**Frustrationen mit bisherigen Lösungen:**
- [z.B. Zu teuer für tatsächlichen Wert]
- [z.B. Zu komplex / lernintensiv]
- [z.B. Kein echtes Support-Team]

## INFORMATIONS-VERHALTEN

**Trusted Sources:**
- [z.B. Newsletter: Morning Brew, Lenny's Newsletter]
- [z.B. Communities: Slack-Groups, Twitter/X, LinkedIn]
- [z.B. Medien: t3n, OMR, Gründerszene]

**Entscheidungs-Prozess:**
1. [Schritt 1: Trigger]
2. [Schritt 2: erste Research]
3. [Schritt 3: Validierung]
4. [Schritt 4: Entscheidung]

**Trust-Signale die wirken:**
- [z.B. Case Studies mit echten Zahlen]
- [z.B. Bewertungen auf G2/Capterra]
- [z.B. Founder/Team ist sichtbar]

## WIE UNSERE MARKE DIESE PERSONA ANSPRICHT

**Messaging-Ansatz:**
[1–2 Sätze: Wie formulieren wir unser Angebot für diese Person?]

**Content-Formate:**
- [Format 1 + Kanal]
- [Format 2 + Kanal]

**Vermeidungen (was NICHT funktioniert):**
- [z.B. Übertriebene Versprechen]
- [z.B. Zu technische Sprache]
```

### 4.2 Beispiel-Ausfüllung

```markdown
# Buyer Persona: "Pragmatic Paula"
Für: BrandFlow AI | Typ: B2B | Priorität: Primär

**Name:** Paula M., 34
**Beruf:** Head of Marketing, 40-köpfiges SaaS-Startup
**Wohnort:** München, Schwabing
**Einkommen:** €78.000/Jahr + Bonus
**Zitat:**
> "Ich brauche keine perfekte Lösung — ich brauche eine die morgen funktioniert."

## EIN TAG IM LEBEN
07:00 — Morning Run, Podcasts (How I Built This, OMR)
09:00 — Team Stand-up, Prioritäten für Sprint
11:00 — Content-Kalender reviewen, Briefings schreiben
13:00 — LinkedIn checken, Newsletter-Inbox
15:00 — KPI-Dashboard: Warum sinkt die Conversion?
18:00 — Remote, aber noch Slack open
22:00 — Twitter/X, dann Figma für Hobby-Projekt

## GOALS
- Beruflich: Brand-Awareness verdoppeln ohne Agentur-Budget
- Persönlich: Weniger Micro-Management, mehr strategische Arbeit

## PAIN POINTS
**Hauptproblem:** Brand-Inkonsistenz im wachsenden Team frisst Zeit.

- Designer + Texter arbeiten nach eigenen Regeln → Chaos
- Agentur-Angebote starten bei €15k — unrealistisch
- Bisherige Lösungen: Canva (zu generisch), Notion-Wiki (zu statisch)

## INFORMATIONS-VERHALTEN
- Newsletter: Lenny's Newsletter, OMR Daily
- Community: Growww Slack, Marketing-Twitter
- Trust: LinkedIn-Posts von Gründern, echte Case Studies

## ANSPRACHE
**Messaging:** "Paula bekommt ein AI-gestütztes Brand System das ihr Team
sofort nutzen kann — ohne Agentur, ohne wochenlange Onboarding."

**Formate:** LinkedIn-Carousel + Loom-Demos, keine langen Whitepapers
**Vermeidungen:** Kein "revolutionär", kein Tech-Jargon, keine Vergleichs-Tabellen
```

---

## 5. Brand Personality Profil Template

### 4.1 Template

```markdown
# Brand Personality Profil: [MARKENNAME]
Erstellt: [DATUM]

## BRAND ARCHETYP

**Primärer Archetyp:** [Wähle aus:]
- Der Held (Nike, Adidas) — Überwindung, Stärke, Triumph
- Der Schöpfer (Adobe, LEGO) — Innovation, Kreativität, Originalität
- Der Weise (Google, McKinsey) — Wissen, Expertise, Wahrheit
- Der Fürsorger (IKEA, Dove) — Schutz, Fürsorge, Gemeinschaft
- Der Rebell (Harley-Davidson, Virgin) — Freiheit, Regelbruch, Authentizität
- Der Liebende (Chanel, Häagen-Dazs) — Begehren, Intimität, Schönheit
- Der Jester (Old Spice, Dollar Shave Club) — Spaß, Humor, Leichtigkeit
- Der Unschuldige (Dove, Innocent) — Reinheit, Einfachheit, Optimismus
- Der Entdecker (The North Face, Jeep) — Abenteuer, Freiheit, Entdeckung
- Der Herrscher (Mercedes, Rolex) — Kontrolle, Prestige, Qualität
- Der Magier (Apple, Disney) — Transformation, Vision, Staunen
- Der Jedermann (IKEA, Gap) — Zugehörigkeit, Ehrlichkeit, Zugänglichkeit

**Sekundärer Archetyp:** [Zweiter aus obiger Liste]

**Begründung:** [Warum passt dieser Archetyp zur Positionierung?]

## PERSONALITY DIMENSIONS (Big Five für Brands)

| Dimension | Score (1-10) | Beschreibung |
|-----------|-------------|-------------|
| **Aufrichtigkeit** | [X]/10 | [z.B. Ehrlich, warmherzig, familienorientiert] |
| **Aufregung** | [X]/10 | [z.B. Gewagt, lebendig, vorstellungskräftig] |
| **Kompetenz** | [X]/10 | [z.B. Verlässlich, intelligent, erfolgreich] |
| **Kultiviertheit** | [X]/10 | [z.B. Gehobener Klasse, charmant, romantisch] |
| **Robustheit** | [X]/10 | [z.B. Outdoor-orientiert, maskulin, westlich] |

## PERSONALITY STATEMENT

```
[MARKENNAME] ist wie [METAPHER/PERSON]:
[ADJEKTIV 1], [ADJEKTIV 2], aber niemals [ANTI-ADJEKTIV].

Sie/Er/Es [TUN/VERB] für [ZIELGRUPPE] was niemand sonst tut:
[UNIQUE BEHAVIOR].
```

**Beispiel:**
"BrandFlow AI ist wie ein erfahrener Kreativ-Direktor:
strukturiert, schnell, aber niemals generisch.
Sie gibt Scale-up-Teams, was bisher nur Enterprises hatten:
konsistente Brand-Qualität ohne Agentur-Overhead."

## BRAND VOICE CHARAKTERISIERUNG

**Wenn unsere Brand eine Person wäre:**
- Alter: [z.B. 35 Jahre]
- Beruf: [z.B. Produkt-Designer bei einem Tech-Startup]
- Persönlichkeit in 3 Adjektiven: [z.B. Direkt, Neugierig, Pragmatisch]
- Lieblingsmedien: [z.B. Wired, Lex Fridman, Linear Changelog]
- Würde NIEMALS sagen: [z.B. "Bahnbrechend", "Best-in-class", "Synergien"]

## DO's & DON'Ts DER BRAND-KOMMUNIKATION

| ✅ DO | ❌ DON'T |
|-------|---------|
| Konkrete Zahlen nennen | Vage Versprechen machen |
| Probleme direkt ansprechen | Drumherum reden |
| Wir-Sprache (inklusiv) | Wir-Sprache (exklusiv/arrogant) |
| Humor wenn angemessen | Forced Humor / Cringe |
| Kurze, klare Sätze | Schachtelsätze |
| [Branchen-spezifische Do's] | [Branchen-spezifische Don'ts] |

## TONE-OF-VOICE MATRIX

| Kontext | Ton | Beispiel |
|---------|-----|---------|
| Marketing (Awareness) | [z.B. Mutig, direkt] | "[Beispiel-Headline]" |
| Onboarding | [z.B. Warm, unterstützend] | "[Beispiel-Copy]" |
| Error Messages | [z.B. Ehrlich, lösungsorientiert] | "[Beispiel-Error]" |
| Support | [z.B. Geduldig, kompetent] | "[Beispiel-Response]" |
| Social Media | [z.B. Locker, authentisch] | "[Beispiel-Post]" |
| PR/Presse | [z.B. Professionell, substanziell] | "[Beispiel-Quote]" |
```

---

## 6. Wettbewerber-Vergleichsmatrix Template

### 5.1 Template

```markdown
# Wettbewerber-Vergleichsmatrix: [BRANCHE]
Erstellt: [DATUM] | Analysiert von: Brand Intelligence Workflow

## POSITIONIERUNGS-MATRIX

| Marke | Tagline | Positionierung | Zielgruppe | Preis-Segment |
|-------|---------|----------------|------------|---------------|
| **[OWN BRAND]** | "[Tagline]" | [1 Satz] | [Zielgruppe] | [€/€€/€€€] |
| [Wettbewerber A] | "[Tagline]" | [1 Satz] | [Zielgruppe] | [€/€€/€€€] |
| [Wettbewerber B] | "[Tagline]" | [1 Satz] | [Zielgruppe] | [€/€€/€€€] |
| [Wettbewerber C] | "[Tagline]" | [1 Satz] | [Zielgruppe] | [€/€€/€€€] |
| [Wettbewerber D] | "[Tagline]" | [1 Satz] | [Zielgruppe] | [€/€€/€€€] |
| [Wettbewerber E] | "[Tagline]" | [1 Satz] | [Zielgruppe] | [€/€€/€€€] |

## VISUELLER BENCHMARK

| Marke | Primärfarbe(n) | Font-Typ | Ästhetik | Bildsprache |
|-------|----------------|----------|----------|-------------|
| **[OWN BRAND]** | [HEX] | [Typ] | [Kategorie] | [Stil] |
| [Wettbewerber A] | [HEX] | [Typ] | [Kategorie] | [Stil] |

## TONE-OF-VOICE BENCHMARK

| Marke | Formalität (1–10) | Perspektive | Hauptton | Besonderheit |
|-------|-------------------|-------------|----------|-------------|
| **[OWN BRAND]** | [X] | [Du/Sie/Wir] | [Ton] | [Besonderheit] |
| [Wettbewerber A] | [X] | [Du/Sie/Wir] | [Ton] | [Besonderheit] |

## STÄRKEN-SCHWÄCHEN-PROFIL

### [Wettbewerber A]
**Stärken:**
- [Stärke 1]
- [Stärke 2]

**Schwächen:**
- [Schwäche 1 — potenzielle Lücke für uns]
- [Schwäche 2]

### [Wettbewerber B]
**Stärken:**
- [Stärke 1]

**Schwächen:**
- [Schwäche 1]

## WETTBEWERBS-LÜCKEN ANALYSE

| Lücke | Beschreibung | Unser Potenzial |
|-------|-------------|-----------------|
| Visuell | [z.B. Alle nutzen Blau → Farblücke] | [z.B. Warme Farben als Differenziator] |
| Positionierung | [z.B. Premium-Segment unbesetzt] | [z.B. Premium-Accessible Hybrid] |
| Zielgruppe | [z.B. Niemand adressiert [Segment]] | [z.B. Fokus auf [Segment]] |
| ToV | [z.B. Alle sehr formal] | [z.B. Casual Expert als Differenziator] |
```

### 5.2 Beispiel-Ausfüllung (Brand Design Tool Markt)

```markdown
# Wettbewerber-Matrix: Brand Design Tools (fiktiv)

## POSITIONIERUNGS-MATRIX

| Marke | Tagline | Positionierung | Zielgruppe | Preis |
|-------|---------|----------------|------------|-------|
| **BrandFlow AI** | "Brand System. Instantly." | AI-gestützt, für Scale-ups | Marketing Teams | €€ |
| Canva | "Design for everyone" | Template-First, Demokratisch | Alle | €/€€ |
| Frontify | "The brand platform" | Enterprise Brand Management | Large Enterprises | €€€ |
| Bynder | "The digital asset management" | DAM + Brand Portal | Enterprise | €€€ |
| Looka | "Brand in minutes" | AI Logo + Basic Identity | SMB | € |

## LÜCKEN ANALYSE

| Lücke | Beschreibung | Potenzial |
|-------|-------------|-----------|
| Positionierung | Niemand besetzt "AI + Strategie" für Scale-ups | Core Differentiator |
| Zielgruppe | Scale-ups (50–500 MA) von allen vernachlässigt | Primäre Zielgruppe |
| ToV | Alle sehr technisch oder sehr simpel | "Expert Friend" Ton |
```

---

## 7. Positionierungs-Statement Template

### 6.1 Template-Struktur

Das Positionierungs-Statement folgt einer etablierten Struktur:

```
FÜR [ZIELGRUPPE],
DIE [PROBLEM / BEDARF],
IST [MARKENNAME]
DIE [PRODUKT-/SERVICE-KATEGORIE],
DIE [UNIQUE BENEFIT / DIFFERENZIERUNG],
WEIL / DENN [BEGRÜNDUNG / BEWEIS].
```

### 6.2 Erweitertes Format (Geoffrey Moore's Crossing the Chasm)

```markdown
## Positionierungs-Statement: [MARKENNAME]

### Kern-Statement (intern, nicht für Marketing)
Für [ZIELGRUPPE], die [PROBLEM], ist [MARKENNAME] die [KATEGORIE],
die [DIFFERENZIERUNG], weil [BEWEIS].

### Tagline (extern, für Marketing — max. 5 Wörter)
"[EINPRÄGSAME TAGLINE]"

### Elevator Pitch (15 Sekunden)
[MARKENNAME] hilft [ZIELGRUPPE], [ERGEBNIS] zu erreichen, ohne [HAUPTHINDERNIS].
Wir tun das durch [METHODE/ANSATZ].

### Value Proposition (1 Absatz für Website Hero)
[HEADLINE: Klar, nutzenorientiert, max. 8 Wörter]
[SUBHEADLINE: Kontext + Differenzierung, max. 20 Wörter]
[CTA: Aktionsorientiert, max. 4 Wörter]

### Messaging Pillars (3 Hauptbotschaften)
| Pillar | Kern-Botschaft | Beweis |
|--------|----------------|--------|
| Pillar 1: [Thema] | [Botschaft] | [Social Proof / Feature / Zahl] |
| Pillar 2: [Thema] | [Botschaft] | [Social Proof / Feature / Zahl] |
| Pillar 3: [Thema] | [Botschaft] | [Social Proof / Feature / Zahl] |
```

### 6.3 Beispiel-Ausfüllungen

**Beispiel 1 — B2B SaaS**
```
FÜR Marketing-Teams in wachsenden B2B-Startups (50–500 MA),
DIE ihre Brand-Qualität skalieren wollen ohne Agentur-Budget,
IST BrandFlow AI
DIE AI-gestützte Brand System Plattform,
DIE in einer Stunde ein vollständiges, konsistentes Brand System generiert,
WEIL unsere AI Design-Entscheidungen auf echtem Markt-Research basiert.

TAGLINE: "Brand System. Instantly."

ELEVATOR PITCH: BrandFlow AI gibt Marketing-Teams ein vollständiges Brand
System in 60 Minuten — ohne Agentur, ohne wochenlange Workshops.

HERO: [Headline] Your Brand. Production-Ready in 60 Minutes.
[Sub] AI-generated brand systems based on real market research.
No agency. No guesswork. Just results.
[CTA] Start Free
```

**Beispiel 2 — B2C Premium**
```
FÜR bewusste Konsumentinnen, 28–42,
DIE Kosmetik suchen die wirkt ohne Greenwashing,
IST Forma
DIE wirkstoff-fokussierte Clean Beauty Brand,
DIE klinisch validierte Formulierungen radikaler Transparenz verbindet,
WEIL wir jede Zutat mit Wirkungsnachweis veröffentlichen.

TAGLINE: "Inhaltsstoffe, die wirken."
```

---

## 8. Verwendung im Plugin-Workflow

### 7.1 Automatische Template-Befüllung

Der Brand Intelligence Workflow (aus `brand-intelligence-module.md`) liefert die Inputs für diese Templates:

```
Research Output                    →    Template
─────────────────────────────────────────────────
Markt-Kontext Block                →    ICP: Trigger-Events
Wettbewerber-Matrix                →    Wettbewerber-Vergleichsmatrix
Perceptual Map                     →    Positionierungs-Statement
Persona-Skizzen                    →    Buyer Persona (ausgebaut)
ToV-Benchmark                      →    Brand Personality: Voice Matrix
Visueller Benchmark                →    → Weiter zu designer
```

### 7.2 Plugin-Prompt für automatische Template-Befüllung

```
PERSONA EXTRACTION — AUTOMATISCH

Basierend auf diesem Brand Strategy Brief: [BRIEF_CONTENT]

Fülle folgende Templates aus:
1. ICP Template ([B2B/B2C]) — vollständig mit Beispielen
2. Buyer Persona — 2 Personas (Primär + Sekundär)
3. Brand Personality Profil — Archetyp + Voice Matrix
4. Positionierungs-Statement — alle Formate

Nutze die Research-Findings als Begründung für jede Entscheidung.
Keine generischen Platzhalter — alle Felder konkret befüllt.

OUTPUT: Vollständig ausgefüllte Templates als Markdown.
```

---

*Erstellt von: researcher | Für: architect, writer, designer | Datum: 2026-03-13*
