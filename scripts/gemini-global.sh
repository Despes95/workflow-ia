#!/usr/bin/env bash
# Lit un ou plusieurs fichiers du vault global
# Usage: gemini-global.sh file1.md [file2.md ...]
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/config.env"
for f in "$@"; do
    path="$GLOBAL_DIR/$f"
    if [ -f "$path" ]; then
        echo "=== $f ==="
        cat "$path"
        echo ""
    else
        echo "# $f — non trouvé dans $GLOBAL_DIR/"
    fi
done
