#!/bin/bash
# safety-guard — Bloque les opérations destructives (hook PreToolUse global)
# Exit 2 = bloquant + message à Claude | Exit 0 = autorisé
# Python note : utiliser "python" (pas "python3" = stub Windows Store)

INPUT=$(cat)
TOOL=$(echo "$INPUT" | python -c "import sys,json; print(json.load(sys.stdin).get('tool_name',''))" 2>/dev/null)
CMD=$(echo "$INPUT" | python -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('command',''))" 2>/dev/null)

if [[ "$TOOL" == "Bash" ]]; then
  if echo "$CMD" | grep -qE 'rm\s+-rf\s+/'; then
    echo "BLOQUE: rm -rf / interdit. Utilise un chemin ciblé ou trash." >&2
    exit 2
  fi
  if echo "$CMD" | grep -qE 'git push.*(--force|-f)\b'; then
    echo "BLOQUE: git push --force interdit. Utilise --force-with-lease si necessaire." >&2
    exit 2
  fi
fi
exit 0
