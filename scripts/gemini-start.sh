#!/usr/bin/env bash
# scripts/gemini-start.sh — v2.6.1
# Consolidated helper for /start command — with iCloud timeouts

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/config.env"
PROJECT="$(basename "$(pwd)")"

# Helper for safe reading with timeout (to avoid iCloud hangs)
safe_read() {
    local f_path="$1"
    local f_name="$2"
    echo "=== VAULT: $f_name ==="
    if [ -f "$f_path" ]; then
        # Timeout 3s to avoid freezing if file is an offline cloud placeholder
        if ! timeout 3s cat "$f_path"; then
            echo "[⚠️ ERREUR] Timeout lecture (iCloud en cours de synchro ?)"
        fi
    else
        echo "$f_name non trouvé"
    fi
    echo ""
}

safe_read "$FORGE_DIR/$PROJECT/index.md" "index.md"
safe_read "$FORGE_DIR/$PROJECT/architecture.md" "architecture.md"

echo "=== GIT STATUS ==="
git --no-pager status
echo ""

echo "=== GIT LOG ==="
git --no-pager log --oneline -10
echo ""
