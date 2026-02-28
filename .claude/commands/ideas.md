# /ideas — Inbox QuestionsIA avec routing intelligent + patterns du projet courant

## Phase 0 — Inbox QuestionsIA

Lis d'abord : `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/_global/index.md`
Puis : `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/_global/QuestionsIA.md`

Projets actifs connus (depuis index.md) :
- `workflow-ia` — stack IA + Obsidian + bash, workflow dev quotidien
- `nexus_hive` — orchestrateur multi-agents
- `openfun` — projet openfun

Si QuestionsIA.md contient des URLs ou des idées :
- Pour chaque item : fetch le README ou la page principale si c'est une URL
- Routing intelligent — classe avec :
  - 🔧 Amélioration d'un projet existant → précise lequel parmi les projets actifs
  - 🚀 Idée de nouveau projet dev/tech → `_global/ideas.md`
  - 💰 Idée SaaS / business / source de revenu → `_global/saas-ideas.md`
  - ❌ Hors scope → une ligne d'explication, pas d'ajout

Rapport par item :
> **[URL ou idée]** — [description 1-2 lignes]
> → 🔧 [projet] | 🚀 futur projet | 💰 SaaS/business | ❌ hors scope
> → `[item backlog concis]`

Après le rapport :
- Items 🔧 → ajoute dans `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/[projet]/backlog.md`
- Items 🚀 → ajoute dans `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/_global/ideas.md`
- Items 💰 → ajoute dans `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/_global/saas-ideas.md`
- Supprime tous les items traités de `QuestionsIA.md`

Si QuestionsIA.md est vide : passe directement à Phase 1.

## Phase 1 — Patterns du projet courant

Détermine d'abord le PROJECT_NAME depuis le dossier de travail actuel (basename du chemin).
Ex : si tu es dans `/c/IA/Projects/workflow-ia`, PROJECT_NAME = `workflow-ia`.

Lis :
1. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/DespesNotes/_daily/` (15 dernières notes)
2. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/sessions.md` (30 dernières entrées)
3. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/lessons.md`
4. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/ideas.md`
5. `memory.md`

Analyse les patterns récurrents et les problèmes contournés plutôt que résolus.

Propose 3 angles d'amélioration, format :
> "D'après les sessions de [période], tu contournes [problème] via [méthode].
> Une solution structurelle serait [proposition concrète]."

⚠️ Seules 2 modifications autorisées : ajouter aux fichiers cibles et supprimer les items traités de `QuestionsIA.md`.
