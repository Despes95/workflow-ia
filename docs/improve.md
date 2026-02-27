# /improve — Rapports d'amélioration (workflow-ia)

> Dernière mise à jour : 2026-02-27
> Aucune modification appliquée — propositions à valider

---

## Rapport A — Scripts (workflow-ia)

> Analyse des scripts bash du projet.

### A1. Code à simplifier

| Impact | Fichier | Problème | Solution |
|--------|---------|----------|----------|
| **High** | `obsidian-sync.sh` L.123–163 | 3 boucles `while IFS= read -r line` quasi-identiques (bugs, leçons, décisions) | Factoriser en `extract_section() { local emoji="$1" filter="$2" ... }` |
| **Medium** | `new-project.sh` L.86–166 | Template `memory.md` en heredoc de 80 lignes dans le script | Extraire dans `scripts/templates/memory.md.tpl` + `sed` |
| **Low** | `install-commands.sh` | 6 blocs `if/if/if` séquentiels verbeux | Faible priorité — déjà lisible |

### A2. Architecture à améliorer

| Impact | Problème | Fichiers | Solution |
|--------|----------|---------|----------|
| **High** | **Hook pre-commit non versionné** : absent du repo — quiconque clone n'a pas le garde-fou | `.git/hooks/pre-commit` | Copier dans `scripts/hooks/pre-commit` + installer via `new-project.sh` |
| **High** | **Double source de vérité** : `check_memory.sh` et `.git/hooks/pre-commit` ont chacun leur liste de sections — déjà divergées | `check_memory.sh`, `.git/hooks/pre-commit` | Le hook appelle `check_memory.sh` directement |
| **Medium** | **`settings.local.json` dans `.gitignore`** mais copié par `new-project.sh` L.171 — crash si absent | `new-project.sh` | `[[ -f ... ]] && cp ... \|\| true` |
| **Medium** | **`sessions.md` grossit sans limite** — chaque sync dump tout `memory.md` | `obsidian-sync.sh` | Snapshot partiel : Focus + Récap + Leçons seulement |

### A3. Performance

| Impact | Problème | Solution |
|--------|----------|---------|
| **Medium** | 3 passes sur `memory.md` (une par section) | Une seule passe avec 3 flags `in_*` simultanés |
| **Low** | `ls "$FORGE_DIR" \| wc -l` inutile en sortie | Supprimer ou hardcoder le compte |

### A4. Maintenabilité

| Impact | Problème | Fichiers | Solution |
|--------|----------|---------|----------|
| **High** | **Couleurs ANSI dupliquées** dans 3 scripts (`GREEN`, `CYAN`, `YELLOW`, `NC`) | `install-commands.sh`, `new-project.sh`, `obsidian-sync.sh` | Extraire dans `scripts/_commons.sh` |
| **Medium** | **Template `memory.md` désynchronisé** : génère `## ✅ Todo` mais `check_memory.sh` ne le vérifie plus | `new-project.sh` | Retirer `## ✅ Todo` du heredoc |
| **Low** | Version `v2.6` dans commentaire non incrémentée après modifs | `obsidian-sync.sh` | Supprimer le numéro ou incrémenter |

### A5. Bonnes pratiques

| Impact | Problème | Fichiers | Solution |
|--------|----------|---------|----------|
| **High** | **Hook non installé dans les nouveaux projets** par `new-project.sh` | `new-project.sh` | Ajouter `cp scripts/hooks/pre-commit .git/hooks/ && chmod +x` |
| **Medium** | Copie `settings.local.json` sans vérifier son existence | `new-project.sh` L.171 | Copie conditionnelle |
| **Low** | `sed -i` sans `.bak` — comportement différent GNU/BSD | `obsidian-sync.sh` L.239 | `sed -i.bak ... && rm -f ...bak` |

### Priorisation scripts

| Rang | Action | Impact |
|------|--------|--------|
| 1 | Hook → `scripts/hooks/` versionné + installé par `new-project.sh` | High |
| 2 | Hook appelle `check_memory.sh` (supprimer duplication) | High |
| 3 | `extract_section()` dans `obsidian-sync.sh` (3 boucles → 1 fn) | High |
| 4 | `_commons.sh` pour les couleurs ANSI | Medium |
| 5 | Une seule passe sur `memory.md` | Medium |
| 6 | Retirer `## ✅ Todo` du template `new-project.sh` | Medium |
| 7 | `settings.local.json` copie conditionnelle | Medium |
| 8 | Snapshot partiel dans `sessions.md` | Medium |

---

## Rapport B — Vault `_forge` Obsidian

> Analyse de la structure cross-projets du vault.
> Projets : workflow-ia · nexus_hive · openfun + couche _global

### B1. Structure — Schémas incompatibles

Les 3 projets ont des structures de fichiers différentes, rendant toute automatisation cross-projets impossible.

| Fichier | workflow-ia | nexus_hive | openfun |
|---------|:-----------:|:----------:|:-------:|
| `index.md` | ✅ | ✅ | ✅ |
| `architecture.md` | ✅ | ✅ | ✅ |
| `bugs.md` | ✅ | ✅ | ✅ |
| `sessions.md` | ✅ | ❌ (`journal.md`) | ❌ (`journal.md`) |
| `lessons.md` | ✅ | ❌ | ❌ |
| `decisions.md` | ✅ | ❌ (dans `architecture.md`) | ❌ |
| `backlog.md` | ❌ (dans `features.md`) | ✅ | ✅ |
| `done.md` | ❌ | ✅ | ✅ |
| `ideas.md` | ✅ | ❌ | ❌ |
| `features.md` | ✅ | ❌ | ❌ |

### B2. Problèmes identifiés

| Impact | Problème | Fichiers | Solution |
|--------|----------|---------|----------|
| **High** | **`_global/` non alimenté automatiquement** — leçons 🌐 ne remontent jamais | `obsidian-sync.sh` | Étape supplémentaire : append 🌐 dans `_global/lessons.md` |
| **High** | **`_global/index.md` désynchronisé** — référence `test-setup-ia` inexistant, date figée au 25/02 | `_global/index.md` | Inclure dans la mise à jour de `obsidian-sync.sh` |
| **High** | **`sessions.md` grossit sans limite** — dump complet de `memory.md` à chaque sync | `obsidian-sync.sh` | Rotation : 10 sessions max, archiver dans `sessions-archive.md` |
| **Medium** | **`nexus_hive` sync non fiable** — fallback manuel documenté "si Gemini quota épuisé" | `nexus_hive/index.md` | Migrer vers `obsidian-sync.sh` standard |
| **Medium** | **Wikilinks cassés** dans `_global/index.md` (`test-setup-ia` n'existe pas) | `_global/index.md` | Nettoyer |
| **Medium** | **Dates de sync incohérentes** — 3 formats différents entre projets | tous les `index.md` | Standardiser sur `YYYY-MM-DD HH:MM` |
| **Low** | `_global/lessons.md` a des sections vides avec commentaires HTML depuis le début | `_global/lessons.md` | Remplir ou supprimer les sections vides |

---

## Schéma canonique proposé

> À appliquer à tous les projets pour permettre l'automatisation cross-projets.

### Fichiers obligatoires (6)

| Fichier | Rôle | Alimenté par |
|---------|------|-------------|
| `index.md` | Point d'entrée, navigation, état rapide, commande sync | `obsidian-sync.sh` (mise à jour date) |
| `architecture.md` | Stack, composants, protocoles, décisions structurantes | Manuel |
| `bugs.md` | Bugs ouverts (🔴/🟡) + résolus | `obsidian-sync.sh` (extrait `## 🐛`) |
| `sessions.md` | Snapshots automatiques memory.md (10 max) | `obsidian-sync.sh` |
| `lessons.md` | Leçons apprises, marquées 🌐 si transversales | `obsidian-sync.sh` (extrait `## 📝`) |
| `decisions.md` | Décisions d'archi avec contexte + conséquences | `obsidian-sync.sh` (extrait `## 📚`) |

### Fichiers optionnels (3, pour projets code actifs)

| Fichier | Rôle | Projets concernés |
|---------|------|------------------|
| `backlog.md` | Tâches P1/P2/P3 à faire | nexus_hive, openfun |
| `done.md` | Features terminées, tâches clôturées | nexus_hive, openfun |
| `ideas.md` | Pistes à explorer sans engagement | workflow-ia, nexus_hive |

### Couche `_global/` (cross-projets)

| Fichier | Rôle | Alimenté par |
|---------|------|-------------|
| `index.md` | Liste tous les projets actifs + date de dernière sync | `obsidian-sync.sh` (auto) |
| `lessons.md` | Agrégat des leçons 🌐 de tous les projets | `obsidian-sync.sh` (auto) |

### Template `index.md` canonique

```markdown
# {PROJECT} — Index

> Dernière sync : YYYY-MM-DD HH:MM

## Navigation

- [[architecture]] — Stack et composants clés
- [[bugs]] — Bugs ouverts et résolus
- [[sessions]] — Historique des sessions
- [[lessons]] — Leçons apprises
- [[decisions]] — Décisions d'architecture
- [[backlog]] — Tâches en attente        ← optionnel
- [[done]] — Tâches terminées            ← optionnel
- [[ideas]] — Pistes à explorer          ← optionnel

## État rapide

| | |
|---|---|
| **Statut** | En cours / Stable / Archivé |
| **Dernière session** | YYYY-MM-DD — résumé |
| **Bugs critiques** | N |
| **Prochain focus** | ... |

## Sync

\`\`\`bash
cd C:\IA\Projects\{PROJECT} && bash scripts/obsidian-sync.sh
\`\`\`
```

### Migration par projet

| Projet | Actions |
|--------|---------|
| **workflow-ia** | Supprimer `features.md` (fusionner dans `backlog.md`), garder le reste |
| **nexus_hive** | Renommer `journal.md` → `sessions.md`, créer `lessons.md` + `decisions.md` (extraire depuis `architecture.md`), migrer vers `obsidian-sync.sh` |
| **openfun** | Renommer `journal.md` → `sessions.md`, créer `lessons.md` + `decisions.md`, migrer vers `obsidian-sync.sh` |
| **_global** | Nettoyer `index.md` (supprimer `test-setup-ia`), automatiser via `obsidian-sync.sh` |

### Priorisation vault

| Rang | Action | Impact |
|------|--------|--------|
| 1 | Définir et appliquer le schéma canonique aux 3 projets | High |
| 2 | `obsidian-sync.sh` alimente `_global/lessons.md` (leçons 🌐) | High |
| 3 | `obsidian-sync.sh` met à jour `_global/index.md` automatiquement | High |
| 4 | Rotation `sessions.md` — 10 sessions max | High |
| 5 | Migrer `nexus_hive` + `openfun` vers `obsidian-sync.sh` standard | Medium |
| 6 | Nettoyer `_global/index.md` (supprimer `test-setup-ia`) | Medium |
| 7 | Standardiser format de date dans tous les `index.md` | Low |
