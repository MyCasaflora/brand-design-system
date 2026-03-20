# Image Generation & Visual Analysis Reference
## Nano Banana 2 / OpenRouter — Plugin Integration Guide

**Version:** 1.0
**Owner:** researcher
**Status:** COMPLETED
**Ziel-Pfad im Plugin:** `references/image-generation.md`
**Letzte Aktualisierung:** 2026-03-13

---

## Übersicht

Dieses Dokument definiert den Einsatz von Nano Banana 2 (google/gemini-3.1-flash-image-preview) und weiteren OpenRouter-Modellen für alle visuellen Analyse- und Generierungs-Aufgaben im Brand Design System Plugin.

**Zwei Hauptanwendungsfälle:**
1. **Analyse** — Bestehende Bilder verstehen (Logo, Screenshot, Referenz-PDF)
2. **Generierung** — Neue Brand-Visuals erstellen (Moodboard, Mockup, Pattern)

---

## 1. Modell-Übersicht

| Modell | OpenRouter ID | Stärke | Kosten | Empfohlener Einsatz |
|--------|--------------|--------|--------|---------------------|
| Nano Banana 2 | `google/gemini-3.1-flash-image-preview` | Schnell, günstig, guter Text in Bildern | ~$0.01 | Standard-Analyse, Moodboards, Screenshotanalyse |
| Nano Banana Pro | `google/gemini-3-pro-image-preview` | Beste Qualität, 4K, Multi-Referenz | ~$0.13 | High-Quality Mockups, Multi-Referenz-Synthesis |
| Nano Banana 1 | `google/gemini-2.5-flash-image-preview` | Stabil, bewährt | ~$0.01 | Fallback wenn NB2 nicht verfügbar |
| FLUX.2 | `flux/flux-2-pro` | Fotorealismus | ~$0.05 | Produkt-Mockups, Fotorealistische Szenen |
| GPT Image | `openai/gpt-image-1` | Allrounder, gute Anweisungsfolge | ~$0.02 | Fallback, Instruction-Heavy Prompts |

**Standard-Modell für alle Analyse-Tasks:** Nano Banana 2
**Standard-Modell für finale Mockups:** Nano Banana Pro

---

## 2. API-Integration

### 2.1 Basis-Setup

```javascript
const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY;
const BASE_URL = "https://openrouter.ai/api/v1/chat/completions";

async function callOpenRouter(model, messages, options = {}) {
  const response = await fetch(BASE_URL, {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${OPENROUTER_API_KEY}`,
      "Content-Type": "application/json",
      "HTTP-Referer": options.referer || "https://brand-plugin.local",
      "X-Title": options.title || "Brand Design System Plugin"
    },
    body: JSON.stringify({
      model,
      modalities: ["image", "text"],
      messages,
      ...(options.image_config && { image_config: options.image_config })
    })
  });

  if (!response.ok) {
    throw new Error(`OpenRouter error: ${response.status} ${await response.text()}`);
  }

  return await response.json();
}
```

### 2.2 Bild-Input vorbereiten

```javascript
// Option A: Base64 (für lokale Dateien / hochgeladene PDFs)
function imageToMessage(base64String, mimeType = "image/jpeg") {
  return {
    type: "image_url",
    image_url: { url: `data:${mimeType};base64,${base64String}` }
  };
}

// Option B: URL (für Web-Screenshots / öffentliche Bilder)
function urlToMessage(imageUrl) {
  return {
    type: "image_url",
    image_url: { url: imageUrl }
  };
}

// Kombinierter Message-Builder
function buildVisionMessage(textPrompt, imageInput) {
  return [{
    role: "user",
    content: [
      { type: "text", text: textPrompt },
      imageInput  // imageToMessage() oder urlToMessage()
    ]
  }];
}
```

---

## 3. Logo-Analyse

### 3.1 Anwendungsfall

Wenn ein Nutzer ein bestehendes Logo hochlädt, extrahiert das Plugin automatisch:
- Farben (HEX-Codes)
- Typografie-Stil (Schriftart-Typ, Gewicht)
- Stil-Kategorie
- Verwendungsregeln-Hinweise

### 3.2 Prompt-Template

```javascript
const LOGO_ANALYSIS_PROMPT = `
Analysiere dieses Logo für ein Brand Design System.

Extrahiere folgende Informationen als JSON:

{
  "colors": {
    "primary": "[HEX oder 'nicht erkennbar']",
    "secondary": "[HEX oder null]",
    "accent": "[HEX oder null]",
    "background": "[HEX — falls im Logo vorhanden, sonst 'transparent']",
    "text": "[HEX — falls Text im Logo]"
  },
  "typography": {
    "has_wordmark": true/false,
    "font_style": "Serif | Sans-Serif | Display | Script | Monospace | Nicht erkennbar",
    "font_weight": "Thin | Light | Regular | Medium | Bold | Black",
    "letter_spacing": "tight | normal | wide",
    "capitalization": "uppercase | lowercase | mixed | titlecase"
  },
  "symbol": {
    "has_symbol": true/false,
    "symbol_type": "Geometric | Organic | Letterform | Abstract | Pictorial | null",
    "symbol_description": "[1 Satz Beschreibung oder null]"
  },
  "style": {
    "aesthetic": "Minimalistisch | Corporate | Playful | Luxury | Tech | Organic | Retro | Modern",
    "complexity": "Simple (1-2 Elemente) | Medium (3-5) | Complex (6+)",
    "scalability": "Funktioniert klein (16px) | Nur ab 32px | Nur groß"
  },
  "brand_personality_signal": "[2-3 Adjektive die das Logo kommuniziert]",
  "zone_1_constraints": {
    "primary_color_locked": true,
    "font_locked": true/false,
    "symbol_locked": true
  }
}

Antworte NUR mit dem JSON-Objekt, kein Begleittext.
`;
```

### 3.3 Verwendung im Plugin

```javascript
async function analyzeLogo(logoBase64, mimeType = "image/png") {
  const messages = buildVisionMessage(
    LOGO_ANALYSIS_PROMPT,
    imageToMessage(logoBase64, mimeType)
  );

  const result = await callOpenRouter(
    "google/gemini-3.1-flash-image-preview",
    messages
  );

  const content = result.choices[0].message.content;
  // Nano Banana 2 gibt strukturierten Text zurück — JSON parsen
  const jsonMatch = content.match(/\{[\s\S]*\}/);
  return jsonMatch ? JSON.parse(jsonMatch[0]) : null;
}
```

### 3.4 Output-Beispiel

```json
{
  "colors": {
    "primary": "#1A1A2E",
    "secondary": "#E94560",
    "accent": null,
    "background": "transparent",
    "text": "#FFFFFF"
  },
  "typography": {
    "has_wordmark": true,
    "font_style": "Sans-Serif",
    "font_weight": "Bold",
    "letter_spacing": "wide",
    "capitalization": "uppercase"
  },
  "symbol": {
    "has_symbol": true,
    "symbol_type": "Geometric",
    "symbol_description": "Stilisiertes Hexagon mit negativem Raum"
  },
  "style": {
    "aesthetic": "Tech",
    "complexity": "Simple (1-2 Elemente)",
    "scalability": "Funktioniert klein (16px)"
  },
  "brand_personality_signal": "Präzise, modern, technisch",
  "zone_1_constraints": {
    "primary_color_locked": true,
    "font_locked": true,
    "symbol_locked": true
  }
}
```

---

## 4. Screenshot-Analyse (Wettbewerber-Websites)

### 4.1 Anwendungsfall

Im Wettbewerber-Audit (Brand Intelligence Schritt 2) werden Websites analysiert. Screenshots werden auf visuelle Design-Muster untersucht.

### 4.2 Fallback-Kette bei Screenshot-Problemen

```
1. Direkter Screenshot via Browser-Tool
   ↓ (falls Cookie-Banner / Geo-Block)
2. Brandfetch API: brandfetch.com/[domain] → strukturierte Marken-Daten
   ↓ (falls nicht verfügbar)
3. Web Archive: web.archive.org/web/*/[url] → archivierter Screenshot
   ↓ (falls zu alt)
4. Google Cache → gecachte Version
   ↓ (falls alles scheitert)
5. Plugin fragt Nutzer nach manuellem Upload
```

### 4.3 Prompt-Template (Standard-Analyse)

```javascript
const SCREENSHOT_ANALYSIS_PROMPT = `
Analysiere diesen Website-Screenshot für ein Brand Benchmark.

Extrahiere als JSON:

{
  "colors": {
    "dominant": ["#HEX1", "#HEX2", "#HEX3"],
    "background": "#HEX",
    "text_primary": "#HEX",
    "accent": "#HEX oder null"
  },
  "typography": {
    "headline_style": "Serif | Sans-Serif | Display",
    "headline_weight": "Light | Regular | Bold | Black",
    "body_style": "Serif | Sans-Serif",
    "font_count": "1 | 2 | 3+",
    "size_contrast": "Stark (großer Unterschied H1/Body) | Mittel | Flach"
  },
  "layout": {
    "density": 1-10,
    "whitespace": "Viel | Mittel | Wenig",
    "grid_type": "Single-column | Multi-column | Asymmetrisch | Freeform",
    "hero_type": "Full-screen | Half | Split | Kompakt"
  },
  "aesthetic": {
    "category": "Minimalistisch | Corporate | Playful | Luxury | Tech | Human | Editorial",
    "mood": "[2-3 Adjektive]",
    "imagery_style": "Stock | Custom | Illustration | Abstract | Screenshot | Keine"
  },
  "target_audience_signal": "[Für wen wirkt das Design? 1 Satz]",
  "differentiators": "[Was ist visuell einzigartig? 1-2 Punkte]",
  "weaknesses": "[Was wirkt schwach oder inkonsistent? 1-2 Punkte]"
}

Antworte NUR mit dem JSON-Objekt.
`;
```

### 4.4 Prompt-Template (Detaillierte Analyse für Benchmark-Report)

```javascript
const SCREENSHOT_DEEP_ANALYSIS_PROMPT = `
Du analysierst einen Website-Screenshot für einen professionellen Brand Benchmark Report.

Erstelle eine strukturierte Analyse:

## VISUELLE IDENTITÄT
- Primärfarbe: [HEX + Farbname]
- Sekundärfarbe: [HEX + Farbname oder "keine"]
- Typografie: [Stil, Gewicht, Besonderheiten]
- Layout-Dichte: [1-10] — 1=maximaler Weißraum, 10=sehr dicht

## ÄSTHETIK-PROFIL
Kategorie: [Eine aus: Minimalistisch / Corporate / Playful / Luxury / Tech / Human / Editorial]
Stimmung: [3 Adjektive]
Bildsprache: [Stil der verwendeten Bilder/Illustrationen]

## ZIELGRUPPEN-SIGNAL
[Wer ist die offensichtliche Zielgruppe? Alter, Profession, Mindset — 2 Sätze]

## POSITIONIERUNGS-SIGNAL
[Was kommuniziert das visuelle Design über Preis-Segment und Markt-Position? 2 Sätze]

## STÄRKEN
- [Stärke 1]
- [Stärke 2]

## SCHWÄCHEN / LÜCKEN
- [Schwäche 1 — potenzielle Differenzierungs-Chance]
- [Schwäche 2]

## BENCHMARK-SCORE (für Vergleichstabelle)
Modern/Traditionell: [Zahl -10 bis +10]
Premium/Zugänglich: [Zahl -10 bis +10]
`;
```

---

## 5. Referenz-Brand-PDF-Analyse

### 5.1 Anwendungsfall

Nutzer laden 1–3 Brand-Guidelines-PDFs als Referenz hoch. Das Plugin extrahiert Struktur, Muster und Qualitäts-Benchmarks.

### 5.2 Strategie: Seiten-basierte Analyse

PDFs werden seitenweise als Bilder analysiert. Priorität:
1. **Cover / Title Page** — Brand-Identität auf einen Blick
2. **Farb-Seite** — Primär/Sekundär-Palette, Token-Struktur
3. **Typografie-Seite** — Font-Hierarchie, Verwendungsregeln
4. **Logo-Seite** — Varianten, Schutzzone, Anwendungen
5. **Beispiel-Layouts** — Wie wird die Brand in der Praxis angewendet?

### 5.3 Prompt-Template (Cover-Analyse)

```javascript
const PDF_COVER_ANALYSIS_PROMPT = `
Dies ist die Titelseite einer Brand Guidelines PDF.

Analysiere:

{
  "brand_name": "[erkannter Markenname]",
  "year": "[Erscheinungsjahr falls erkennbar]",
  "positioning_signal": "[Was kommuniziert das Cover über die Brand? 1 Satz]",
  "primary_color": "#HEX",
  "aesthetic": "Minimalistisch | Corporate | Playful | Luxury | Tech | Human",
  "quality_tier": "Enterprise-Grade | Professional | Standard | Basic",
  "structure_complexity": "Comprehensive (viele Sektionen sichtbar) | Focused | Simple",
  "first_impression": "[Was fällt sofort auf? 2-3 Sätze]"
}
`;
```

### 5.4 Prompt-Template (Vollständige PDF-Seite)

```javascript
const PDF_PAGE_ANALYSIS_PROMPT = `
Dies ist eine Seite aus einer Brand Guidelines PDF.

Identifiziere den Seitentyp und extrahiere relevante Informationen:

SEITENTYP: [Farben | Typografie | Logo | Layout-Beispiele | Fotografie | Icons | Do/Don't | Sonstiges]

Falls FARBEN:
- Extrahiere alle sichtbaren Farb-Swatches mit HEX/Name
- Notiere die Naming-Convention (Primary/Secondary/Accent vs. numerisch vs. semantisch)

Falls TYPOGRAFIE:
- Notiere alle Font-Namen
- Font-Größen-Hierarchie (H1, H2, Body etc.)
- Besondere Verwendungsregeln

Falls LOGO:
- Varianten (Positiv/Negativ/Monochrom)
- Schutzzone-Regeln
- Verbotene Verwendungen

Falls LAYOUT-BEISPIELE:
- Beschreibe 2-3 charakteristische Layout-Muster
- Grid-Struktur erkennbar?

Antworte als strukturiertes Markdown, kein JSON.
`;
```

### 5.5 Pattern-Extraktion aus mehreren Referenz-Brands

```javascript
const MULTI_REFERENCE_SYNTHESIS_PROMPT = `
Du hast mehrere Brand Guidelines analysiert. Erstelle eine Synthese:

## GEMEINSAME MUSTER (was alle tun)
[3-5 Punkte]

## DIFFERENZIERUNGS-MUSTER (was einzelne einzigartig macht)
[Pro analysierte Brand: 1-2 einzigartige Elemente]

## QUALITÄTS-STANDARDS
Was unterscheidet Enterprise-Grade Brand Guidelines von Basic-Qualität?
[3-5 konkrete Unterschiede]

## EMPFEHLUNGEN FÜR UNSER SYSTEM
Welche Muster sollten wir übernehmen? Welche vermeiden?
[Actionable Recommendations]
`;
```

---

## 6. Moodboard-Generierung

### 6.1 Anwendungsfall

Nach dem Research (Brand Intelligence Phase 0) generiert das Plugin ein Moodboard das die gewählte Design-Richtung visualisiert — noch bevor Fonts und Farben final festgelegt sind.

### 6.2 Brand-Constrained Prompting

**Prinzip:** Alle Generierungs-Prompts sind durch Zone-1-Constraints eingeschränkt. Das Modell darf keine Zone-1-Entscheidungen treffen oder modifizieren.

```javascript
function buildMoodboardPrompt(brandContext) {
  return `
Erstelle ein professionelles Brand Moodboard-Bild.

BRAND CONTEXT:
- Positionierung: ${brandContext.positioning}
- Ästhetik-Ziel: ${brandContext.aesthetic}
- Primärfarbe: ${brandContext.primaryColor}
- Zielgruppe: ${brandContext.targetAudience}
- Referenz-Brands: ${brandContext.references.join(", ")}

MOODBOARD-INHALT (arrangiert als 3×3 oder 2×4 Grid):
- Farbpalette-Swatches (oben links)
- Typografie-Beispiel (1-2 Wörter, passender Font-Stil)
- Textur oder Pattern
- Lifestyle-Bild (Zielgruppe im Kontext)
- Produkt/Interface Mockup-Andeutung
- Stimmungs-Fotografie (abstract)
- Material/Oberflächen-Referenz
- Gesamt-Komposition: ${brandContext.aesthetic}

TECHNISCH:
- Aspect Ratio: 16:9
- Qualität: Professionell, print-ready
- Keine Text-Overlays außer Typografie-Beispiel
- Keine Logos, keine erkennbaren Markennamen

ZONE-1-CONSTRAINTS (unveränderlich):
- Primärfarbe MUSS ${brandContext.primaryColor} sein
- Kein Ersetzen durch ähnliche Farben
- Keine Logo-Elemente generieren
`;
}
```

### 6.3 Verwendung mit Nano Banana Pro (für finale Qualität)

```javascript
async function generateMoodboard(brandContext) {
  const prompt = buildMoodboardPrompt(brandContext);

  const result = await callOpenRouter(
    "google/gemini-3-pro-image-preview",  // Pro für finale Qualität
    [{
      role: "user",
      content: [{ type: "text", text: prompt }]
    }],
    {
      image_config: { aspect_ratio: "16:9" }
    }
  );

  // Nano Banana Pro gibt Bild-URL oder Base64 zurück
  const content = result.choices[0].message.content;
  return extractImageFromContent(content);
}

function extractImageFromContent(content) {
  // Suche nach Base64-Bild in der Antwort
  if (Array.isArray(content)) {
    const imageItem = content.find(item => item.type === "image_url");
    return imageItem?.image_url?.url || null;
  }
  return null;
}
```

---

## 7. Produkt-Mockups (Zone 2)

### 7.1 Device-Mockups

```javascript
const DEVICE_MOCKUP_PROMPT = `
Platziere dieses Interface-Design (im Anhang) in einem professionellen Device-Mockup.

DEVICE: ${deviceType}  // "MacBook Pro", "iPhone 15 Pro", "iPad Pro"
UMGEBUNG: ${environment}  // "Minimaler weißer Hintergrund", "Büro-Setup", "Outdoor"
LICHT: Natürliches Seitenlicht, weiche Schatten
PERSPEKTIVE: ${perspective}  // "Frontal", "Slight angle (15°)", "Flat lay"

ANFORDERUNGEN:
- Device-Farbe: ${deviceColor}  // "Space Black", "Silver", "Natural Titanium"
- Screen: Zeigt das beigefügte Interface-Design exakt wie hochgeladen
- Keine Text-Manipulationen am Interface
- Professionelle Produktfotografie-Ästhetik
- 16:9 Aspect Ratio

ZONE-2-STATUS: Dieser Mockup ist kontrollierte Variation.
Darf keine Zone-1-Elemente (Logo, Primärfarben) modifizieren.
`;
```

### 7.2 Print-Mockups

```javascript
const PRINT_MOCKUP_TEMPLATES = {
  businessCard: `Visitenkarte auf dunkler Holzoberfläche, leichter Bokeh-Hintergrund,
                 Makro-Fotografie-Stil, natürliches Licht von links`,
  letterhead: `DIN A4 Briefbogen, leicht von oben fotografiert (30°),
               weißer Hintergrund, professionelles Studio-Licht`,
  envelope: `Briefumschlag C5, Flatlay auf weißem Hintergrund,
             cleaner Stil, Draufsicht 90°`,
  tshirt: `T-Shirt auf weißem Hintergrund, Ghost-Mannequin-Stil,
           professionelle Produktfotografie, Frontalansicht`
};
```

---

## 8. Fehlerbehandlung & Fallbacks

### 8.1 Modell-Fallback-Kette

```javascript
const MODEL_FALLBACK_CHAIN = {
  analysis: [
    "google/gemini-3.1-flash-image-preview",  // Nano Banana 2 (primär)
    "google/gemini-2.5-flash-image-preview",  // Nano Banana 1 (fallback)
    "openai/gpt-image-1"                       // GPT Image (letzter Fallback)
  ],
  generation: [
    "google/gemini-3-pro-image-preview",       // Nano Banana Pro (primär)
    "google/gemini-3.1-flash-image-preview",   // Nano Banana 2 (schneller Fallback)
    "flux/flux-2-pro"                          // FLUX für fotorealistische Szenen
  ]
};

async function callWithFallback(type, messages, options = {}) {
  const chain = MODEL_FALLBACK_CHAIN[type];

  for (const model of chain) {
    try {
      return await callOpenRouter(model, messages, options);
    } catch (error) {
      console.warn(`Model ${model} failed: ${error.message}. Trying next...`);
    }
  }
  throw new Error("All models in fallback chain failed.");
}
```

### 8.2 JSON-Parse-Fallback

Wenn das Modell kein valides JSON zurückgibt:

```javascript
function safeParseAnalysisResult(rawContent) {
  // Versuch 1: Direktes JSON
  try {
    return JSON.parse(rawContent);
  } catch {}

  // Versuch 2: JSON aus Markdown-Block extrahieren
  const jsonBlockMatch = rawContent.match(/```(?:json)?\s*([\s\S]*?)```/);
  if (jsonBlockMatch) {
    try { return JSON.parse(jsonBlockMatch[1]); } catch {}
  }

  // Versuch 3: Erstes { ... } Block
  const jsonObjectMatch = rawContent.match(/\{[\s\S]*\}/);
  if (jsonObjectMatch) {
    try { return JSON.parse(jsonObjectMatch[0]); } catch {}
  }

  // Fallback: Strukturierter Text-Parse (minimale Extraktion)
  return {
    raw_text: rawContent,
    parse_error: true,
    colors: { primary: null },
    aesthetic: "Nicht extrahiert"
  };
}
```

---

## 9. Kosten-Kalkulation

### 9.1 Typischer Brand Intelligence Workflow

| Schritt | Modell | Anzahl Calls | Kosten/Call | Gesamt |
|---------|--------|-------------|-------------|--------|
| Logo-Analyse | NB2 | 1 | $0.01 | $0.01 |
| Wettbewerber-Screenshots (5–7) | NB2 | 6 | $0.01 | $0.06 |
| Referenz-PDF (3 PDFs × 5 Seiten) | NB2 | 15 | $0.01 | $0.15 |
| Moodboard-Generierung | NB Pro | 2 | $0.13 | $0.26 |
| Device-Mockups (3 Varianten) | NB2 | 3 | $0.01 | $0.03 |
| **Gesamt** | | **27** | | **~$0.51** |

### 9.2 Kostenoptimierung

```javascript
const COST_OPTIMIZATION_RULES = {
  // Für schnelle Iterationen im Workflow → NB2
  use_fast_model: [
    "logo_analysis",
    "screenshot_analysis",
    "pdf_page_analysis",
    "draft_moodboard"
  ],
  // Nur für finale Outputs → NB Pro
  use_pro_model: [
    "final_moodboard",
    "hero_mockup",
    "presentation_visual"
  ],
  // Batch-Analyse: Mehrere Screenshots in einem Call (spart Overhead)
  batch_compatible: [
    "screenshot_analysis"  // Bis zu 3 Bilder pro Call möglich
  ]
};
```

---

## 10. Sicherheit & Datenschutz

### 10.1 Was NICHT an OpenRouter gesendet werden darf

```
❌ Persönliche Kundendaten (PII)
❌ Interne Dokumente mit Vertraulichkeitsvermerk
❌ Passwörter, API-Keys, Credentials im Bild
❌ Unveröffentlichte Produkt-Screenshots vor NDA-Ablauf
```

### 10.2 Was sicher ist

```
✅ Wettbewerber-Screenshots von öffentlichen Websites
✅ Eigene Logos und Brand Assets (nach Nutzer-Freigabe)
✅ Referenz-PDFs von öffentlich verfügbaren Brand Guidelines
✅ Generierte Moodboards und Mockups
```

### 10.3 Daten-Handling

```javascript
// Bilder werden NICHT gespeichert — nur für den einzelnen API-Call genutzt
// Nach dem Call: Base64-Strings aus dem Memory freigeben
async function analyzeAndDiscard(imageBase64, prompt) {
  const result = await callOpenRouter(
    "google/gemini-3.1-flash-image-preview",
    buildVisionMessage(prompt, imageToMessage(imageBase64))
  );

  // Nur das Analyse-Ergebnis behalten, nicht das Bild
  const analysis = safeParseAnalysisResult(
    result.choices[0].message.content
  );

  // imageBase64 wird nach dieser Funktion vom GC freigegeben
  return analysis;
}
```

---

## 11. Zone-System Integration

Alle Bild-Analyse und -Generierungs-Calls müssen das Zone-System respektieren:

| Zone | Spielraum | Bild-Analyse erlaubt? | Bild-Generierung erlaubt? |
|------|-----------|----------------------|--------------------------|
| Zone 1 — Unveränderlich | 0% | Nur lesen/dokumentieren | Nicht erlaubt |
| Zone 2 — Kontrollierte Variation | 20% | Analyse + Optimierung | Mit Token-Constraints |
| Zone 3 — Kreative Freiheit | 40% | Exploration | Explizit als Zone-3 markieren |

```javascript
function assertZoneCompliance(generationRequest, brandTokens) {
  const zone1Violations = [];

  if (generationRequest.modifyLogo) {
    zone1Violations.push("Logo-Modifikation ist Zone-1-Verletzung");
  }
  if (generationRequest.primaryColor !== brandTokens.colorPrimary) {
    zone1Violations.push(`Primärfarbe darf nicht geändert werden (ist: ${brandTokens.colorPrimary})`);
  }
  if (generationRequest.headlineFont !== brandTokens.fontHeadline) {
    zone1Violations.push(`Headline-Font ist gesperrt: ${brandTokens.fontHeadline}`);
  }

  if (zone1Violations.length > 0) {
    throw new Error(`Zone-1-Verletzung: ${zone1Violations.join(", ")}`);
  }

  return true;
}
```

---

*Erstellt von: researcher | Für: implementer, designer, writer | Datum: 2026-03-13*
*Ziel-Pfad: references/image-generation.md*
