#!/usr/bin/env bash
# handoff-package.sh — Frontend-Handoff ZIP erstellen
# Usage: bash handoff-package.sh --brand-slug=acme-corp --profile=developer --output-dir=.output
#
# Profiles:
#   developer  — CSS + JSON Tokens + HTML + README (Default)
#   designer   — PDF + Figma Tokens + Styleguide Summary
#   marketing  — PDF + Social Media Specs

# Parse args
BRAND_SLUG=""
PROFILE="developer"
OUTPUT_DIR=".output"

for arg in "$@"; do
  case $arg in
    --brand-slug=*) BRAND_SLUG="${arg#*=}" ;;
    --profile=*)    PROFILE="${arg#*=}" ;;
    --output-dir=*) OUTPUT_DIR="${arg#*=}" ;;
  esac
done

if [[ -z "$BRAND_SLUG" ]]; then
  echo "ERROR: --brand-slug is required"
  echo "Usage: bash handoff-package.sh --brand-slug=acme-corp [--profile=developer|designer|marketing]"
  exit 1
fi

BRAND_DIR="$OUTPUT_DIR/$BRAND_SLUG"
EXPORT_DIR="$BRAND_DIR/export"
HANDOFF_DIR="$EXPORT_DIR/handoff-tmp"
ZIP_OUTPUT="$EXPORT_DIR/handoff-package.zip"

if [[ ! -d "$BRAND_DIR" ]]; then
  echo "ERROR: Brand output dir not found: $BRAND_DIR"
  exit 1
fi

mkdir -p "$HANDOFF_DIR" "$EXPORT_DIR"

echo "Creating handoff package: profile=$PROFILE, brand=$BRAND_SLUG"

# --- Generate README for developer profile ---
generate_readme() {
  local brand_name
  brand_name=$(node -e "
    const s=require('$BRAND_DIR/state.json');
    console.log(s.brand_name||'$BRAND_SLUG');
  " 2>/dev/null || echo "$BRAND_SLUG")

  cat > "$HANDOFF_DIR/README.md" <<READMEEOF
# Brand Design System — $brand_name

## Quick Start

\`\`\`html
<!-- Include tokens in your HTML -->
<link rel="stylesheet" href="design-tokens.css">
\`\`\`

\`\`\`js
// Or import JSON tokens
import tokens from './design-tokens.json';
\`\`\`

## Token Reference

### Colors
\`\`\`css
var(--color-primary)    /* 10% — CTAs, Links, Highlights */
var(--color-secondary)  /* 30% — Supporting elements */
var(--color-accent)     /* Komplementär — Badges, Icons */
var(--color-bg)         /* 60% — Page background */
var(--color-surface)    /* Cards, Panels, Modals */
var(--color-text)       /* Primary text */
var(--color-text-muted) /* Secondary text, captions */
var(--color-border)     /* Borders, dividers */
\`\`\`

### Typography
\`\`\`css
var(--font-heading)  /* Headings H1–H3 */
var(--font-body)     /* Body text, UI elements */

/* Type scale */
var(--text-xs)  /* 12px */ var(--text-sm)  /* 14px */
var(--text-base)/* 16px */ var(--text-lg)  /* 20px */
var(--text-xl)  /* 25px */ var(--text-2xl) /* 31px */
var(--text-3xl) /* 39px */ var(--text-4xl) /* 49px */
var(--text-5xl) /* 61px */
\`\`\`

### Spacing (8px Grid)
\`\`\`css
var(--space-xs) /* 8px */  var(--space-sm)  /* 16px */
var(--space-md) /* 24px */ var(--space-lg)  /* 32px */
var(--space-xl) /* 48px */ var(--space-2xl) /* 64px */
var(--space-3xl)/* 96px */ var(--space-4xl) /* 128px */
\`\`\`

### Radii & Shadows
\`\`\`css
var(--radius-sm) /* 4px */  var(--radius-md) /* 8px */  var(--radius-lg) /* 16px */
var(--shadow-sm) var(--shadow-md) var(--shadow-lg)
\`\`\`

## Usage Example
\`\`\`css
.button-primary {
  background: var(--color-primary);
  color: var(--color-bg);
  padding: var(--space-sm) var(--space-md);
  border-radius: var(--radius-md);
  font-family: var(--font-body);
  font-size: var(--text-base);
  box-shadow: var(--shadow-sm);
}
\`\`\`

## Files Included
- design-tokens.css — CSS Custom Properties
- design-tokens.json — JSON format (for JS/build tools)
- brand-guidelines.html — Full visual brand guidelines
- components.html — UI component library (if available)
- dark-mode.css — Dark mode overrides (if available)
READMEEOF
}

# --- Profile: developer ---
if [[ "$PROFILE" == "developer" ]]; then
  FILES=()
  [[ -f "$BRAND_DIR/design-tokens.css" ]]    && FILES+=("$BRAND_DIR/design-tokens.css")
  [[ -f "$BRAND_DIR/design-tokens.json" ]]   && FILES+=("$BRAND_DIR/design-tokens.json")
  [[ -f "$BRAND_DIR/brand-guidelines.html" ]] && FILES+=("$BRAND_DIR/brand-guidelines.html")
  [[ -f "$BRAND_DIR/components.html" ]]       && FILES+=("$BRAND_DIR/components.html")
  [[ -f "$BRAND_DIR/dark-mode.css" ]]         && FILES+=("$BRAND_DIR/dark-mode.css")
  generate_readme
  FILES+=("$HANDOFF_DIR/README.md")
  echo "  Developer package: ${#FILES[@]} files"
fi

# --- Profile: designer ---
if [[ "$PROFILE" == "designer" ]]; then
  FILES=()
  [[ -f "$EXPORT_DIR/brand-guidelines.pdf" ]]    && FILES+=("$EXPORT_DIR/brand-guidelines.pdf")
  [[ -f "$BRAND_DIR/brand-guidelines.html" ]]    && FILES+=("$BRAND_DIR/brand-guidelines.html")
  [[ -f "$EXPORT_DIR/figma-tokens.json" ]]       && FILES+=("$EXPORT_DIR/figma-tokens.json")

  # Generate Styleguide Summary
  cat > "$HANDOFF_DIR/Styleguide-Summary.md" <<SUMMARYEOF
# Styleguide Summary — $BRAND_SLUG

## Colors
See brand-guidelines.html or brand-guidelines.pdf for full color system.

## Figma Integration
Import figma-tokens.json via Figma Tokens Plugin:
1. Install "Figma Tokens" plugin
2. Open plugin → Import → Select figma-tokens.json
3. Apply to document

## Assets
Logo and mockup files in assets/ folder (if available).
SUMMARYEOF
  FILES+=("$HANDOFF_DIR/Styleguide-Summary.md")

  # Copy assets if they exist
  if [[ -d "$BRAND_DIR/assets" ]]; then
    cp -r "$BRAND_DIR/assets" "$HANDOFF_DIR/"
  fi
  echo "  Designer package: ${#FILES[@]} files"
fi

# --- Profile: marketing ---
if [[ "$PROFILE" == "marketing" ]]; then
  FILES=()
  [[ -f "$EXPORT_DIR/brand-guidelines.pdf" ]] && FILES+=("$EXPORT_DIR/brand-guidelines.pdf")
  [[ -f "$BRAND_DIR/brand-guidelines.html" ]] && FILES+=("$BRAND_DIR/brand-guidelines.html")

  # Generate Social Media Specs
  cat > "$HANDOFF_DIR/Social-Media-Specs.md" <<SOCIALEOF
# Social Media Specs — $BRAND_SLUG

## Format Sizes

### Instagram
- Post (Square): 1080 × 1080px
- Post (Portrait): 1080 × 1350px
- Story: 1080 × 1920px
- Reels Cover: 1080 × 1920px

### LinkedIn
- Profile Banner: 1584 × 396px
- Post Image: 1200 × 628px
- Company Logo: 300 × 300px

### Twitter / X
- Header Image: 1500 × 500px
- Post Image: 1200 × 675px
- Profile Photo: 400 × 400px

### Facebook
- Cover Photo: 820 × 312px
- Post Image: 1200 × 630px
- Event Cover: 1920 × 1080px

## Brand Colors
See brand-guidelines.pdf for exact color values.

## Typography
See brand-guidelines.pdf for font specifications.

## Assets
Logo files in assets/ folder (if available).
SOCIALEOF
  FILES+=("$HANDOFF_DIR/Social-Media-Specs.md")

  if [[ -d "$BRAND_DIR/assets" ]]; then
    cp -r "$BRAND_DIR/assets" "$HANDOFF_DIR/"
  fi
  echo "  Marketing package: ${#FILES[@]} files"
fi

# --- Copy files to handoff dir ---
for f in "${FILES[@]}"; do
  if [[ -f "$f" ]]; then
    cp "$f" "$HANDOFF_DIR/" 2>/dev/null
  fi
done

# --- Create ZIP ---
if command -v zip &>/dev/null; then
  cd "$EXPORT_DIR" || exit 1
  zip -r "handoff-package.zip" "handoff-tmp/" -x "*.DS_Store" 2>/dev/null
  cd - >/dev/null
  rm -rf "$HANDOFF_DIR"
  echo "  ✓ ZIP created: $ZIP_OUTPUT"
else
  # No zip available — keep folder
  echo "  ⚠️  zip not found — package created as folder: $HANDOFF_DIR"
  echo "  Install zip: brew install zip (macOS) or apt install zip (Linux)"
  ZIP_OUTPUT="$HANDOFF_DIR (folder)"
fi

echo ""
echo "✓ Handoff package ($PROFILE): $ZIP_OUTPUT"
