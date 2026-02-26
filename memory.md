# workflow-ia — Memory

**Dernière mise à jour :** 2026-02-26 (new-project.cmd/.sh — bootstrapper nouveau projet)
**Dernier outil CLI utilisé :** Claude Code — claude-sonnet-4-6

---

## 🎯 Focus Actuel

- **Mission en cours** : Bootstrapper livré — new-project.cmd/.sh opérationnel (78 commands × 3 outils)
- **Prochaine étape** : Tester Gemini CLI + OpenCode en session réelle
- **Zone sensible** : AGENTS.md — ne pas modifier sans validation
- **État git** : Propre — tout pushé (26 commands × 3 outils + bootstrapper)

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
- `docs/prompts-et-commandes.md` — référence opérationnelle prompts + 12 commandes — Stable
- `scripts/obsidian-sync.sh` — sync memory.md → vault Obsidian (pure bash v2.6) — Stable
- `scripts/check_memory.sh` — garde-fou intégrité memory.md (doublons, sections, lignes) — Stable
- `.claude/commands/*.md` — 26 custom slash commands (12 orig + /start + 13 Obsidian) — Stable
- `.gemini/commands/*.toml` — 26 commands Gemini CLI (TOML, `{{args}}`, `@{}`, `!{}`) — Stable
- `.opencode/commands/*.md` — 26 commands OpenCode (MD frontmatter, `$ARGUMENTS`, `@`, `!`) — Stable
- `docs/commands-list.cmd` — Windows batch double-clic, affiche les 26 commandes — Stable
- `new-project.cmd` — launcher Windows bootstrap nouveau projet en 1 clic — Stable
- `scripts/new-project.sh` — script bootstrap complet (stack workflow-ia) — Stable

---

## 📜 Récap sessions (5 max)

### Résumé global

- Stack complète : 26 commandes × 3 outils, vault Obsidian, bootstrapper new-project.cmd/.sh opérationnel.

### Historique

- 2026-02-25 | Claude Code | check_memory.sh + prompts cross-outil + daily notes backlog | Stable
- 2026-02-25 | Claude Code | Commands globales `~/.claude/commands/` + /close prompt v2 | Stable (bug résolu : relancer Claude Code)
- 2026-02-26 | Claude Code | Commands multi-outils Gemini (TOML) + OpenCode (MD) + install --all | Stable
- 2026-02-26 | Claude Code | /start + 13 commands Obsidian × 3 outils + commands-list.cmd (26 total) | Stable
- 2026-02-26 | Claude Code | new-project.cmd/.sh — bootstrapper nouveau projet en 1 clic | Stable

---

## ✅ Todo

- [x] Phase 1 — Unification règles IA
- [x] Phase 2 — Amélioration memory.md
- [x] Phase 3 — Vault Obsidian
- [x] Phase 4 — Connexion vault
- [x] Phase 5 — Slash commands
- [x] Autonomie complète workflow-ia (settings + install-commands + tutorial-valider)
- [x] Phase 6 — Leçons globales
- [x] Phase 7 — Momentum Transfer
- [x] Clôture tuto — prompts-et-commandes.md + /backup + rétroliens /close
- [x] Commands multi-outils — Gemini (TOML) + OpenCode (MD) + install --all/--gemini/--opencode
- [x] Ajouter remote GitHub sur workflow-ia → déjà configuré, push actif depuis plusieurs sessions
- [x] /start + 13 commands Obsidian × 3 outils + docs/commands-list.cmd
- [x] Tester commandes OpenCode en session réelle (/start, /stranger, /close fonctionnent) 🌐
- [ ] Tester commandes Gemini CLI (TOML) en session réelle
- [ ] Lancer install-commands.sh --all pour déployer les 14 nouvelles commandes globalement
- [x] new-project.cmd/.sh — bootstrapper nouveau projet en 1 clic

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

---

## ⛔ Contraintes & Interdits

- Ne jamais modifier AGENTS.md sans validation explicite

---

## 🧪 Plan de test (Gemini CLI)

1. Lancer `gemini` en interactif depuis `C:\IA\Projects\workflow-ia`
2. Tester une commande simple : taper `/start` ou une commande Obsidian
3. Vérifier : arguments passés ? `@{path}` résolu ? `!{cmd}` exécuté ?
4. Résultat : OK → syntaxe validée. KO → corriger `.gemini/commands/*.toml`
