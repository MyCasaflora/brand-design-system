# design-tokens.md

**Owner: designer**
**Status: FINAL** — Generated from designer deliverables

---

## Token Naming Conventions

| Domain       | Pattern                          | Example               |
|--------------|----------------------------------|-----------------------|
| Colors       | `--color-{role}-{step}`          | `--color-primary-500` |
| Typography   | `--font-{role}`, `--text-{size}` | `--font-heading`, `--text-lg` |
| Spacing      | `--space-{size}`                 | `--space-md`          |
| Radius       | `--radius-{size}`                | `--radius-lg`         |
| Shadows      | `--shadow-{size}`                | `--shadow-md`         |
| Z-Index      | `--z-{layer}`                    | `--z-modal`           |
| Animation    | `--duration-{speed}`, `--ease-{type}` | `--duration-fast` |
| Opacity      | `--opacity-{state}`              | `--opacity-disabled`  |
| Breakpoints  | `--bp-{size}`                    | `--bp-lg`             |

---

## 3-Level Token Hierarchy

### Level 1: Primitive Tokens
Raw values without context. The foundational palette.
```
--color-blue-500: #3B82F6;
--font-size-16: 1rem;
--space-8: 0.5rem;
```

### Level 2: Semantic Tokens
Context-aware aliases describing purpose, not appearance.
```
--color-primary: var(--color-blue-500);
--color-bg: var(--color-gray-100);
--text-base: var(--font-size-16);
```

### Level 3: Component Tokens
Scoped to specific UI components.
```
--btn-bg: var(--color-primary);
--btn-text: var(--color-on-primary);
--card-padding: var(--space-lg);
```

**Rule:** Always use semantic tokens in component styles, never primitives directly. Component tokens override semantic tokens for component-specific needs.

---

## :root Template Reference

```css
:root {
  /* Colors — 60/30/10 distribution */
  --color-primary-500: {{PRIMARY}};
  --color-secondary-500: {{SECONDARY}};
  --color-accent-500: {{ACCENT}};
  --color-bg: {{BG}};
  --color-surface: {{SURFACE}};
  --color-text: {{TEXT}};
  --color-text-muted: {{TEXT_MUTED}};
  --color-border: {{BORDER}};

  /* Typography — Modular scale 1.25 (Major Third) */
  --font-heading: {{HEADING_FONT}}, system-ui, sans-serif;
  --font-body: {{BODY_FONT}}, system-ui, sans-serif;
  --font-mono: 'JetBrains Mono', ui-monospace, monospace;
  --text-xs: 0.75rem; --text-sm: 0.875rem; --text-base: 1rem;
  --text-lg: 1.125rem; --text-xl: 1.25rem; --text-2xl: 1.5rem;
  --text-3xl: 1.875rem; --text-4xl: 2.25rem; --text-5xl: 3rem;
  --text-6xl: 3.75rem; --text-7xl: 4.5rem;
  --font-light: 300; --font-regular: 400; --font-medium: 500;
  --font-semibold: 600; --font-bold: 700;
  --leading-tight: 1.2; --leading-snug: 1.375;
  --leading-normal: 1.5; --leading-relaxed: 1.625;

  /* Spacing — 8px grid */
  --space-xs: 0.25rem; --space-sm: 0.5rem; --space-md: 1rem;
  --space-lg: 1.5rem; --space-xl: 2rem; --space-2xl: 3rem;
  --space-3xl: 4rem; --space-4xl: 6rem;

  /* Radius */
  --radius-none: 0; --radius-sm: 4px; --radius-md: 8px;
  --radius-lg: 12px; --radius-xl: 20px; --radius-full: 9999px;

  /* Shadows */
  --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
  --shadow-md: 0 4px 6px rgba(0,0,0,0.07);
  --shadow-lg: 0 10px 15px rgba(0,0,0,0.10);
  --shadow-xl: 0 20px 25px rgba(0,0,0,0.15);

  /* Z-Index */
  --z-dropdown: 1000; --z-sticky: 1020; --z-fixed: 1030;
  --z-modal-backdrop: 1040; --z-modal: 1050;
  --z-tooltip: 1060; --z-toast: 1070;

  /* Animation */
  --duration-instant: 0ms; --duration-fast: 150ms;
  --duration-normal: 300ms; --duration-slow: 450ms;
  --ease-default: cubic-bezier(0.4, 0, 0.2, 1);
  --ease-in: cubic-bezier(0.4, 0, 1, 1);
  --ease-out: cubic-bezier(0, 0, 0.2, 1);

  /* Opacity */
  --opacity-disabled: 0.5; --opacity-hover: 0.8;
  --opacity-overlay: 0.75; --opacity-subtle: 0.1;

  /* Breakpoints (reference only) */
  --bp-sm: 640px; --bp-md: 768px; --bp-lg: 1024px;
  --bp-xl: 1280px; --bp-2xl: 1536px;
}
```

---

## WCAG Contrast Requirements

| Level | Ratio | Applies To                         |
|-------|-------|------------------------------------|
| AA    | 4.5:1 | Normal text (< 18px / < 14px bold) |
| AA    | 3:1   | Large text (>= 18px / >= 14px bold)|
| AA    | 3:1   | UI components, graphical objects   |
| AAA   | 7:1   | Normal text (enhanced)             |
| AAA   | 4.5:1 | Large text (enhanced)              |

### Mandatory Checks
1. `--color-text` on `--color-bg` — minimum 4.5:1
2. `--color-text` on `--color-surface` — minimum 4.5:1
3. `--color-text-muted` on `--color-bg` — minimum 3:1 (large text)
4. `--color-primary-500` on `--color-bg` — minimum 3:1
5. All interactive elements — visible focus indicators at 3:1 contrast

---

## Color Distribution Rule

- **60% Primary** — Backgrounds, large surfaces
- **30% Secondary** — Navigation, sidebars, cards
- **10% Accent** — CTAs, highlights, interactive elements

Each color role generates a 10-step scale (50-900) by lightness.

---

## Fallback Defaults

| Token            | Fallback Value                          |
|------------------|-----------------------------------------|
| Primary Color    | `#2563EB` (Blue 600)                    |
| Secondary Color  | `#475569` (Slate 600)                   |
| Accent Color     | `#F59E0B` (Amber 500)                   |
| Background       | `#FFFFFF`                               |
| Surface          | `#F8FAFC` (Slate 50)                    |
| Text             | `#0F172A` (Slate 900)                   |
| Text Muted       | `#64748B` (Slate 500)                   |
| Border           | `#E2E8F0` (Slate 200)                   |
| Heading Font     | `'Inter'`, system-ui, sans-serif        |
| Body Font        | `'Inter'`, system-ui, sans-serif        |
| Mono Font        | `'JetBrains Mono'`, ui-monospace, monospace |
| Radius (sm/md/lg)| 4px / 8px / 12px                        |

---

## Export Formats

| Format          | File                | Usage                |
|-----------------|---------------------|----------------------|
| CSS             | `tokens.css`        | Web projects         |
| JSON            | `tokens.json`       | JavaScript/React     |
| SCSS            | `_tokens.scss`      | Sass-based projects  |
| Tailwind Config | `tailwind.config.js`| Tailwind CSS         |
| Figma Variables | `figma-tokens.json` | Figma design tool    |

---

## Usage Rules

1. Always use semantic tokens in component styles, never primitives
2. Component tokens override semantic tokens for component-specific needs
3. Never hardcode values — always reference a token
4. Test in both light and dark modes before shipping
5. Validate contrast ratios after any color change
6. Maintain the 8px grid for all spacing decisions
7. Use rem units for scalable, accessible sizing
