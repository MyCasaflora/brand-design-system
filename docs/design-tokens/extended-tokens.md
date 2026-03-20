# Extended Design Tokens

## Overview

This document extends the core token system with specialized tokens for dark mode, social media, print, motion, icons, favicons, data visualization, responsive breakpoints, and multilingual/i18n support.

---

## 1. Dark Mode

### Token Overrides

Dark mode uses a dual-activation strategy: automatic via `prefers-color-scheme` and manual via `[data-theme="dark"]`.

#### Dark Mode Color Palette

| Token               | Light Value | Dark Value   | Notes                        |
|---------------------|-------------|-------------|------------------------------|
| `--color-bg`        | `#FFFFFF`   | `#0A0A0B`   | Deep gray, not pure black    |
| `--color-bg-alt`    | `#F8FAFC`   | `#111114`   | Slightly elevated            |
| `--color-surface`   | `#F1F5F9`   | `#1C1C1F`   | Card/panel backgrounds       |
| `--color-surface-raised` | `#E2E8F0` | `#27272A` | Elevated surfaces          |
| `--color-surface-overlay`| `#FFFFFF` | `#2E2E33` | Popovers, dropdowns        |
| `--color-text`      | `#0F172A`   | `#FAFAFA`   | Primary text                 |
| `--color-text-muted`| `#64748B`   | `#A1A1AA`   | Secondary text               |
| `--color-border`    | `#E2E8F0`   | `#2E2E33`   | Default borders              |
| `--color-border-strong` | `#CBD5E1`| `#3F3F46`  | Emphasized borders           |

#### Dark Mode Principles

1. **Deep grays, not pure black** — `#0A0A0B` reduces eye strain vs `#000000`
2. **Brand colors unchanged** — Primary, secondary, accent remain the same hues (adjust lightness only if contrast fails)
3. **Increased shadow alpha** — Shadows need 3-5x alpha on dark backgrounds to be visible
4. **Reduced surface contrast** — Adjacent surfaces differ by only 1-2 steps to avoid harsh boundaries
5. **Inverted lightness hierarchy** — Elevation = lighter (opposite of light mode)

#### Shadow Overrides for Dark Mode

| Token         | Light Alpha | Dark Alpha | Reasoning                    |
|---------------|-------------|------------|------------------------------|
| `--shadow-sm` | 0.05        | 0.30       | Visible on dark backgrounds  |
| `--shadow-md` | 0.07        | 0.40       | Moderate elevation           |
| `--shadow-lg` | 0.10        | 0.50       | Strong elevation             |
| `--shadow-xl` | 0.15        | 0.55       | Floating elements            |
| `--shadow-2xl`| 0.25        | 0.75       | Maximum elevation            |

#### CSS Implementation

```css
[data-theme="dark"] {
  --color-bg: #0A0A0B;
  --color-bg-alt: #111114;
  --color-surface: #1C1C1F;
  --color-surface-raised: #27272A;
  --color-surface-overlay: #2E2E33;
  --color-text: #FAFAFA;
  --color-text-muted: #A1A1AA;
  --color-text-inverted: #0F172A;
  --color-border: #2E2E33;
  --color-border-strong: #3F3F46;
  --color-border-muted: #1C1C1F;

  --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.30);
  --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.40), 0 2px 4px -2px rgba(0, 0, 0, 0.30);
  --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.50), 0 4px 6px -4px rgba(0, 0, 0, 0.30);
  --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.55), 0 8px 10px -6px rgba(0, 0, 0, 0.35);
  --shadow-2xl: 0 25px 50px -12px rgba(0, 0, 0, 0.75);
}

@media (prefers-color-scheme: dark) {
  :root:not([data-theme="light"]) {
    /* Same overrides as [data-theme="dark"] */
  }
}
```

#### JavaScript Theme Toggle with localStorage Persistence

```javascript
class ThemeManager {
  static STORAGE_KEY = 'brand-theme-preference';
  static THEMES = ['light', 'dark', 'auto'];

  constructor() {
    this.init();
  }

  init() {
    const saved = localStorage.getItem(ThemeManager.STORAGE_KEY);
    if (saved && ThemeManager.THEMES.includes(saved)) {
      this.setTheme(saved);
    } else {
      this.setTheme('auto');
    }

    // Listen for system preference changes
    window.matchMedia('(prefers-color-scheme: dark)')
      .addEventListener('change', (e) => {
        if (this.getCurrentTheme() === 'auto') {
          // Auto mode: follow system
          document.documentElement.removeAttribute('data-theme');
        }
      });
  }

  getCurrentTheme() {
    return localStorage.getItem(ThemeManager.STORAGE_KEY) || 'auto';
  }

  setTheme(theme) {
    if (!ThemeManager.THEMES.includes(theme)) return;

    localStorage.setItem(ThemeManager.STORAGE_KEY, theme);

    if (theme === 'auto') {
      document.documentElement.removeAttribute('data-theme');
    } else {
      document.documentElement.setAttribute('data-theme', theme);
    }

    // Dispatch event for other components
    window.dispatchEvent(new CustomEvent('themechange', {
      detail: { theme, resolved: this.getResolvedTheme() }
    }));
  }

  getResolvedTheme() {
    const explicit = document.documentElement.getAttribute('data-theme');
    if (explicit) return explicit;
    return window.matchMedia('(prefers-color-scheme: dark)').matches
      ? 'dark' : 'light';
  }

  toggle() {
    const current = this.getResolvedTheme();
    this.setTheme(current === 'dark' ? 'light' : 'dark');
  }
}

// Initialize
const themeManager = new ThemeManager();

// Usage:
// themeManager.toggle();
// themeManager.setTheme('dark');
// themeManager.setTheme('auto');
```

#### Anti-FOUC Script (place in `<head>`)

```html
<script>
  (function() {
    var t = localStorage.getItem('brand-theme-preference');
    if (t === 'dark' || t === 'light') {
      document.documentElement.setAttribute('data-theme', t);
    }
  })();
</script>
```

---

## 2. Social Media Format Tokens

### Platform Dimensions

| Platform     | Format              | Width (px) | Height (px) | Aspect Ratio | Token Prefix       |
|-------------|---------------------|------------|-------------|--------------|---------------------|
| Instagram   | Post (Square)       | 1080       | 1080        | 1:1          | `--social-ig-post`  |
| Instagram   | Story / Reel        | 1080       | 1920        | 9:16         | `--social-ig-story` |
| Instagram   | Landscape           | 1080       | 566         | 1.91:1       | `--social-ig-land`  |
| Instagram   | Profile Photo       | 320        | 320         | 1:1          | `--social-ig-avatar`|
| LinkedIn    | Cover Banner        | 1584       | 396         | 4:1          | `--social-li-cover` |
| LinkedIn    | Post Image          | 1200       | 627         | 1.91:1       | `--social-li-post`  |
| LinkedIn    | Profile Photo       | 400        | 400         | 1:1          | `--social-li-avatar`|
| Twitter/X   | Header Banner       | 1500       | 500         | 3:1          | `--social-tw-header`|
| Twitter/X   | Post Image          | 1200       | 675         | 16:9         | `--social-tw-post`  |
| Twitter/X   | Profile Photo       | 400        | 400         | 1:1          | `--social-tw-avatar`|
| Facebook    | Cover Photo         | 820        | 312         | 2.63:1       | `--social-fb-cover` |
| Facebook    | Post Image          | 1200       | 630         | 1.91:1       | `--social-fb-post`  |
| Facebook    | Profile Photo       | 180        | 180         | 1:1          | `--social-fb-avatar`|
| YouTube     | Thumbnail           | 1280       | 720         | 16:9         | `--social-yt-thumb` |
| YouTube     | Channel Art         | 2560       | 1440        | 16:9         | `--social-yt-banner`|

### Safe Zone Tokens

Safe zones define areas that are guaranteed to be visible across all device crops.

```css
:root {
  /* Safe zone insets (content must stay within these margins) */
  --social-safe-zone-sm: 48px;   /* Profile photos, small formats */
  --social-safe-zone-md: 64px;   /* Standard posts */
  --social-safe-zone-lg: 96px;   /* Banners, covers (heavy cropping) */

  /* Text safe zones (additional margin for readable text) */
  --social-text-safe-zone: 120px;

  /* Logo placement zones */
  --social-logo-margin: 48px;
  --social-logo-max-width: 30%;  /* Logo should not exceed 30% of canvas width */
}
```

### Social Media Typography

```css
:root {
  /* Larger text for social (renders small on feeds) */
  --social-text-headline: 64px;
  --social-text-subhead: 36px;
  --social-text-body: 28px;
  --social-text-caption: 22px;

  /* Maximum line count (for readability at small sizes) */
  --social-max-headline-lines: 2;
  --social-max-body-lines: 4;
}
```

---

## 3. Print Tokens

### Color Space: CMYK

Print requires CMYK color values, not RGB/hex. All brand colors must be converted.

#### CMYK Equivalents

| Token              | Hex (Screen) | CMYK (Print)            | Pantone (approx)  |
|--------------------|-------------|-------------------------|---------------------|
| `--print-primary`  | {{PRIMARY}} | {{PRIMARY_CMYK}}        | {{PRIMARY_PANTONE}} |
| `--print-secondary`| {{SECONDARY}}| {{SECONDARY_CMYK}}     | {{SECONDARY_PANTONE}}|
| `--print-accent`   | {{ACCENT}}  | {{ACCENT_CMYK}}         | {{ACCENT_PANTONE}}  |
| `--print-black`    | `#000000`   | C:0 M:0 Y:0 K:100      | Black               |
| `--print-rich-black`| `#0A0A0B`  | C:60 M:40 Y:40 K:100   | Rich Black          |
| `--print-white`    | `#FFFFFF`   | C:0 M:0 Y:0 K:0        | White               |

> **Rich Black:** Always use C:60 M:40 Y:40 K:100 for large black areas in print. Pure K:100 black appears washed out.

### Print Dimensions

```css
:root {
  /* Resolution */
  --print-dpi: 300;
  --print-dpi-draft: 150;

  /* Bleed */
  --print-bleed: 3mm;

  /* Safe Zone (content margin from trim) */
  --print-safe-zone: 5mm;

  /* Standard Paper Sizes */
  --print-a4-width: 210mm;
  --print-a4-height: 297mm;
  --print-a5-width: 148mm;
  --print-a5-height: 210mm;
  --print-letter-width: 215.9mm;
  --print-letter-height: 279.4mm;

  /* Business Card */
  --print-card-width: 88.9mm;   /* 3.5in */
  --print-card-height: 50.8mm;  /* 2in */
}
```

### Print Stylesheet

```css
@media print {
  *,
  *::before,
  *::after {
    background: transparent !important;
    box-shadow: none !important;
    text-shadow: none !important;
  }

  body {
    font-family: var(--font-body);
    font-size: 12pt;
    line-height: 1.5;
    color: #000000;
  }

  h1, h2, h3, h4, h5, h6 {
    font-family: var(--font-heading);
    page-break-after: avoid;
    page-break-inside: avoid;
  }

  p, blockquote, ul, ol {
    orphans: 3;
    widows: 3;
  }

  img {
    max-width: 100% !important;
    page-break-inside: avoid;
  }

  a {
    color: #000000;
    text-decoration: underline;
  }

  a[href^="http"]::after {
    content: " (" attr(href) ")";
    font-size: 0.8em;
    color: #666666;
  }

  .no-print,
  nav,
  footer,
  .sidebar {
    display: none !important;
  }

  @page {
    margin: 20mm;
    size: A4;
  }

  @page :first {
    margin-top: 30mm;
  }
}
```

---

## 4. Motion Tokens

### Duration Tiers

| Tier       | Token               | Duration | Use Case                              |
|-----------|---------------------|----------|---------------------------------------|
| Instant   | `--duration-instant` | 0ms      | Immediate state changes               |
| Fast      | `--duration-fast`    | 150ms    | Hover, focus, micro-interactions      |
| Normal    | `--duration-normal`  | 300ms    | Transitions, reveals, collapses       |
| Slow      | `--duration-slow`    | 450ms    | Complex multi-step animations         |
| X-Slow    | `--duration-x-slow`  | 600ms    | Page transitions, loading sequences   |

### Easing Curves

| Curve      | Token          | Value                          | Use Case               |
|-----------|----------------|--------------------------------|------------------------|
| Default   | `--ease-default`| `cubic-bezier(0.4, 0, 0.2, 1)`| General transitions   |
| In        | `--ease-in`     | `cubic-bezier(0.4, 0, 1, 1)`  | Elements leaving view |
| Out       | `--ease-out`    | `cubic-bezier(0, 0, 0.2, 1)`  | Elements entering view|
| In-Out    | `--ease-in-out` | `cubic-bezier(0.42, 0, 0.58, 1)` | Symmetrical moves  |
| Bounce    | `--ease-bounce` | `cubic-bezier(0.34, 1.56, 0.64, 1)` | Playful feedback |

### Forbidden Motion Patterns (Accessibility)

Per WCAG 2.3.1 (Three Flashes) and general accessibility guidelines:

| Pattern                          | Rule                                              | Reference     |
|----------------------------------|----------------------------------------------------|---------------|
| Duration > 400ms                 | Avoid for frequent UI interactions                 | Best practice |
| Parallax scrolling               | Must respect `prefers-reduced-motion`              | WCAG 2.3.3    |
| Auto-play animation              | Must provide pause/stop control                    | WCAG 2.2.2    |
| Blinking/flashing content        | **FORBIDDEN** — max 3 flashes/second               | WCAG 2.3.1    |
| Infinite loops                   | Must have stop mechanism                           | WCAG 2.2.2    |
| Motion-triggered interactions    | Must have non-motion alternative                   | WCAG 2.5.4    |
| Vestibular-triggering animations | Zoom, spin, bouncing — must respect reduced motion | Best practice |

### Reduced Motion Implementation

```css
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

### Recommended Animation Tokens

```css
:root {
  /* Fade */
  --animation-fade-in: fade-in var(--duration-normal) var(--ease-out);
  --animation-fade-out: fade-out var(--duration-fast) var(--ease-in);

  /* Slide */
  --animation-slide-up: slide-up var(--duration-normal) var(--ease-out);
  --animation-slide-down: slide-down var(--duration-normal) var(--ease-out);

  /* Scale */
  --animation-scale-in: scale-in var(--duration-fast) var(--ease-bounce);
  --animation-scale-out: scale-out var(--duration-fast) var(--ease-in);
}

@keyframes fade-in { from { opacity: 0; } to { opacity: 1; } }
@keyframes fade-out { from { opacity: 1; } to { opacity: 0; } }
@keyframes slide-up { from { transform: translateY(8px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
@keyframes slide-down { from { transform: translateY(-8px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
@keyframes scale-in { from { transform: scale(0.95); opacity: 0; } to { transform: scale(1); opacity: 1; } }
@keyframes scale-out { from { transform: scale(1); opacity: 1; } to { transform: scale(0.95); opacity: 0; } }
```

---

## 5. Icon System

### Icon Design Tokens

```css
:root {
  /* Icon Sizes */
  --icon-xs: 12px;
  --icon-sm: 16px;
  --icon-md: 20px;
  --icon-lg: 24px;
  --icon-xl: 32px;
  --icon-2xl: 48px;

  /* Icon Stroke */
  --icon-stroke-width: 1.5px;    /* Default stroke width */
  --icon-stroke-width-thin: 1px; /* For larger icons */
  --icon-stroke-width-bold: 2px; /* For emphasis */

  /* Icon Colors — inherit from text by default */
  --icon-color: currentColor;
  --icon-color-muted: var(--color-text-muted);
  --icon-color-primary: var(--color-primary-500);
  --icon-color-on-primary: var(--color-text-on-primary);

  /* Icon Optical Sizing */
  --icon-optical-margin: 2px;    /* Visual alignment compensation */
}
```

### Icon Specifications

| Property        | Value                            | Rationale                         |
|-----------------|----------------------------------|-----------------------------------|
| Style           | Outline (stroke-based)           | Scalable, consistent weight       |
| Stroke Width    | 1.5px – 2px                      | Visible at small sizes            |
| Corner Radius   | Match `--radius-sm` of brand     | Visual consistency                |
| Color           | `currentColor` inheritance       | Automatic theme adaptation        |
| Grid            | 24×24 base grid                  | Standard, widely supported        |
| Padding         | 2px internal padding             | Optical balance at edges          |
| Fill            | No fill (outline only)           | Clean, modern aesthetic           |

### Icon Set Consistency Rules

1. **One icon set per brand** — Never mix icon libraries (e.g., do not combine Heroicons with Feather)
2. **Consistent stroke weight** — All icons must use the same stroke width
3. **Color inheritance** — Use `currentColor` so icons adapt to their text context
4. **Optical alignment** — Round icons may need `--icon-optical-margin` to visually align with text

### Recommended Icon Libraries (by personality)

| Personality | Library              | Style              |
|------------|----------------------|---------------------|
| Luxury     | Phosphor (thin)      | Thin outline        |
| Corporate  | Heroicons (outline)  | Clean outline       |
| Tech       | Lucide               | Geometric outline   |
| Friendly   | Phosphor (regular)   | Rounded outline     |
| Creative   | Tabler Icons         | Expressive outline  |
| Classic    | Feather Icons        | Simple outline      |
| Minimal    | Heroicons (mini)     | Compact outline     |

---

## 6. Favicon System

### Required Formats

| Format                    | Dimensions   | File Type | Purpose                        |
|--------------------------|-------------|-----------|--------------------------------|
| Standard favicon         | 16×16       | ICO/PNG   | Browser tab (standard)         |
| Retina favicon           | 32×32       | PNG       | Browser tab (HiDPI)            |
| Windows tile             | 48×48       | PNG       | Windows pinned sites           |
| Apple Touch Icon         | 180×180     | PNG       | iOS home screen                |
| Android Chrome (small)   | 192×192     | PNG       | Android home screen            |
| Android Chrome (large)   | 512×512     | PNG       | Android splash screen          |
| MS Tile                  | 150×150     | PNG       | Windows Start tiles            |
| Safari Pinned Tab        | SVG         | SVG       | Safari pinned tab (monochrome) |

### Favicon Tokens

```css
:root {
  --favicon-bg: var(--color-primary-500);     /* Background color */
  --favicon-fg: var(--color-text-on-primary); /* Icon/letter color */
  --favicon-radius: 20%;                       /* Corner rounding for app icons */
}
```

### HTML Implementation

```html
<!-- Favicons -->
<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
<link rel="icon" type="image/svg+xml" href="/favicon.svg">
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
<link rel="manifest" href="/site.webmanifest">
<meta name="msapplication-TileColor" content="var(--favicon-bg)">
<meta name="theme-color" content="var(--color-primary-500)">
```

### Web App Manifest

```json
{
  "name": "{{BRAND_NAME}}",
  "short_name": "{{BRAND_SHORT_NAME}}",
  "icons": [
    { "src": "/android-chrome-192x192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "/android-chrome-512x512.png", "sizes": "512x512", "type": "image/png" }
  ],
  "theme_color": "{{PRIMARY_500}}",
  "background_color": "{{BG_COLOR}}",
  "display": "standalone"
}
```

---

## 7. Data Visualization Tokens

### Sequential Palette (Single Hue, 6 Steps)

For ordered data (e.g., heat maps, progress).

```css
:root {
  --dataviz-seq-1: var(--color-primary-100);   /* opacity: 0.15 */
  --dataviz-seq-2: var(--color-primary-200);   /* opacity: 0.30 */
  --dataviz-seq-3: var(--color-primary-300);   /* opacity: 0.50 */
  --dataviz-seq-4: var(--color-primary-500);   /* opacity: 0.70 */
  --dataviz-seq-5: var(--color-primary-700);   /* opacity: 0.85 */
  --dataviz-seq-6: var(--color-primary-900);   /* opacity: 1.00 */
}
```

### Categorical Palette (Multi-Hue, 6 Colors)

For unrelated categories (e.g., pie charts, legend items).

```css
:root {
  --dataviz-cat-1: var(--color-primary-500);   /* Primary brand hue */
  --dataviz-cat-2: var(--color-secondary-500); /* Secondary brand hue */
  --dataviz-cat-3: var(--color-accent-500);    /* Accent brand hue */
  --dataviz-cat-4: #06B6D4;                    /* Cyan — neutral addition */
  --dataviz-cat-5: #8B5CF6;                    /* Violet — neutral addition */
  --dataviz-cat-6: #F97316;                    /* Orange — neutral addition */
}
```

### Diverging Palette (Positive / Neutral / Negative)

For data with a meaningful midpoint (e.g., profit/loss, sentiment).

```css
:root {
  /* Positive (green family) */
  --dataviz-positive-strong: #059669;
  --dataviz-positive-moderate: #34D399;
  --dataviz-positive-light: #D1FAE5;

  /* Neutral (gray) */
  --dataviz-neutral: var(--color-gray-300);

  /* Negative (red family) */
  --dataviz-negative-light: #FEE2E2;
  --dataviz-negative-moderate: #F87171;
  --dataviz-negative-strong: #DC2626;
}
```

### Data Visualization Guidelines

| Rule                         | Specification                                  |
|------------------------------|------------------------------------------------|
| Minimum colors per chart     | 2                                              |
| Maximum colors per chart     | 6 (use grouping for more categories)           |
| Contrast between adjacent    | Minimum ΔE > 25                                |
| Color-blind safe             | All palettes tested with deuteranopia filter    |
| Pattern backup               | Provide pattern fills for essential charts      |
| Grid lines                   | Use `--color-border-muted` at 0.5 opacity      |
| Axis labels                  | Use `--color-text-muted` at `--text-sm`        |
| Data labels                  | Use `--color-text` at `--text-xs`              |

---

## 8. Responsive Breakpoints

### Breakpoint Token System

```css
:root {
  /* Breakpoint values (reference only — cannot use in @media) */
  --bp-xs: 0px;       /* Mobile portrait (default) */
  --bp-sm: 640px;     /* Mobile landscape */
  --bp-md: 768px;     /* Tablet portrait */
  --bp-lg: 1024px;    /* Tablet landscape / small desktop */
  --bp-xl: 1280px;    /* Desktop */
  --bp-2xl: 1536px;   /* Large desktop / ultra-wide */
}
```

### Responsive Token Overrides

Tokens that change at breakpoints:

```css
/* Mobile-first defaults */
:root {
  --container-width: 100%;
  --container-padding: var(--space-md);       /* 16px */
  --grid-columns: 4;
  --grid-gutter: var(--space-md);             /* 16px */
  --text-hero: var(--text-3xl);               /* 30px */
  --text-section: var(--text-xl);             /* 20px */
  --nav-height: 3.5rem;                       /* 56px */
  --sidebar-width: 0;
}

/* Tablet (768px+) */
@media (min-width: 768px) {
  :root {
    --container-width: 720px;
    --container-padding: var(--space-lg);     /* 24px */
    --grid-columns: 8;
    --grid-gutter: var(--space-lg);           /* 24px */
    --text-hero: var(--text-4xl);             /* 36px */
    --text-section: var(--text-2xl);          /* 24px */
    --nav-height: 4rem;                       /* 64px */
  }
}

/* Desktop (1024px+) */
@media (min-width: 1024px) {
  :root {
    --container-width: 960px;
    --container-padding: var(--space-xl);     /* 32px */
    --grid-columns: 12;
    --grid-gutter: var(--space-lg);           /* 24px */
    --text-hero: var(--text-5xl);             /* 48px */
    --text-section: var(--text-3xl);          /* 30px */
    --sidebar-width: 280px;
  }
}

/* Large Desktop (1280px+) */
@media (min-width: 1280px) {
  :root {
    --container-width: 1200px;
    --container-padding: var(--space-2xl);    /* 48px */
    --text-hero: var(--text-6xl);             /* 60px */
    --text-section: var(--text-4xl);          /* 36px */
    --sidebar-width: 320px;
  }
}

/* Ultra-wide (1536px+) */
@media (min-width: 1536px) {
  :root {
    --container-width: 1440px;
    --text-hero: var(--text-7xl);             /* 72px */
    --text-section: var(--text-5xl);          /* 48px */
  }
}
```

### Touch Target Tokens

```css
:root {
  /* Minimum touch targets (WCAG 2.5.5 Level AAA) */
  --touch-target-min: 44px;
  --touch-target-comfortable: 48px;

  /* Pointer-specific adjustments */
  --click-target-min: 32px;   /* Mouse/trackpad users */
}

@media (pointer: coarse) {
  :root {
    --btn-min-height: var(--touch-target-comfortable);
    --input-min-height: var(--touch-target-comfortable);
    --nav-link-min-height: var(--touch-target-comfortable);
  }
}

@media (pointer: fine) {
  :root {
    --btn-min-height: var(--click-target-min);
    --input-min-height: 36px;
    --nav-link-min-height: 36px;
  }
}
```

---

## 9. Multilingual / i18n Tokens

### Text Direction

```css
:root {
  --text-direction: ltr;
  --text-align-start: left;
  --text-align-end: right;
}

[dir="rtl"] {
  --text-direction: rtl;
  --text-align-start: right;
  --text-align-end: left;
}
```

### Language-Specific Typography

```css
/* CJK (Chinese, Japanese, Korean) */
:lang(zh),
:lang(ja),
:lang(ko) {
  --font-body: {{FONT_CJK_BODY}}, 'Noto Sans CJK', 'PingFang SC', 'Hiragino Sans', 'Microsoft YaHei', sans-serif;
  --font-heading: {{FONT_CJK_HEADING}}, 'Noto Sans CJK', 'PingFang SC', sans-serif;
  --leading-normal: 1.75;     /* CJK needs more line height */
  --leading-tight: 1.4;
  --tracking-normal: 0.02em;  /* Slight letter spacing for readability */
  --text-base: 1rem;          /* Keep 16px base */
}

/* Arabic / Hebrew (RTL) */
:lang(ar),
:lang(he) {
  --font-body: {{FONT_ARABIC_BODY}}, 'Noto Sans Arabic', 'Segoe UI', Tahoma, sans-serif;
  --font-heading: {{FONT_ARABIC_HEADING}}, 'Noto Sans Arabic', sans-serif;
  --leading-normal: 1.8;      /* Arabic script needs generous line height */
  --tracking-normal: 0;       /* No extra letter spacing for Arabic */
}

/* Devanagari (Hindi, Sanskrit) */
:lang(hi),
:lang(sa) {
  --font-body: {{FONT_DEVANAGARI_BODY}}, 'Noto Sans Devanagari', 'Mangal', sans-serif;
  --font-heading: {{FONT_DEVANAGARI_HEADING}}, 'Noto Sans Devanagari', sans-serif;
  --leading-normal: 1.7;
}

/* Thai */
:lang(th) {
  --font-body: {{FONT_THAI_BODY}}, 'Noto Sans Thai', 'Tahoma', sans-serif;
  --leading-normal: 1.8;      /* Thai tall glyphs need more space */
}

/* Cyrillic (Russian, etc.) */
:lang(ru),
:lang(uk),
:lang(bg) {
  --font-body: {{FONT_BODY}}, 'Noto Sans', 'Segoe UI', sans-serif;
  /* Most Latin fonts support Cyrillic; verify coverage */
}
```

### Content Expansion Tokens

Different languages expand or contract relative to English. These tokens help plan layouts.

```css
:root {
  /* Content expansion factors (relative to English baseline 1.0) */
  --i18n-expansion-de: 1.30;   /* German: ~30% longer */
  --i18n-expansion-fr: 1.20;   /* French: ~20% longer */
  --i18n-expansion-es: 1.25;   /* Spanish: ~25% longer */
  --i18n-expansion-it: 1.15;   /* Italian: ~15% longer */
  --i18n-expansion-pt: 1.20;   /* Portuguese: ~20% longer */
  --i18n-expansion-ja: 0.60;   /* Japanese: ~40% shorter */
  --i18n-expansion-zh: 0.50;   /* Chinese: ~50% shorter */
  --i18n-expansion-ko: 0.70;   /* Korean: ~30% shorter */
  --i18n-expansion-ar: 1.25;   /* Arabic: ~25% longer */
  --i18n-expansion-ru: 1.30;   /* Russian: ~30% longer */
}
```

### Number & Date Format Tokens

```css
:root {
  /* Number formatting (CSS reference — implement in JS) */
  --i18n-decimal-separator: '.';    /* en: '.'  de: ',' */
  --i18n-thousands-separator: ',';  /* en: ','  de: '.' */
  --i18n-currency-position: 'before'; /* en: before ($10)  de: after (10€) */

  /* Date format hints */
  --i18n-date-format: 'MM/DD/YYYY';    /* US */
  /* --i18n-date-format: 'DD.MM.YYYY'; */ /* Europe */
  /* --i18n-date-format: 'YYYY-MM-DD'; */ /* ISO */
}
```

### Pluralization & Gender Spacing

```css
:root {
  /* Reserve extra space for languages with longer plural forms */
  --i18n-label-min-width: 80px;

  /* Gender-inclusive typography (German, French, etc.) */
  --i18n-genderstar-spacing: 0.02em;  /* Spacing around gender symbols */
}
```

---

## Appendix: Token Naming Quick Reference

| Domain            | Pattern                          | Example                     |
|-------------------|----------------------------------|-----------------------------|
| Colors            | `--color-{role}-{step}`          | `--color-primary-500`       |
| Typography        | `--font-{role}`, `--text-{size}` | `--font-heading`, `--text-lg` |
| Spacing           | `--space-{size}`                 | `--space-md`                |
| Radius            | `--radius-{size}`                | `--radius-lg`               |
| Shadows           | `--shadow-{size}`                | `--shadow-md`               |
| Z-Index           | `--z-{layer}`                    | `--z-modal`                 |
| Animation         | `--duration-{speed}`             | `--duration-fast`           |
| Opacity           | `--opacity-{state}`              | `--opacity-disabled`        |
| Breakpoints       | `--bp-{size}`                    | `--bp-lg`                   |
| Social            | `--social-{platform}-{format}`   | `--social-ig-post`          |
| Print             | `--print-{property}`             | `--print-bleed`             |
| Icons             | `--icon-{property}`              | `--icon-sm`                 |
| Favicon           | `--favicon-{property}`           | `--favicon-bg`              |
| Data Viz          | `--dataviz-{type}-{step}`        | `--dataviz-cat-1`           |
| i18n              | `--i18n-{property}`              | `--i18n-expansion-de`       |
