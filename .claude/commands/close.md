# /close — Rituel de fin de journée

Fais d'abord `git status` + `git log --oneline -10` + `git diff HEAD~3..HEAD`.
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
   a. Lance `bash scripts/obsidian-sync.sh` (génère callouts + wikilinks automatiquement)
   b. `git add memory.md && git commit -m "chore: fin de session" && git push`
      - Revois ce qui a été accompli et identifie les changements à reporter dans `docs/tutorial-valider.md`
      - Si le tuto général a évolué, mets à jour `docs/tutorial-valider.md` en conséquence
