# /close — Rituel de fin de journée

Fais d'abord `git status` + `git log --oneline -10` + `git diff HEAD~3..HEAD`.
À partir de l'historique git, infère ce qui s'est passé durant cette session.

Puis :
1. Extrais les action items depuis les commits et diffs
2. Identifie décisions (→ decisions.md)
3. Identifie bugs (→ bugs.md)
4. Identifie leçons (→ lessons.md, 🌐 si transversal)
5. Lis `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/Projects/$PROJECT_NAME/backlog.md`
   - Croise avec les commits de la session
   - Marque ✅ les items clairement terminés (préfixe la ligne du titre : `### ✅ F1. ...`)
   - Ne touche pas aux items partiels ou incertains
6. Montre le diff complet de memory.md que tu proposes
   - Si memory.md doit changer : écris les changements, puis enchaîne
   - Si memory.md est déjà à jour : enchaîne directement

7. Après analyse :
   a. Lance `bash scripts/obsidian-sync.sh` (génère callouts + wikilinks automatiquement)
   b. `git add memory.md && git commit -m "chore: fin de session" && git push`
      - Revois ce qui a été accompli et identifie les changements à reporter dans `docs/tutorial-valider.md`
      - Si le tuto général a évolué, mets à jour `docs/tutorial-valider.md` en conséquence

8. (Optionnel) Génération rapport HTML de session :
   Crée `reports/$(date +%Y-%m-%d)-session.html` avec :
   - En-tête résumé (titre, date, projet, nb commits de la session)
   - Mermaid flowchart des étapes accomplies
   - Liste des items backlog complétés (issues ✅)
   - CSS inline dark + CDN Mermaid + CDN Chart.js (zéro dépendance build)
   Structure minimale :
   ```html
   <!DOCTYPE html><html lang="fr"><head><meta charset="UTF-8">
   <script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
   <style>body{background:#1a1a2e;color:#eee;font-family:monospace;padding:2rem}
   h1{color:#7ec8e3}ul{line-height:2}.mermaid{background:#16213e;padding:1rem;border-radius:8px}</style>
   </head><body>
   <h1>Session — DATE — PROJET</h1>
   <p>Commits : N | Items complétés : M</p>
   <div class="mermaid">flowchart LR
     A[start] --> B[items] --> C[commit] --> D[push]
   </div>
   <ul><!-- items backlog ✅ --></ul>
   </body></html>
   ```
