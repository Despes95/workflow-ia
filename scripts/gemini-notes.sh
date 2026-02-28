#!/usr/bin/env bash
# Lit un ou plusieurs fichiers de DespesNotes
# Usage: gemini-notes.sh file1.md [file2.md ...]
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/config.env"
for f in "$@"; do
    path="$DESPES_NOTES/$f"
    if [ -f "$path" ]; then
        echo "=== $f ==="
        cat "$path"
        echo ""
    else
        echo "# $f — non trouvé dans $DESPES_NOTES/"
    fi
done
