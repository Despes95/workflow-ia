#!/usr/bin/env bash
# Lit un ou plusieurs fichiers du vault projet courant
# Usage: gemini-vault.sh file1.md [file2.md ...]
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/config.env"
PROJECT="$(basename "$(pwd)")"
for f in "$@"; do
    path="$FORGE_DIR/$PROJECT/$f"
    if [ -f "$path" ]; then
        echo "=== $f ==="
        cat "$path"
        echo ""
    else
        echo "# $f — non trouvé dans $FORGE_DIR/$PROJECT/"
    fi
done
