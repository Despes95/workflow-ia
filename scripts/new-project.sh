#!/usr/bin/env bash
# new-project.sh — Bootstrap un nouveau projet depuis le template workflow-ia
# Usage : bash scripts/new-project.sh <project-name> [target-path]
#
# Déploie la stack complète :
#   AGENTS.md, CLAUDE.md, memory.md, .claude/, .gemini/, .opencode/, scripts/, docs/

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=_commons.sh
source "${SCRIPT_DIR}/_commons.sh"
# shellcheck source=config.env
source "${SCRIPT_DIR}/config.env"
TEMPLATE="$(dirname "$SCRIPT_DIR")"  # Racine de workflow-ia
DATE="$(date '+%Y-%m-%d')"

# ── HELPER : normalise chemin Windows → bash ────────────────────────────────
normalize_path() {
  local p="$1"
  # Remplacer \ par /
  p="${p//\\//}"
  # Convertir lettre de lecteur C: → /c
  if [[ "$p" =~ ^([A-Za-z]): ]]; then
    local drive="${BASH_REMATCH[1]}"
    drive="${drive,,}"
    p="/$drive${p:2}"
  fi
  echo "$p"
}

# ── 1. VALIDATION ────────────────────────────────────────────────────────────
PROJECT_NAME="${1:-}"

if [[ -z "$PROJECT_NAME" ]]; then
  echo -e "${RED}❌ Usage : bash scripts/new-project.sh <project-name> [target-path]${NC}"
  exit 1
fi

if [[ ! "$PROJECT_NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  echo -e "${RED}❌ Nom invalide : utilisez uniquement lettres, chiffres, tirets, underscores.${NC}"
  exit 1
fi

RAW_TARGET="${2:-}"
if [[ -z "$RAW_TARGET" ]]; then
  TARGET="/c/IA/projects/$PROJECT_NAME"
else
  TARGET="$(normalize_path "$RAW_TARGET")"
fi

if [[ -d "$TARGET" ]]; then
  echo -e "${YELLOW}⚠️  Le dossier $TARGET existe déjà.${NC}"
  read -rp "   Continuer quand même ? (o/N) : " CONFIRM
  if [[ "${CONFIRM,,}" != "o" ]]; then
    echo "Annulé."
    exit 0
  fi
fi

echo -e "${CYAN}🚀 Bootstrap du projet : ${PROJECT_NAME}${NC}"
echo -e "   Template : $TEMPLATE"
echo -e "   Cible    : $TARGET"
echo ""

mkdir -p "$TARGET"

# ── 2. AGENTS.md — copie + sed workflow-ia → PROJECT_NAME ───────────────────
echo -e "   📄 AGENTS.md..."
sed "s|workflow-ia|$PROJECT_NAME|g" "$TEMPLATE/AGENTS.md" > "$TARGET/AGENTS.md"

# ── 3. CLAUDE.md — template inline ──────────────────────────────────────────
echo -e "   📄 CLAUDE.md..."
cat > "$TARGET/CLAUDE.md" <<EOF
# $PROJECT_NAME — Règles Claude Code

@AGENTS.md

## Règles spécifiques Claude Code

- Toujours utiliser Plan Mode avant de toucher au code
- Confirmer avec l'utilisateur avant tout refactor touchant plus de 3 fichiers
- Ne jamais modifier un fichier sans montrer le diff d'abord
EOF

# ── 4. memory.md — template externe ──────────────────────────────────────────
echo -e "   📄 memory.md..."
sed -e "s|PROJECT_NAME|$PROJECT_NAME|g" \
    -e "s|DATE_PLACEHOLDER|$DATE|g" \
    "${SCRIPT_DIR}/templates/memory.md.tpl" > "$TARGET/memory.md"

# ── 5. .claude/ — copie + sed ────────────────────────────────────────────────
echo -e "   📂 .claude/..."
mkdir -p "$TARGET/.claude/commands"
[[ -f "$TEMPLATE/.claude/settings.local.json" ]] && cp "$TEMPLATE/.claude/settings.local.json" "$TARGET/.claude/" || true
for src in "$TEMPLATE/.claude/commands/"*.md; do
  fname="$(basename "$src")"
  sed "s|workflow-ia|$PROJECT_NAME|g" "$src" > "$TARGET/.claude/commands/$fname"
done

# ── 6. .gemini/commands/ — copie + sed ──────────────────────────────────────
echo -e "   📂 .gemini/commands/..."
mkdir -p "$TARGET/.gemini/commands"
for src in "$TEMPLATE/.gemini/commands/"*.toml; do
  fname="$(basename "$src")"
  sed "s|workflow-ia|$PROJECT_NAME|g" "$src" > "$TARGET/.gemini/commands/$fname"
done

# ── 7. .opencode/commands/ — copie + sed ────────────────────────────────────
echo -e "   📂 .opencode/commands/..."
mkdir -p "$TARGET/.opencode/commands"
for src in "$TEMPLATE/.opencode/commands/"*.md; do
  fname="$(basename "$src")"
  sed "s|workflow-ia|$PROJECT_NAME|g" "$src" > "$TARGET/.opencode/commands/$fname"
done

# ── 8. scripts/ — copie brute + chmod ───────────────────────────────────────
echo -e "   📂 scripts/..."
mkdir -p "$TARGET/scripts"
cp "$TEMPLATE/scripts/"*.sh "$TARGET/scripts/"
cp "$TEMPLATE/scripts/"*.py "$TARGET/scripts/" 2>/dev/null || true
cp "$TEMPLATE/scripts/config.env" "$TARGET/scripts/"
[[ -f "$TEMPLATE/scripts/setup-windows.json" ]] && cp "$TEMPLATE/scripts/setup-windows.json" "$TARGET/scripts/" || true
[[ -d "$TEMPLATE/scripts/templates" ]] && cp -r "$TEMPLATE/scripts/templates" "$TARGET/scripts/" || true
chmod +x "$TARGET/scripts/"*.sh
mkdir -p "$TARGET/scripts/hooks"
cp "$TEMPLATE/scripts/hooks/pre-commit" "$TARGET/scripts/hooks/"
chmod +x "$TARGET/scripts/hooks/pre-commit"

# ── 9. hooks/ — core.hooksPath → scripts/hooks (F2) ─────────────────────────
echo -e "   🔒 Hook pre-commit..."
if [[ -d "$TARGET/.git" ]]; then
  git -C "$TARGET" config core.hooksPath scripts/hooks
  echo -e "     ✓ core.hooksPath → scripts/hooks"
else
  echo -e "     ℹ️  Pas de .git/ — après git init : git config core.hooksPath scripts/hooks"
fi

# ── 10. docs/ — commands-list.cmd uniquement ─────────────────────────────────
echo -e "   📂 docs/..."
mkdir -p "$TARGET/docs"
cp "$TEMPLATE/docs/commands-list.cmd" "$TARGET/docs/"

# ── 11. RÉSUMÉ ───────────────────────────────────────────────────────────────
CLAUDE_COUNT=$(ls "$TARGET/.claude/commands/"*.md 2>/dev/null | wc -l)
GEMINI_COUNT=$(ls "$TARGET/.gemini/commands/"*.toml 2>/dev/null | wc -l)
OC_COUNT=$(ls "$TARGET/.opencode/commands/"*.md 2>/dev/null | wc -l)
TOTAL=$((CLAUDE_COUNT + GEMINI_COUNT + OC_COUNT))

echo ""
echo -e "${GREEN}✅ Projet ${PROJECT_NAME} créé dans ${TARGET}${NC}"
echo -e "${GREEN}📁 ${TOTAL} commandes déployées (${CLAUDE_COUNT} Claude × ${GEMINI_COUNT} Gemini × ${OC_COUNT} OpenCode)${NC}"
echo ""
echo -e "${CYAN}🔜 Prochaines étapes :${NC}"
echo -e "   cd $TARGET"
echo -e "   git init"
echo -e "   git config core.hooksPath scripts/hooks"
echo -e "   git add . && git commit -m \"init: bootstrap $PROJECT_NAME\""
echo -e "   bash scripts/install-commands.sh --all"
echo ""
echo -e "${YELLOW}💡 Vault Obsidian : bash scripts/obsidian-sync.sh${NC}"
echo -e "${YELLOW}   (crée automatiquement /_forge/$PROJECT_NAME/ dans le vault)${NC}"
