#!/bin/bash
# check_secrets.sh — Détecte les secrets dans les fichiers stagés
# Appelé par scripts/hooks/pre-commit (section 3)
# Scanne uniquement les fichiers stagés (pas l'historique entier)

REPO_ROOT="$(git rev-parse --show-toplevel)"

# Patterns de secrets connus
PATTERNS=(
  'sk-[A-Za-z0-9]{20,}'        # OpenAI / anciens Anthropic
  'sk-ant-[A-Za-z0-9\-_]{20,}' # Anthropic
  'ghp_[A-Za-z0-9]{36}'         # GitHub PAT classic
  'github_pat_[A-Za-z0-9_]{82}' # GitHub PAT fine-grained
  'AKIA[A-Z0-9]{16}'             # AWS Access Key
  'AIza[A-Za-z0-9\-_]{35}'      # Google API key
  'xoxb-[A-Za-z0-9\-]+'         # Slack bot token
  'xoxp-[A-Za-z0-9\-]+'         # Slack user token
  'xoxa-[A-Za-z0-9\-]+'         # Slack app token
)

# Fichiers stagés (ajoutés / modifiés uniquement, pas supprimés)
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)

if [[ -z "$STAGED_FILES" ]]; then
  exit 0
fi

FOUND=0

while IFS= read -r file; do
  # Ignorer les fichiers binaires et non-existants
  [[ ! -f "${REPO_ROOT}/$file" ]] && continue
  file "${REPO_ROOT}/$file" 2>/dev/null | grep -q "text" || continue

  # Lire le contenu stagé (pas le disque — pour les fichiers partiellement stagés)
  CONTENT=$(git show ":${file}" 2>/dev/null) || continue

  for pattern in "${PATTERNS[@]}"; do
    # Chercher le pattern, en excluant les faux positifs courants
    MATCHES=$(echo "$CONTENT" | grep -nE "$pattern" \
      | grep -vE '(EXAMPLE|FAKE|test|<[A-Z_]+>|#|placeholder|your_|YOUR_|xxx)' \
      | grep -v '\.gitignore')

    if [[ -n "$MATCHES" ]]; then
      echo "❌ Secret potentiel détecté dans : $file"
      echo "$MATCHES" | while IFS= read -r line; do
        echo "   → $line"
      done
      FOUND=$((FOUND + 1))
    fi
  done
done <<< "$STAGED_FILES"

if [[ "$FOUND" -gt 0 ]]; then
  echo ""
  echo "⛔ $FOUND secret(s) potentiel(s) détecté(s) — commit bloqué."
  echo "   Si c'est un faux positif, ajoutez EXAMPLE ou FAKE dans la ligne."
  exit 1
fi

echo "✅ Secrets OK — aucun token détecté ($(echo "$STAGED_FILES" | wc -l | tr -d ' ') fichier(s))"
exit 0
