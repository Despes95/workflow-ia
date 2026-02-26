# workflow-ia — Memory

**Dernière mise à jour :** 2026-02-26 (28 commands + DespesNotes + improve/audit)
**Dernier outil CLI utilisé :** Claude Code — claude-sonnet-4-6

---

## 🎯 Focus Actuel

- **Mission en cours** : Commands DEV/PENSÉE réorganisées — DespesNotes intégré
- **Prochaine étape** : Tester Gemini CLI (TOML) + installer commands global
- **Zone sensible** : AGENTS.md — ne pas modifier sans validation
- **État git** : Modifié — 48 fichiers (44 modifiés + 4 nouveaux)

---

## 🧠 Momentum (Handoff)

> Section volatile — remplie par l'IA avant un switch, effacée après reprise.

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

- 2026-02-26 | Claude Code | 28 commands + DespesNotes + improve/audit + README | Stable
- 2026-02-26 | Claude Code | Test commands OpenCode (/start, /stranger, /close) + plan test Gemini CLI | Stable
- 2026-02-25 | Claude Code | check_memory.sh + prompts cross-outil + daily notes backlog | Stable
- 2026-02-25 | Claude Code | Commands globales + /close prompt v2 | Stable
- 2026-02-26 | Claude Code | Commands multi-outils Gemini + OpenCode + install --all | Stable

---

## ✅ Todo

- [x] Phase 1 — Unification règles IA
- [x] Phase 2 — Amélioration memory.md
- [x] Phase 3 — Vault Obsidian
- [x] Phase 4 — Connexion vault
- [x] Phase 5 — Slash commands
- [x] Autonomie complète workflow-ia
- [x] Phase 6 — Leçons globales
- [x] Phase 7 — Momentum Transfer
- [x] Clôture tuto — prompts-et-commandes.md + /backup
- [x] Commands multi-outils — 28 commands × 3 outils
- [x] README.md + .gitignore créés
- [x] Commands DEV réorganisées (DEV/PENSÉE)
- [x] DespesNotes intégré aux 16 commands pensée
- [x] Nouvelles commands /improve + /audit
- [x] Tester commandes OpenCode (/start, /stranger, /close) 🌐
- [ ] Tester commandes Gemini CLI (TOML) en session réelle
- [ ] Lancer install-commands.sh --all pour déployer les 28 commandes globalement

---

## 🐛 Bugs connus

- `/close` "Unknown skill" résolu : il fallait relancer Claude Code après install --global
- OpenCode custom slash commands : ne fonctionnent pas en mode non-interactif (`opencode run`) — utiliser le mode interactif 🌐

---

## 📝 Leçons apprises

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
- OpenCode dossier global Windows : `%APPDATA%\opencode\commands\` (pas ~/.config/) 🌐
- OpenCode : `/start`, `/stranger`, `/close` testés et fonctionnent en mode interactif `opencode .` 🌐
- Commands pensée : ajouter le chemin DespesNotes `_daily/` enrichit le contexte avec les notes personnelles 🌐
- Nouvelles commands DEV : `/improve` (améliorations tech) + `/audit` (bugs/refactor) — lecture seule

---

## ⛔ Contraintes & Interdits

- Ne jamais modifier AGENTS.md sans validation explicite

---

## 🧪 Plan de test (Gemini CLI)

1. Lancer `gemini` en interactif depuis `C:\IA\Projects\workflow-ia`
2. Tester une commande simple : taper `/start` ou une commande Obsidian
3. Vérifier : arguments passés ? `@{path}` résolu ? `!{cmd}` exécuté ?
4. Résultat : OK → syntaxe validée. KO → corriger `.gemini/commands/*.toml`
