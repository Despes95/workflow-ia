# workflow-ia — Memory

**Dernière mise à jour :** 2026-02-25
**Dernier outil CLI utilisé :** Claude Code — claude-sonnet-4-6

---

## 🎯 Focus Actuel

- **Mission en cours** : Valider le tuto tutorial-optimisation-v2.6 phase par phase
- **Prochaine étape** : Phase 3 — Vault Obsidian
- **Zone sensible** : AGENTS.md — ne pas modifier sans validation
- **État git** : Propre (commit 0ccee34)

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

---

## 📜 Récap sessions (5 max)

### Résumé global

- Projet initialisé. Phase 1 terminée : AGENTS.md source unique, CLAUDE.md pointe dessus, Gemini configuré.

### Historique

- 2026-02-25 | Claude Code | Phase 1 unification règles IA | AGENTS.md, CLAUDE.md | Stable

---

## ✅ Todo

- [x] Phase 1 — Unification règles IA
- [ ] Phase 2 — Amélioration memory.md
- [ ] Phase 3 — Vault Obsidian
- [ ] Phase 4 — Connexion vault
- [ ] Phase 5 — Slash commands
- [ ] Phase 6 — Leçons globales
- [ ] Phase 7 — Momentum Transfer

---

## 🐛 Bugs connus

- Aucun connu actuellement

---

## 📝 Leçons apprises

- ~/.gemini/settings.json avait une section security.auth à préserver — toujours lire avant d'écraser

---

## ⛔ Contraintes & Interdits

- Ne jamais toucher C:\IA\_setup — travail uniquement dans workflow-ia/
- Ne jamais modifier AGENTS.md sans validation explicite
