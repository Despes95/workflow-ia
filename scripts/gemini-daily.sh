#!/usr/bin/env bash
# Lit les N dernières daily notes, la note du jour, ou toutes en ordre chronologique
# Usage: gemini-daily.sh [N|today|all]  (défaut: 3)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/config.env"
ARG="${1:-3}"
if [ "$ARG" = "today" ]; then
    TODAY="$(date +%Y/%m/%d)"
    FILE="$DESPES_NOTES/_daily/$TODAY.md"
    if [ -f "$FILE" ]; then
        cat "$FILE"
    else
        echo "# Daily note du $TODAY — non trouvée"
    fi
elif [ "$ARG" = "all" ]; then
    find "$DESPES_NOTES/_daily" -name "*.md" | sort | xargs -r cat 2>/dev/null
else
    find "$DESPES_NOTES/_daily" -name "*.md" | sort -r | head -"$ARG" | xargs -r cat 2>/dev/null
fi
