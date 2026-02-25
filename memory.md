# workflow-ia — Memory

**Dernière mise à jour :** 2026-02-25
**Dernier outil CLI utilisé :** Claude Code — claude-sonnet-4-6

---

## 🎯 Focus Actuel

- **Mission en cours** : check_memory.sh + prompts cross-outil + daily notes backlog ✅
- **Prochaine étape** : Phase 8 — Rehydration vault → memory.md
- **Zone sensible** : AGENTS.md — ne pas modifier sans validation
- **État git** : Phases 1-7 ✅ + clôture tuto — commit 89259ac

---

## 🧠 Momentum (Handoff)

> Section volatile — remplie par l'IA avant un switch, effacée après reprise.

- **Pensée en cours** : —
- **Vibe / Style** : —
- **Contraintes actives** : —
- **Le prochain petit pas** : —
- **Contexte chaud** : —

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
- `.claude/commands/*.md` — 12 custom slash commands (backup + wikilinks dans close) — Stable

---

## 📜 Récap sessions (5 max)

### Résumé global

- Projet initialisé. Phase 1 terminée : AGENTS.md source unique, CLAUDE.md pointe dessus, Gemini configuré.

### Historique

- 2026-02-25 | Claude Code | Clôture tuto — /backup + wikilinks /close + prompts-et-commandes | Stable
- 2026-02-25 | Claude Code | Unification prompt fin-de-session — git status + callouts + full workflow | Stable
- 2026-02-25 | Claude Code | Auto-close /close + remplissage vault (architecture, decisions, features, ideas) | Stable
- 2026-02-25 | Claude Code | check_memory.sh + prompts cross-outil + daily notes backlog | Stable

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

---

## 🐛 Bugs connus

- `/close` "Unknown skill" si `claude` lancé hors de `workflow-ia/` → fix : `cd workflow-ia && claude`, ou `bash scripts/install-commands.sh` pour global

---

## 📝 Leçons apprises

- Custom commands visibles seulement si `claude` lancé depuis le dossier contenant `.claude/commands/` — utiliser `install-commands.sh` pour un accès global 🌐
- ~/.gemini/settings.json avait une section security.auth à préserver — toujours lire avant d'écraser
- git subtree split réécrit les SHA — les anciens SHA (0ccee34, af2f545, ecb24b2) ne sont plus valides, remplacés par (c76414b, 31faaff, 7ed0855)
- Tous les AIs (Claude, Gemini, OpenCode) ont les mêmes capacités sur le vault — prompt fin-de-session unifié (obsidian-sync + wikilinks + push) 🌐
- Pattern grep de check_memory.sh doit correspondre au titre de section exact — un mot-clé court capte aussi les champs volatiles (ex: "Contraintes" → faux positif) 🌐

---

## ⛔ Contraintes & Interdits

- Ne jamais modifier AGENTS.md sans validation explicite
