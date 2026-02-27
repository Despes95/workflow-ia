# workflow-ia — Memory

**Dernière mise à jour :** 2026-02-27 (Rapport D + fix CMD ASCII + improve.md épuré)
**Dernier outil CLI utilisé :** Claude Code

---

## 🎯 Focus Actuel

- **Mission en cours** : Rapport D documenté + fix CMD + improve.md épuré
- **Prochaine étape** : D1 créer `DespesNotes/Polaris.md` (manuel) → D2 `/focus`
- **Zone sensible** : AGENTS.md — ne pas modifier sans validation
- **État git** : Propre (35510de)

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
- `docs/prompts-et-commandes.md` — référence opérationnelle 31 commandes — Stable
- `docs/commands-list.cmd` — Windows batch, affiche 31 commandes — Stable
- `scripts/obsidian-sync.sh` — sync memory.md → vault Obsidian — Stable
- `scripts/check_memory.sh` — garde-fou intégrité memory.md — Stable
- `.claude/commands/*.md` — 31 custom slash commands Claude — Stable
- `.gemini/commands/*.toml` — 31 commands Gemini CLI (TOML) — Stable
- `.opencode/commands/*.md` — 31 commands OpenCode (MD) — Stable
- `docs/improve.md` — backlog actif améliorations — Stable
- `scripts/hooks/pre-commit` — hook versionné (délègue à check_memory.sh) — Stable
- `scripts/_commons.sh` — couleurs ANSI partagées — Stable
- `README.md` — documentation principale — Nouveau
- `.gitignore` — exclusions standards — Nouveau
- `new-project.cmd` — launcher Windows bootstrap — Stable
- `scripts/new-project.sh` — script bootstrap complet — Stable

---

## 📜 Récap sessions (5 max)

### Résumé global

- Stack complète : 31 commands × 3 outils (Claude/Gemini/OpenCode), vault Obsidian, bootstrapper.
- Catégories SESSION/PROJET/VAULT. DespesNotes `_daily/` intégré dans commandes VAULT.
- Infrastructure : hooks versionnés, _commons.sh, obsidian-sync refactorisé, rotation 10 sessions, _global auto.

### Historique

- 2026-02-27 | Claude Code | Rapport D (Polaris/focus/caching), fix CMD ASCII, improve.md épuré | Stable
- 2026-02-27 | Claude Code | Rapports A+B : hooks, _commons.sh, obsidian-sync refactorisé, _global, rotation 10 | Stable
- 2026-02-27 | Claude Code | Fix Gemini date dynamique + drift 26→31 + SESSION/PROJET/VAULT | Stable
- 2026-02-27 | Claude Code | 5 améliorations high-priority + 3 cmds check-in/debug/wins | Stable
- 2026-02-27 | OpenCode    | Analyse /improve + rapport 23 propositions (high/medium/low) | Stable

---


## 🐛 Bugs connus

- `grep "🌐"` dans obsidian-sync.sh retourne vide sur Windows Git Bash — `_global/lessons.md` non alimenté (bug encodage UTF-8 dans pipes) — ouvert
- OpenCode custom slash commands : ne fonctionnent pas en mode non-interactif (`opencode run`) — utiliser le mode interactif 🌐

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
- `chcp 65001` dans CMD Windows ne protège pas contre les U+2500 box-drawing — utiliser ASCII pur dans tous les .cmd 🌐
- Pattern "Polaris" : sans boussole stable (priorités / valeurs), les recommandations IA restent génériques — un fichier Polaris.md change ça 🌐
- `improve.md` doit rester un backlog actif ≤ 1 page — l'historique va dans le vault, pas dans le fichier 🌐
- Analyser articles externes (blogs Anthropic, créateurs) = source d'idées structurées pour `/improve` — systématiser en session dédiée 🌐
- `install-commands.sh --all` : nouvelles commandes actives immédiatement dans Claude Code sans redémarrage si déployées globalement 🌐

---

## 📚 Décisions

- `improve.md` = backlog actif uniquement (≤ 1 page) — historique dans vault `features.md`
- U+2500 box-drawing interdits dans tous les `.cmd` Windows — ASCII pur obligatoire
- Hook pre-commit versionné dans `scripts/hooks/` — source unique via `check_memory.sh`

---

## ⛔ Contraintes & Interdits

- Ne jamais modifier AGENTS.md sans validation explicite

---

