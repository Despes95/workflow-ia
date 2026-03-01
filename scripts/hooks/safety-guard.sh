#!/bin/bash
# safety-guard — Bloque les opérations destructives (hook PreToolUse global)
# Exit 2 = bloquant + message à Claude | Exit 0 = autorisé
# Python note : utiliser "python" (pas "python3" = stub Windows Store)

INPUT=$(cat)
TOOL=$(echo "$INPUT" | python -c "import sys,json; print(json.load(sys.stdin).get('tool_name',''))" 2>/dev/null)
CMD=$(echo "$INPUT" | python -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('command',''))" 2>/dev/null)

if [[ "$TOOL" == "Bash" ]]; then
  # Verifier uniquement le premier token pour eviter les faux positifs
  # (commit messages, echo/printf contenant des patterns dangereux)
  FIRST_TOKEN=$(echo "$CMD" | awk '{print $1}')

  # Bloquer rm seulement si rm EST la commande (premier token)
  if [[ "$FIRST_TOKEN" == "rm" ]]; then
    if echo "$CMD" | grep -qE 'rm[[:space:]].*-[rf]*rf?[[:space:]]+/[[:space:]]*(\*|$)'; then
      echo "BLOQUE: rm -rf / interdit. Utilise un chemin ciblé." >&2
      exit 2
    fi
  fi
  # Force push : couvert par les deny rules settings.local.json
fi
exit 0
