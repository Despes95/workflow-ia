#!/bin/bash

# ============================================================
# install-commands.sh — Déploie les custom slash commands
# Usage depuis workflow-ia : bash scripts/install-commands.sh
# Usage global             : bash scripts/install-commands.sh --global
# Usage sur un projet      : bash /chemin/vers/workflow-ia/scripts/install-commands.sh --project
# ============================================================

set -euo pipefail

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'; NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
COMMANDS_SRC="$REPO_DIR/.claude/commands"
MODE="${1:-}"

echo -e "${CYAN}📦 Déploiement des custom slash commands...${NC}"

# -- Mode --global : déploie dans ~/.claude/commands/
if [ "$MODE" = "--global" ]; then
  TARGET="$HOME/.claude/commands"
  mkdir -p "$TARGET"
  cp "$COMMANDS_SRC/"*.md "$TARGET/"
  echo -e "${GREEN}✓ Commands déployées globalement dans : $TARGET${NC}"
  ls "$TARGET/"
  exit 0
fi

# -- Mode --project : déploie dans le projet courant
if [ "$MODE" = "--project" ]; then
  TARGET="$PWD/.claude/commands"
  mkdir -p "$TARGET"
  cp "$COMMANDS_SRC/"*.md "$TARGET/"
  echo -e "${GREEN}✓ Commands déployées dans : $TARGET${NC}"
  ls "$TARGET/"
  exit 0
fi

# -- Mode défaut : vérifie l'intégrité des sources dans workflow-ia
if [ ! -d "$COMMANDS_SRC" ]; then
  echo -e "${YELLOW}⚠️  Dossier introuvable : $COMMANDS_SRC${NC}"
  echo -e "${YELLOW}   Assure-toi de lancer ce script depuis workflow-ia/scripts/${NC}"
  exit 1
fi

# Vérifie que les fichiers sources existent
COMMANDS=(my-world today close emerge challenge connect trace ideas global-connect context)
MISSING=0
for cmd in "${COMMANDS[@]}"; do
  if [ ! -f "$COMMANDS_SRC/$cmd.md" ]; then
    echo -e "${YELLOW}! Manquant : $cmd.md${NC}"
    MISSING=$((MISSING+1))
  fi
done

if [ "$MISSING" -gt 0 ]; then
  echo -e "${YELLOW}⚠️  $MISSING fichier(s) manquant(s) dans $COMMANDS_SRC${NC}"
  echo -e "${YELLOW}   Vérifie que workflow-ia/.claude/commands/ est complet.${NC}"
  exit 1
fi

echo -e "${GREEN}✓ Tous les commands sont présents dans workflow-ia${NC}"
echo ""
echo -e "${CYAN}Commandes disponibles :${NC}"
for cmd in "${COMMANDS[@]}"; do
  echo -e "  ${GREEN}/$cmd${NC}"
done

echo ""
echo -e "${CYAN}Pour déployer globalement (tous projets) :${NC}"
echo -e "  bash $SCRIPT_DIR/install-commands.sh --global"
echo ""
echo -e "${CYAN}Pour déployer sur un projet existant :${NC}"
echo -e "  cd /c/IA/Projects/<ton-projet>"
echo -e "  bash $SCRIPT_DIR/install-commands.sh --project"
