---
description: Passage de relais vers une autre IA — handoff propre
---

Prépare un handoff propre. Contenu actuel de memory.md :
@memory.md

Exécute dans cet ordre :

1. Remplis la section `## 🧠 Momentum (Handoff)` dans memory.md :
   - Pensée en cours : l'idée que tu avais mais pas encore implémentée
   - Vibe / Style : comment tu raisonnais (fonctionnel ? défensif ? exploratoire ?)
   - Le prochain petit pas : l'action atomique exacte à faire en premier
   - Contexte chaud : ce que les fichiers ne disent pas encore mais qui compte

2. Mets à jour le reste de memory.md (Focus Actuel, Todo, Bugs si besoin)

3. Fais un commit :
   !git add memory.md && git commit -m "chore: handoff — momentum capturé"

4. Donne-moi le prompt bootstrap exact à coller dans l'IA suivante :
   ```
   Lis AGENTS.md puis memory.md (section Momentum en priorité).
   Lis _forge/workflow-ia/index.md + architecture.md.
   Reprise du momentum : [résumé d'une phrase].
   Adopte immédiatement le style : [vibe/style de la section Momentum].
   Commence par le prochain petit pas : [action atomique].
   Ne touche à aucun fichier avant confirmation.
   ```

5. Après confirmation de reprise par l'utilisateur : efface le contenu
   de la section `## 🧠 Momentum (Handoff)` dans memory.md
   (laisse le titre et les 5 lignes vides avec `—`).
