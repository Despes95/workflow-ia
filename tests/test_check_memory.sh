#!/usr/bin/env bash
# test_check_memory.sh — Tests unitaires pour scripts/check_memory.sh
# Usage : bash tests/test_check_memory.sh  (depuis workflow-ia/)

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$SCRIPT_DIR/scripts/check_memory.sh"
TMP=$(mktemp -d)
PASS=0; FAIL=0

trap 'rm -rf "$TMP"' EXIT

ok()   { echo "  ✅ $1"; PASS=$((PASS+1)); }
fail() { echo "  ❌ $1"; FAIL=$((FAIL+1)); }

assert_exit() {
  local desc="$1" expected="$2" actual="$3"
  [ "$actual" = "$expected" ] \
    && ok "$desc (exit $actual)" \
    || fail "$desc — attendu exit $expected, obtenu $actual"
}

assert_contains() {
  local desc="$1" pattern="$2" output="$3"
  echo "$output" | grep -q "$pattern" \
    && ok "$desc" \
    || fail "$desc — pattern '$pattern' absent"
}

# ── Fixture : memory.md valide minimal (8 emojis + sections texte) ─────────────
VALID=$(cat <<'EOF'
## 🎯 Focus Actuel
contenu focus

## 🧠 Momentum (Handoff)
—

## 🏗️ Architecture
contenu archi

## 📁 Fichiers clés
liste fichiers

## 📜 Récap sessions
historique

## 🐛 Bugs connus
aucun bug connu

## 📝 Leçons apprises
aucune leçon

## 📚 Décisions
aucune décision

## ⛔ Contraintes & Interdits
règles
EOF
)

echo "=== test_check_memory.sh ==="

# T1 — Fichier absent → exit 1
echo ""
echo "T1 — Fichier absent"
out=$(cd "$TMP" && bash "$SCRIPT" 2>&1); code=$?
assert_exit "exit 1" 1 "$code"

# T2 — memory.md valide → exit 0
echo ""
echo "T2 — Valide"
printf '%s\n' "$VALID" > "$TMP/memory.md"
out=$(cd "$TMP" && bash "$SCRIPT" 2>&1); code=$?
assert_exit "exit 0" 0 "$code"
assert_contains "message OK" "✅" "$out"

# T3 — Doublon section → exit 1
echo ""
echo "T3 — Doublon section"
printf '%s\nFocus Actuel dupliqué\n' "$VALID" > "$TMP/memory.md"
out=$(cd "$TMP" && bash "$SCRIPT" 2>&1); code=$?
assert_exit "exit 1" 1 "$code"
assert_contains "message DOUBLON" "DOUBLON" "$out"

# T4 — Emoji ancre manquant → exit 1
echo ""
echo "T4 — Emoji ⛔ manquant (suppression de la ligne Contraintes)"
grep -v "Contraintes" <<< "$VALID" > "$TMP/memory.md"
out=$(cd "$TMP" && bash "$SCRIPT" 2>&1); code=$?
assert_exit "exit 1" 1 "$code"
assert_contains "message ANCRE MANQUANTE" "ANCRE MANQUANTE" "$out"

# T5 — > 120 lignes → warning mais exit 0
echo ""
echo "T5 — Warning > 120 lignes"
{ printf '%s\n' "$VALID"; yes "padding" | head -110; } > "$TMP/memory.md"
out=$(cd "$TMP" && bash "$SCRIPT" 2>&1); code=$?
assert_exit "exit 0 malgré warning" 0 "$code"
assert_contains "warning lignes" "lignes" "$out"

# ── Résultat ───────────────────────────────────────────────────────────────────
echo ""
echo "=== Résultat : $PASS ✅  $FAIL ❌ ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
