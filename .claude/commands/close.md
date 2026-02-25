# /close — Rituel de fin de journée

Fais d'abord `git status` + `git log --oneline -5`.
Demande-moi ensuite : "Qu'est-ce qui s'est passé aujourd'hui ?"
Attends ma réponse, puis :

1. Extrais les action items de ma réponse
2. Identifie les décisions prises (candidates pour `decisions.md`)
3. Identifie les bugs rencontrés (candidats pour `bugs.md`)
4. Identifie les leçons (candidates pour `lessons.md` — marque 🌐 si transversal)
5. Montre-moi le diff `memory.md` que tu proposes

⚠️ Tu proposes les mises à jour, je valide, PUIS tu écris.
Ne modifie aucun fichier sans confirmation explicite de ma part.

6. Après validation, lance `bash scripts/obsidian-sync.sh`
7. Dans l'entrée sessions.md créée, remplis les callouts :
   - `> [!decision]` ← décisions identifiées en étape 2
   - `> [!insight]` ← leçons identifiées en étape 4
   - `> [!warning]` ← bugs / anti-patterns identifiés en étape 3
8. Dans l'entrée sessions.md, ajoute les [[wikilinks]] :
   - Si des décisions ont été prises → `→ [[decisions]]`
   - Si des bugs ont été rencontrés → `→ [[bugs]]`
   - Si des leçons ont été identifiées → `→ [[lessons]]`
9. Commit et push :
   `git add memory.md && git commit -m "chore: fin de session" && git push`
