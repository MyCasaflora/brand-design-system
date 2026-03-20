# extended-tokens.md

**Owner: designer**
**Status: FINAL** — Generated from designer deliverables

---

## Dark Mode Tokens

### Activation
Dual strategy: automatic via `prefers-color-scheme` and manual via `[data-theme="dark"]`.

### Color Overrides

| Token                      | Light       | Dark        |
|----------------------------|-------------|-------------|
| `--color-bg`               | `#FFFFFF`   | `#0A0A0B`   |
| `--color-bg-alt`           | `#F8FAFC`   | `#111114`   |
| `--color-surface`          | `#F1F5F9`   | `#1C1C1F`   |
| `--color-surface-raised`   | `#E2E8F0`   | `#27272A`   |
| `--color-surface-overlay`  | `#FFFFFF`   | `#2E2E33`   |
| `--color-text`             | `#0F172A`   | `#FAFAFA`   |
| `--color-text-muted`       | `#64748B`   | `#A1A1AA`   |
| `--color-border`           | `#E2E8F0`   | `#2E2E33`   |

### Dark Mode Principles
1. Deep grays (`#0A0A0B`), not pure black — reduces eye strain
2. Brand colors unchanged (adjust lightness only if contrast fails)
3. Shadow alpha 3-5x higher on dark backgrounds
4. Elevation = lighter (inverted from light mode)

### Shadow Overrides
| Token         | Light Alpha | Dark Alpha |
|---------------|-------------|------------|
| `--shadow-sm` | 0.05        | 0.30       |
| `--shadow-md` | 0.07        | 0.40       |
| `--shadow-lg` | 0.10        | 0.50       |
| `--shadow-xl` | 0.15        | 0.55       |

---

## Social Media Dimensions

| Platform   | Format          | Width | Height | Aspect Ratio |
|------------|-----------------|-------|--------|--------------|
| Instagram  | Post (Square)   | 1080  | 1080   | 1:1          |
| Instagram  | Story / Reel    | 1080  | 1920   | 9:16         |
| Instagram  | Landscape       | 1080  | 566    | 1.91:1       |
| LinkedIn   | Cover Banner    | 1584  | 396    | 4:1          |
| LinkedIn   | Post Image      | 1200  | 627    | 1.91:1       |
| Twitter/X  | Header Banner   | 1500  | 500    | 3:1          |
| Twitter/X  | Post Image      | 1200  | 675    | 16:9         |
| Facebook   | Cover Photo     | 820   | 312    | 2.63:1       |
| Facebook   | Post Image      | 1200  | 630    | 1.91:1       |
| YouTube    | Thumbnail       | 1280  | 720    | 16:9         |
| YouTube    | Channel Art     | 2560  | 1440   | 16:9         |

### Safe Zones
- `--social-safe-zone-sm: 48px` (profile photos, small formats)
- `--social-safe-zone-md: 64px` (standard posts)
- `--social-safe-zone-lg: 96px` (banners, covers)
- `--social-text-safe-zone: 120px` (text readability)
- `--social-logo-max-width: 30%` of canvas width

### Social Typography
- Headline: 64px, Subhead: 36px, Body: 28px, Caption: 22px
- Max headline lines: 2, Max body lines: 4

---

## Print Specifications

### Color Space
Print requires CMYK. Use Rich Black (C:60 M:40 Y:40 K:100) for large black areas.

### Dimensions
- Resolution: 300 DPI (150 DPI draft)
- Bleed: 3mm, Safe zone: 5mm
- A4: 210 x 297mm, Letter: 215.9 x 279.4mm
- Business card: 88.9 x 50.8mm (3.5 x 2in)

### Print Stylesheet Essentials
- Body: 12pt, line-height 1.5, color #000
- Headings: page-break-after/inside avoid
- Paragraphs: orphans 3, widows 3
- Hide: nav, footer, .sidebar, .no-print
- Page margin: 20mm, size A4, first page top 30mm

---

## Motion Constraints

### Duration Tiers
| Token                | Duration | Use Case                    |
|----------------------|----------|-----------------------------|
| `--duration-instant` | 0ms      | Immediate state changes     |
| `--duration-fast`    | 150ms    | Hover, focus, micro-feedback|
| `--duration-normal`  | 300ms    | Transitions, reveals        |
| `--duration-slow`    | 450ms    | Complex animations          |
| `--duration-x-slow`  | 600ms    | Page transitions            |

### Easing Curves
| Token            | Value                                | Use Case          |
|------------------|--------------------------------------|--------------------|
| `--ease-default` | `cubic-bezier(0.4, 0, 0.2, 1)`      | General purpose    |
| `--ease-in`      | `cubic-bezier(0.4, 0, 1, 1)`        | Exit animations    |
| `--ease-out`     | `cubic-bezier(0, 0, 0.2, 1)`        | Enter animations   |
| `--ease-bounce`  | `cubic-bezier(0.34, 1.56, 0.64, 1)` | Playful feedback   |

### Forbidden Patterns
- Blinking/flashing: max 3 flashes/second (WCAG 2.3.1)
- Auto-play animation: must have pause/stop control
- Infinite loops: must have stop mechanism
- Parallax/vestibular triggers: must respect `prefers-reduced-motion`

---

## Icon and Favicon Specs

### Icon Tokens
- Sizes: `--icon-xs: 12px` through `--icon-2xl: 48px`
- Stroke: 1.5px default, 1px thin, 2px bold
- Color: `currentColor` (inherits from text context)
- Grid: 24x24 base, 2px internal padding

### Icon Rules
- One icon library per brand (never mix)
- Consistent stroke weight across all icons
- Use `currentColor` for automatic theme adaptation

### Favicon Sizes Required
| Format              | Size    | Purpose                |
|---------------------|---------|------------------------|
| Standard            | 16x16   | Browser tab            |
| Retina              | 32x32   | HiDPI browser tab      |
| Apple Touch Icon    | 180x180 | iOS home screen        |
| Android Chrome      | 192x192 | Android home screen    |
| Android Splash      | 512x512 | Android splash screen  |
| Safari Pinned Tab   | SVG     | Monochrome pinned tab  |

---

## Responsive Breakpoints

| Token      | Value   | Target                    | Grid Columns |
|------------|---------|---------------------------|--------------|
| `--bp-xs`  | 0px     | Mobile portrait (default) | 4            |
| `--bp-sm`  | 640px   | Mobile landscape          | 4            |
| `--bp-md`  | 768px   | Tablet portrait           | 8            |
| `--bp-lg`  | 1024px  | Tablet landscape          | 12           |
| `--bp-xl`  | 1280px  | Desktop                   | 12           |
| `--bp-2xl` | 1536px  | Large desktop             | 12           |

### Responsive Token Changes
- Container: 100% (mobile) -> 720px (tablet) -> 960px (desktop) -> 1200px (xl) -> 1440px (2xl)
- Hero text: `--text-3xl` (mobile) -> `--text-5xl` (desktop) -> `--text-7xl` (2xl)
- Nav height: 3.5rem (mobile) -> 4rem (tablet+)
- Sidebar: 0 (mobile) -> 280px (desktop) -> 320px (xl)

### Touch Targets
- `--touch-target-min: 44px` (WCAG 2.5.5)
- `--touch-target-comfortable: 48px`
- `--click-target-min: 32px` (mouse/trackpad)

---

## Internationalization (i18n) Tokens

### Text Direction
- LTR default; RTL via `[dir="rtl"]` reverses `--text-align-start`/`--text-align-end`

### Language-Specific Typography
| Script      | Line Height | Letter Spacing | Font Stack Fallback              |
|-------------|-------------|----------------|----------------------------------|
| CJK (zh/ja/ko) | 1.75    | 0.02em         | Noto Sans CJK, PingFang SC      |
| Arabic/Hebrew   | 1.8     | 0              | Noto Sans Arabic, Segoe UI      |
| Devanagari      | 1.7     | default        | Noto Sans Devanagari, Mangal    |
| Thai            | 1.8     | default        | Noto Sans Thai, Tahoma          |

### Content Expansion Factors
| Language   | Factor | Impact          |
|------------|--------|-----------------|
| German     | 1.30   | ~30% longer     |
| Spanish    | 1.25   | ~25% longer     |
| Arabic     | 1.25   | ~25% longer     |
| Russian    | 1.30   | ~30% longer     |
| French     | 1.20   | ~20% longer     |
| Japanese   | 0.60   | ~40% shorter    |
| Chinese    | 0.50   | ~50% shorter    |

### Number/Date Formatting (implement in JS)
- Decimal/thousands separators vary by locale
- Currency position: before (en: $10) or after (de: 10 EUR)
- Date formats: MM/DD/YYYY (US), DD.MM.YYYY (EU), YYYY-MM-DD (ISO)
