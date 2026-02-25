# workflow-ia — Règles communes (OpenCode · Gemini CLI · Claude Code)

## Comportement général

- Tu réponds TOUJOURS en français, sans exception
- Toujours lire `memory.md` en PREMIER avant d'agir
- Git First : `git status` + `git diff` + `git log --oneline -10` avant toute action
- Commits autonomes aux checkpoints (feature, refactor, bug, fin session)
- Marqueurs de maturité : `Stable` / `En cours` / `Expérimental` / `Déprécié`
- Historique memory.md : 5 entrées max

## Règles Git

- Ne jamais committer sans inclure memory.md
- Un commit par checkpoint logique
- Format : `type: description courte` (feat, fix, refactor, chore, docs)

## Garde-fous

- Ne jamais modifier un fichier sans montrer le diff d'abord
- Toujours montrer un plan avant tout refactor ou suppression de fichier
- Ne toucher à aucun fichier tant que l'utilisateur n'a pas confirmé

## Modes de session

- **Mode complet** : `/my-world` → dev → `/close` → push
- **Mode rapide** : `/context` → action → `/close`
- **Mode urgence** : `/context` → action → commit manuel

## Vault Obsidian

Le vault `_forge/workflow-ia/` contient la mémoire long terme du projet.
Chemin d'accès direct : `C:\Users\Despes\iCloudDrive\iCloud~md~obsidian\_forge\workflow-ia\`

Fichiers à lire en début de session si le contexte est flou :
- `index.md` → point d'entrée, liens vers tout le reste
- `architecture.md` → état de l'archi et fichiers clés
- `sessions.md` → historique chronologique
- `decisions.md` → pourquoi telle archi, alternatives rejetées
- `bugs.md` → bugs résolus et patterns à éviter
- `lessons.md` → leçons réutilisables

Règle d'or : tu lis le vault, tu ne l'écris pas sans validation explicite.

## Règle de reprise (Handoff)

Si la section `## 🧠 Momentum (Handoff)` de `memory.md` n'est **pas vide** :
- Adopte immédiatement le style et l'intention décrits
- Ta première réponse commence par : "Reprise du momentum : [résumé d'une phrase]"
- **Ne commence pas à coder avant que l'utilisateur ait confirmé la reprise**
- Une fois confirmé : remets les 5 lignes à `—` (garde le titre, efface le contenu)
  pour éviter toute confusion dans les sessions suivantes
