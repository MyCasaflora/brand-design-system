#!/usr/bin/env node
/**
 * token-generator.js — Design Token Generator für brand-design-system
 *
 * Usage:
 *   node token-generator.js --primary="#2563EB" --brand="Acme Corp" --industry="SaaS"
 *   node token-generator.js --input=brand-strategy-brief.json --output=.output/acme-corp/
 *
 * Output:
 *   design-tokens.css  — CSS Custom Properties (:root block)
 *   design-tokens.json — JSON Token-Format (value + rationale)
 */

const fs = require('fs');
const path = require('path');

// --- CLI Args Parsing ---
const args = process.argv.slice(2).reduce((acc, arg) => {
  const [key, val] = arg.replace('--', '').split('=');
  acc[key] = val;
  return acc;
}, {});

const PRIMARY_COLOR = args.primary || '#2563EB';
const BRAND_NAME = args.brand || 'Brand';
const INDUSTRY = args.industry || 'Technology';
const OUTPUT_DIR = args.output || '.';
const INPUT_BRIEF = args.input || null;

// --- Color Utilities ---

function hexToRgb(hex) {
  const clean = hex.replace('#', '');
  return {
    r: parseInt(clean.substring(0, 2), 16),
    g: parseInt(clean.substring(2, 4), 16),
    b: parseInt(clean.substring(4, 6), 16)
  };
}

function rgbToHex(r, g, b) {
  return '#' + [r, g, b].map(v => {
    const hex = Math.max(0, Math.min(255, Math.round(v))).toString(16);
    return hex.length === 1 ? '0' + hex : hex;
  }).join('').toUpperCase();
}

function rgbToHsl(r, g, b) {
  r /= 255; g /= 255; b /= 255;
  const max = Math.max(r, g, b), min = Math.min(r, g, b);
  let h, s;
  const l = (max + min) / 2;
  if (max === min) {
    h = s = 0;
  } else {
    const d = max - min;
    s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
    switch (max) {
      case r: h = ((g - b) / d + (g < b ? 6 : 0)) / 6; break;
      case g: h = ((b - r) / d + 2) / 6; break;
      case b: h = ((r - g) / d + 4) / 6; break;
    }
  }
  return { h: h * 360, s: s * 100, l: l * 100 };
}

function hslToRgb(h, s, l) {
  h /= 360; s /= 100; l /= 100;
  let r, g, b;
  if (s === 0) {
    r = g = b = l;
  } else {
    const hue2rgb = (p, q, t) => {
      if (t < 0) t += 1;
      if (t > 1) t -= 1;
      if (t < 1/6) return p + (q - p) * 6 * t;
      if (t < 1/2) return q;
      if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
      return p;
    };
    const q = l < 0.5 ? l * (1 + s) : l + s - l * s;
    const p = 2 * l - q;
    r = hue2rgb(p, q, h + 1/3);
    g = hue2rgb(p, q, h);
    b = hue2rgb(p, q, h - 1/3);
  }
  return { r: r * 255, g: g * 255, b: b * 255 };
}

function luminance(r, g, b) {
  const [rs, gs, bs] = [r, g, b].map(v => {
    v /= 255;
    return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4);
  });
  return 0.2126 * rs + 0.7152 * gs + 0.0722 * bs;
}

function contrastRatio(hex1, hex2) {
  const { r: r1, g: g1, b: b1 } = hexToRgb(hex1);
  const { r: r2, g: g2, b: b2 } = hexToRgb(hex2);
  const l1 = luminance(r1, g1, b1);
  const l2 = luminance(r2, g2, b2);
  const lighter = Math.max(l1, l2);
  const darker = Math.min(l1, l2);
  return (lighter + 0.05) / (darker + 0.05);
}

// --- Palette Generation (60-30-10 Rule) ---

function generatePalette(primaryHex, industry) {
  const { r, g, b } = hexToRgb(primaryHex);
  const { h, s, l } = rgbToHsl(r, g, b);

  // Secondary: analogous, lower saturation
  const secondaryHsl = { h: (h + 30) % 360, s: s * 0.6, l: Math.min(l + 10, 80) };
  const secondaryRgb = hslToRgb(secondaryHsl.h, secondaryHsl.s, secondaryHsl.l);
  const secondary = rgbToHex(secondaryRgb.r, secondaryRgb.g, secondaryRgb.b);

  // Accent: complementary, vibrant
  const accentHsl = { h: (h + 180) % 360, s: Math.min(s * 1.1, 100), l: Math.max(l - 5, 40) };
  const accentRgb = hslToRgb(accentHsl.h, accentHsl.s, accentHsl.l);
  const accent = rgbToHex(accentRgb.r, accentRgb.g, accentRgb.b);

  // Background: near-white, very low saturation from primary hue
  const bgHsl = { h, s: Math.min(s * 0.08, 8), l: 98 };
  const bgRgb = hslToRgb(bgHsl.h, bgHsl.s, bgHsl.l);
  const bg = rgbToHex(bgRgb.r, bgRgb.g, bgRgb.b);

  // Surface: slightly darker than bg
  const surfaceHsl = { h, s: Math.min(s * 0.06, 6), l: 96 };
  const surfaceRgb = hslToRgb(surfaceHsl.h, surfaceHsl.s, surfaceHsl.l);
  const surface = rgbToHex(surfaceRgb.r, surfaceRgb.g, surfaceRgb.b);

  // Text: near-black
  const text = l > 50 ? '#1A1A2E' : '#0F0F1A';

  // Text-muted: mid-gray
  const textMuted = '#64748B';

  // Border: light gray
  const border = '#E2E8F0';

  // WCAG AA check — text on bg
  const ratio = contrastRatio(text, bg);
  const wcagPass = ratio >= 4.5;

  return {
    primary: primaryHex.toUpperCase(),
    secondary,
    accent,
    bg,
    surface,
    text,
    textMuted,
    border,
    wcagRatio: ratio.toFixed(2),
    wcagPass
  };
}

// --- Font Pairing by Industry ---
const FONT_PAIRINGS = {
  'SaaS':        { heading: 'Inter', body: 'Inter' },
  'Fintech':     { heading: 'DM Sans', body: 'DM Sans' },
  'Healthcare':  { heading: 'Plus Jakarta Sans', body: 'Plus Jakarta Sans' },
  'E-Commerce':  { heading: 'Sora', body: 'DM Sans' },
  'Luxury':      { heading: 'Cormorant Garamond', body: 'Jost' },
  'Technology':  { heading: 'Space Grotesk', body: 'Inter' },
  'Creative':    { heading: 'Playfair Display', body: 'Lato' },
  'default':     { heading: 'Inter', body: 'Inter' }
};

function getFontPairing(industry) {
  const key = Object.keys(FONT_PAIRINGS).find(k =>
    industry.toLowerCase().includes(k.toLowerCase())
  ) || 'default';
  return FONT_PAIRINGS[key];
}

// --- Main Token Generation ---

function generateTokens(primaryHex, brandName, industry) {
  const palette = generatePalette(primaryHex, industry);
  const fonts = getFontPairing(industry);
  const slug = brandName.toLowerCase().replace(/[^a-z0-9]+/g, '-');

  const tokens = {
    meta: {
      brand: brandName,
      slug,
      industry,
      generated: new Date().toISOString(),
      wcag_aa: palette.wcagPass,
      contrast_ratio: palette.wcagRatio
    },
    colors: {
      primary:    { value: palette.primary,    rationale: '10% rule — Akzent, CTAs, Links' },
      secondary:  { value: palette.secondary,  rationale: '30% rule — Supporting elements' },
      accent:     { value: palette.accent,     rationale: 'Komplementär — Highlights, Badges' },
      bg:         { value: palette.bg,         rationale: '60% rule — Haupt-Hintergrund' },
      surface:    { value: palette.surface,    rationale: 'Cards, Panels, Overlays' },
      text:       { value: palette.text,       rationale: `Primärer Text (${palette.wcagRatio}:1 Kontrast)` },
      textMuted:  { value: palette.textMuted,  rationale: 'Sekundärer Text, Captions' },
      border:     { value: palette.border,     rationale: 'Borders, Divider, Input-Umrandungen' }
    },
    typography: {
      fontHeading: { value: fonts.heading, rationale: `Gewählt für ${industry}-Branche` },
      fontBody:    { value: fonts.body,    rationale: 'Lesbarkeit bei Fließtext' },
      scale: {
        xs:   { value: '0.75rem',  px: '12px' },
        sm:   { value: '0.875rem', px: '14px' },
        base: { value: '1rem',     px: '16px' },
        lg:   { value: '1.25rem',  px: '20px' },
        xl:   { value: '1.563rem', px: '25px' },
        '2xl':{ value: '1.953rem', px: '31px' },
        '3xl':{ value: '2.441rem', px: '39px' },
        '4xl':{ value: '3.052rem', px: '49px' },
        '5xl':{ value: '3.815rem', px: '61px' }
      }
    },
    spacing: {
      xs:  { value: '0.5rem',  px: '8px',  rationale: '8px Grid' },
      sm:  { value: '1rem',    px: '16px', rationale: '8px Grid' },
      md:  { value: '1.5rem',  px: '24px', rationale: '8px Grid' },
      lg:  { value: '2rem',    px: '32px', rationale: '8px Grid' },
      xl:  { value: '3rem',    px: '48px', rationale: '8px Grid' },
      '2xl':{ value: '4rem',   px: '64px', rationale: '8px Grid' },
      '3xl':{ value: '6rem',   px: '96px', rationale: '8px Grid' },
      '4xl':{ value: '8rem',   px: '128px',rationale: '8px Grid' }
    },
    radii: {
      sm: { value: '4px' },
      md: { value: '8px' },
      lg: { value: '16px' }
    },
    shadows: {
      sm: { value: '0 1px 3px rgba(0,0,0,0.12)' },
      md: { value: '0 4px 12px rgba(0,0,0,0.15)' },
      lg: { value: '0 8px 32px rgba(0,0,0,0.18)' }
    }
  };

  return tokens;
}

function tokensToCss(tokens) {
  const c = tokens.colors;
  const t = tokens.typography;
  const s = tokens.spacing;
  const r = tokens.radii;
  const sh = tokens.shadows;

  return `/* =================================================
   Design Tokens — ${tokens.meta.brand}
   Generated: ${tokens.meta.generated}
   WCAG AA: ${tokens.meta.wcag_aa ? 'PASS' : 'FAIL'} (${tokens.meta.contrast_ratio}:1)
   ================================================= */

@import url('https://fonts.googleapis.com/css2?family=${t.fontHeading.value.replace(/ /g, '+')}:wght@400;500;600;700&family=${t.fontBody.value.replace(/ /g, '+')}:wght@400;500&display=swap');

:root {
  /* Colors — 60-30-10 Rule */
  --color-primary:    ${c.primary.value};
  --color-secondary:  ${c.secondary.value};
  --color-accent:     ${c.accent.value};
  --color-bg:         ${c.bg.value};
  --color-surface:    ${c.surface.value};
  --color-text:       ${c.text.value};
  --color-text-muted: ${c.textMuted.value};
  --color-border:     ${c.border.value};

  /* Typography */
  --font-heading: '${t.fontHeading.value}', sans-serif;
  --font-body:    '${t.fontBody.value}', sans-serif;

  /* Type Scale (modular 1.25) */
  --text-xs:   ${t.scale.xs.value};   /* ${t.scale.xs.px} */
  --text-sm:   ${t.scale.sm.value};   /* ${t.scale.sm.px} */
  --text-base: ${t.scale.base.value}; /* ${t.scale.base.px} */
  --text-lg:   ${t.scale.lg.value};   /* ${t.scale.lg.px} */
  --text-xl:   ${t.scale.xl.value};   /* ${t.scale.xl.px} */
  --text-2xl:  ${t.scale['2xl'].value}; /* ${t.scale['2xl'].px} */
  --text-3xl:  ${t.scale['3xl'].value}; /* ${t.scale['3xl'].px} */
  --text-4xl:  ${t.scale['4xl'].value}; /* ${t.scale['4xl'].px} */
  --text-5xl:  ${t.scale['5xl'].value}; /* ${t.scale['5xl'].px} */

  /* Spacing (8px Grid) */
  --space-xs:  ${s.xs.value};   /* ${s.xs.px} */
  --space-sm:  ${s.sm.value};   /* ${s.sm.px} */
  --space-md:  ${s.md.value};   /* ${s.md.px} */
  --space-lg:  ${s.lg.value};   /* ${s.lg.px} */
  --space-xl:  ${s.xl.value};   /* ${s.xl.px} */
  --space-2xl: ${s['2xl'].value}; /* ${s['2xl'].px} */
  --space-3xl: ${s['3xl'].value}; /* ${s['3xl'].px} */
  --space-4xl: ${s['4xl'].value}; /* ${s['4xl'].px} */

  /* Radii */
  --radius-sm: ${r.sm.value};
  --radius-md: ${r.md.value};
  --radius-lg: ${r.lg.value};

  /* Shadows */
  --shadow-sm: ${sh.sm.value};
  --shadow-md: ${sh.md.value};
  --shadow-lg: ${sh.lg.value};
}
`;
}

// --- Main Execution ---

let primaryHex = PRIMARY_COLOR;
let brandName = BRAND_NAME;
let industry = INDUSTRY;

// Load from brief if provided
if (INPUT_BRIEF && fs.existsSync(INPUT_BRIEF)) {
  try {
    const brief = JSON.parse(fs.readFileSync(INPUT_BRIEF, 'utf8'));
    if (brief.brand_name) brandName = brief.brand_name;
    if (brief.industry) industry = brief.industry;
    if (brief.color_direction) primaryHex = brief.color_direction.split(',')[0].trim();
  } catch (e) {
    console.warn('Warning: Could not parse brief JSON:', e.message);
  }
}

const tokens = generateTokens(primaryHex, brandName, industry);
const css = tokensToCss(tokens);

// Ensure output dir
if (!fs.existsSync(OUTPUT_DIR)) {
  fs.mkdirSync(OUTPUT_DIR, { recursive: true });
}

const cssPath = path.join(OUTPUT_DIR, 'design-tokens.css');
const jsonPath = path.join(OUTPUT_DIR, 'design-tokens.json');

fs.writeFileSync(cssPath, css, 'utf8');
fs.writeFileSync(jsonPath, JSON.stringify(tokens, null, 2), 'utf8');

console.log(`✓ design-tokens.css → ${cssPath}`);
console.log(`✓ design-tokens.json → ${jsonPath}`);
console.log(`  WCAG AA: ${tokens.meta.wcag_aa ? 'PASS' : 'FAIL'} (${tokens.meta.contrast_ratio}:1)`);
console.log(`  Primary: ${tokens.colors.primary.value}`);
console.log(`  Fonts: ${tokens.typography.fontHeading.value} / ${tokens.typography.fontBody.value}`);
