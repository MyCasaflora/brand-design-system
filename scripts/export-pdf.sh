#!/usr/bin/env bash
# export-pdf.sh — HTML → PDF Export (Fallback-Kette)
# Usage: bash export-pdf.sh <input.html> <output.pdf>

INPUT_HTML="${1:-brand-guidelines.html}"
OUTPUT_PDF="${2:-brand-guidelines.pdf}"

if [[ ! -f "$INPUT_HTML" ]]; then
  echo "ERROR: Input file not found: $INPUT_HTML"
  exit 1
fi

mkdir -p "$(dirname "$OUTPUT_PDF")"

echo "PDF Export: $INPUT_HTML → $OUTPUT_PDF"

# --- Fallback 1: Puppeteer ---
if command -v npx &>/dev/null; then
  echo "  Trying Puppeteer..."
  npx --yes puppeteer@latest print "$INPUT_HTML" "$OUTPUT_PDF" 2>/dev/null
  if [[ -f "$OUTPUT_PDF" && -s "$OUTPUT_PDF" ]]; then
    echo "  ✓ PDF via Puppeteer: $OUTPUT_PDF"
    exit 0
  fi
fi

# --- Fallback 2: wkhtmltopdf ---
if command -v wkhtmltopdf &>/dev/null; then
  echo "  Trying wkhtmltopdf..."
  wkhtmltopdf --enable-local-file-access --print-media-type \
    --margin-top 20mm --margin-bottom 20mm \
    --margin-left 15mm --margin-right 15mm \
    "$INPUT_HTML" "$OUTPUT_PDF" 2>/dev/null
  if [[ -f "$OUTPUT_PDF" && -s "$OUTPUT_PDF" ]]; then
    echo "  ✓ PDF via wkhtmltopdf: $OUTPUT_PDF"
    exit 0
  fi
fi

# --- Fallback 3: Chrome headless ---
CHROME_BIN=""
for candidate in \
  "google-chrome" "chromium" "chromium-browser" \
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  "/usr/bin/google-chrome-stable"; do
  if command -v "$candidate" &>/dev/null || [[ -f "$candidate" ]]; then
    CHROME_BIN="$candidate"
    break
  fi
done

if [[ -n "$CHROME_BIN" ]]; then
  echo "  Trying Chrome headless..."
  ABS_INPUT=$(realpath "$INPUT_HTML")
  ABS_OUTPUT=$(realpath "$OUTPUT_PDF" 2>/dev/null || echo "$OUTPUT_PDF")
  "$CHROME_BIN" --headless --disable-gpu --print-to-pdf="$ABS_OUTPUT" \
    "file://$ABS_INPUT" 2>/dev/null
  if [[ -f "$OUTPUT_PDF" && -s "$OUTPUT_PDF" ]]; then
    echo "  ✓ PDF via Chrome headless: $OUTPUT_PDF"
    exit 0
  fi
fi

# --- Fallback 4: Manual instruction ---
echo ""
echo "  ⚠️  Kein automatisches PDF-Tool verfügbar."
echo ""
echo "  MANUELLE ALTERNATIVE:"
echo "  1. Öffne folgende Datei im Browser:"
echo "     $(realpath "$INPUT_HTML" 2>/dev/null || echo "$INPUT_HTML")"
echo "  2. Drücke Strg+P (Windows/Linux) oder Cmd+P (Mac)"
echo "  3. Wähle 'Als PDF speichern'"
echo "  4. Speichere als: $OUTPUT_PDF"
echo ""
echo "  Die HTML-Datei enthält optimierte @media print Styles."
echo ""
exit 1
