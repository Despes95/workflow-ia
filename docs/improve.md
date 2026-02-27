# /improve — Rapports d'amélioration (workflow-ia)

> Dernière mise à jour : 2026-02-27
> Aucune modification appliquée sauf mention contraire

---

## Rapport A — Scripts bash

> Analyse des scripts : `obsidian-sync.sh`, `install-commands.sh`, `new-project.sh`, `check_memory.sh`

### A1. Code à simplifier

| Impact | Fichier | Problème | Solution |
|--------|---------|----------|----------|
| **High** | `obsidian-sync.sh` L.123–163 | 3 boucles `while IFS= read -r line` quasi-identiques (bugs, leçons, décisions) | Factoriser en `extract_section() { local emoji filter ... }` |
| **Medium** | `new-project.sh` L.86–166 | Template `memory.md` en heredoc de 80 lignes dans le script | Extraire dans `scripts/templates/memory.md.tpl` + `sed` |
| **Low** | `install-commands.sh` | 6 blocs `if/if/if` séquentiels verbeux | Faible priorité — déjà lisible |

### A2. Architecture à améliorer

| Impact | Problème | Fichiers | Solution |
|--------|----------|---------|----------|
| **High** | **Hook pre-commit non versionné** : absent du repo — quiconque clone n'a pas le garde-fou | `.git/hooks/pre-commit` | Copier dans `scripts/hooks/pre-commit` + installer via `new-project.sh` |
| **High** | **Double source de vérité** : `check_memory.sh` et `.git/hooks/pre-commit` ont chacun leur liste de sections — déjà divergées | `check_memory.sh`, `.git/hooks/pre-commit` | Le hook appelle `check_memory.sh` directement |
| **Medium** | **`settings.local.json` dans `.gitignore`** mais copié par `new-project.sh` L.171 — crash si absent | `new-project.sh` | `[[ -f ... ]] && cp ... \|\| true` |
| **Medium** | **`sessions.md` grossit sans limite** — chaque sync dump tout `memory.md` | `obsidian-sync.sh` | Snapshot partiel : Focus + Récap + Leçons seulement |

### A3. Maintenabilité

| Impact | Problème | Fichiers | Solution |
|--------|----------|---------|----------|
| **High** | **Couleurs ANSI dupliquées** dans 3 scripts (`GREEN`, `CYAN`, `YELLOW`, `NC`) | `install-commands.sh`, `new-project.sh`, `obsidian-sync.sh` | Extraire dans `scripts/_commons.sh` |
| **Medium** | **Template memory.md désynchronisé** : génère `## ✅ Todo` mais `check_memory.sh` ne le vérifie plus | `new-project.sh` | Retirer `## ✅ Todo` du heredoc |
| **Medium** | **3 passes sur `memory.md`** (une par section) | `obsidian-sync.sh` | Une seule passe avec 3 flags `in_*` simultanés |
| **Medium** | **Hook non installé dans les nouveaux projets** | `new-project.sh` | Ajouter `cp scripts/hooks/pre-commit .git/hooks/ && chmod +x` |

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

> Projets : workflow-ia · nexus_hive · openfun + couche _global

### B1. Schémas incompatibles entre projets

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

### B2. Problèmes identifiés

| Impact | Problème | Solution |
|--------|----------|---------|
| **High** | `_global/` non alimenté automatiquement — leçons 🌐 ne remontent jamais | Étape dans `obsidian-sync.sh` → append `_global/lessons.md` |
| **High** | `_global/index.md` désynchronisé — référence `test-setup-ia` inexistant | Inclure dans `obsidian-sync.sh` |
| **High** | `sessions.md` grossit sans limite — dump complet de `memory.md` à chaque sync | Rotation : 10 sessions max |
| **Medium** | `nexus_hive` sync non fiable — fallback manuel documenté | Migrer vers `obsidian-sync.sh` standard |
| **Medium** | Wikilinks cassés dans `_global/index.md` | Nettoyer |
| **Medium** | Dates de sync incohérentes — 3 formats différents | Standardiser `YYYY-MM-DD HH:MM` |

### B3. Schéma canonique proposé

**Fichiers obligatoires (6) — tous projets :**

| Fichier | Rôle | Alimenté par |
|---------|------|-------------|
| `index.md` | Point d'entrée, navigation, état rapide | `obsidian-sync.sh` (date) |
| `architecture.md` | Stack, composants, décisions structurantes | Manuel |
| `bugs.md` | Bugs ouverts + résolus | `obsidian-sync.sh` (extrait `## 🐛`) |
| `sessions.md` | Snapshots memory.md (10 max) | `obsidian-sync.sh` |
| `lessons.md` | Leçons apprises, 🌐 si transversales | `obsidian-sync.sh` (extrait `## 📝`) |
| `decisions.md` | Décisions archi avec contexte + conséquences | `obsidian-sync.sh` (extrait `## 📚`) |

**Fichiers optionnels (3) — projets code actifs :**

| Fichier | Rôle |
|---------|------|
| `backlog.md` | Tâches P1/P2/P3 |
| `done.md` | Features terminées |
| `ideas.md` | Pistes à explorer |

**Couche `_global/` alimentée automatiquement :**

| Fichier | Alimenté par |
|---------|-------------|
| `index.md` | `obsidian-sync.sh` — liste projets + date sync |
| `lessons.md` | `obsidian-sync.sh` — agrège les leçons 🌐 |

**Migration par projet :**

| Projet | Actions |
|--------|---------|
| **workflow-ia** | Supprimer `features.md` (fusionner dans `backlog.md`) |
| **nexus_hive** | Renommer `journal.md` → `sessions.md`, créer `lessons.md` + `decisions.md`, migrer vers `obsidian-sync.sh` |
| **openfun** | Idem nexus_hive |
| **_global** | Nettoyer `index.md`, automatiser via `obsidian-sync.sh` |

### Priorisation vault

| Rang | Action | Impact |
|------|--------|--------|
| 1 | Appliquer le schéma canonique aux 3 projets | High |
| 2 | `obsidian-sync.sh` → alimente `_global/lessons.md` (🌐) | High |
| 3 | `obsidian-sync.sh` → met à jour `_global/index.md` | High |
| 4 | Rotation `sessions.md` — 10 sessions max | High |
| 5 | Migrer `nexus_hive` + `openfun` vers `obsidian-sync.sh` | Medium |
| 6 | Nettoyer `_global/index.md` (supprimer `test-setup-ia`) | Medium |

---

## Rapport C — Commandes & Daily

> Analyse des 31 commandes et du template daily note.

### C1. Réorganisation en 3 catégories

La division **DEV / PENSEE** (2 catégories) était approximative.
Division proposée et **appliquée** → `docs/commands-list.cmd` mis à jour :

| Catégorie | Nb | Logique |
|-----------|-----|---------|
| **SESSION** | 10 | Rituels qui encadrent la journée |
| **PROJET** | 7 | Outils dev et architecture |
| **VAULT** | 14 | Réflexion personnelle et notes |

**Déplacements :**
- `/my-world` : PENSEE → PROJET (charge le contexte de travail)
- `/global-connect` : PENSEE → PROJET (pont direct dev/vault)
- `/map` : DEV → VAULT (vue du vault Obsidian)

### C2. Chevauchements à clarifier

| Commandes | Problème | Solution |
|-----------|---------|---------|
| `/today` vs `/start` | Tous les deux lisent le contexte du matin | `/today` = matin sans git. `/start` = début de session de code avec git |
| `/ideas` vs `/improve` | Noms proches, logiques différentes | OK — juste ajouter description plus claire dans `commands-list.cmd` |
| `/graduate` vs `/learned` | Tous les deux "transforment des apprentissages" | `/graduate` = daily → permanent. `/learned` = leçons → post public |

### C3. Les 3 nouvelles commandes (créées et déployées)

**`/check-in`** — avant de commencer à travailler
> Lit les 3 dernières daily notes. Pose 3 questions (énergie / mode / intention). Recommande la commande à lancer + projet à prioriser + ce qu'il vaut mieux éviter.

**`/debug`** — quand tu es bloqué sur un bug précis
> Prend le bug en argument. Lit le fichier concerné + bugs.md + memory.md. Structure : contexte → symptôme → 3 hypothèses → prochaine action.

**`/wins`** — motivation et bilan positif
> Lit git log (7j) + sessions.md + daily notes. Liste les victoires : features, bugs résolus, leçons, décisions. Termine par une phrase "Cette semaine tu as...".

**Déployées dans :**
- `.claude/commands/` ✅
- `.gemini/commands/` ✅
- `.opencode/commands/` ✅

### C4. Template daily note — analyse

**Template actuel :**
```markdown
# 2026-02-26 — jeudi

## Ce qui me passe par la tête aujourd'hui
-

## Idées, réflexions, opinions
-

## Leçons ou insights du jour
-

## Travail
-

---
**Tags :** #daily
```

**Ce qui fonctionne bien :**
- Court et non intimidant à remplir
- Section "Leçons" alimente `/learned`, `/graduate`, `/global-connect`
- Section "Travail" alimente `/today`, `/wins`

**Ce qui manque pour les nouvelles commandes :**

| Manque | Commande impactée | Proposition |
|--------|------------------|-------------|
| Aucune info énergie/état | `/check-in` | Ajouter `## Energie [1-5]` en tête |
| Pas de victoires explicites | `/wins` | Ajouter `## Victoires du jour` |
| Les 2 sections "pensée" se chevauchent | lisibilité | Fusionner en `## Pensées` |

**Template amélioré proposé :**
```markdown
# YYYY-MM-DD — jour

Energie : /5

## Pensées du jour
-

## Travail
-

## Victoires
-

## Leçons ou insights
-

---
**Tags :** #daily
```

**Avantages :** 4 sections au lieu de 4 (même nombre, meilleur signal), énergie visible en un coup d'œil, `/check-in` et `/wins` ont leur signal.

### Priorisation commandes

| Rang | Action | Impact |
|------|--------|--------|
| 1 | Déployer les 3 nouvelles globalement (`install-commands.sh --all`) | High |
| 2 | Mettre à jour le template daily dans Obsidian | Medium |
| 3 | Clarifier descriptions `/today` vs `/start` dans les prompts | Low |
| 4 | Vérifier `/check-in` Gemini — path daily notes hardcodé (date fixe) | Medium |
