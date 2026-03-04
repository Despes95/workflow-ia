# workflow-ia — Memory

**Dernière mise à jour :** 2026-03-04 (docs mémoire Claude Code + statusline powerline + discovery atelier)
**Dernier outil CLI utilisé :** Claude Code

---

## 🎯 Focus Actuel

- **État** : atelier lancé — discovery.md Q36-Q38 ajoutés, backlog CC1-CC5 (memory native Claude Code)
- **Nom v2** : **atelier** ✅ — projet à `C:\IA\Projects\atelier`
- **Next** : remplir discovery.md (Q1-Q38) + tester `new-project.sh`

---

## 🧠 Momentum (Handoff)

—

---

## 🏗️ Architecture

- **Objectif** : Projet test pour valider le workflow IA du tuto v2.6
- **Stack** : Markdown + Git Bash + Windows 11 + Python (Bridge)
- **Workflow dev** : Lire tuto → créer fichiers → vérifier → commit

---

## 📁 Fichiers clés

- `scripts/gemini-tools.sh` — helper unifié pour Gemini CLI (remplace 7 scripts) — Stable (L2)
- `scripts/config.env` — chemins vault portables ($HOME-based) — v2.6.2 (M1)
- `scripts/obsidian-sync.sh` — sync memory.md → vault Obsidian — v2.6.2 (M1)
- `scripts/vault-check.sh` — vérifie wikilinks dans vault — v2.6.2 (M1)
- `scripts/generate_commands.py` — SSoT Python génère 34 commands OpenCode — v2.6.2 (M1)
- `.claude/commands/*.md` — 34 custom slash commands Claude — v2.6.2 (M1)
- `.gemini/commands/*.toml` — 34 commands Gemini CLI (TOML) — v2.6.2 (L2+M1)
- `.opencode/commands/*.md` — 34 commands OpenCode (MD) — v2.6.2 (M1)


---

## 📜 Récap sessions (5 max)

### Résumé global

- Stack complète : 34 commands × 3 outils (Claude/Gemini/OpenCode), vault Obsidian, bootstrapper.
- Catégories SESSION/PROJET/VAULT. DespesNotes `_daily/` intégré dans commandes VAULT.
- Infrastructure : hooks versionnés, _commons.sh, obsidian-sync refactorisé, rotation 10 sessions, _global auto.
- B-reste : nexus_hive & openfun branchés sur standard v2.6 (sessions/lessons/decisions).

### Historique

- 2026-03-04 | Claude Code | docs memory Claude Code + CC1-CC5 backlog atelier + statusline powerline + discovery Q36-Q38 | Stable
- 2026-03-02 | Claude Code | /ideas 11 URLs → V1-V4 v2 + CAR nexus_hive + Persona.md × 4 projets + discovery.md | Stable
- 2026-03-01 | Claude Code | S1 opencode-mem → backlog v2 HNSW vs sqlite-vss | Stable
- 2026-03-01 | Claude Code | L3 verify-secrets + M5 close→HTML + O2 model routing + G5 ✅ | Stable
- 2026-03-01 | Multi-IA    | M6 audit cross-IA + fix L2 régression — 34 cmd × 3 outils stables | Stable


---


## 🐛 Bugs connus

- `grep "🌐"` dans obsidian-sync.sh retourne vide sur Windows Git Bash — résolu via `while read` bash native (B-reste)
- OpenCode custom slash commands : ne fonctionnent pas en mode non-interactif (`opencode run`) — utiliser le mode interactif 🌐
- `vault_sync.py` regex lignes 125-136 : espaces incorrects → stats index.md jamais mises à jour (→ L1 backlog)

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
- Workflow /close Gemini : Éviter d'enchaîner `git add && git commit` dans un bloc `!{}` sous Windows ; déléguer à un script `gemini-close.sh` pour une autorisation unique et stable. 🌐
- iCloud Drive Windows : La lecture de fichiers (cat) peut geler si le fichier est un "placeholder" non synchronisé. Utiliser `timeout 3s cat` dans les scripts helpers pour garantir un retour immédiat. 🌐
- Git Bash Windows : Éviter `${HOME}` dans `config.env` car il peut être résolu avec des backslashes mal échappés (ex: `C:UsersDespes`). Préférer le chemin canonique Git Bash `/c/Users/Despes`. 🌐
- `approvalMode: "yolo"` dans `~/.gemini/settings.json` = supprime tous les prompts d'autorisation `! {}` — fallback : `gemini --yolo` 🌐
- Rapports de bugs générés par IA : taux de faux positifs élevé — toujours lire le code source avant de valider. Ex: `FileLockTimeout` "manquant" était importé ligne 25, stubs `NotImplementedError` intentionnels et documentés 🌐
- `/ideas` routing : vision "réécriture complète" d'un projet = 🚀 futur projet, pas 🔧 amélioration — trop grand pour un backlog item normal 🌐
- Outils MCP : toujours évaluer sous double angle (complément / remplacement) avant de router — le MCP natif change la catégorie de pertinence 🌐
- Python Windows `print()` avec emojis → `UnicodeEncodeError` cp1252 — toujours `PYTHONIOENCODING=utf-8` ou supprimer les emojis des print() 🌐
- `/simplify` lit `git diff HEAD~1..HEAD` uniquement — vision micro post-edit, pas état global — utiliser `/audit` pour une vue macro du projet 🌐
- `awk 'NF && !seen[$0]++'` supprime les lignes vides intentionnelles (bug K3 obsidian-sync.sh) — anti-pattern pour sections avec espacement délibéré 🌐
- `grep -qF` (fixed-string) vs `grep -q` (regex) : normaliser sur `-qF` dans les tests bash — évite les faux matchs sur caractères spéciaux 🌐
- `grep -qF "## Session 1"` matche aussi "## Session 10" — toujours `grep -q "^pattern$"` pour vérifier une ligne exacte 🌐
- `grep -m1` au lieu de `grep | head -1` = un subprocess de moins, arrêt dès le 1er match 🌐
- Bash tests : lire un fichier une fois dans `$content`, réutiliser — évite N subprocesses pour N assertions sur le même fichier 🌐
- 12 tests E2E valident le workflow complet (sync → vault → rotation → _global) 🌐
- `/review-improve` : items LOW = vivier v2.md, items HIGH = backlog v1 — filtre naturel anti-pollution du backlog 🌐
- `/ideas` workflow (M2) : traite+écrit directement sans confirmation, présente rapport comme récapitulatif — ancien comportement avec pause supprimé 🌐
- Consolidation scripts : mettre à jour TOUS les appelants (*.toml, *.md) en même temps — sinon régression garantie (leçon L2) 🌐
- Claude Code `settings.local.json` : `maxCost` n'existe pas — vérifier les sources avant d'ajouter en backlog "XS" 🌐
- FigJam `generate_diagram` : liens expirent en 7j → sauvegarder immédiatement dans l'ADR au moment de la génération 🌐
- iCloud Windows : `mv` sur dossiers vault refusé en bash (Permission denied) → Explorateur Windows obligatoire 🌐
- Barre statusline : fond coloré + `█` même couleur = invisible → `█` en couleur contrastée sur fond sombre 🌐
- Triangle powerline `\ue0b0` = Private Use Area Unicode — Nerd Font requise dans le terminal 🌐
- ANSI `\033[4Xm` (background) + FG blanc = segments powerline sans framework externe 🌐

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
- `tests/test_helpers.sh` = source unique helpers de test (ok/fail/assert_*) — sourcer dans tout nouveau script de test
- Fonctions obsidian-sync.sh copiées inline dans test_sync.sh (pas sourcées) — évite sourcing config.env/iCloud, compromis intentionnel
- `gemini-tools.sh` = script unifié Gemini (remplace 7 scripts séparés) — sous-commandes : vault/start/close/git/global/notes/daily 🌐
- `v2.md` dans `_forge/Projects/workflow-ia/` = design doc vision long terme — items structurels/spéculatifs → v2.md (pas backlog)
- vault docs v2 = dossier séparé `workflow-ia-v2/` dans `_forge/Projects/` — pas sous-dossier de workflow-ia 🌐
- M6 : rapport d'audit cross-IA AVANT modifications = standard pour tout refactor multi-outils 🌐
- check_secrets.sh scanne uniquement les fichiers stagés via `git show ":file"` — évite faux positifs historique 🌐
- AGENTS.md vault path corrigé : `_forge/workflow-ia/` → `_forge/Projects/workflow-ia/` (O2) 🌐
- Stack v2 : Python Bridge (Palier 1) + FastAPI REST (Palier 2) + SvelteKit dashboard (Palier 3) — xterm.js pour terminaux intégrés
- **ADR-001 (Accepté)** : Python + SQLite pour Palier 1 — `vault_sync.py` comme base, `sqlite3` stdlib, Rust reste cible finale v2 🌐
- Diagrammes C4 Contexte + Conteneurs créés dans FigJam (2026-03-01) 🌐
- `reports/` = dossier pour les rapports HTML de session générés par `/close` (étape 8 optionnelle) 🌐
- "déjà couvert" ≠ "hors scope" — FigJam statique ≠ tldraw SDK interactif : deux outils, deux usages distincts 🌐
- 3 IAs sur le même input = triangulation utile — les désaccords entre outils sont un signal, pas du bruit 🌐
- `opencode-mem` (SQLite+HNSW) = référence archi storage v2 — arbitrer HNSW vs sqlite-vss avant Palier 2 🌐
- OpenClaw = couche d'accès mobile/conversationnel (Telegram/Discord) au-dessus d'atelier — pas un 4e outil, pas un remplacement 🌐
- Persona.md : v1 = enrichissement manuel via `/close` | v2 = auto-capture via `vault_bridge.py` (pattern mem0) 🌐
- Nom v2 = **atelier** ✅ — `C:\IA\Projects\atelier` — source unique `Docs/discovery.md`
- Statusline powerline : triangles `\ue0b0`, BG segments (cyan/bleu/jaune/magenta), € 2 déc., barre fond jaune + `█` vert→orange→rouge
- `~/.claude/statusline.py` = source unique config statusline Claude Code 🌐
- vault docs v2 = dossier `_forge/Projects/atelier/` (renommé depuis `workflow-ia-v2/`)

---

## ⛔ Contraintes & Interdits

- Ne jamais modifier AGENTS.md sans validation explicite
- **NE JAMAIS écrire le motif `! {` (sans espace) dans ce fichier.**

---
