#!/usr/bin/env bash
# test_sync.sh — Tests des helpers de scripts/obsidian-sync.sh
# Usage : bash tests/test_sync.sh  (depuis workflow-ia/)
#
# Stratégie : les fonctions helper sont copiées inline pour éviter
# le sourcing de config.env (qui pointe vers iCloud Drive).
# Un test d'intégration vérifie le guard memory.md absent.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
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

# ── Fonctions copiées depuis obsidian-sync.sh ──────────────────────────────────

MEMORY_FILE="$TMP/memory.md"

extract_section() {
  local pattern="$1"
  local section=""
  local in_section=0
  while IFS= read -r line; do
    if [[ "$line" =~ ^##[[:space:]]*${pattern} ]]; then
      in_section=1
    elif [[ "$in_section" -eq 1 && "$line" =~ ^## ]]; then
      in_section=0
    elif [[ "$in_section" -eq 1 ]]; then
      section+="${line}"$'\n'
    fi
  done < "$MEMORY_FILE"
  echo "$section"
}

append_section() {
  local file="$1"
  local title="$2"
  local content="$3"
  local label="$4"
  local DATE="2026-01-01"
  {
    echo ""
    echo "---"
    echo ""
    echo "### ${title} du ${DATE}"
    echo ""
    echo "$content"
  } >> "$file"
  # K3 — préserve les lignes vides tout en dédupliquant
  awk '!seen[$0]++ || !NF' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
  echo "  ${label} extraits → $(basename "$file")"
}

rotate_sessions() {
  local file="$1"
  local max="${2:-10}"
  local count
  count=$(grep -c "^## Session" "$file" 2>/dev/null || echo 0)
  [[ "$count" -le "$max" ]] && return 0

  local to_skip=$(( count - max ))
  local first_session_line
  first_session_line=$(grep -n "^## Session" "$file" | head -1 | cut -d: -f1)
  local header_end=$(( first_session_line - 4 ))
  [[ "$header_end" -lt 1 ]] && header_end=1

  local start_line
  start_line=$(grep -n "^## Session" "$file" | awk -F: -v n="$(( to_skip + 1 ))" 'NR==n{print $1}')
  [[ -z "$start_line" ]] && return 0

  local print_from=$(( start_line - 2 ))
  [[ "$print_from" -le "$header_end" ]] && print_from=$(( header_end + 1 ))

  {
    head -n "$header_end" "$file"
    tail -n +"$print_from" "$file"
  } > "${file}.tmp" && mv "${file}.tmp" "$file"
  echo "  Rotation sessions.md (${count} -> ${max})"
}

# ── Tests ──────────────────────────────────────────────────────────────────────

echo "=== test_sync.sh ==="

# T1 — Intégration : memory.md absent → obsidian-sync.sh exit 1
echo ""
echo "T1 — memory.md absent (intégration)"
out=$(cd "$TMP" && bash "$SCRIPT_DIR/scripts/obsidian-sync.sh" 2>&1); code=$?
assert_exit "exit 1" 1 "$code"
assert_contains "message introuvable" "introuvable" "$out"

# T2 — extract_section() : extrait le bon contenu, pas le reste
echo ""
echo "T2 — extract_section()"
cat > "$MEMORY_FILE" <<'EOF'
## 🎯 Focus Actuel
ligne focus 1
ligne focus 2

## 🏗️ Architecture
contenu archi
EOF
result=$(extract_section "🎯")
assert_contains "contient 'ligne focus 1'" "ligne focus 1" "$result"
assert_contains "contient 'ligne focus 2'" "ligne focus 2" "$result"
assert_not_contains "ne contient pas 'contenu archi'" "contenu archi" "$result"

# T3 — append_section() : K3 — préserve les lignes vides
echo ""
echo "T3 — append_section() préserve les lignes vides (K3)"
FILE="$TMP/test_append.md"
echo "# Header" > "$FILE"
# Content avec une ligne vide entre A et B
append_section "$FILE" "Test" $'ligne A\n\nligne B' "test" > /dev/null
content=$(cat "$FILE")
assert_contains "ligne A présente" "ligne A" "$content"
assert_contains "ligne B présente" "ligne B" "$content"
line_a=$(grep -n "ligne A" "$FILE" | head -1 | cut -d: -f1)
line_b=$(grep -n "ligne B" "$FILE" | head -1 | cut -d: -f1)
gap=$(( line_b - line_a ))
[ "$gap" -gt 1 ] \
  && ok "ligne vide préservée entre A et B (gap=$gap)" \
  || fail "ligne vide supprimée (gap=$gap, attendu > 1)"

# T4 — append_section() : déduplique les lignes identiques
echo ""
echo "T4 — append_section() déduplique les doublons"
FILE="$TMP/test_dedup.md"
echo "# Dedup test" > "$FILE"
append_section "$FILE" "Pass1" "contenu duplique" "test" > /dev/null
append_section "$FILE" "Pass2" "contenu duplique" "test" > /dev/null
count=$(grep -c "contenu duplique" "$FILE" || true)
[ "$count" -eq 1 ] \
  && ok "1 seule occurrence après 2 appends" \
  || fail "doublon non supprimé ($count occurrences)"

# T5 — rotate_sessions() : garde exactement max sessions
echo ""
echo "T5 — rotate_sessions() garde 10 sessions max (depuis 12)"
FILE="$TMP/sessions.md"
{
  echo "# Sessions"
  echo ""
  echo "> Header"
  echo ""
  for i in $(seq 1 12); do
    echo ""
    echo "## Session $i"
    echo ""
    echo "Contenu session $i"
    echo ""
  done
} > "$FILE"
rotate_sessions "$FILE" 10
count=$(grep -c "^## Session" "$FILE" || true)
[ "$count" -eq 10 ] \
  && ok "10 sessions après rotation (était 12)" \
  || fail "rotation incorrecte ($count sessions, attendu 10)"
grep -q "^## Session 1$" "$FILE" \
  && fail "Session 1 supprimée — encore présente" \
  || ok  "Session 1 supprimée"
grep -q "^## Session 2$" "$FILE" \
  && fail "Session 2 supprimée — encore présente" \
  || ok  "Session 2 supprimée"
assert_contains "Session 12 présente" "## Session 12" "$(cat "$FILE")"

# ── Résultat ───────────────────────────────────────────────────────────────────
echo ""
echo "=== Résultat : $PASS ✅  $FAIL ❌ ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
