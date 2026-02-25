# /close — Rituel de fin de journée

Fais d'abord `git status` + `git log --oneline -10` + `git diff HEAD~3..HEAD`.
À partir de l'historique git, infère ce qui s'est passé durant cette session.

Puis :
1. Extrais les action items depuis les commits et diffs
2. Identifie les décisions prises (candidates pour `decisions.md`)
3. Identifie les bugs rencontrés (candidats pour `bugs.md`)
4. Identifie les leçons (candidates pour `lessons.md` — marque 🌐 si transversal)
5. Montre le diff `memory.md` que tu proposes
   - Si memory.md doit changer : écris les changements, puis enchaîne
   - Si memory.md est déjà à jour : enchaîne directement

6. Lance `bash scripts/obsidian-sync.sh`
7. Dans l'entrée sessions.md créée, remplis les callouts :
   - `> [!decision]` ← décisions identifiées en étape 2
   - `> [!insight]` ← leçons identifiées en étape 4
   - `> [!warning]` ← bugs / anti-patterns identifiés en étape 3
8. Dans l'entrée sessions.md, ajoute les [[wikilinks]] :
   - Si des décisions ont été prises → `→ [[decisions]]`
   - Si des bugs ont été rencontrés → `→ [[bugs]]`
   - Si des leçons ont été identifiées → `→ [[lessons]]`
9. Commit et push (si remote configuré) :
   `git add memory.md && git commit -m "chore: fin de session" && git remote | grep -q . && git push || true`
