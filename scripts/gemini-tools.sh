#!/usr/bin/env bash
set -euo pipefail

# scripts/gemini-tools.sh — v1.0.0
# Centralized helper for Gemini CLI (Windows/Git Bash)
# Usage: bash scripts/gemini-tools.sh <command> [args]

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/config.env"
PROJECT="$(basename "$(pwd)")"

# --- Helpers ---

# Safe read with timeout (to avoid iCloud hangs on placeholders)
safe_read() {
    local f_path="$1"
    local f_name="$2"
    if [ -f "$f_path" ]; then
        echo "=== $f_name ==="
        if ! timeout 3s cat "$f_path" 2>/dev/null; then
            echo "[⚠️ ERREUR] Timeout lecture (iCloud en cours de synchro ?)"
        fi
        echo ""
    else
        echo "# $f_name — non trouvé"
        echo ""
    fi
}

# Git with no pager to avoid Gemini freezes
git_nopager() {
    git --no-pager "$@"
}

# --- Subcommands ---

case "${1:-help}" in
    close)
        echo "--- 📦 Synchronisation vault Obsidian ---"
        bash "$SCRIPT_DIR/obsidian-sync.sh"

        echo "--- 💾 Commit memory.md ---"
        git_nopager add memory.md
        git_nopager commit -m "chore: fin de session (auto-sync)" || echo "Aucun changement dans memory.md"

        echo "--- 🚀 Push vers origin ---"
        git_nopager push
        echo "--- ✅ Session close ---"
        ;;

    daily)
        ARG="${2:-3}"
        if [ "$ARG" = "today" ]; then
            TODAY="$(date +%Y/%m/%d)"
            safe_read "$DESPES_NOTES/_daily/$TODAY.md" "Daily note du $TODAY"
        elif [ "$ARG" = "all" ]; then
            find "$DESPES_NOTES/_daily" -name "*.md" | sort | xargs -r cat 2>/dev/null
        else
            find "$DESPES_NOTES/_daily" -name "*.md" | sort -r | head -"$ARG" | xargs -r cat 2>/dev/null
        fi
        ;;

    git)
        MODE="${2:-status}"
        case "$MODE" in
            status) git_nopager status ;;
            log)    git_nopager log -n 5 --oneline ;;
            diff)   git_nopager diff HEAD ;;
            all)
                echo "=== GIT STATUS ==="
                git_nopager status
                echo -e "
=== GIT LOG ==="
                git_nopager log -n 5 --oneline
                echo -e "
=== GIT DIFF ==="
                git_nopager diff HEAD
                ;;
            *)
                echo "Usage: $0 git [status|log|diff|all]"
                exit 1
                ;;
        esac
        ;;

    global)
        shift
        for f in "$@"; do
            safe_read "$GLOBAL_DIR/$f" "$f"
        done
        ;;

    notes)
        shift
        for f in "$@"; do
            safe_read "$DESPES_NOTES/$f" "$f"
        done
        ;;

    start)
        safe_read "${PROJECTS_DIR}/$PROJECT/index.md" "index.md"
        safe_read "${PROJECTS_DIR}/$PROJECT/architecture.md" "architecture.md"
        echo "=== GIT STATUS ==="
        git_nopager status
        echo -e "\n=== GIT LOG ==="
        git_nopager log --oneline -10
        ;;

    vault)
        shift
        for f in "$@"; do
            safe_read "${PROJECTS_DIR}/$PROJECT/$f" "$f"
        done
        ;;

    help|*)
        echo "Gemini Tools v1.0.0"
        echo "Usage: $0 <command> [args]"
        echo ""
        echo "Commands:"
        echo "  close          Sync vault, commit memory.md and push"
        echo "  daily [N|today|all]  Read daily notes (default: last 3)"
        echo "  git [status|log|diff|all]  Git helpers (no-pager)"
        echo "  global [files...]   Read files from _global/"
        echo "  notes [files...]    Read files from DespesNotes/"
        echo "  start               Initial session context"
        echo "  vault [files...]    Read files from current project vault"
        ;;
esac
