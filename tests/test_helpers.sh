#!/usr/bin/env bash
# test_helpers.sh — Helpers partagés pour les scripts de test
# Usage : source "$(dirname "${BASH_SOURCE[0]}")/test_helpers.sh"

PASS=0; FAIL=0

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
  echo "$output" | grep -qF "$pattern" \
    && ok "$desc" \
    || fail "$desc — pattern '$pattern' absent"
}

assert_not_contains() {
  local desc="$1" pattern="$2" output="$3"
  echo "$output" | grep -qF "$pattern" \
    && fail "$desc — '$pattern' trouvé (ne devrait pas)" \
    || ok "$desc"
}

summary() {
  echo ""
  echo "=== Résultat : $PASS ✅  $FAIL ❌ ==="
  [ "$FAIL" -eq 0 ] && exit 0 || exit 1
}
