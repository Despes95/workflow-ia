#!/usr/bin/env bash
# vault-check.sh — Vérifie l'intégrité des wikilinks dans le vault
# Usage : bash scripts/vault-check.sh [vault-path]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/_commons.sh"
source "${SCRIPT_DIR}/config.env"

VAULT_PATH="${1:-${FORGE_DIR}}"

if [[ ! -d "$VAULT_PATH" ]]; then
  echo -e "${RED}❌ Vault non trouvé : $VAULT_PATH${NC}"
  exit 1
fi

echo -e "${CYAN}🔍 Vérification des wikilinks dans : $VAULT_PATH${NC}"
echo ""

ERRORS=0
LINKS_FOUND=0
ORPHANS=0

while IFS= read -r -d '' file; do
  while IFS= read -r line; do
    [[ "$line" =~ \[\[([^\]]+)\]\] ]] || continue
    link="${BASH_REMATCH[1]}"
    link_name="${link%%\|*}"
    
    LINKS_FOUND=$((LINKS_FOUND + 1))

    target=""
    if [[ -f "${VAULT_PATH}/${link_name}.md" ]]; then
      target="${VAULT_PATH}/${link_name}.md"
    elif [[ -d "${VAULT_PATH}/${link_name}" ]]; then
      target="${VAULT_PATH}/${link_name}/index.md"
    fi

    if [[ -z "$target" || ! -e "$target" ]]; then
      ORPHANS=$((ORPHANS + 1))
      ERRORS=$((ERRORS + 1))
      echo -e "${RED}  🔗 [[${link}]] → NON TROUVÉ${NC}"
      echo -e "     dans : ${file#$VAULT_PATH/}"
    fi
  done < <(grep -oP '\[\[[^\]]+\]\]' "$file" 2>/dev/null || true)
done < <(find "$VAULT_PATH" -name "*.md" -print0)

echo ""
echo -e "${CYAN}📊 Résumé :${NC}"
echo -e "   Liens trouvés : $LINKS_FOUND"
echo -e "   Orphelins    : $ORPHANS"

if [[ $ERRORS -eq 0 ]]; then
  echo ""
  echo -e "${GREEN}✅ Vault intègre — aucun lien cassé${NC}"
  exit 0
else
  echo ""
  echo -e "${YELLOW}⚠️  $ERRORS liens cassés trouvés${NC}"
  exit 1
fi
