# workflow-ia — Memory

**Dernière mise à jour :** 2026-02-25
**Dernier outil CLI utilisé :** Claude Code — claude-sonnet-4-6

---

## 🎯 Focus Actuel

- **Mission en cours** : Valider le tuto tutorial-optimisation-v2.6 phase par phase
- **Prochaine étape** : Phase 6 — Leçons globales (ou clore le tuto)
- **Zone sensible** : AGENTS.md — ne pas modifier sans validation
- **État git** : Phases 1-5 ✅ + autonomie complète — commit 29d28da

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
- `scripts/obsidian-sync.sh` — sync memory.md → vault Obsidian (pure bash v2.6) — Stable

---

## 📜 Récap sessions (5 max)

### Résumé global

- Projet initialisé. Phase 1 terminée : AGENTS.md source unique, CLAUDE.md pointe dessus, Gemini configuré.

### Historique

- 2026-02-25 | Claude Code | Phase 1 unification règles IA | AGENTS.md, CLAUDE.md | Stable
- 2026-02-25 | Claude Code | Phase 2 amélioration memory.md | memory.md, pre-commit hook | Stable
- 2026-02-25 | Claude Code | Phase 3 vault Obsidian | scripts/obsidian-sync.sh | Stable
- 2026-02-25 | Claude Code | Déplacement git repo dans workflow-ia/ | git subtree split | Stable

---

## ✅ Todo

- [x] Phase 1 — Unification règles IA
- [x] Phase 2 — Amélioration memory.md
- [x] Phase 3 — Vault Obsidian
- [x] Phase 4 — Connexion vault
- [x] Phase 5 — Slash commands
- [x] Autonomie complète workflow-ia (settings + install-commands + tutorial-valider)
- [ ] Phase 6 — Leçons globales
- [ ] Phase 7 — Momentum Transfer

---

## 🐛 Bugs connus

- Aucun connu actuellement

---

## 📝 Leçons apprises

- ~/.gemini/settings.json avait une section security.auth à préserver — toujours lire avant d'écraser
- git subtree split réécrit les SHA — les anciens SHA (0ccee34, af2f545, ecb24b2) ne sont plus valides, remplacés par (c76414b, 31faaff, 7ed0855)

---

## ⛔ Contraintes & Interdits

- Ne jamais modifier AGENTS.md sans validation explicite
