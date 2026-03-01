---
description: Rituel de fin de journée — analyse session + sync vault + commit
---

Analyse la session en cours.

Données git :
!git status && git log --oneline -10 && git diff HEAD~3..HEAD

Contenu memory.md actuel :
@memory.md

À partir de l'historique git, infère ce qui s'est passé durant cette session.

Puis :
1. Extrais les action items depuis les commits et diffs
2. Identifie décisions (→ decisions.md)
3. Identifie bugs (→ bugs.md)
4. Identifie leçons (→ lessons.md, 🌐 si transversal)
5. Montre le diff complet de memory.md que tu proposes
   - Si memory.md doit changer : écris les changements, puis enchaîne
   - Si memory.md est déjà à jour : enchaîne directement

6. Après analyse :
   a. Lance : !bash scripts/obsidian-sync.sh
   b. Dans l'entrée sessions.md créée, remplis les callouts :
      - `> [!decision]` ← décisions identifiées
      - `> [!insight]` ← leçons identifiées
      - `> [!warning]` ← bugs / anti-patterns
   c. Ajoute les wikilinks dans l'entrée sessions.md :
      - Si décisions → `→ [[decisions]]`
      - Si bugs → `→ [[bugs]]`
      - Si leçons → `→ [[lessons]]`
   d. !git add memory.md && git commit -m "chore: fin de session" && git push
   e. Revois ce qui a été accompli et identifie les changements à reporter dans docs/tutorial-valider.md

7. (Optionnel) Génération rapport HTML de session :
   Crée `reports/$(date +%Y-%m-%d)-session.html` avec :
   - En-tête résumé (titre, date, projet, nb commits de la session)
   - Mermaid flowchart des étapes accomplies
   - Liste des items backlog complétés (issues ✅)
   - CSS inline dark + CDN Mermaid + CDN Chart.js (zéro dépendance build)