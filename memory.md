# workflow-ia — Memory

**Dernière mise à jour :** 2026-02-27 (fix Gemini date dynamique + architecture.md vault synchro)
**Dernier outil CLI utilisé :** Claude Code

---

## 🎯 Focus Actuel

- **Mission en cours** : Session terminée — fix Gemini date dynamique (check-in/wins) + architecture.md vault 31 cmds
- **Prochaine étape** : Appliquer rapport A (scripts) + rapport B (vault canonique)
- **Zone sensible** : AGENTS.md — ne pas modifier sans validation
- **État git** : Propre (commit 6808b43)

---

## 🧠 Momentum (Handoff)

—

---

## 🏗️ Architecture

- **Objectif** : Projet test pour valider le workflow IA du tuto v2.6
- **Stack** : Markdown + Git Bash + Windows 11
- **Workflow dev** : Lire tuto → créer fichiers → vérifier → commit

---

## 📁 Fichiers clés

- `AGENTS.md` — règles communes à tous les outils IA — Stable
- `CLAUDE.md` — directive @AGENTS.md + règles spécifiques Claude — Stable
- `docs/tutorial-optimisation-v2.6.md` — référence tuto (lecture seule) — Stable
- `docs/prompts-et-commandes.md` — référence opérationnelle 28 commandes — Stable
- `docs/commands-list.cmd` — Windows batch, affiche 28 commandes — Stable
- `scripts/obsidian-sync.sh` — sync memory.md → vault Obsidian — Stable
- `scripts/check_memory.sh` — garde-fou intégrité memory.md — Stable
- `.claude/commands/*.md` — 28 custom slash commands Claude — Stable
- `.gemini/commands/*.toml` — 28 commands Gemini CLI (TOML) — Stable
- `.opencode/commands/*.md` — 28 commands OpenCode (MD) — Stable
- `docs/improve.md` — rapport d'analyse + propositions d'amélioration — Nouveau
- `README.md` — documentation principale — Nouveau
- `.gitignore` — exclusions standards — Nouveau
- `new-project.cmd` — launcher Windows bootstrap — Stable
- `scripts/new-project.sh` — script bootstrap complet — Stable

---

## 📜 Récap sessions (5 max)

### Résumé global

- Stack complète : 28 commands × 3 outils (Claude/Gemini/OpenCode), vault Obsidian, bootstrapper.
- DespesNotes intégré : commands PENSÉE lisent `_daily/`.
- Nouvelles commands DEV : `/improve` (améliorations tech) + `/audit` (bugs/refactor).

### Historique

- 2026-02-27 | Claude Code | Fix Gemini date dynamique (check-in/wins) + architecture.md vault 31 cmds | Stable
- 2026-02-27 | Claude Code | 3 cmds (check-in/debug/wins) + reorganisation SESSION/PROJET/VAULT + 3 rapports improve.md | Stable
- 2026-02-27 | Claude Code | 5 améliorations high-priority : check 28 cmds, set -e, callouts+wikilinks auto, /close simplifié, section Décisions | Stable
- 2026-02-27 | OpenCode    | Analyse /improve + rapport 23 propositions (high/medium/low) | Stable
- 2026-02-26 | Gemini CLI  | Fix sécurité injections absolues (!{type}) + deploy global | Stable

---


## 🐛 Bugs connus

- `/check-in` et `/wins` Gemini : path daily notes désormais dynamique via PowerShell `Get-Date` — résolu 2026-02-27
- `/close` "Unknown skill" résolu : il fallait relancer Claude Code après install --global
- OpenCode custom slash commands : ne fonctionnent pas en mode non-interactif (`opencode run`) — utiliser le mode interactif 🌐
- Gemini CLI Absolute Path Security : résolu en utilisant `!{type \"...\"}` au lieu de `@{...}` pour les fichiers hors workspace. 🌐

---

## 📝 Leçons apprises

- Gemini CLI : les chemins absolus hors workspace sont interdits avec `@{}`. Utiliser `!{type \"...\"}` (Windows) ou `!{cat ...}` (Linux/Mac) pour contourner la sécurité via le shell. 🌐
- PowerShell dans .toml Gemini : attention aux échappements de quotes et aux pipes (`\|`). 🌐
- Custom commands visibles seulement si `claude` lancé depuis le dossier contenant `.claude/commands/` — utiliser `install-commands.sh` pour un accès global 🌐
- ~/.gemini/settings.json avait une section security.auth à préserver — toujours lire avant d'écraser
- git subtree split réécrit les SHA — les anciens SHA (0ccee34, af2f545, ecb24b2) ne sont plus valides, remplacés par (c76414b, 31faaff, 7ed0855)
- Tous les AIs (Claude, Gemini, OpenCode) ont les mêmes capacités sur le vault — prompt fin-de-session unifié (obsidian-sync + wikilinks + push) 🌐
- Pattern grep de check_memory.sh doit correspondre au titre de section exact — un mot-clé court capte aussi les champs volatiles (ex: "Contraintes" → faux positif) 🌐
- `~/.claude/commands/` global : "Unknown skill" se résout en relançant Claude Code — toujours redémarrer après install 🌐
- Commands multi-outils : adapter le format par outil (`{{args}}`/Gemini, `$ARGUMENTS`/OpenCode) mais le contenu prompt reste identique 🌐
- `install-commands.sh` couvre automatiquement les nouveaux fichiers via glob `*.md`/`*.toml` — pas besoin de modifier le script pour les nouvelles commandes 🌐
- `normalize_path()` avec BASH_REMATCH = pattern propre pour convertir `C:\foo` → `/c/foo` dans un script bash appelé depuis .cmd Windows 🌐
- Bootstrap d'un template : tester avec un projet jetable avant commit — vérifier sed + counts en une passe, puis `rm -rf` 🌐
- OpenCode custom slash commands : nécessitent le mode interactif — `opencode run` ne les reconnaît pas 🌐
- PowerShell `Get-Date -Format 'yyyy/MM/dd'` dans les TOML Gemini : seule solution fiable Windows pour dates dynamiques — `!{type + date fixe}` est un anti-pattern 🌐
- OpenCode dossier global Windows : `%APPDATA%\opencode\commands\` (pas ~/.config/) 🌐
- OpenCode : `/start`, `/stranger`, `/close` testés et fonctionnent en mode interactif `opencode .` 🌐
- Commands pensée : ajouter le chemin DespesNotes `_daily/` enrichit le contexte avec les notes personnelles 🌐
- Nouvelles commands DEV : `/improve` (améliorations tech) + `/audit` (bugs/refactor) — lecture seule
- commands-list.cmd : ém-dash cause erreurs CMD Windows — utiliser ASCII uniquement 🌐
- Commande `/improve` : analyse structurée par catégories (Code, Archi, Perf, Maintenabilité, Bonnes pratiques) + tri par impact (high/medium/low) — output directement intégrable dans memory.md 🌐
- `"Sibling tool call errored"` : causé par lecture explicite du path auto-memory MEMORY.md inexistant — ne jamais lire ce path, il est chargé automatiquement si présent 🌐
- Hook `.git/hooks/pre-commit` et `check_memory.sh` sont deux scripts indépendants à maintenir en sync manuellement — toujours modifier les deux ensemble 🌐
- `install-commands.sh --all` : nouvelles commandes actives immédiatement dans Claude Code sans redémarrage si déployées globalement 🌐

---

## 📚 Décisions

- [aucune décision enregistrée]

---

## ⛔ Contraintes & Interdits

- Ne jamais modifier AGENTS.md sans validation explicite

---

