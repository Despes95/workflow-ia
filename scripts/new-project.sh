#!/usr/bin/env bash
# new-project.sh — Bootstrap un nouveau projet depuis le template workflow-ia
# Usage : bash scripts/new-project.sh <project-name> [target-path]
#
# Déploie la stack complète :
#   AGENTS.md, CLAUDE.md, memory.md, .claude/, .gemini/, .opencode/, scripts/, docs/

set -euo pipefail

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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

# ── 4. memory.md — template vierge ──────────────────────────────────────────
echo -e "   📄 memory.md..."
cat > "$TARGET/memory.md" <<EOF
# $PROJECT_NAME — Memory

**Dernière mise à jour :** $DATE (init bootstrap)
**Dernier outil CLI utilisé :** —

---

## 🎯 Focus Actuel

- **Mission en cours** : —
- **Prochaine étape** : —
- **Zone sensible** : —
- **État git** : init

---

## 🧠 Momentum (Handoff)

> Section volatile — remplie par l'IA avant un switch, effacée après reprise.

- —
- —
- —
- —
- —

---

## 🏗️ Architecture

- **Objectif** : —
- **Stack** : —
- **Workflow dev** : —

---

## 📁 Fichiers clés

- \`AGENTS.md\` — règles communes à tous les outils IA — Stable
- \`CLAUDE.md\` — directive @AGENTS.md + règles spécifiques Claude — Stable
- \`memory.md\` — état court terme du projet — Stable

---

## 📜 Récap sessions (5 max)

### Résumé global

- Projet initialisé depuis le template workflow-ia.

### Historique

- $DATE | bootstrap | Création depuis workflow-ia/new-project.sh | Stable

---

## ✅ Todo

- [ ] \`git init && git add . && git commit -m "init: bootstrap $PROJECT_NAME"\`
- [ ] \`bash scripts/install-commands.sh --all\` — déployer les commandes globalement
- [ ] Configurer le vault Obsidian si nécessaire (\`bash scripts/obsidian-sync.sh\`)

---

## 🐛 Bugs connus

_Aucun connu_

---

## 📝 Leçons apprises

_Aucune encore_

---

## ⛔ Contraintes & Interdits

- Ne jamais modifier AGENTS.md sans validation explicite
EOF

# ── 5. .claude/ — copie brute ────────────────────────────────────────────────
echo -e "   📂 .claude/..."
mkdir -p "$TARGET/.claude/commands"
cp "$TEMPLATE/.claude/settings.local.json" "$TARGET/.claude/"
cp "$TEMPLATE/.claude/commands/"*.md "$TARGET/.claude/commands/"

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
chmod +x "$TARGET/scripts/"*.sh

# ── 9. docs/ — commands-list.cmd uniquement ─────────────────────────────────
echo -e "   📂 docs/..."
mkdir -p "$TARGET/docs"
cp "$TEMPLATE/docs/commands-list.cmd" "$TARGET/docs/"

# ── 10. RÉSUMÉ ───────────────────────────────────────────────────────────────
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
echo -e "   git init && git add . && git commit -m \"init: bootstrap $PROJECT_NAME\""
echo -e "   bash scripts/install-commands.sh --all"
echo ""
echo -e "${YELLOW}💡 Vault Obsidian : bash scripts/obsidian-sync.sh${NC}"
echo -e "${YELLOW}   (crée automatiquement /_forge/$PROJECT_NAME/ dans le vault)${NC}"
