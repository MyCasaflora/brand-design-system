# Design Token System Documentation

## Overview

This document defines the complete design token system for the Brand Design System plugin. Design tokens are the atomic building blocks of a visual design system — named entities that store visual design attributes (colors, typography, spacing, etc.) and can be consumed across platforms and tools.

---

## Token Architecture: 3-Level Hierarchy

### Level 1: Primitive Tokens
Raw, context-free values. These are the foundational palette.

```
--color-blue-500: #3B82F6;
--color-gray-100: #F3F4F6;
--font-size-16: 1rem;
--space-8: 0.5rem;
```

### Level 2: Semantic Tokens
Context-aware aliases that describe *purpose*, not appearance.

```
--color-primary: var(--color-blue-500);
--color-bg: var(--color-gray-100);
--text-base: var(--font-size-16);
--space-md: var(--space-8);
```

### Level 3: Component Tokens
Scoped to specific UI components for maximum flexibility.

```
--btn-bg: var(--color-primary);
--btn-text: var(--color-on-primary);
--btn-radius: var(--radius-md);
--card-padding: var(--space-lg);
--card-shadow: var(--shadow-md);
```

---

## Token Categories (9 Total)

### 1. Colors

#### Naming Convention
```
--color-{role}-{step}
```

#### Color Roles
| Role         | Description                        | Scale Steps          |
|--------------|------------------------------------|----------------------|
| `primary`    | Main brand color                   | 50–900 (10 steps)   |
| `secondary`  | Supporting brand color             | 50–900 (10 steps)   |
| `accent`     | Highlight / CTA color              | 50–900 (10 steps)   |
| `bg`         | Page background                    | Single value         |
| `surface`    | Card/panel backgrounds             | Single value         |
| `text`       | Primary body text                  | Single value         |
| `text-muted` | Secondary/helper text              | Single value         |
| `border`     | Dividers, outlines                 | Single value         |

#### 10-Step Scale
Each color role generates 10 lightness variants:

| Step | Lightness | Usage                           |
|------|-----------|----------------------------------|
| 50   | 96%       | Tinted backgrounds               |
| 100  | 90%       | Hover backgrounds                |
| 200  | 80%       | Light accents                    |
| 300  | 68%       | Decorative elements              |
| 400  | 52%       | Icons, secondary text            |
| 500  | Base      | Primary usage (brand color)      |
| 600  | 18%       | Hover states on dark             |
| 700  | 14%       | Active/pressed states            |
| 800  | 10%       | Dark accents                     |
| 900  | 6%        | Darkest variant                  |

#### 60-30-10 Color Distribution Rule
- **60% Primary** — Dominant brand color (backgrounds, large surfaces)
- **30% Secondary** — Supporting color (navigation, sidebars, cards)
- **10% Accent** — Call-to-action, highlights, interactive elements

This rule ensures visual harmony and hierarchy across all brand touchpoints.

---

### 2. Typography

#### Naming Convention
```
--font-{role}        → Font family (heading, body, mono)
--text-{size}        → Font size (xs through 7xl)
--font-{weight}      → Font weight (light, regular, medium, semibold, bold)
--leading-{density}  → Line height (tight, snug, normal, relaxed)
--tracking-{width}   → Letter spacing (tight, normal, wide, wider)
```

#### Modular Scale (Ratio: 1.25 — Major Third)
| Token        | Size      | rem    | px (at 16px base) |
|-------------|-----------|--------|---------------------|
| `--text-xs`  | Extra Small | 0.75rem  | 12px             |
| `--text-sm`  | Small       | 0.875rem | 14px             |
| `--text-base`| Base        | 1rem     | 16px             |
| `--text-lg`  | Large       | 1.125rem | 18px             |
| `--text-xl`  | XL          | 1.25rem  | 20px             |
| `--text-2xl` | 2XL         | 1.5rem   | 24px             |
| `--text-3xl` | 3XL         | 1.875rem | 30px             |
| `--text-4xl` | 4XL         | 2.25rem  | 36px             |
| `--text-5xl` | 5XL         | 3rem     | 48px             |
| `--text-6xl` | 6XL         | 3.75rem  | 60px             |
| `--text-7xl` | 7XL         | 4.5rem   | 72px             |

#### Font Weight Scale
| Token             | Weight | Usage                    |
|-------------------|--------|--------------------------|
| `--font-light`    | 300    | Decorative, display text |
| `--font-regular`  | 400    | Body text                |
| `--font-medium`   | 500    | Emphasis, subheadings    |
| `--font-semibold` | 600    | UI labels, nav items     |
| `--font-bold`     | 700    | Headings, CTAs           |

#### Line Height
| Token              | Value  | Usage                      |
|--------------------|--------|----------------------------|
| `--leading-tight`  | 1.2    | Headings, display text     |
| `--leading-snug`   | 1.375  | Subheadings, compact text  |
| `--leading-normal` | 1.5    | Body text (default)        |
| `--leading-relaxed`| 1.625  | Long-form reading          |

#### Letter Spacing
| Token              | Value     | Usage                |
|--------------------|-----------|----------------------|
| `--tracking-tight` | -0.025em  | Large display text   |
| `--tracking-normal`| 0         | Body text (default)  |
| `--tracking-wide`  | 0.025em   | Uppercase labels     |
| `--tracking-wider` | 0.05em    | Small caps, buttons  |

---

### 3. Spacing

#### Naming Convention
```
--space-{size}
```

#### 8px Grid System
All spacing values align to a 4px sub-grid with primary stops on 8px.

| Token         | Value    | px  | Usage                            |
|---------------|----------|-----|----------------------------------|
| `--space-xs`  | 0.25rem  | 4   | Tight internal padding           |
| `--space-sm`  | 0.5rem   | 8   | Icon gaps, compact elements      |
| `--space-md`  | 1rem     | 16  | Default padding, form gaps       |
| `--space-lg`  | 1.5rem   | 24  | Section padding                  |
| `--space-xl`  | 2rem     | 32  | Card padding, component gaps     |
| `--space-2xl` | 3rem     | 48  | Section margins                  |
| `--space-3xl` | 4rem     | 64  | Page section spacing             |
| `--space-4xl` | 6rem     | 96  | Hero sections, major separations |

---

### 4. Border Radius

#### Naming Convention
```
--radius-{size}
```

| Token           | Range         | Personality    |
|-----------------|---------------|----------------|
| `--radius-none` | 0             | Angular        |
| `--radius-sm`   | 2px–4px       | Subtle curves  |
| `--radius-md`   | 6px–8px       | Balanced       |
| `--radius-lg`   | 12px–16px     | Soft, friendly |
| `--radius-xl`   | 20px–24px     | Very rounded   |
| `--radius-full` | 9999px        | Pill / Circle  |

---

### 5. Shadows

#### Naming Convention
```
--shadow-{size}
```

| Token          | Value                               | Usage              |
|----------------|-------------------------------------|--------------------|
| `--shadow-sm`  | 0 1px 2px rgba(0,0,0,0.05)         | Subtle lift        |
| `--shadow-md`  | 0 4px 6px rgba(0,0,0,0.07)         | Cards, dropdowns   |
| `--shadow-lg`  | 0 10px 15px rgba(0,0,0,0.10)       | Modals, popovers   |
| `--shadow-xl`  | 0 20px 25px rgba(0,0,0,0.15)       | Floating elements  |

---

### 6. Breakpoints

#### Naming Convention
```
--bp-{size}
```

| Token      | Value   | Target                |
|------------|---------|------------------------|
| `--bp-sm`  | 640px   | Mobile landscape       |
| `--bp-md`  | 768px   | Tablet portrait        |
| `--bp-lg`  | 1024px  | Tablet landscape       |
| `--bp-xl`  | 1280px  | Desktop                |
| `--bp-2xl` | 1536px  | Large desktop          |

> **Note:** CSS custom properties cannot be used in `@media` queries directly. These values serve as documentation references. Use `@media (min-width: 768px)` in stylesheets.

---

### 7. Z-Index

#### Naming Convention
```
--z-{layer}
```

| Token              | Value | Usage                      |
|--------------------|-------|----------------------------|
| `--z-dropdown`     | 1000  | Dropdowns, autocompletes   |
| `--z-sticky`       | 1020  | Sticky headers, sidebars   |
| `--z-fixed`        | 1030  | Fixed navigation           |
| `--z-modal-backdrop` | 1040 | Modal overlay background  |
| `--z-modal`        | 1050  | Modal dialogs              |
| `--z-tooltip`      | 1060  | Tooltips, popovers         |
| `--z-toast`        | 1070  | Toast notifications        |

---

### 8. Animation

#### Naming Convention
```
--duration-{speed}
--ease-{type}
```

#### Duration Tiers
| Token               | Value | Usage                          |
|---------------------|-------|--------------------------------|
| `--duration-instant` | 0ms   | Immediate state changes       |
| `--duration-fast`    | 150ms | Hover states, micro feedback  |
| `--duration-normal`  | 300ms | Transitions, reveals          |
| `--duration-slow`    | 450ms | Complex animations            |
| `--duration-x-slow`  | 600ms | Page transitions              |

#### Easing Curves
| Token          | Value                          | Usage              |
|----------------|--------------------------------|--------------------|
| `--ease-default` | cubic-bezier(0.4, 0, 0.2, 1) | General purpose    |
| `--ease-in`      | cubic-bezier(0.4, 0, 1, 1)   | Exit animations    |
| `--ease-out`     | cubic-bezier(0, 0, 0.2, 1)   | Enter animations   |
| `--ease-bounce`  | cubic-bezier(0.34, 1.56, 0.64, 1) | Playful feedback |

---

### 9. Opacity

#### Naming Convention
```
--opacity-{state}
```

| Token               | Value | Usage                     |
|---------------------|-------|---------------------------|
| `--opacity-disabled` | 0.5   | Disabled UI elements     |
| `--opacity-hover`    | 0.8   | Hover overlay states     |
| `--opacity-overlay`  | 0.75  | Modal backdrops          |
| `--opacity-subtle`   | 0.1   | Background tints         |

---

## WCAG Accessibility Compliance

### Contrast Requirements

| Level   | Ratio  | Applies To                          |
|---------|--------|--------------------------------------|
| AA      | 4.5:1  | Normal text (< 18px / < 14px bold)  |
| AA      | 3:1    | Large text (≥ 18px / ≥ 14px bold)   |
| AA      | 3:1    | UI components, graphical objects     |
| AAA     | 7:1    | Normal text (enhanced)              |
| AAA     | 4.5:1  | Large text (enhanced)               |

### Mandatory Checks
1. `--color-text` on `--color-bg` must meet **WCAG AA (4.5:1)** minimum
2. `--color-text` on `--color-surface` must meet **WCAG AA (4.5:1)** minimum
3. `--color-text-muted` on `--color-bg` must meet **WCAG AA (3:1)** minimum for large text
4. `--color-primary-500` on `--color-bg` must meet **WCAG AA (3:1)** minimum
5. All interactive elements must have visible focus indicators with **3:1** contrast

---

## Fallback Defaults

When brand input is missing or incomplete, the system applies these sensible defaults:

| Token Category   | Fallback Value                                       |
|------------------|------------------------------------------------------|
| Primary Color    | `#2563EB` (Blue 600)                                 |
| Secondary Color  | `#475569` (Slate 600)                                |
| Accent Color     | `#F59E0B` (Amber 500)                                |
| Background       | `#FFFFFF` (White)                                    |
| Surface          | `#F8FAFC` (Slate 50)                                 |
| Text             | `#0F172A` (Slate 900)                                |
| Text Muted       | `#64748B` (Slate 500)                                |
| Border           | `#E2E8F0` (Slate 200)                                |
| Heading Font     | `'Inter'`, system-ui, sans-serif                     |
| Body Font        | `'Inter'`, system-ui, sans-serif                     |
| Mono Font        | `'JetBrains Mono'`, ui-monospace, monospace          |
| Radius (sm)      | `0.25rem` (4px)                                      |
| Radius (md)      | `0.5rem` (8px)                                       |
| Radius (lg)      | `0.75rem` (12px)                                     |

---

## Token Format & Export

Tokens are authored as CSS Custom Properties and can be exported to:

| Format            | File                | Usage                    |
|-------------------|---------------------|--------------------------|
| CSS               | `tokens.css`        | Web projects             |
| JSON              | `tokens.json`       | JavaScript/React         |
| SCSS              | `_tokens.scss`      | Sass-based projects      |
| Tailwind Config   | `tailwind.config.js`| Tailwind CSS projects    |
| Figma Variables   | `figma-tokens.json` | Figma design tool        |

---

## Usage Guidelines

1. **Always use semantic tokens** in component styles, never primitives directly
2. **Component tokens override semantic tokens** for component-specific needs
3. **Never hardcode values** — always reference a token
4. **Test in both light and dark modes** before shipping
5. **Validate contrast ratios** after any color change
6. **Maintain the 8px grid** for all spacing decisions
7. **Use rem units** for scalable, accessible sizing
