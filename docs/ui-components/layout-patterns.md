# Layout Patterns

Token-driven layout system for the {{BRAND_NAME}} Design System. All values reference CSS custom properties for consistency and themability.

---

## 12-Column Grid System

### Container Widths

| Breakpoint | Token            | Max Width |
|------------|------------------|-----------|
| sm         | `--container-sm` | 640px     |
| md         | `--container-md` | 768px     |
| lg         | `--container-lg` | 1024px    |
| xl         | `--container-xl` | 1280px    |
| 2xl        | `--container-2xl`| 1440px    |

### Grid Tokens

| Token              | Value  | Description            |
|--------------------|--------|------------------------|
| `--grid-columns`   | 12     | Number of columns      |
| `--grid-gutter`    | 1.5rem | Gap between columns    |
| `--grid-margin`    | 1rem   | Outer margin (mobile)  |
| `--grid-margin-lg` | 2rem   | Outer margin (desktop) |

### CSS Grid Implementation

```css
/* Base container */
.container {
  width: 100%;
  max-width: var(--container-xl);
  margin-inline: auto;
  padding-inline: var(--grid-margin);
}

@media (min-width: 1024px) {
  .container {
    padding-inline: var(--grid-margin-lg);
  }
}

/* 12-column grid */
.grid {
  display: grid;
  grid-template-columns: repeat(var(--grid-columns), 1fr);
  gap: var(--grid-gutter);
}

/* Column spans */
.col-1  { grid-column: span 1; }
.col-2  { grid-column: span 2; }
.col-3  { grid-column: span 3; }
.col-4  { grid-column: span 4; }
.col-5  { grid-column: span 5; }
.col-6  { grid-column: span 6; }
.col-7  { grid-column: span 7; }
.col-8  { grid-column: span 8; }
.col-9  { grid-column: span 9; }
.col-10 { grid-column: span 10; }
.col-11 { grid-column: span 11; }
.col-12 { grid-column: span 12; }

/* Responsive column spans (mobile-first) */
@media (max-width: 767px) {
  [class*="col-"] {
    grid-column: span 12; /* Full width on mobile */
  }
}

@media (min-width: 768px) {
  .col-md-1  { grid-column: span 1; }
  .col-md-2  { grid-column: span 2; }
  .col-md-3  { grid-column: span 3; }
  .col-md-4  { grid-column: span 4; }
  .col-md-5  { grid-column: span 5; }
  .col-md-6  { grid-column: span 6; }
  .col-md-7  { grid-column: span 7; }
  .col-md-8  { grid-column: span 8; }
  .col-md-9  { grid-column: span 9; }
  .col-md-10 { grid-column: span 10; }
  .col-md-11 { grid-column: span 11; }
  .col-md-12 { grid-column: span 12; }
}

@media (min-width: 1024px) {
  .col-lg-1  { grid-column: span 1; }
  .col-lg-2  { grid-column: span 2; }
  .col-lg-3  { grid-column: span 3; }
  .col-lg-4  { grid-column: span 4; }
  .col-lg-5  { grid-column: span 5; }
  .col-lg-6  { grid-column: span 6; }
  .col-lg-7  { grid-column: span 7; }
  .col-lg-8  { grid-column: span 8; }
  .col-lg-9  { grid-column: span 9; }
  .col-lg-10 { grid-column: span 10; }
  .col-lg-11 { grid-column: span 11; }
  .col-lg-12 { grid-column: span 12; }
}
```

### Utility Classes

```css
/* Common layout utilities */
.flex       { display: flex; }
.flex-col   { flex-direction: column; }
.flex-wrap  { flex-wrap: wrap; }
.items-center   { align-items: center; }
.items-start    { align-items: flex-start; }
.justify-center { justify-content: center; }
.justify-between { justify-content: space-between; }
.gap-sm     { gap: var(--space-sm); }
.gap-md     { gap: var(--space-md); }
.gap-lg     { gap: var(--space-lg); }
.gap-xl     { gap: var(--space-xl); }
```

---

## Page Templates

### 1. Landing Page

**Structure:** Hero -> Features -> Testimonials -> CTA -> Footer

```css
/* Landing page layout */
.landing-hero {
  min-height: 80vh;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding: var(--space-3xl) var(--grid-margin);
}

.landing-hero-content {
  max-width: var(--container-md);
}

.landing-hero h1 {
  font-size: clamp(var(--font-size-3xl), 5vw, var(--font-size-4xl));
  font-weight: var(--font-weight-bold);
  line-height: var(--line-height-tight);
  margin-bottom: var(--space-lg);
}

.landing-features {
  padding: var(--space-3xl) 0;
}

.landing-features .grid {
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: var(--space-xl);
}

.landing-testimonials {
  padding: var(--space-3xl) 0;
  background-color: var(--color-gray-50);
}

.landing-testimonials .grid {
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  gap: var(--space-lg);
}

.landing-cta {
  padding: var(--space-3xl) 0;
  text-align: center;
}

.landing-cta-content {
  max-width: var(--container-sm);
  margin: 0 auto;
}
```

### 2. Dashboard

**Structure:** Sidebar + Top Nav + Content Grid + Widget Cards

```css
/* Dashboard layout */
.dashboard {
  display: grid;
  grid-template-columns: 260px 1fr;
  grid-template-rows: 64px 1fr;
  grid-template-areas:
    "sidebar topnav"
    "sidebar content";
  min-height: 100vh;
}

.dashboard-sidebar {
  grid-area: sidebar;
  background: var(--color-bg-surface);
  border-right: 1px solid var(--color-border);
  padding: var(--space-lg) 0;
  overflow-y: auto;
}

.dashboard-topnav {
  grid-area: topnav;
  background: var(--color-bg-surface);
  border-bottom: 1px solid var(--color-border);
  display: flex;
  align-items: center;
  padding: 0 var(--space-lg);
}

.dashboard-content {
  grid-area: content;
  padding: var(--space-xl);
  background: var(--color-bg-page);
  overflow-y: auto;
}

.dashboard-widgets {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: var(--space-lg);
  margin-bottom: var(--space-xl);
}

/* Collapse sidebar on mobile */
@media (max-width: 768px) {
  .dashboard {
    grid-template-columns: 1fr;
    grid-template-areas:
      "topnav"
      "content";
  }
  .dashboard-sidebar {
    position: fixed;
    left: -260px;
    top: 0;
    bottom: 0;
    z-index: var(--z-overlay);
    transition: left var(--transition-normal);
  }
  .dashboard-sidebar.open {
    left: 0;
  }
}
```

### 3. About / Team Page

**Structure:** Full-width hero -> Content sections -> Team grid

```css
/* About page layout */
.about-hero {
  width: 100%;
  min-height: 50vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: var(--color-primary);
  color: var(--color-text-inverse);
  padding: var(--space-3xl) var(--grid-margin);
  text-align: center;
}

.about-hero-content {
  max-width: var(--container-md);
}

.about-section {
  padding: var(--space-3xl) 0;
  max-width: var(--container-lg);
  margin: 0 auto;
}

.about-section + .about-section {
  border-top: 1px solid var(--color-border);
}

.team-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: var(--space-xl);
}

.team-member {
  text-align: center;
}

.team-member-photo {
  width: 160px;
  height: 160px;
  border-radius: var(--radius-full);
  object-fit: cover;
  margin: 0 auto var(--space-md);
}
```

### 4. Blog / Article Page

**Structure:** Narrow content column (65ch max) + optional sidebar

```css
/* Article layout */
.article-layout {
  display: grid;
  grid-template-columns: 1fr min(65ch, 100%) 1fr;
  padding: var(--space-3xl) var(--grid-margin);
}

.article-layout > * {
  grid-column: 2;
}

/* Full-bleed elements within article */
.article-layout > .full-bleed {
  grid-column: 1 / -1;
  width: 100%;
}

.article-content {
  font-size: var(--font-size-lg);
  line-height: var(--line-height-relaxed);
}

.article-content h2 {
  margin-top: var(--space-2xl);
  margin-bottom: var(--space-md);
  font-size: var(--font-size-2xl);
}

.article-content h3 {
  margin-top: var(--space-xl);
  margin-bottom: var(--space-sm);
  font-size: var(--font-size-xl);
}

.article-content p {
  margin-bottom: var(--space-md);
}

.article-content img {
  width: 100%;
  height: auto;
  border-radius: var(--radius-lg);
  margin: var(--space-lg) 0;
}

/* Article with sidebar variant */
.article-with-sidebar {
  display: grid;
  grid-template-columns: 1fr 300px;
  gap: var(--space-2xl);
  max-width: var(--container-xl);
  margin: 0 auto;
  padding: var(--space-3xl) var(--grid-margin);
}

.article-sidebar {
  position: sticky;
  top: var(--space-xl);
  align-self: start;
}

@media (max-width: 1024px) {
  .article-with-sidebar {
    grid-template-columns: 1fr;
  }
  .article-sidebar {
    position: static;
    border-top: 1px solid var(--color-border);
    padding-top: var(--space-xl);
  }
}
```

### 5. Product Page

**Structure:** Image gallery + Details + Related items grid

```css
/* Product page layout */
.product-layout {
  max-width: var(--container-xl);
  margin: 0 auto;
  padding: var(--space-xl) var(--grid-margin);
}

.product-main {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-2xl);
  margin-bottom: var(--space-3xl);
}

.product-gallery {
  display: grid;
  grid-template-columns: 80px 1fr;
  gap: var(--space-md);
}

.product-thumbnails {
  display: flex;
  flex-direction: column;
  gap: var(--space-sm);
}

.product-thumbnail {
  width: 80px;
  height: 80px;
  object-fit: cover;
  border-radius: var(--radius-md);
  border: 2px solid transparent;
  cursor: pointer;
}

.product-thumbnail[aria-selected="true"] {
  border-color: var(--color-primary);
}

.product-main-image {
  width: 100%;
  aspect-ratio: 1;
  object-fit: cover;
  border-radius: var(--radius-lg);
}

.product-details h1 {
  font-size: var(--font-size-3xl);
  margin-bottom: var(--space-md);
}

.product-price {
  font-size: var(--font-size-2xl);
  font-weight: var(--font-weight-bold);
  color: var(--color-primary);
  margin-bottom: var(--space-lg);
}

.product-related {
  border-top: 1px solid var(--color-border);
  padding-top: var(--space-2xl);
}

.product-related-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
  gap: var(--space-lg);
}

@media (max-width: 768px) {
  .product-main {
    grid-template-columns: 1fr;
  }
  .product-gallery {
    grid-template-columns: 1fr;
  }
  .product-thumbnails {
    flex-direction: row;
    overflow-x: auto;
  }
}
```

---

## Layout Principles

### Mobile-First Approach

All styles are written mobile-first using `min-width` breakpoints:

```css
/* Base: mobile (< 640px) */
.component { padding: var(--space-md); }

/* sm: >= 640px */
@media (min-width: 640px) {
  .component { padding: var(--space-lg); }
}

/* md: >= 768px */
@media (min-width: 768px) {
  .component { padding: var(--space-xl); }
}

/* lg: >= 1024px */
@media (min-width: 1024px) {
  .component { padding: var(--space-2xl); }
}

/* xl: >= 1280px */
@media (min-width: 1280px) {
  .component { padding: var(--space-3xl); }
}
```

### Content Width Constraints

```css
/* Prose content: optimized reading width */
.prose {
  max-width: 65ch;
  margin-inline: auto;
}

/* Constrained content within full-width sections */
.section-content {
  max-width: var(--container-lg);
  margin-inline: auto;
  padding-inline: var(--grid-margin);
}
```

### Vertical Rhythm (Spacing Tokens)

Consistent vertical spacing using the design token scale:

| Context            | Token             | Value  |
|--------------------|-------------------|--------|
| Between elements   | `--space-md`      | 1rem   |
| Between groups     | `--space-xl`      | 2rem   |
| Between sections   | `--space-3xl`     | 4rem   |
| Page top/bottom    | `--space-3xl`     | 4rem   |
| Card internal      | `--space-lg`      | 1.5rem |

```css
/* Section spacing */
.section {
  padding-block: var(--space-3xl);
}

.section + .section {
  border-top: 1px solid var(--color-border);
}

/* Stack pattern: consistent vertical spacing */
.stack > * + * {
  margin-top: var(--space-md);
}

.stack-lg > * + * {
  margin-top: var(--space-xl);
}
```

### Section Spacing Guidelines

- **Page header to first section:** `--space-2xl` (3rem)
- **Between major sections:** `--space-3xl` (4rem)
- **Section title to content:** `--space-xl` (2rem)
- **Between related elements:** `--space-md` (1rem)
- **Between unrelated elements:** `--space-lg` (1.5rem)
- **Footer top padding:** `--space-3xl` (4rem)

---

## Responsive Breakpoint Reference

```
Mobile:   0 - 639px    (base styles)
sm:       640px+       (small tablets, landscape phones)
md:       768px+       (tablets)
lg:       1024px+      (laptops, small desktops)
xl:       1280px+      (large desktops)
2xl:      1440px+      (wide monitors)
```

All breakpoints use `min-width` for mobile-first progressive enhancement.