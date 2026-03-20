# accessibility-rules.md

**Owner: designer**
**Status: FINAL** — Generated from designer deliverables

---

## Contrast Requirements

| Element                           | Minimum Contrast Ratio              |
|-----------------------------------|-------------------------------------|
| Normal text (< 18pt)              | 4.5:1                               |
| Large text (>= 18pt or 14pt bold) | 3:1                                 |
| UI components & graphical objects | 3:1                                 |
| Focus indicators                  | 3:1 against adjacent colors         |
| Placeholder text (if informative) | 4.5:1                               |
| Decorative elements               | None                                |
| Disabled elements                 | No minimum (must be visually distinct) |

### Token Contrast Rules
- `--color-text-primary` on `--color-bg-surface` — must be >= 4.5:1
- `--color-text-secondary` on `--color-bg-surface` — must be >= 4.5:1
- `--color-text-inverse` on `--color-primary` — must be >= 4.5:1
- Every interactive state (hover, focus, active) must independently meet contrast

---

## Keyboard Navigation

### Focus Visibility
```css
:focus-visible {
  outline: none;
  box-shadow: 0 0 0 2px var(--color-bg-surface), 0 0 0 4px var(--color-primary);
}
/* Minimum: 2px width, 3:1 contrast, never obscured */
```

### Tab Order Rules
- Tab order MUST follow logical reading order (match DOM to visual order)
- Only use `tabindex="0"` or `tabindex="-1"` — never positive values
- All interactive elements reachable via Tab; non-interactive elements NOT focusable

### Skip Links
First focusable element on every page:
```html
<a href="#main-content" class="skip-link">Skip to main content</a>
```

### Modal Focus Trapping
1. Move focus to first focusable element inside modal on open
2. Tab/Shift+Tab cycles only within modal
3. Escape closes modal
4. Focus returns to trigger element on close

### Escape to Close
All overlay components must close on Escape:
- Modal dialogs, dropdown menus, popovers, tooltips (click-opened), mobile nav overlays, lightboxes

---

## Semantic HTML

### Required Landmark Regions
```html
<header role="banner">        <!-- Once per page -->
<nav role="navigation">        <!-- aria-label if multiple -->
<main role="main">             <!-- Exactly once per page -->
<aside role="complementary">   <!-- Sidebar/related -->
<footer role="contentinfo">    <!-- Once per page -->
```

### Heading Hierarchy
- Exactly one `<h1>` per page
- Never skip levels (h1 -> h2 -> h3, not h1 -> h3)
- Headings describe content, not used for visual styling alone

### ARIA Labels Quick Reference

| Scenario                     | Required ARIA                                    |
|------------------------------|--------------------------------------------------|
| Icon-only buttons/links      | `aria-label="descriptive text"`                  |
| Complex widgets (tabs, etc.) | `role`, `aria-selected`, `aria-expanded`          |
| Navigation regions           | `aria-label="unique name"`                        |
| Form groups                  | `<fieldset>` + `<legend>` or `aria-labelledby`    |
| Meaningful images            | `alt="descriptive text"`                          |
| Decorative images            | `alt=""` and `aria-hidden="true"`                 |

### Live Regions
```html
<div role="status" aria-live="polite">3 results found</div>      <!-- Status -->
<div role="alert" aria-live="assertive">Form failed</div>        <!-- Errors -->
<div aria-live="polite" aria-atomic="true">Cart: $42 (3)</div>   <!-- Atomic -->
```

---

## Touch Targets

| Element                    | Minimum Size    |
|----------------------------|-----------------|
| Buttons, links, controls   | 44 x 44 px      |
| Dense UI (tables, lists)   | 44 x 44 px (via padding) |
| Adjacent target spacing    | 8px minimum gap |

### No Hover-Only Interactions
- Every hover interaction must also work via focus (keyboard) and click/tap (touch)
- Tooltip content accessible via `aria-describedby`
- Dropdowns open on click, not just hover

---

## Color and Visual Rules

### Color Must Not Be Sole Indicator

| Information        | Required Additional Indicator |
|--------------------|-------------------------------|
| Error state        | Icon + text message           |
| Success state      | Icon + text message           |
| Required field     | Text "(required)"             |
| Active/current link| Underline, bold, or border    |
| Chart data series  | Patterns, labels, or shapes   |

### Error States Must Include
1. Color change (e.g., red border)
2. Icon (e.g., warning triangle)
3. Descriptive text message
4. `aria-describedby` linking error to input + `aria-invalid="true"`

### Reduced Motion
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

---

## Forms

- ALL inputs MUST have a visible `<label>` with `for="input-id"`
- Never rely on placeholder as label
- Error messages linked via `aria-describedby`, input has `aria-invalid="true"`
- Required fields: use text "(required)", not just `*` or color
- Common fields must include `autocomplete` attribute (name, email, tel, etc.)

---

## Testing Checklist

### Automated
- [ ] axe DevTools: zero critical/serious violations
- [ ] Lighthouse accessibility: score >= 95
- [ ] W3C HTML validator: no errors
- [ ] Contrast ratio check with automated tool

### Screen Reader (VoiceOver / NVDA)
- [ ] Content announced in logical order
- [ ] All images have appropriate alt text
- [ ] Form inputs announce label and state
- [ ] Dynamic updates announced via live regions
- [ ] Modal focus trapping works

### Keyboard-Only
- [ ] All interactive elements reachable via Tab
- [ ] Focus order matches reading order
- [ ] Focus indicator visible (2px min, 3:1 contrast)
- [ ] Skip link is first focusable element
- [ ] Escape closes all overlays/modals
- [ ] No keyboard traps (except intentional modal trapping)

### Touch Targets
- [ ] All interactive elements >= 44x44px
- [ ] Adjacent targets >= 8px spacing
- [ ] No hover-only interactions on mobile

### Visual
- [ ] No information conveyed by color alone
- [ ] Error states have icon + text + color
- [ ] Text contrast >= 4.5:1 (normal) / 3:1 (large)
- [ ] UI component boundaries >= 3:1

### Zoom and Motion
- [ ] Page usable at 200% zoom, no horizontal scroll at 320px
- [ ] Reduced motion: all animations removed or near-instant
- [ ] High contrast mode: boundaries and focus indicators visible
