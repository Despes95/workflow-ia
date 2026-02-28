# workflow-ia — Memory

**Dernière mise à jour :** 2026-02-28 (/review-improve Phase 4 + /ideas routing 6 items)
**Dernier outil CLI utilisé :** Claude Code

---

## 🎯 Focus Actuel

- **État** : Infrastructure stable ✅ — mode optimisation/amélioration du backlog
- **Priorité immédiate** : I1 (tests shell critiques) + D3-vérif (audit $ARGUMENTS réels dans 64 fichiers)
- **Horizon moyen** : J2 (claude-code-templates 100+ agents) + J3 (MemMachine MCP) à explorer

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
- `.claude/commands/*.md` — 32 custom slash commands Claude — Stable
- `.gemini/commands/*.toml` — 32 commands Gemini CLI (TOML) — Stable
- `.opencode/commands/*.md` — 32 commands OpenCode (MD) — Stable
- `scripts/gemini-*.sh` — 4 helpers d'accès vault pour Gemini CLI Windows — Stable
- `improve-inbox.md` — inbox rapports /improve multi-IA (gitignored) — Stable
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

- 2026-02-28 | Gemini CLI | Fix freeze `/start` (nettoyage récursion ! {) | Stable
- 2026-02-28 | Claude Code | Gemini helpers ×4, /improve-inbox + /review-improve ×3, yolo settings | Stable
- 2026-02-28 | Claude Code | D1 Polaris.md + D2 /focus × 3 outils, 32 commandes | Stable
- 2026-02-28 | Claude Code | Fix 28 .toml Gemini $env:→bash, README config.env, backlog ✅ 6 items | Stable
- 2026-02-28 | Claude Code | /review-improve Ph4 (C/A-reste ✅, I1-I4, D3-vérif) + /ideas 6 items + table /simplify+/audit+/improve | Stable

---


## 🐛 Bugs connus

- `grep "🌐"` dans obsidian-sync.sh retourne vide sur Windows Git Bash — résolu via `while read` bash native (B-reste)
- OpenCode custom slash commands : ne fonctionnent pas en mode non-interactif (`opencode run`) — utiliser le mode interactif 🌐

---

## 📝 Leçons apprises

- **SÉCURITÉ CRITIQUE** : Gemini CLI exécute récursivement les motifs `! {` trouvés dans les fichiers chargés par `@{}`. Ne JAMAIS écrire ce motif dans `memory.md` ou `AGENTS.md`. Toujours ajouter un espace : `! {`. 🌐
- Gemini CLI : les chemins absolus hors workspace sont interdits avec `@{}`. Utiliser `! {type \"...\"}` (Windows) ou `! {cat ...}` (Linux/Mac) pour contourner la sécurité via le shell. 🌐
- Migration Gemini → `$env:FORGE_DIR/$env:PROJECT_NAME` casse tout : ces vars PowerShell ne sont jamais définies. Pattern correct : `! {bash -c 'source scripts/config.env; cat "$FORGE_DIR/$(basename $(pwd))/file.md"'}` 🌐
- Windows Git Bash : `python3` = stub Windows Store (exit 49) → utiliser `python` (3.11 disponible via PATH) 🌐
- PowerShell dans .toml Gemini : attention aux échappements de quotes et aux pipes (`\|`). 🌐
- ~/.gemini/settings.json avait une section security.auth à préserver — toujours lire avant d'écraser
- Tous les AIs (Claude, Gemini, OpenCode) ont les mêmes capacités sur le vault — prompt fin-de-session unifié (obsidian-sync + wikilinks + push) 🌐
- `install-commands.sh` couvre automatiquement les nouveaux fichiers via glob `*.md`/`*.toml` — pas besoin de modifier le script pour les nouvelles commandes 🌐
- `normalize_path()` avec BASH_REMATCH = pattern propre pour convertir `C:\foo` → `/c/foo` dans un script bash appelé depuis .cmd Windows 🌐
- Bootstrap d'un template : tester avec un projet jetable avant commit — vérifier sed + counts en une passe, puis `rm -rf` 🌐
- PowerShell `Get-Date -Format 'yyyy/MM/dd'` dans les TOML Gemini : seule solution fiable Windows pour dates dynamiques — `! {type + date fixe}` est un anti-pattern 🌐
- OpenCode : `/start`, `/stranger`, `/close` testés et fonctionnent en mode interactif `opencode .` 🌐
- `chcp 65001` dans CMD Windows ne protège pas contre les U+2500 box-drawing — utiliser ASCII pur dans tous les .cmd 🌐
- Gemini `! {bash -c "cat ...$(basename $(pwd))/..."}` = résolution dynamique du nom de projet 🌐
- `git config core.hooksPath scripts/hooks` = alternative élégante à la copie dans `.git/hooks/` (F2) 🌐
- `grep` sur emojis UTF-8 échoue dans tous les modes de pipe Git Bash (-a, -F, -P, LC_ALL) — seule solution : `[[ "$line" == *emoji* ]]` bash native 🌐
- Gemini CLI Windows : `! {bash -c 'source ...; cmd'}` casse sous PowerShell. Solution : scripts helpers `scripts/gemini-*.sh` appelés via `! {bash.exe scripts/gemini-vault.sh file.md}` — utiliser `bash.exe` (pas seulement `bash`) garantit que PowerShell n'intercepte pas les commandes internes (comme `cat`). 🌐
- Gemini CLI Windows : les commandes `git status`, `git log` et `git diff` dans les blocs `! {}` gèlent l'interface si un pager (`less`) est activé. Toujours utiliser `git --no-pager <cmd>` pour une exécution non-interactive. 🌐
- Gemini CLI Windows : Consolider les appels multiples dans un script unique (ex: `scripts/gemini-start.sh`) réduit les risques de freeze et améliore la performance (1 spawn shell au lieu de 4). 🌐
- iCloud Drive Windows : La lecture de fichiers (cat) peut geler si le fichier est un "placeholder" non synchronisé. Utiliser `timeout 3s cat` dans les scripts helpers pour garantir un retour immédiat. 🌐
- Git Bash Windows : Éviter `${HOME}` dans `config.env` car il peut être résolu avec des backslashes mal échappés (ex: `C:UsersDespes`). Préférer le chemin canonique Git Bash `/c/Users/Despes`. 🌐
- `approvalMode: "yolo"` dans `~/.gemini/settings.json` = supprime tous les prompts d'autorisation `! {}` — fallback : `gemini --yolo` 🌐
- `/ideas` routing : vision "réécriture complète" d'un projet = 🚀 futur projet, pas 🔧 amélioration — trop grand pour un backlog item normal 🌐
- Outils MCP : toujours évaluer sous double angle (complément / remplacement) avant de router — le MCP natif change la catégorie de pertinence 🌐
- Python Windows `print()` avec emojis → `UnicodeEncodeError` cp1252 — toujours `PYTHONIOENCODING=utf-8` ou supprimer les emojis des print() 🌐

---

## 📚 Décisions

- `backlog.md` dans le vault = source unique du backlog (hors repo) — `features.md` = roadmap haut niveau
- U+2500 box-drawing interdits dans tous les `.cmd` Windows — ASCII pur obligatoire
- Hook pre-commit versionné dans `scripts/hooks/` — source unique via `check_memory.sh`
- `scripts/config.env` = source unique des chemins vault — 1 fichier à modifier pour portabilité multi-machine
- Variables dynamiques (`$ARGUMENTS`, `{{args}}`) toujours en dernière ligne des custom commands
- GitHub MCP configuré dans `~/.claude.json` via PAT — pas de Copilot requis, fonctionne globalement
- `approvalMode: "yolo"` dans `~/.gemini/settings.json` — confiance totale, workflow perso uniquement
- Cascade analyse : `/simplify` → `/audit` → `/improve` — voir section dédiée dans `AGENTS.md`

---

## ⛔ Contraintes & Interdits

- Ne jamais modifier AGENTS.md sans validation explicite
- **NE JAMAIS écrire le motif `! {` (sans espace) dans ce fichier.**

---
