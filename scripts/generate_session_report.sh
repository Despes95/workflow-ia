#!/bin/bash
# generate_session_report.sh — Génère reports/YYYY-MM-DD-session.html
# Appelé par /close étape 8
# Usage : bash scripts/generate_session_report.sh

REPO_ROOT="$(git rev-parse --show-toplevel)"
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M)
PROJECT=$(basename "$REPO_ROOT")
OUTPUT="${REPO_ROOT}/reports/${DATE}-session.html"

# ── Commits de la session ─────────────────────────────────────────────────────
# Depuis le dernier commit "fin de session", sinon les 15 derniers
LAST_CLOSE_HASH=$(git --no-pager log --oneline | grep -m1 "fin de session" | awk '{print $1}')
if [[ -n "$LAST_CLOSE_HASH" ]]; then
  COMMITS=$(git --no-pager log --oneline "${LAST_CLOSE_HASH}..HEAD")
else
  COMMITS=$(git --no-pager log --oneline -15)
fi

NB_COMMITS=$(echo "$COMMITS" | grep -c .)
if [[ "$NB_COMMITS" -eq 0 ]]; then
  echo "⚠️  Aucun commit depuis la dernière session — rapport non généré"
  exit 0
fi

# ── Helpers ───────────────────────────────────────────────────────────────────

# Sanitise un message pour Mermaid : supprime les chars dangereux, 38 chars max
sanitize_mermaid() {
  # Supprimer guillemets + backslash (cassent Mermaid), remplacer emojis par rien
  echo "$1" \
    | LC_ALL=C sed 's/["\`\\]//g' \
    | LC_ALL=C sed "s/'//g" \
    | LC_ALL=C sed 's/[^[:print:]]//g' \
    | cut -c1-38
}

# ── Flowchart Mermaid ─────────────────────────────────────────────────────────
MERMAID_NODES=""
MERMAID_EDGES=""
i=1
prev_id=""
while IFS= read -r commit; do
  [[ -z "$commit" ]] && continue
  msg=$(echo "$commit" | cut -d' ' -f2-)
  clean=$(sanitize_mermaid "$msg")
  id="C${i}"
  MERMAID_NODES+="  ${id}[\"${clean}\"]\n"
  [[ -n "$prev_id" ]] && MERMAID_EDGES+="  ${prev_id} --> ${id}\n"
  prev_id="$id"
  i=$((i+1))
done <<< "$COMMITS"

# ── Liste <li> des commits ────────────────────────────────────────────────────
LI_ITEMS=""
while IFS= read -r commit; do
  [[ -z "$commit" ]] && continue
  msg=$(echo "$commit" | cut -d' ' -f2-)
  # Échapper HTML basique
  msg_esc=$(echo "$msg" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')
  LI_ITEMS+="    <li>${msg_esc}</li>\n"
done <<< "$COMMITS"

# ── Génération HTML ───────────────────────────────────────────────────────────
mkdir -p "${REPO_ROOT}/reports"

{
echo '<!DOCTYPE html>'
echo '<html lang="fr">'
echo '<head>'
echo '  <meta charset="UTF-8">'
echo '  <meta name="viewport" content="width=device-width, initial-scale=1.0">'
echo "  <title>Session ${DATE} — ${PROJECT}</title>"
echo '  <script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>'
echo '  <style>'
echo '    * { box-sizing: border-box; margin: 0; padding: 0; }'
echo '    body { background: #0d1117; color: #c9d1d9; font-family: "Courier New", monospace;'
echo '           padding: 2rem; line-height: 1.6; max-width: 900px; margin: 0 auto; }'
echo '    h1 { color: #58a6ff; font-size: 1.4rem; margin-bottom: 0.5rem; }'
echo '    .meta { color: #8b949e; font-size: 0.85rem; margin-bottom: 2rem; }'
echo '    .badge { background: #21262d; border: 1px solid #30363d; padding: 2px 10px;'
echo '             border-radius: 12px; margin-right: 0.8rem; }'
echo '    h2 { color: #7ee787; font-size: 0.8rem; margin: 2rem 0 0.8rem;'
echo '         text-transform: uppercase; letter-spacing: 0.12em; }'
echo '    .mermaid { background: #161b22; padding: 1.5rem; border-radius: 8px;'
echo '               border: 1px solid #30363d; overflow-x: auto; }'
echo '    ul { list-style: none; }'
echo '    li { background: #161b22; border: 1px solid #30363d; border-radius: 6px;'
echo '         padding: 0.45rem 1rem; margin-bottom: 0.35rem; font-size: 0.88rem; }'
echo '    li::before { content: "→ "; color: #f78166; }'
echo '    footer { margin-top: 3rem; padding-top: 1rem; border-top: 1px solid #21262d;'
echo '             color: #484f58; font-size: 0.75rem; }'
echo '  </style>'
echo '</head>'
echo '<body>'
echo "  <h1>Session — ${DATE} — ${PROJECT}</h1>"
echo '  <div class="meta">'
echo "    <span class=\"badge\">commits : ${NB_COMMITS}</span>"
echo "    <span class=\"badge\">heure : ${TIME}</span>"
echo '  </div>'
echo '  <h2>Flowchart</h2>'
echo '  <div class="mermaid">'
echo 'flowchart LR'
printf "%b" "$MERMAID_NODES"
printf "%b" "$MERMAID_EDGES"
echo '  </div>'
echo '  <h2>Commits de la session</h2>'
echo '  <ul>'
printf "%b" "$LI_ITEMS"
echo '  </ul>'
echo "  <footer>workflow-ia · generate_session_report.sh · ${DATE}</footer>"
echo '  <script>mermaid.initialize({ startOnLoad: true, theme: "dark" });</script>'
echo '</body>'
echo '</html>'
} > "$OUTPUT"

echo "✅ Rapport HTML : reports/${DATE}-session.html"
