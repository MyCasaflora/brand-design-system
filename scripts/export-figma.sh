#!/usr/bin/env bash
# export-figma.sh — Design Tokens → Figma Variables Format
# Usage: bash export-figma.sh <design-tokens.json> <output-figma-tokens.json>
#
# NOTE: Actual Figma MCP push is orchestrated by brand-export SKILL.md
# This script handles the JSON conversion (design-tokens.json → figma format)

INPUT_JSON="${1:-design-tokens.json}"
OUTPUT_JSON="${2:-figma-tokens.json}"

if [[ ! -f "$INPUT_JSON" ]]; then
  echo "ERROR: Input not found: $INPUT_JSON"
  exit 1
fi

echo "Converting: $INPUT_JSON → $OUTPUT_JSON (Figma Variables Format)"

node -e "
const fs = require('fs');
const tokens = JSON.parse(fs.readFileSync('$INPUT_JSON', 'utf8'));
const c = tokens.colors;
const t = tokens.typography;
const s = tokens.spacing;
const r = tokens.radii;

// Dark mode color derivation (consistent with dark-mode.css / extended-tokens.md)
const DARK = {
  bg:        { r: 0.059, g: 0.090, b: 0.161, a: 1 }, // #0F172A Slate 900
  surface:   { r: 0.118, g: 0.161, b: 0.239, a: 1 }, // #1E293B Slate 800
  text:      { r: 0.945, g: 0.961, b: 0.976, a: 1 }, // #F1F5F9 Slate 100
  textMuted: { r: 0.580, g: 0.639, b: 0.722, a: 1 }, // #94A3B8 Slate 400
  border:    { r: 0.200, g: 0.255, b: 0.333, a: 1 }, // #334155 Slate 700
};

// Figma Variables Format (Local Variables API compatible, Light + Dark modes)
const figma = {
  version: '1.0',
  meta: {
    brand: tokens.meta.brand,
    generated: new Date().toISOString()
  },
  collections: [
    {
      name: 'Brand Tokens',
      modes: ['Light', 'Dark'],
      variables: [
        // Colors — both Light and Dark modes
        { name: 'color/primary',    type: 'COLOR', values: { Light: hexToRgba(c.primary.value),    Dark: hexToRgba(c.primary.value) } },
        { name: 'color/secondary',  type: 'COLOR', values: { Light: hexToRgba(c.secondary.value),  Dark: hexToRgba(c.secondary.value) } },
        { name: 'color/accent',     type: 'COLOR', values: { Light: hexToRgba(c.accent.value),     Dark: hexToRgba(c.accent.value) } },
        { name: 'color/bg',         type: 'COLOR', values: { Light: hexToRgba(c.bg.value),         Dark: DARK.bg } },
        { name: 'color/surface',    type: 'COLOR', values: { Light: hexToRgba(c.surface.value),    Dark: DARK.surface } },
        { name: 'color/text',       type: 'COLOR', values: { Light: hexToRgba(c.text.value),       Dark: DARK.text } },
        { name: 'color/text-muted', type: 'COLOR', values: { Light: hexToRgba(c.textMuted.value),  Dark: DARK.textMuted } },
        { name: 'color/border',     type: 'COLOR', values: { Light: hexToRgba(c.border.value),     Dark: DARK.border } },
        // Typography (mode-agnostic)
        { name: 'font/heading', type: 'STRING', values: { Light: t.fontHeading.value, Dark: t.fontHeading.value } },
        { name: 'font/body',    type: 'STRING', values: { Light: t.fontBody.value,    Dark: t.fontBody.value } },
        // Spacing (mode-agnostic)
        { name: 'space/xs',  type: 'FLOAT', values: { Light: 8,   Dark: 8 } },
        { name: 'space/sm',  type: 'FLOAT', values: { Light: 16,  Dark: 16 } },
        { name: 'space/md',  type: 'FLOAT', values: { Light: 24,  Dark: 24 } },
        { name: 'space/lg',  type: 'FLOAT', values: { Light: 32,  Dark: 32 } },
        { name: 'space/xl',  type: 'FLOAT', values: { Light: 48,  Dark: 48 } },
        { name: 'space/2xl', type: 'FLOAT', values: { Light: 64,  Dark: 64 } },
        { name: 'space/3xl', type: 'FLOAT', values: { Light: 96,  Dark: 96 } },
        { name: 'space/4xl', type: 'FLOAT', values: { Light: 128, Dark: 128 } },
        // Radii (mode-agnostic)
        { name: 'radius/sm', type: 'FLOAT', values: { Light: 4,  Dark: 4 } },
        { name: 'radius/md', type: 'FLOAT', values: { Light: 8,  Dark: 8 } },
        { name: 'radius/lg', type: 'FLOAT', values: { Light: 16, Dark: 16 } }
      ]
    }
  ],
  import_guide: {
    method: 'Figma Tokens Plugin',
    steps: [
      '1. Figma Tokens Plugin installieren',
      '2. Plugin öffnen → Import → JSON',
      '3. Diese Datei importieren',
      '4. Apply to document'
    ],
    alternative: 'Figma Local Variables API (requires Figma MCP)'
  }
};

function hexToRgba(hex) {
  const clean = hex.replace('#', '');
  const r = parseInt(clean.substring(0, 2), 16) / 255;
  const g = parseInt(clean.substring(2, 4), 16) / 255;
  const b = parseInt(clean.substring(4, 6), 16) / 255;
  return { r, g, b, a: 1 };
}

fs.writeFileSync('$OUTPUT_JSON', JSON.stringify(figma, null, 2));
console.log('✓ Figma tokens written: $OUTPUT_JSON');
console.log('  Variables: ' + figma.collections[0].variables.length);
" 2>/dev/null

if [[ $? -ne 0 ]]; then
  # Python fallback if node fails
  echo "  Node.js not available — creating simplified Figma token format..."
  python3 - <<'PYEOF'
import json, sys
with open('$INPUT_JSON') as f:
    tokens = json.load(f)
output = {
    "brand": tokens["meta"]["brand"],
    "note": "Import via Figma Tokens Plugin",
    "colors": {k: v["value"] for k, v in tokens["colors"].items()},
    "typography": {
        "fontHeading": tokens["typography"]["fontHeading"]["value"],
        "fontBody": tokens["typography"]["fontBody"]["value"]
    }
}
with open('$OUTPUT_JSON', 'w') as f:
    json.dump(output, f, indent=2)
print(f"✓ Simplified Figma tokens: $OUTPUT_JSON")
PYEOF
fi

echo ""

# --- Figma REST API Push (optional, requires Editor seat + Personal Access Token) ---
FIGMA_TOKEN="${FIGMA_ACCESS_TOKEN:-}"
FIGMA_FILE_KEY="${3:-}"

if [[ -n "$FIGMA_TOKEN" && -n "$FIGMA_FILE_KEY" ]]; then
  echo "Attempting Figma REST API push..."

  # Step 1: Get existing variable collections
  COLLECTIONS=$(curl -s -H "X-FIGMA-TOKEN: $FIGMA_TOKEN" \
    "https://api.figma.com/v1/files/$FIGMA_FILE_KEY/variables/local" 2>/dev/null)

  if echo "$COLLECTIONS" | grep -q '"error"'; then
    echo "  ✗ API Error: $(echo "$COLLECTIONS" | node -e "const d=require('fs').readFileSync(0,'utf8');try{console.log(JSON.parse(d).error)}catch{console.log('Unknown error')}" 2>/dev/null)"
    echo "  Possible causes: Invalid token, View-only seat, or file not accessible"
    echo "  Falling back to manual import..."
  else
    # Step 2: Build POST payload from figma-tokens.json
    PAYLOAD=$(node -e "
const fs = require('fs');
const figma = JSON.parse(fs.readFileSync('$OUTPUT_JSON', 'utf8'));
const existing = JSON.parse(process.argv[1]);

// Check if 'Brand Tokens' collection already exists
const collections = Object.values(existing.meta?.variableCollections || {});
const existingCollection = collections.find(c => c.name === 'Brand Tokens');

const vars = figma.collections[0].variables;
const payload = { variableCollections: [], variableModes: [], variables: [], variableModeValues: [] };

if (existingCollection) {
  // Update existing collection
  const collectionId = existingCollection.id;
  const modes = Object.values(existing.meta?.variableModes || {}).filter(m => m.variableCollectionId === collectionId);
  const lightMode = modes.find(m => m.name === 'Light') || modes[0];
  const darkMode = modes.find(m => m.name === 'Dark') || modes[1];
  const existingVars = Object.values(existing.meta?.variables || {}).filter(v => v.variableCollectionId === collectionId);

  vars.forEach(v => {
    const ev = existingVars.find(e => e.name === v.name);
    if (ev) {
      // Update existing variable
      if (lightMode) payload.variableModeValues.push({ variableId: ev.id, modeId: lightMode.id, value: v.values.Light });
      if (darkMode) payload.variableModeValues.push({ variableId: ev.id, modeId: darkMode.id, value: v.values.Dark });
    } else {
      // Create new variable
      const tempId = 'tmp_' + v.name.replace(/\\//g, '_');
      payload.variables.push({
        action: 'CREATE',
        id: tempId,
        name: v.name,
        variableCollectionId: collectionId,
        resolvedType: v.type
      });
      if (lightMode) payload.variableModeValues.push({ variableId: tempId, modeId: lightMode.id, value: v.values.Light });
      if (darkMode) payload.variableModeValues.push({ variableId: tempId, modeId: darkMode.id, value: v.values.Dark });
    }
  });
} else {
  // Create new collection
  const collId = 'tmp_brand_tokens';
  const lightId = 'tmp_mode_light';
  const darkId = 'tmp_mode_dark';
  payload.variableCollections.push({ action: 'CREATE', id: collId, name: 'Brand Tokens', initialModeId: lightId });
  payload.variableModes.push({ action: 'CREATE', id: darkId, name: 'Dark', variableCollectionId: collId });

  vars.forEach(v => {
    const tempId = 'tmp_' + v.name.replace(/\\//g, '_');
    payload.variables.push({
      action: 'CREATE',
      id: tempId,
      name: v.name,
      variableCollectionId: collId,
      resolvedType: v.type
    });
    payload.variableModeValues.push({ variableId: tempId, modeId: lightId, value: v.values.Light });
    payload.variableModeValues.push({ variableId: tempId, modeId: darkId, value: v.values.Dark });
  });
}

console.log(JSON.stringify(payload));
" "$COLLECTIONS" 2>/dev/null)

    if [[ -z "$PAYLOAD" ]]; then
      echo "  ✗ Failed to build API payload"
      echo "  Falling back to manual import..."
    else
      # Step 3: POST variables to Figma
      RESULT=$(curl -s -X POST \
        -H "X-FIGMA-TOKEN: $FIGMA_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$PAYLOAD" \
        "https://api.figma.com/v1/files/$FIGMA_FILE_KEY/variables" 2>/dev/null)

      if echo "$RESULT" | grep -q '"status":200'; then
        echo "  ✓ Tokens pushed to Figma file: $FIGMA_FILE_KEY"
        echo "  Variables: $(echo "$PAYLOAD" | node -e "const d=JSON.parse(require('fs').readFileSync(0,'utf8'));console.log(d.variables.length + ' created, ' + d.variableModeValues.length + ' values set')" 2>/dev/null)"
      elif echo "$RESULT" | grep -q '"error"'; then
        echo "  ✗ Push failed: $(echo "$RESULT" | node -e "const d=require('fs').readFileSync(0,'utf8');try{console.log(JSON.parse(d).error)}catch{console.log(d.substring(0,200))}" 2>/dev/null)"
        echo "  Falling back to manual import..."
      else
        echo "  ✓ API response received (check Figma file for changes)"
      fi
    fi
  fi
else
  if [[ -z "$FIGMA_TOKEN" && -n "$FIGMA_FILE_KEY" ]]; then
    echo "  ⚠ FIGMA_ACCESS_TOKEN not set. Export: FIGMA_ACCESS_TOKEN=figd_xxx"
  fi
  echo "Next steps:"
  echo "  Option 1 — API Push (requires Editor seat):"
  echo "    export FIGMA_ACCESS_TOKEN=figd_your_token"
  echo "    bash export-figma.sh $INPUT_JSON $OUTPUT_JSON YOUR_FILE_KEY"
  echo ""
  echo "  Option 2 — Manual import:"
  echo "    $OUTPUT_JSON → Figma Tokens Studio Plugin → Import"
fi
