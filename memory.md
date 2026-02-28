# workflow-ia — Memory

**Dernière mise à jour :** 2026-02-28 (D1 Polaris.md créé, D2 /focus × 3 outils déployé)
**Dernier outil CLI utilisé :** Claude Code

---

## 🎯 Focus Actuel

- **Mission en cours** : D1 ✅ Polaris.md, D2 ✅ /focus × 3 outils (Claude/Gemini/OpenCode) déployés
- **Prochaine étape** : C-reste (template daily note) → A-reste (snapshot partiel sessions.md)
- **Zone sensible** : AGENTS.md — ne pas modifier sans validation
- **État git** : À jour — /focus ajouté (32 commandes)

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
- `vault/backlog.md` — backlog actif améliorations (vault, hors repo) — Stable
- `scripts/hooks/pre-commit` — hook versionné (délègue à check_memory.sh) — Stable
- `scripts/_commons.sh` — couleurs ANSI partagées — Stable
- `README.md` — documentation principale — Nouveau
- `.gitignore` — exclusions standards — Nouveau
- `new-project.cmd` — launcher Windows bootstrap — Stable
- `scripts/new-project.sh` — script bootstrap complet — Stable
- `scripts/config.env` — chemins vault portables ($HOME-based) — Stable

---

## 📜 Récap sessions (5 max)

### Résumé global

- Stack complète : 32 commands × 3 outils (Claude/Gemini/OpenCode), vault Obsidian, bootstrapper.
- Catégories SESSION/PROJET/VAULT. DespesNotes `_daily/` intégré dans commandes VAULT.
- Infrastructure : hooks versionnés, _commons.sh, obsidian-sync refactorisé, rotation 10 sessions, _global auto.

### Historique

- 2026-02-28 | Claude Code | D1 Polaris.md + D2 /focus × 3 outils, 32 commandes | Stable
- 2026-02-28 | Claude Code | Fix 28 .toml Gemini $env:→bash, README config.env, backlog ✅ 6 items | Stable
- 2026-02-28 | Claude Code | QuestionsIA inbox → /ideas routing 🔧🚀💰, GitHub MCP, audit 6 commandes | Stable
- 2026-02-28 | Claude Code | F1/F2/F3/E2/D3/B-reste — vault infra : dédup, hooks, ancres, portabilité, cache, UTF-8 | Stable
- 2026-02-27 | Claude Code | Rapports E+F — backlog.md vault, /improve enrichi (bugs+backlog), dédup planned | Stable

---


## 🐛 Bugs connus

- `grep "🌐"` dans obsidian-sync.sh retourne vide sur Windows Git Bash — résolu via `while read` bash native (B-reste)
- OpenCode custom slash commands : ne fonctionnent pas en mode non-interactif (`opencode run`) — utiliser le mode interactif 🌐

---

## 📝 Leçons apprises

- Gemini CLI : les chemins absolus hors workspace sont interdits avec `@{}`. Utiliser `!{type \"...\"}` (Windows) ou `!{cat ...}` (Linux/Mac) pour contourner la sécurité via le shell. 🌐
- Migration Gemini → `$env:FORGE_DIR/$env:PROJECT_NAME` casse tout : ces vars PowerShell ne sont jamais définies. Pattern correct : `!{bash -c 'source scripts/config.env; cat "$FORGE_DIR/$(basename $(pwd))/file.md"'}` 🌐
- Windows Git Bash : `python3` = stub Windows Store (exit 49) → utiliser `python` (3.11 disponible via PATH) 🌐
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
- Rapports IA génériques (MiniMax/Gemini) : filtrer par ROI et contexte — 1 bonne idée retenue sur 8 en moyenne 🌐
- `backlog.md` dans le vault = bonne place pour la planification — le repo git = code + config uniquement 🌐
- `/improve` sans lecture préalable de bugs.md + backlog.md = analyse hors contexte → résultats génériques 🌐
- Gemini `!{bash -c "cat ...$(basename $(pwd))/..."}` = résolution dynamique du nom de projet 🌐
- `git config core.hooksPath scripts/hooks` = alternative élégante à la copie dans `.git/hooks/` (F2) 🌐
- `grep` sur emojis UTF-8 échoue dans tous les modes de pipe Git Bash (-a, -F, -P, LC_ALL) — seule solution : `[[ "$line" == *emoji* ]]` bash native 🌐
- Gemini CLI Windows : `!{bash -c 'source ...; cmd'}` casse sous PowerShell. Solution : scripts helpers `scripts/gemini-*.sh` appelés via `!{bash scripts/gemini-vault.sh file.md}` — commande simple, PowerShell ne l'interprète pas 🌐
- `awk 'NF && !seen[$0]++'` + écriture atomique `.tmp`/`mv` = dédup robuste compatible `set -euo pipefail` 🌐
- `$ARGUMENTS`/`{{args}}` en début de prompt = cache miss — toujours en dernière ligne des custom commands 🌐
- GitHub MCP : `@github/mcp-server` absent de npm — utiliser `@modelcontextprotocol/server-github` (déprécié mais fonctionnel) ou Docker/binaires GitHub 🌐
- QuestionsIA.md : inbox opérationnel → appartient à `_forge/_global/`, pas `DespesNotes/` (sémantique : capture IA ≠ note perso) 🌐
- `/ideas` routing : lire `_global/index.md` en Phase 0 = projets réels connus → routing précis sans hallucination de projet 🌐

---

## 📚 Décisions

- `backlog.md` dans le vault = source unique du backlog (hors repo) — `features.md` = roadmap haut niveau
- U+2500 box-drawing interdits dans tous les `.cmd` Windows — ASCII pur obligatoire
- Hook pre-commit versionné dans `scripts/hooks/` — source unique via `check_memory.sh`
- `scripts/config.env` = source unique des chemins vault — 1 fichier à modifier pour portabilité multi-machine
- Variables dynamiques (`$ARGUMENTS`, `{{args}}`) toujours en dernière ligne des custom commands
- GitHub MCP configuré dans `~/.claude.json` via PAT — pas de Copilot requis, fonctionne globalement
- `/ideas` = commande unique inbox : 🔧 projet existant | 🚀 dev futur | 💰 SaaS/business | ❌ hors scope + Phase 1 patterns

---

## ⛔ Contraintes & Interdits

- Ne jamais modifier AGENTS.md sans validation explicite

---

