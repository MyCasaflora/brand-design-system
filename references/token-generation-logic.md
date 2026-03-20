# Token Generation Logic

## Overview

This document describes the 9-step algorithm used by the brand-generator to produce a complete set of design tokens from brand inputs. The algorithm transforms raw brand information (logos, colors, company descriptions) into a production-ready `tokens.css` file.

---

## Input Priority Hierarchy (5 Levels)

The generator resolves each design decision using a strict priority order:

| Priority | Source                 | Description                                    | Example                         |
|----------|------------------------|------------------------------------------------|---------------------------------|
| 1        | Explicit User Input    | Colors, fonts, or values directly specified     | "Use #2563EB as primary"        |
| 2        | Logo Analysis          | Colors and style extracted from uploaded logo   | Dominant hue from SVG/PNG       |
| 3        | Brand Intelligence     | Industry norms and competitor analysis          | Finance → navy, trust tones     |
| 4        | Company Description    | Personality inferred from text                  | "Innovative fintech" → modern   |
| 5        | Fallback Defaults      | Safe, neutral defaults (see token-system.md)    | Inter font, Blue 600 primary    |

At each step, the algorithm checks Level 1 first. If no input exists, it falls to Level 2, then 3, and so on.

---

## The 9-Step Generation Algorithm

### Step 1: Input Collection

Gather all available brand inputs and normalize them:

```
INPUTS:
  logo_url: string | null          → uploaded logo file or URL
  brand_colors: string[] | null    → user-specified hex colors
  company_name: string | null      → company/brand name
  company_description: string | null → what the company does
  industry: string | null          → industry category
  personality: string[] | null     → brand personality keywords
  font_preferences: object | null  → heading/body font choices
  style_preferences: object | null → radius, density preferences
```

**Normalization Rules:**
- All hex colors converted to uppercase 6-digit format (`#abc` → `#AABBCC`)
- Font names trimmed and title-cased
- Industry mapped to canonical categories (see Step 2)
- Empty strings treated as null

---

### Step 2: Primary Color Derivation

Determine the primary brand color using the priority hierarchy.

#### From Logo (Priority 2)
1. Extract all colors from logo (SVG `fill`/`stroke` attributes, or pixel sampling for raster)
2. Cluster colors using k-means (k=5)
3. Select the dominant non-neutral cluster (saturation > 15%, lightness 20–80%)
4. Use the cluster centroid as the primary color

#### From Industry Heuristics (Priority 3)

| Industry             | Default Primary  | Hex       | Rationale                         |
|----------------------|------------------|-----------|-----------------------------------|
| Finance / Banking    | Navy Blue        | `#1E3A5F` | Trust, stability, authority       |
| Technology           | Deep Indigo      | `#3730A3` | Innovation, precision             |
| Healthcare / Medical | Emerald Green    | `#059669` | Growth, healing, vitality         |
| Education            | Royal Blue       | `#1D4ED8` | Knowledge, trust, depth           |
| E-commerce / Retail  | Orange Red       | `#EA580C` | Energy, urgency, warmth           |
| Food & Beverage      | Warm Red         | `#DC2626` | Appetite, passion, energy         |
| Real Estate          | Deep Teal        | `#0F766E` | Luxury, nature, stability         |
| Legal / Law          | Dark Navy        | `#1E293B` | Authority, tradition, trust       |
| Creative / Design    | Vivid Purple     | `#7C3AED` | Creativity, imagination           |
| Environmental / Green| Forest Green     | `#15803D` | Nature, sustainability            |
| Automotive           | Charcoal Blue    | `#334155` | Precision, performance            |
| Hospitality / Travel | Warm Coral       | `#F97316` | Warmth, adventure, welcome        |
| Sports / Fitness     | Dynamic Red      | `#EF4444` | Energy, competition, power        |
| Luxury / Fashion     | Rich Black       | `#18181B` | Elegance, exclusivity             |
| Non-Profit           | Trust Blue       | `#2563EB` | Trust, compassion, reliability    |

#### From Company Description (Priority 4)
Extract personality keywords and map to color families:
- "innovative", "cutting-edge", "disruptive" → Blue/Indigo
- "natural", "organic", "sustainable" → Green
- "luxury", "premium", "exclusive" → Black/Gold
- "friendly", "approachable", "fun" → Orange/Yellow
- "creative", "artistic", "bold" → Purple/Magenta

---

### Step 3: Color Scale Generation

Generate 10 lightness variants from the base (500) color using HSL manipulation.

#### Algorithm

```
INPUT: base_color (HSL: H, S, L)

SCALE_MAP:
  50:  (H, S * 0.30, 96%)   → Tinted background
  100: (H, S * 0.45, 90%)   → Hover background
  200: (H, S * 0.55, 80%)   → Light accent
  300: (H, S * 0.70, 68%)   → Medium light
  400: (H, S * 0.85, 52%)   → Medium
  500: (H, S,        L)     → Base (brand color)
  600: (H, S * 1.05, L-12%) → Hover on dark
  700: (H, S * 1.10, L-22%) → Active state
  800: (H, S * 1.05, L-32%) → Dark accent
  900: (H, S * 0.95, L-40%) → Darkest

CONSTRAINTS:
  - Lightness clamped to [4%, 98%]
  - Saturation clamped to [5%, 100%]
  - 50 ↔ 900 must have contrast ratio ≥ 7:1 (WCAG AAA)
```

#### Lightness Anchors

| Step | Target Lightness | Saturation Modifier | Purpose                |
|------|------------------|---------------------|------------------------|
| 50   | 96%              | ×0.30               | Tinted backgrounds     |
| 100  | 90%              | ×0.45               | Subtle highlights      |
| 200  | 80%              | ×0.55               | Light accents          |
| 300  | 68%              | ×0.70               | Decorative elements    |
| 400  | 52%              | ×0.85               | Icons, secondary text  |
| 500  | Base             | ×1.00               | Primary usage          |
| 600  | Base - 12%       | ×1.05               | Hover states           |
| 700  | Base - 22%       | ×1.10               | Pressed states         |
| 800  | Base - 32%       | ×1.05               | Dark accents           |
| 900  | Base - 40%       | ×0.95               | Darkest variant        |

---

### Step 4: Secondary Color Derivation

Select a secondary color that harmonizes with the primary.

#### Strategy Selection

| Primary Hue Range | Strategy              | Hue Offset  |
|--------------------|-----------------------|-------------|
| 0°–60° (Reds)     | Analogous             | +30° to +45°|
| 60°–120° (Yellows)| Split-complementary   | +150°       |
| 120°–180° (Greens)| Analogous             | -30° to -45°|
| 180°–240° (Blues)  | Analogous warm        | -40° to -60°|
| 240°–300° (Purples)| Split-complementary  | +150°       |
| 300°–360° (Magentas)| Analogous           | +30° to +45°|

#### Algorithm

```
INPUT: primary_hue, primary_saturation

1. Determine hue_offset from strategy table
2. secondary_hue = (primary_hue + hue_offset) % 360
3. secondary_saturation = primary_saturation * 0.75  (more muted)
4. secondary_lightness = clamp(primary_lightness ± 5%, 25%, 55%)
5. Generate 10-step scale using Step 3 algorithm
```

---

### Step 5: Accent Color Derivation

Select an accent color with warm/cool contrast for maximum visual impact.

#### Algorithm

```
INPUT: primary_color (HSL), secondary_color (HSL)

1. Compute complementary_hue = (primary_hue + 180) % 360
2. Apply warm/cool adjustment:
   - If primary is cool (180°–300°): shift accent warm (+15° toward yellow/orange)
   - If primary is warm (0°–180°): shift accent cool (-15° toward blue/purple)
3. accent_hue = complementary_hue + warm_cool_offset
4. accent_saturation = max(primary_saturation, 60%)  (vibrant accents)
5. accent_lightness = adjust to meet WCAG AA (≥ 4.5:1) on both bg and surface

VALIDATION:
  - contrast(accent, --color-bg) ≥ 4.5:1
  - contrast(accent, --color-surface) ≥ 3:1
  - accent must be perceptually distinct from primary (ΔE > 30)
  - accent should not clash with secondary (hue difference > 30°)
```

---

### Step 6: Typography Selection

Map brand personality to appropriate font pairings.

#### Personality-to-Typography Matrix

| Personality  | Heading Font           | Body Font              | Characteristics                    |
|-------------|------------------------|------------------------|------------------------------------|
| Luxury      | `Playfair Display`     | `Lora`                 | Serifs, high contrast, elegant     |
|             | `Cormorant Garamond`   | `EB Garamond`          |                                    |
|             | `Didot`, `Bodoni Moda` | `Source Serif Pro`     |                                    |
| Corporate   | `Inter`                | `Inter`                | Clean, neutral, professional       |
|             | `IBM Plex Sans`        | `IBM Plex Sans`        |                                    |
|             | `Roboto`               | `Roboto`               |                                    |
| Tech        | `Space Grotesk`        | `Inter`                | Geometric, modern, precise         |
|             | `JetBrains Mono`       | `IBM Plex Sans`        |                                    |
|             | `Outfit`               | `DM Sans`              |                                    |
| Friendly    | `Nunito`               | `Open Sans`            | Rounded, warm, approachable        |
|             | `Quicksand`            | `Nunito Sans`          |                                    |
|             | `Poppins`              | `Source Sans Pro`      |                                    |
| Creative    | `Sora`                 | `Work Sans`            | Distinctive, expressive            |
|             | `Clash Display`        | `General Sans`         |                                    |
|             | `Cabinet Grotesk`      | `Satoshi`              |                                    |
| Classic     | `Merriweather`         | `Source Serif Pro`     | Traditional, timeless, readable    |
|             | `Libre Baskerville`    | `Crimson Text`         |                                    |
|             | `Lora`                 | `PT Serif`             |                                    |
| Minimal     | `Inter`                | `Inter`                | Simple, clean, maximum whitespace  |
|             | `Helvetica Neue`       | `Helvetica Neue`       |                                    |
|             | `DM Sans`              | `DM Sans`              |                                    |

#### Font Fallback Chains

```css
/* Sans-serif */
var(--font-heading), system-ui, -apple-system, 'Segoe UI', sans-serif;

/* Serif */
var(--font-heading), Georgia, 'Times New Roman', serif;

/* Monospace */
'JetBrains Mono', 'Fira Code', ui-monospace, SFMono-Regular, monospace;
```

#### Selection Logic

```
INPUT: personality_keywords[], industry

1. Map industry to default personality (e.g., Finance → Corporate)
2. Override with explicit personality keywords if provided
3. Select primary personality match
4. Choose heading + body font pair from matrix
5. Verify fonts available on Google Fonts API
6. Generate fallback chain
```

---

### Step 7: Spacing & Border Radius

Derive spacing density and corner radius from brand personality.

#### Personality-to-Geometry Matrix

| Personality | Radius SM | Radius MD | Radius LG | Radius XL | Density  |
|------------|-----------|-----------|-----------|-----------|----------|
| Luxury     | 0px       | 2px       | 4px       | 8px       | Spacious |
| Corporate  | 2px       | 4px       | 8px       | 12px      | Standard |
| Tech       | 4px       | 6px       | 10px      | 14px      | Standard |
| Friendly   | 8px       | 12px      | 16px      | 24px      | Relaxed  |
| Creative   | 6px       | 10px      | 16px      | 24px      | Standard |
| Classic    | 0px       | 2px       | 4px       | 6px       | Spacious |
| Minimal    | 4px       | 8px       | 12px      | 16px      | Spacious |

#### Spacing Density Modifiers

| Density  | Modifier | Effect                            |
|----------|----------|-----------------------------------|
| Compact  | ×0.75    | Tighter padding, smaller gaps     |
| Standard | ×1.00    | Default 8px grid                  |
| Relaxed  | ×1.25    | More breathing room               |
| Spacious | ×1.50    | Maximum whitespace, editorial     |

#### Algorithm

```
INPUT: personality, density_modifier

1. Look up radius values from personality matrix
2. Apply density modifier to base spacing scale
3. Validate all values align to 4px sub-grid
4. Round non-aligned values to nearest 4px

VALIDATION:
  - All spacing values must be divisible by 4
  - radius-sm ≤ radius-md ≤ radius-lg ≤ radius-xl
  - Minimum touch target: 44×44px (WCAG 2.5.5)
```

---

### Step 8: Token Assembly

Fill the `template.css` placeholders with computed values.

#### Assembly Process

```
INPUT: All computed values from Steps 1–7

1. Load template.css content
2. For each {{PLACEHOLDER}}:
   a. Look up computed value from generation results
   b. Format value appropriately (hex for colors, rem for sizes)
   c. Replace placeholder with formatted value
3. Generate dark mode overrides:
   a. Invert lightness scale for backgrounds
   b. Adjust text colors for dark backgrounds
   c. Increase shadow alpha values
4. Generate neutral (gray) scale from primary hue:
   a. gray_hue = primary_hue
   b. gray_saturation = primary_saturation * 0.08
   c. Generate 10-step scale with lightness anchors
5. Compute semantic colors:
   a. --color-bg: gray-50 or #FFFFFF
   b. --color-surface: gray-50 or gray-100
   c. --color-text: gray-900
   d. --color-text-muted: gray-500
   e. --color-border: gray-200
6. Compute feedback colors:
   a. Success: #059669 (green, adjusted for harmony)
   b. Warning: #D97706 (amber)
   c. Error: #DC2626 (red)
   d. Info: primary-500 or #2563EB
7. Write final tokens.css
```

#### Placeholder Reference

| Placeholder             | Source Step | Example Value          |
|-------------------------|------------|------------------------|
| `{{PRIMARY_500}}`       | Step 2     | `#2563EB`              |
| `{{PRIMARY_50}}`        | Step 3     | `#EFF6FF`              |
| `{{SECONDARY_500}}`     | Step 4     | `#475569`              |
| `{{ACCENT_500}}`        | Step 5     | `#F59E0B`              |
| `{{FONT_HEADING}}`      | Step 6     | `'Inter'`              |
| `{{FONT_BODY}}`         | Step 6     | `'Inter'`              |
| `{{RADIUS_SM}}`         | Step 7     | `0.25rem`              |
| `{{RADIUS_MD}}`         | Step 7     | `0.5rem`               |
| `{{RADIUS_LG}}`         | Step 7     | `0.75rem`              |
| `{{BG_COLOR}}`          | Step 8     | `#FFFFFF`              |
| `{{SURFACE_COLOR}}`     | Step 8     | `#F8FAFC`              |
| `{{TEXT_COLOR}}`         | Step 8     | `#0F172A`              |
| `{{TEXT_MUTED}}`         | Step 8     | `#64748B`              |
| `{{BORDER_COLOR}}`      | Step 8     | `#E2E8F0`              |
| `{{DARK_BG_COLOR}}`     | Step 8     | `#0A0A0B`              |
| `{{DARK_SURFACE_COLOR}}`| Step 8     | `#1C1C1F`              |
| `{{DARK_TEXT_COLOR}}`    | Step 8     | `#FAFAFA`              |

---

### Step 9: Validation

Comprehensive checks before output is finalized.

#### 9a. WCAG Contrast Validation

| Check                              | Minimum Ratio | Level    |
|------------------------------------|---------------|----------|
| Body text on background            | 7:1           | AAA      |
| Body text on surface               | 7:1           | AAA      |
| UI text on background              | 4.5:1         | AA       |
| Large text on background           | 3:1           | AA       |
| Muted text on background           | 4.5:1         | AA       |
| Primary color on background        | 3:1           | AA (UI)  |
| Accent color on background         | 4.5:1         | AA       |
| Text on primary (buttons)          | 4.5:1         | AA       |
| Text on accent (CTAs)              | 4.5:1         | AA       |
| Focus ring visibility              | 3:1           | AA       |
| Dark mode: text on dark bg         | 7:1           | AAA      |
| Dark mode: muted text on dark bg   | 4.5:1         | AA       |

**Remediation:** If any check fails, adjust lightness of the failing color by ±5% increments until the ratio is met, preserving hue and saturation.

#### 9b. 60-30-10 Distribution Check

```
VALIDATION:
  1. Primary color family should dominate layouts (≥50% of colored area)
  2. Secondary color family supports (25–35%)
  3. Accent color highlights (5–15%)
  4. Alert: if accent usage > 20%, flag as "accent overuse"
```

#### 9c. 4px Grid Alignment

```
FOR EACH spacing/radius/size token:
  value_px = convert_to_px(token_value)
  IF value_px % 4 !== 0 AND value_px !== 1:
    WARN: "{token_name}: {value_px}px is not on 4px grid"
    SUGGEST: nearest 4px-aligned value
```

#### 9d. Typography Validation

```
CHECKS:
  1. Heading font ≠ mono font
  2. Font files accessible via Google Fonts CDN or local hosting
  3. All weight variants (300–700) available for selected fonts
  4. Fallback fonts specified for all font stacks
  5. Base font size ≥ 16px (accessibility minimum)
```

#### 9e. Color Harmony Validation

```
CHECKS:
  1. Primary ↔ Secondary hue difference ≥ 20° and ≤ 180°
  2. Primary ↔ Accent hue difference ≥ 60°
  3. Secondary ↔ Accent hue difference ≥ 30°
  4. No two scale-500 values are perceptually identical (ΔE > 20)
  5. Dark mode colors maintain same hue relationships
```

---

## Error Handling

| Error Condition                       | Resolution                                    |
|---------------------------------------|-----------------------------------------------|
| No inputs at all                      | Use full fallback defaults                    |
| Logo analysis fails                   | Skip to Priority 3 (industry heuristics)      |
| Unknown industry                      | Map to "Technology" (most neutral)            |
| Font not found on Google Fonts        | Substitute with Inter (universal fallback)    |
| Contrast check fails after 10 adjustments | Use pure black/white text               |
| Invalid hex color provided            | Parse closest valid hex, warn user            |
| Multiple conflicting inputs           | Prefer higher priority source, log conflict   |

---

## Output Format

The generator produces the following files:

| File                 | Format       | Contents                              |
|----------------------|-------------|---------------------------------------|
| `tokens.css`         | CSS          | Complete custom properties            |
| `tokens.json`        | JSON         | Structured token data for JS          |
| `tokens.scss`        | SCSS         | Sass variables version                |
| `palette.svg`        | SVG          | Visual color palette swatch           |
| `generation-log.json`| JSON         | Audit trail of all decisions          |
