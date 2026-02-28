#!/usr/bin/env bash
set -euo pipefail
# gemini-close.sh — Finalise la session proprement (sync, add, commit, push)
# Force --no-pager pour éviter les freezes Gemini.

echo "--- 📦 Synchronisation vault Obsidian ---"
bash scripts/obsidian-sync.sh

echo "--- 💾 Commit memory.md ---"
# On n'ajoute que memory.md comme prévu par le workflow standard
git --no-pager add memory.md
# Commit seulement si changement, sinon continue sans erreur
git --no-pager commit -m "chore: fin de session (auto-sync)" || echo "Aucun changement dans memory.md"

echo "--- 🚀 Push vers origin ---"
git --no-pager push

echo "--- ✅ Session close ---"
