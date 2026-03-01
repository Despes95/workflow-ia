#!/usr/bin/env bash
set -euo pipefail
# gemini-git-info.sh — Centralise les appels Git pour Gemini CLI
# Force --no-pager pour éviter les freezes sous Windows/PowerShell.
# Usage: bash scripts/gemini-git-info.sh [status|log|diff]

MODE="${1:-status}"

case "$MODE" in
  status)
    git --no-pager status
    ;;
  log)
    git --no-pager log -n 5 --oneline
    ;;
  diff)
    git --no-pager diff HEAD
    ;;
  all)
    echo "=== GIT STATUS ==="
    git --no-pager status
    echo -e "\n=== GIT LOG ==="
    git --no-pager log -n 5 --oneline
    echo -e "\n=== GIT DIFF ==="
    git --no-pager diff HEAD
    ;;
  *)
    echo "Usage: $0 [status|log|diff|all]"
    exit 1
    ;;
esac
