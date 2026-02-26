---
description: Sauvegarde complète du système — vault + git
---

Exécute dans l'ordre :

1. Lance la sync Obsidian :
   !bash scripts/obsidian-sync.sh

2. Commit memory.md :
   !git add memory.md && git commit -m "chore: backup session"

3. Push le repo :
   !git push

4. Confirme : "✅ Sauvegarde terminée — vault + git à jour"

⚠️ Si git push échoue (pas de remote configuré), arrête et signale l'erreur.
