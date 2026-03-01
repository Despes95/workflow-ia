#!/usr/bin/env bash
# test_workflow_e2e.sh — Tests end-to-end du workflow complet
# Simule : memory.md → obsidian-sync.sh → vault mock → rotation → _global
# Usage : bash tests/test_workflow_e2e.sh  (depuis workflow-ia/)
#
# Stratégie : vault mock dans un répertoire temporaire avec config.env patchée.
# obsidian-sync.sh est copié dans un projet simulé pour isolation complète.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# shellcheck source=test_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/test_helpers.sh"

# ── Setup : structure projet + vault mock ─────────────────────────────────────
PROJ_DIR="$TMP/workflow-ia"
VAULT_DIR="$TMP/vault"
FORGE_MOCK="$VAULT_DIR/_forge"
GLOBAL_MOCK="$FORGE_MOCK/_global"
PROJECT_VAULT="$FORGE_MOCK/workflow-ia"

mkdir -p "$PROJ_DIR/scripts"
mkdir -p "$PROJECT_VAULT"
mkdir -p "$GLOBAL_MOCK"

# config.env pointant vers le vault mock
cat > "$PROJ_DIR/scripts/config.env" << EOF
OBSIDIAN_BASE="$VAULT_DIR"
FORGE_DIR="$FORGE_MOCK"
GLOBAL_DIR="$GLOBAL_MOCK"
DESPES_NOTES="$VAULT_DIR/DespesNotes"
EOF

# Copie du script réel
cp "$SCRIPT_DIR/scripts/obsidian-sync.sh" "$PROJ_DIR/scripts/"

# memory.md de test (toutes sections requises + leçon 🌐)
cat > "$PROJ_DIR/memory.md" << 'MEMEOF'
# workflow-ia — Memory

**Dernière mise à jour :** 2026-03-01

---

## 🎯 Focus Actuel

- **État** : Test E2E actif

---

## 🧠 Momentum (Handoff)

—

---

## 🏗️ Architecture

- **Stack** : Bash + Markdown

---

## 📁 Fichiers clés

- `memory.md` — source de vérité

---

## 📜 Récap sessions (5 max)

### Résumé global

- Stack complète testée

### Historique

- 2026-03-01 | Test | Session E2E | Stable

---

## 🐛 Bugs connus

- Bug E2E validé

---

## 📝 Leçons apprises

- Leçon locale sans marqueur
- Leçon globale cross-projets 🌐

---

## 📚 Décisions

- Décision test E2E

---

## ⛔ Contraintes & Interdits

- Aucune

---
MEMEOF

echo "=== test_workflow_e2e.sh ==="

# ── T1 — Sync sans erreur sur vault mock ─────────────────────────────────────
echo ""
echo "T1 — obsidian-sync.sh tourne sans erreur sur vault mock"
out=$(cd "$PROJ_DIR" && bash "scripts/obsidian-sync.sh" 2>&1); code=$?
assert_exit "exit 0" 0 "$code"
assert_contains "message success" "Sync terminée" "$out"
assert_contains "sessions.md mentionné" "sessions.md" "$out"
[ -f "$PROJECT_VAULT/sessions.md" ] \
  && ok "sessions.md créé dans le vault" \
  || fail "sessions.md absent du vault"
[ -f "$PROJECT_VAULT/index.md" ] \
  && ok "index.md créé dans le vault" \
  || fail "index.md absent du vault"

# ── T2 — sessions.md contient un snapshot après sync ─────────────────────────
echo ""
echo "T2 — sessions.md contient un snapshot avec le contenu de memory.md"
sessions_content=$(cat "$PROJECT_VAULT/sessions.md")
assert_contains "header sessions présent" "Sessions" "$sessions_content"
assert_contains "entrée Session présente" "## Session " "$sessions_content"
assert_contains "contenu Focus dans snapshot" "Test E2E actif" "$sessions_content"

# ── T3 — rotation : 11 sessions pré-chargées + sync → 12 → rotation → 10 ─────
echo ""
echo "T3 — rotation sessions.md (11 pré-chargées + 1 sync = 12 → rotation → 10)"
{
  echo "# workflow-ia — Sessions"
  echo ""
  echo "> Snapshots automatiques de memory.md"
  echo ""
  for i in $(seq 1 11); do
    echo ""
    echo "---"
    echo ""
    printf "## Session 202601%02d-120000\n" "$i"
    echo ""
    printf "> Sync test — 2026-01-%02d\n" "$i"
    echo ""
  done
} > "$PROJECT_VAULT/sessions.md"
cd "$PROJ_DIR" && bash "scripts/obsidian-sync.sh" >/dev/null 2>&1
count_after=$(grep -c "^## Session" "$PROJECT_VAULT/sessions.md" || true)
[ "$count_after" -eq 10 ] \
  && ok "10 sessions après rotation (12 → 10)" \
  || fail "rotation incorrecte ($count_after sessions, attendu 10)"
grep -q "^## Session 2026010[12]-120000" "$PROJECT_VAULT/sessions.md" \
  && fail "sessions 01/02 encore présentes (auraient dû être supprimées)" \
  || ok "sessions les plus anciennes supprimées"

# ── T4 — _global/lessons.md reçoit les leçons marquées 🌐 ───────────────────
echo ""
echo "T4 — _global/lessons.md reçoit les leçons marquées 🌐"
cat > "$GLOBAL_MOCK/lessons.md" << 'EOF'
# _global — Leçons apprises (toutes projets)

> Extraites automatiquement depuis les projets via obsidian-sync.sh (marqueur 🌐)
EOF
cd "$PROJ_DIR" && bash "scripts/obsidian-sync.sh" >/dev/null 2>&1
global_content=$(cat "$GLOBAL_MOCK/lessons.md")
assert_contains "leçon 🌐 présente dans global" "Leçon globale cross-projets" "$global_content"
assert_not_contains "leçon locale absente de global" "Leçon locale sans marqueur" "$global_content"

summary
