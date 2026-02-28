#!/bin/bash
set -euo pipefail
# check_memory.sh — Garde-fou intégrité de memory.md
FILE="memory.md"
ERRORS=0
echo "🔍 Vérification de $FILE..."
[ ! -f "$FILE" ] && echo "❌ ERREUR : $FILE introuvable" && exit 1

SECTIONS=("Focus Actuel" "Architecture" "Récap sessions" "Bugs connus" "Leçons apprises" "Contraintes & Interdits")
for section in "${SECTIONS[@]}"; do
  count=$(grep -c "$section" "$FILE" 2>/dev/null || true); count=${count:-0}
  [ "$count" -gt 1 ] && echo "❌ DOUBLON : '$section' ($count fois)" && ERRORS=$((ERRORS+1))
done

# F3 — Vérification des 8 emojis d'ancrage (utilisés par obsidian-sync.sh)
ANCHORS=("🎯" "🏗️" "📁" "📜" "🐛" "📝" "📚" "⛔")
for emoji in "${ANCHORS[@]}"; do
  found=0
  while IFS= read -r line; do
    if [[ "$line" =~ ^## ]] && [[ "$line" == *"$emoji"* ]]; then
      found=1; break
    fi
  done < "$FILE"
  [ "$found" -eq 0 ] && echo "❌ ANCRE MANQUANTE : '$emoji' absent d'un ## header" && ERRORS=$((ERRORS+1))
done

lines=$(wc -l < "$FILE")
[ "$lines" -gt 120 ] && echo "⚠️  $lines lignes (limite recommandée : 100)"

if [ "$ERRORS" -eq 0 ]; then
  echo "✅ memory.md OK ($lines lignes, aucun doublon)"; exit 0
else
  echo "⛔ $ERRORS problème(s) — réécrire memory.md en entier (Read → modifier → Write)"; exit 1
fi
