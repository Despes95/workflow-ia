#!/bin/bash

# ============================================================
# install-commands.sh — Déploie les custom slash commands
# Usage depuis workflow-ia :
#   bash scripts/install-commands.sh            → vérifie les sources
#   bash scripts/install-commands.sh --global   → Claude global (~/.claude/commands/)
#   bash scripts/install-commands.sh --gemini   → Gemini global (~/.gemini/commands/)
#   bash scripts/install-commands.sh --opencode → OpenCode global (~/.config/opencode/commands/)
#   bash scripts/install-commands.sh --all      → les 3 ensembles globaux
#   bash scripts/install-commands.sh --project  → Claude projet courant
# ============================================================

set -euo pipefail

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'; NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
CLAUDE_SRC="$REPO_DIR/.claude/commands"
GEMINI_SRC="$REPO_DIR/.gemini/commands"
OPENCODE_SRC="$REPO_DIR/.opencode/commands"
MODE="${1:-}"

echo -e "${CYAN}📦 Déploiement des custom slash commands...${NC}"

# -- Mode --global : déploie Claude dans ~/.claude/commands/
if [ "$MODE" = "--global" ]; then
  TARGET="$HOME/.claude/commands"
  mkdir -p "$TARGET"
  cp "$CLAUDE_SRC/"*.md "$TARGET/"
  echo -e "${GREEN}✓ Commands Claude déployées globalement dans : $TARGET${NC}"
  ls "$TARGET/"
  echo ""
  echo -e "${YELLOW}⚠️  Relance Claude Code pour activer les commandes globales.${NC}"
  exit 0
fi

# -- Mode --gemini : déploie dans ~/.gemini/commands/
if [ "$MODE" = "--gemini" ]; then
  TARGET="$HOME/.gemini/commands"
  mkdir -p "$TARGET"
  cp "$GEMINI_SRC/"*.toml "$TARGET/"
  echo -e "${GREEN}✓ Commands Gemini déployées globalement dans : $TARGET${NC}"
  ls "$TARGET/"
  exit 0
fi

# -- Mode --opencode : déploie dans ~/.config/opencode/commands/
if [ "$MODE" = "--opencode" ]; then
  TARGET="$HOME/.config/opencode/commands"
  mkdir -p "$TARGET"
  cp "$OPENCODE_SRC/"*.md "$TARGET/"
  echo -e "${GREEN}✓ Commands OpenCode déployées globalement dans : $TARGET${NC}"
  ls "$TARGET/"
  exit 0
fi

# -- Mode --all : déploie les 3 ensembles globalement
if [ "$MODE" = "--all" ]; then
  # Claude
  TARGET_CLAUDE="$HOME/.claude/commands"
  mkdir -p "$TARGET_CLAUDE"
  cp "$CLAUDE_SRC/"*.md "$TARGET_CLAUDE/"
  echo -e "${GREEN}✓ Claude → $TARGET_CLAUDE${NC}"

  # Gemini
  TARGET_GEMINI="$HOME/.gemini/commands"
  mkdir -p "$TARGET_GEMINI"
  cp "$GEMINI_SRC/"*.toml "$TARGET_GEMINI/"
  echo -e "${GREEN}✓ Gemini → $TARGET_GEMINI${NC}"

  # OpenCode
  TARGET_OC="$HOME/.config/opencode/commands"
  mkdir -p "$TARGET_OC"
  cp "$OPENCODE_SRC/"*.md "$TARGET_OC/"
  echo -e "${GREEN}✓ OpenCode → $TARGET_OC${NC}"

  echo ""
  echo -e "${GREEN}✅ Déploiement --all terminé (Claude + Gemini + OpenCode)${NC}"
  echo -e "${YELLOW}⚠️  Relance Claude Code pour activer les commandes globales.${NC}"
  exit 0
fi

# -- Mode --project : déploie Claude dans le projet courant
if [ "$MODE" = "--project" ]; then
  TARGET="$PWD/.claude/commands"
  mkdir -p "$TARGET"
  cp "$CLAUDE_SRC/"*.md "$TARGET/"
  echo -e "${GREEN}✓ Commands Claude déployées dans : $TARGET${NC}"
  ls "$TARGET/"
  exit 0
fi

# -- Mode défaut : vérifie l'intégrité des sources dans workflow-ia
echo -e "${CYAN}Vérification des sources...${NC}"

MISSING=0
for dir_label in "Claude:.claude/commands:md" "Gemini:.gemini/commands:toml" "OpenCode:.opencode/commands:md"; do
  LABEL=$(echo "$dir_label" | cut -d: -f1)
  SUBDIR=$(echo "$dir_label" | cut -d: -f2)
  EXT=$(echo "$dir_label" | cut -d: -f3)
  SRC="$REPO_DIR/$SUBDIR"
  COUNT=$(ls "$SRC/"*."$EXT" 2>/dev/null | wc -l)
  if [ "$COUNT" -eq 28 ]; then
    echo -e "  ${GREEN}✓ $LABEL : $COUNT fichiers .$EXT${NC}"
  else
    echo -e "  ${YELLOW}! $LABEL : $COUNT/28 fichiers .$EXT dans $SRC${NC}"
    MISSING=$((MISSING+1))
  fi
done

if [ "$MISSING" -gt 0 ]; then
  echo -e "${YELLOW}⚠️  Sources incomplètes — vérifie les dossiers ci-dessus.${NC}"
  exit 1
fi

echo ""
echo -e "${GREEN}✓ Toutes les sources sont complètes (28 commands × 3 outils)${NC}"
echo ""
echo -e "${CYAN}Modes de déploiement disponibles :${NC}"
echo -e "  bash $SCRIPT_DIR/install-commands.sh --global    → Claude Code (global)"
echo -e "  bash $SCRIPT_DIR/install-commands.sh --gemini    → Gemini CLI (global)"
echo -e "  bash $SCRIPT_DIR/install-commands.sh --opencode  → OpenCode (global)"
echo -e "  bash $SCRIPT_DIR/install-commands.sh --all       → les 3 (global)"
echo -e "  bash $SCRIPT_DIR/install-commands.sh --project   → Claude projet courant"
