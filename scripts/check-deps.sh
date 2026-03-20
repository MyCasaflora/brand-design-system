#!/usr/bin/env bash
# check-deps.sh — Dependency-Check für brand-design-system Plugin
# Usage: bash check-deps.sh [--json]
# Output: Human-readable status oder JSON (--json flag)

JSON_OUTPUT=false
[[ "$1" == "--json" ]] && JSON_OUTPUT=true

# Farben für Terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_command() {
  command -v "$1" &>/dev/null && echo "true" || echo "false"
}

check_node_module() {
  node -e "require('$1')" &>/dev/null && echo "true" || echo "false"
}

# --- Check alle Dependencies ---

# Node.js
NODE=$(check_command "node")
NODE_VERSION=$(node --version 2>/dev/null || echo "n/a")

# Puppeteer (für PDF)
if [[ "$NODE" == "true" ]]; then
  PUPPETEER=$(check_command "npx" && npx puppeteer --version &>/dev/null && echo "true" || echo "false")
else
  PUPPETEER="false"
fi

# wkhtmltopdf (für PDF-Fallback)
WKHTMLTOPDF=$(check_command "wkhtmltopdf")

# Chrome/Chromium (für Playwright/Puppeteer)
CHROME=$(check_command "google-chrome" || check_command "chromium" || check_command "chromium-browser" || check_command "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" && echo "true" || echo "false")

# Python3 (Fallback für export-figma.sh wenn Node nicht verfügbar)
PYTHON=$(check_command "python3")

# zip (für handoff-package)
ZIP=$(check_command "zip")

# OpenRouter Skill
OPENROUTER_SKILL="false"
[[ -d "$HOME/.claude/skills/openrouter-skill-v3" ]] && OPENROUTER_SKILL="true"

# Figma MCP (heuristic: check claude config)
FIGMA_MCP="false"
if [[ -f "$HOME/.claude.json" ]]; then
  grep -q "figma" "$HOME/.claude.json" &>/dev/null && FIGMA_MCP="true"
fi

# Playwright MCP
PLAYWRIGHT_MCP="false"
if [[ -f "$HOME/.claude.json" ]]; then
  grep -q "playwright" "$HOME/.claude.json" &>/dev/null && PLAYWRIGHT_MCP="true"
fi

# Bestimme bestes PDF-Tool
PDF_TOOL="none"
[[ "$PUPPETEER" == "true" ]] && PDF_TOOL="puppeteer"
[[ "$PDF_TOOL" == "none" && "$WKHTMLTOPDF" == "true" ]] && PDF_TOOL="wkhtmltopdf"
[[ "$PDF_TOOL" == "none" && "$PLAYWRIGHT_MCP" == "true" ]] && PDF_TOOL="playwright-mcp"
[[ "$PDF_TOOL" == "none" ]] && PDF_TOOL="manual-print"

# --- Output ---

if [[ "$JSON_OUTPUT" == "true" ]]; then
  cat <<EOF
{
  "node": "$NODE",
  "node_version": "$NODE_VERSION",
  "pdf": {
    "best_tool": "$PDF_TOOL",
    "puppeteer": "$PUPPETEER",
    "wkhtmltopdf": "$WKHTMLTOPDF",
    "playwright_mcp": "$PLAYWRIGHT_MCP"
  },
  "figma_mcp": "$FIGMA_MCP",
  "openrouter_skill": "$OPENROUTER_SKILL",
  "chrome": "$CHROME",
  "python3": "$PYTHON",
  "zip": "$ZIP"
}
EOF
else
  echo "================================================"
  echo "  brand-design-system — Dependency Check"
  echo "================================================"
  echo ""

  # Core
  echo "CORE:"
  [[ "$NODE" == "true" ]] \
    && echo -e "  ${GREEN}✓${NC} Node.js ($NODE_VERSION)" \
    || echo -e "  ${YELLOW}○${NC} Node.js — empfohlen für token-generator.js"

  # PDF Tools
  echo ""
  echo "PDF EXPORT (Fallback-Kette):"
  if [[ "$PUPPETEER" == "true" ]]; then
    echo -e "  ${GREEN}✓${NC} Puppeteer — bevorzugtes PDF-Tool"
  else
    echo -e "  ${YELLOW}○${NC} Puppeteer nicht gefunden (npm install puppeteer)"
  fi
  if [[ "$WKHTMLTOPDF" == "true" ]]; then
    echo -e "  ${GREEN}✓${NC} wkhtmltopdf — Fallback verfügbar"
  else
    echo -e "  ${YELLOW}○${NC} wkhtmltopdf nicht gefunden (brew install wkhtmltopdf)"
  fi
  if [[ "$PLAYWRIGHT_MCP" == "true" ]]; then
    echo -e "  ${GREEN}✓${NC} Playwright MCP — Fallback verfügbar"
  else
    echo -e "  ${YELLOW}○${NC} Playwright MCP nicht konfiguriert"
  fi

  echo ""
  echo -e "  PDF-Tool gewählt: ${GREEN}${PDF_TOOL}${NC}"
  [[ "$PDF_TOOL" == "manual-print" ]] && echo -e "  ${YELLOW}HINWEIS: Kein automatisches PDF-Tool. Manueller @media print Export nötig.${NC}"

  # Figma
  echo ""
  echo "FIGMA INTEGRATION:"
  if [[ "$FIGMA_MCP" == "true" ]]; then
    echo -e "  ${GREEN}✓${NC} Figma MCP konfiguriert"
  else
    echo -e "  ${YELLOW}○${NC} Figma MCP nicht konfiguriert — Token-Push nicht verfügbar"
    echo "    Fallback: figma-tokens.json wird für manuellen Import erstellt"
  fi

  # OpenRouter
  echo ""
  echo "AI / OPENROUTER:"
  if [[ "$OPENROUTER_SKILL" == "true" ]]; then
    echo -e "  ${GREEN}✓${NC} openrouter-skill-v3 installiert"
  else
    echo -e "  ${RED}✗${NC} openrouter-skill-v3 NICHT gefunden — PFLICHT für Logo-Analyse + Image-Gen"
    echo "    Installieren: Skill in ~/.claude/skills/openrouter-skill-v3/ kopieren"
  fi

  # Utilities
  echo ""
  echo "UTILITIES:"
  [[ "$PYTHON" == "true" ]] \
    && echo -e "  ${GREEN}✓${NC} Python3" \
    || echo -e "  ${YELLOW}○${NC} Python3 nicht gefunden"
  [[ "$ZIP" == "true" ]] \
    && echo -e "  ${GREEN}✓${NC} zip (für Handoff-Package)" \
    || echo -e "  ${YELLOW}○${NC} zip nicht gefunden — Handoff als Ordner statt ZIP"

  echo ""
  echo "================================================"

  # Critical errors
  if [[ "$OPENROUTER_SKILL" == "false" ]]; then
    echo -e "${RED}KRITISCH: openrouter-skill-v3 fehlt — Logo-Analyse und Image-Generation nicht verfügbar${NC}"
    exit 1
  fi

  echo -e "${GREEN}Plugin bereit. PDF via: ${PDF_TOOL}${NC}"
  echo "================================================"
fi
