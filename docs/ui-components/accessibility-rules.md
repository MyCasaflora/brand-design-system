# Accessibility Rules — WCAG 2.1 AA Compliance

This document defines the accessibility requirements for all components in the {{BRAND_NAME}} Design System. Every component, page, and interaction MUST meet WCAG 2.1 Level AA conformance.

---

## Contrast Requirements

| Element                         | Minimum Contrast Ratio |
|---------------------------------|------------------------|
| Normal text (< 18pt)            | 4.5:1                  |
| Large text (>= 18pt or 14pt bold) | 3:1                  |
| UI components & graphical objects | 3:1                  |
| Decorative elements             | None                   |
| Focus indicators                | 3:1 against adjacent colors |
| Placeholder text                | 4.5:1 (if conveying info) |
| Disabled elements               | No minimum (but must be visually distinct) |

### Implementation

```css
/* Ensure text tokens meet contrast on their background */
--color-text-primary:   /* must be >= 4.5:1 on --color-bg-surface */
--color-text-secondary: /* must be >= 4.5:1 on --color-bg-surface */
--color-text-muted:     /* use only for non-essential, decorative text */

/* Button contrast: text-inverse must be >= 4.5:1 on primary/secondary */
--color-text-inverse:   /* must be >= 4.5:1 on --color-primary */
```

### Verification Tools

- Chrome DevTools > Rendering > CSS Overview (contrast audit)
- axe DevTools browser extension
- WebAIM Contrast Checker (webaim.org/resources/contrastchecker)

---

## Keyboard Navigation

### Focus Visibility

All interactive elements MUST have a visible focus indicator:

```css
/* Global focus style */
:focus-visible {
  outline: none;
  box-shadow: 0 0 0 2px var(--color-bg-surface), 0 0 0 4px var(--color-primary);
}

/* Minimum requirements */
/* - Outline width: >= 2px                    */
/* - Outline contrast: >= 3:1 against adjacent colors */
/* - Must not be obscured by other elements    */
```

### Tab Order

- Tab order MUST follow logical reading order (match DOM order to visual order)
- Do NOT use positive `tabindex` values (only `0` or `-1`)
- All interactive elements must be reachable via Tab key
- Non-interactive elements must NOT be focusable

### Skip Links

The first focusable element on every page must be a skip link:

```html
<a href="#main-content" class="skip-link">Skip to main content</a>
```

### Focus Trapping in Modals

When a modal dialog is open:

1. Focus MUST be moved to the first focusable element inside the modal
2. Tab and Shift+Tab MUST cycle only within the modal
3. Pressing Escape MUST close the modal
4. Focus MUST return to the element that triggered the modal on close

```javascript
// Required modal behavior
// - On open:  trap focus within modal
// - On close: restore focus to trigger element
// - Escape:   close modal
// - Click outside: close modal (optional)
```

### Escape to Close

All overlay components must close on Escape key press:
- Modal dialogs
- Dropdown menus
- Popovers / Tooltips (if opened via click)
- Mobile navigation overlays
- Lightboxes

---

## Semantic HTML

### Landmark Regions

Every page MUST include these landmarks:

```html
<header role="banner">       <!-- Site header, once per page -->
<nav role="navigation">       <!-- Navigation, label if multiple -->
<main role="main">            <!-- Main content, once per page -->
<aside role="complementary">  <!-- Sidebar/related content -->
<footer role="contentinfo">   <!-- Site footer, once per page -->
```

- Multiple `<nav>` elements must each have a unique `aria-label`
- `<main>` must appear exactly once per page

### Heading Hierarchy

- Every page MUST have exactly one `<h1>`
- Headings must NOT skip levels (h1 -> h2 -> h3, never h1 -> h3)
- Headings must describe the content that follows
- Do not use headings solely for visual styling

### ARIA Labels

| Scenario | Required ARIA |
|----------|---------------|
| Icon-only buttons | `aria-label="descriptive text"` |
| Icon-only links | `aria-label="descriptive text"` |
| Complex widgets (tabs, accordions) | `role`, `aria-selected`, `aria-expanded` |
| Navigation regions | `aria-label="unique name"` |
| Form groups | `<fieldset>` + `<legend>` or `aria-labelledby` |
| Images with meaning | `alt="descriptive text"` |
| Decorative images | `alt=""` and `aria-hidden="true"` |

### Live Regions

Dynamic content updates must use ARIA live regions:

```html
<!-- Polite: read when user is idle (status messages, notifications) -->
<div role="status" aria-live="polite">3 results found</div>

<!-- Assertive: interrupt immediately (errors, urgent alerts) -->
<div role="alert" aria-live="assertive">Form submission failed</div>

<!-- Atomic: read entire region on change -->
<div aria-live="polite" aria-atomic="true">
  Cart total: $42.00 (3 items)
</div>
```

---

## Touch and Pointer

### Minimum Touch Target Size

All interactive elements MUST meet minimum size requirements:

| Element | Minimum Size |
|---------|-------------|
| Buttons, links, controls | 44 x 44 px |
| Dense UI (tables, lists) | 44 x 44 px (via padding) |
| Adjacent targets spacing | 8px minimum gap |

```css
/* Ensure all interactive elements meet target size */
button, a, input, select, textarea {
  min-height: 44px;
}

.btn {
  min-height: 44px;
  min-width: 44px;
}

/* Use padding to enlarge small visual elements */
.small-link {
  padding: var(--space-sm); /* expands touch target */
}
```

### No Hover-Only Interactions

- Every interaction available on hover MUST also be available via:
  - Focus (keyboard)
  - Click/tap (touch)
- Tooltip content must be accessible to screen readers via `aria-describedby`
- Dropdown menus must open on click, not just hover

---

## Color and Visual

### Color Must Not Be the Sole Indicator

Never use color alone to convey meaning. Always combine color with:

| Information | Color | Additional Indicator |
|-------------|-------|---------------------|
| Error state | Red | Icon + text message |
| Success state | Green | Icon + text message |
| Required field | (any) | Text "(required)" |
| Active/current link | Color change | Underline, bold, or border |
| Chart data series | Different colors | Patterns, labels, or shapes |

### Error States Must Include

1. Color change (e.g., red border)
2. Icon (e.g., warning triangle)
3. Descriptive text message
4. Linked via `aria-describedby` to the input

```html
<input
  type="email"
  aria-invalid="true"
  aria-describedby="email-error"
  class="form-input form-input-error"
>
<p id="email-error" class="form-error-msg" role="alert">
  Please enter a valid email address.
</p>
```

### Reduced Motion Support

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

### Color Scheme Support

```css
@media (prefers-color-scheme: dark) {
  :root {
    /* Override surface and text tokens for dark mode */
    --color-bg-page: var(--color-gray-900);
    --color-bg-surface: var(--color-gray-800);
    --color-text-primary: var(--color-gray-100);
    --color-text-secondary: var(--color-gray-300);
    --color-border: var(--color-gray-600);
  }
}
```

### All States Must Meet Contrast

Every interactive element state must independently meet contrast requirements:

- Default state: 4.5:1 (text), 3:1 (UI boundary)
- Hover state: 4.5:1
- Focus state: 3:1 (focus indicator)
- Active/pressed state: 4.5:1
- Disabled state: visually distinct, no contrast minimum

---

## Forms

### Visible Labels

- ALL inputs MUST have a visible `<label>` element
- Labels must be programmatically associated: `<label for="input-id">`
- Do NOT rely on placeholder text as a label
- Placeholder text is supplemental only

### Error Messages

- Error messages MUST be linked to their input via `aria-describedby`
- Inputs in error MUST have `aria-invalid="true"`
- Error messages should use `role="alert"` for immediate announcement
- Error text must describe how to fix the issue, not just state the problem

### Required Fields

- Required fields MUST be indicated with text, not just an asterisk or color
- Use `aria-required="true"` or the `required` HTML attribute
- Provide a label suffix like "(required)" rather than relying on `*` alone

```html
<label for="name" class="form-label form-label-required">
  Full Name
</label>
<!-- CSS adds " (required)" text after the label -->
```

### Autocomplete Attributes

Common fields MUST include the appropriate `autocomplete` attribute:

| Field           | Autocomplete Value |
|-----------------|-------------------|
| Full name       | `name`            |
| Email           | `email`           |
| Phone           | `tel`             |
| Street address  | `street-address`  |
| City            | `address-level2`  |
| State/Province  | `address-level1`  |
| Postal code     | `postal-code`     |
| Country         | `country-name`    |
| Credit card     | `cc-number`       |
| Expiry          | `cc-exp`          |
| Username        | `username`        |
| Current password | `current-password` |
| New password    | `new-password`    |

---

## Testing Checklist

Use this checklist before every release to verify accessibility compliance.

### Automated Testing

- [ ] Run axe DevTools on all pages (zero critical/serious violations)
- [ ] Run Lighthouse accessibility audit (score >= 95)
- [ ] Validate HTML with W3C validator (no errors)
- [ ] Check all color contrast ratios with automated tool

### Manual Testing

- [ ] **Screen reader navigation:** Test with VoiceOver (macOS) or NVDA (Windows)
  - [ ] All content is announced in logical order
  - [ ] All images have appropriate alt text
  - [ ] All form inputs announce their label and state
  - [ ] Dynamic updates are announced via live regions
  - [ ] Modal focus trapping works correctly

- [ ] **Keyboard-only navigation:**
  - [ ] All interactive elements are reachable via Tab
  - [ ] Focus order follows logical reading order
  - [ ] Focus indicator is always visible (2px min, 3:1 contrast)
  - [ ] Skip link works and is the first focusable element
  - [ ] Escape closes all overlays/modals
  - [ ] No keyboard traps (except intentional modal trapping)
  - [ ] Enter/Space activates buttons and links

- [ ] **Touch target audit:**
  - [ ] All interactive elements >= 44x44px
  - [ ] Adjacent targets have >= 8px spacing
  - [ ] No hover-only interactions on mobile

- [ ] **Color and contrast:**
  - [ ] No information conveyed by color alone
  - [ ] All error states have icon + text + color
  - [ ] Text contrast >= 4.5:1 (normal) / 3:1 (large)
  - [ ] UI component boundaries >= 3:1

- [ ] **Focus order verification:**
  - [ ] Tab through entire page; order matches visual layout
  - [ ] No unexpected focus jumps
  - [ ] Focus returns correctly after closing modals/menus

- [ ] **Zoom to 200% test:**
  - [ ] Page is usable at 200% browser zoom
  - [ ] No content is cut off or overlapping
  - [ ] No horizontal scrolling required at 320px viewport width
  - [ ] Text reflows properly

- [ ] **High contrast mode test:**
  - [ ] Test with Windows High Contrast Mode
  - [ ] All interactive boundaries remain visible
  - [ ] Focus indicators remain visible
  - [ ] Icons and graphics remain distinguishable

- [ ] **Reduced motion test:**
  - [ ] Enable prefers-reduced-motion in OS settings
  - [ ] All animations are removed or reduced to near-instant
  - [ ] No content is lost when animations are disabled

---

## Quick Reference: Common ARIA Patterns

### Tabs

```html
<div role="tablist" aria-label="Settings">
  <button role="tab" aria-selected="true" aria-controls="panel-1" id="tab-1">General</button>
  <button role="tab" aria-selected="false" aria-controls="panel-2" id="tab-2" tabindex="-1">Security</button>
</div>
<div role="tabpanel" id="panel-1" aria-labelledby="tab-1">...</div>
<div role="tabpanel" id="panel-2" aria-labelledby="tab-2" hidden>...</div>
```

### Accordion

```html
<h3>
  <button aria-expanded="true" aria-controls="section-1">Section Title</button>
</h3>
<div id="section-1" role="region" aria-labelledby="...">
  Content here
</div>
```

### Dialog / Modal

```html
<div role="dialog" aria-modal="true" aria-labelledby="dialog-title">
  <h2 id="dialog-title">Dialog Heading</h2>
  <div>Content</div>
  <button>Close</button>
</div>
```

### Alert

```html
<div role="alert">
  <strong>Error:</strong> Your session has expired. Please log in again.
</div>
```