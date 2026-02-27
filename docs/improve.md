# /improve — Backlog améliorations (workflow-ia)

> Dernière mise à jour : 2026-02-27
> Rapports A+B+D appliqués. Rapport E (MiniMax) ajouté. Ce fichier = ce qui reste à faire.
> Historique complet → vault `_forge/workflow-ia/features.md`

---

## Priorité 1 — High

### E1. Tests unitaires bash (bats)

Aucun test pour `check_memory.sh` et `obsidian-sync.sh` — les régressions
ne sont détectées qu'en prod.

**Framework** : [bats-core](https://github.com/bats-core/bats-core)

**À créer** :
- `tests/check_memory.bats` — valide les sections requises, garde-fou memory.md
- `tests/obsidian-sync.bats` — valide `extract_section()`, `rotate_sessions()`, chemins vault

**Impact** : refactors futurs sans régression, CI possible.

### E2. `config.env` — chemins absolus centralisés

Chemins du vault (`OBSIDIAN_BASE`, `VAULT_PATH`, `FORGE_DIR`) codés en dur
dans `obsidian-sync.sh` + `new-project.sh` → cassent sur une autre machine.

**À créer** : `scripts/config.env` sourcé dans tous les scripts :

```bash
# scripts/config.env
OBSIDIAN_BASE="$HOME/iCloudDrive/iCloud~md~obsidian"
FORGE_DIR="${OBSIDIAN_BASE}/_forge"
GLOBAL_DIR="${FORGE_DIR}/_global"
DESPES_NOTES="${OBSIDIAN_BASE}/DespesNotes"
```

**À modifier** : `obsidian-sync.sh`, `new-project.sh` → remplacer les chemins
codés en dur par `source "${SCRIPT_DIR}/config.env"`.

### D1. Créer `DespesNotes/Polaris.md`

Aucun document "boussole personnelle" dans le vault. Les commandes de réflexion
(`/check-in`, `/today`, `/my-world`, `/drift`, `/challenge`) n'ont pas d'ancrage
stable dans les priorités / valeurs.

**Action utilisateur** : créer manuellement `DespesNotes/Polaris.md` :

```markdown
# Polaris — Boussole personnelle

## Life Razor
[Une phrase. Ce qui guide toutes les décisions.]

## Top of Mind (mis à jour : YYYY-MM-DD)
- [Priorité 1 + 1 phrase de contexte]
- [Priorité 2]
- [Priorité 3]

## Ce que j'évite activement en ce moment
- [Distraction / pattern à éviter]
```

**Action code** : enrichir `/check-in`, `/today`, `/my-world`, `/drift`,
`/challenge`, `/connect` → ajouter lecture de `DespesNotes/Polaris.md`.

### D2. Créer commande `/focus`

Aucune commande "sur quoi travailler là maintenant ?" cross-projets × Polaris × énergie.

**Logique :**
1. Lit `DespesNotes/Polaris.md` (boussole)
2. Lit `_forge/_global/index.md` (état tous projets)
3. Lit 3 dernières daily notes (énergie / mode)
4. Lit `memory.md` du projet actif
5. Recommande : **1 action principale** + pourquoi cohérent avec Polaris + ce à éviter

**À créer** : `.claude/commands/focus.md` + `.gemini/commands/focus.toml` + `.opencode/commands/focus.md`

---

## Priorité 2 — Medium

### E3. DRY boucles .gemini/.opencode dans `new-project.sh`

`new-project.sh` contient 2 boucles identiques pour copier les commandes
`.gemini/` et `.opencode/` — extraire en une fonction `copy_commands()`.

### E4. Guard `_commons.sh` (idempotence)

`_commons.sh` peut être sourcé plusieurs fois → ajouter guard :

```bash
if [ -z "$CYAN" ]; then source "${SCRIPT_DIR}/_commons.sh"; fi
```

### E5. `set -E` + `trap ERR` dans les scripts critiques

`check_memory.sh` et `obsidian-sync.sh` n'ont pas de gestion d'erreurs robuste —
un pipe cassé passe silencieusement.

**À ajouter** en tête de chaque script critique :
```bash
set -eE
trap 'echo "Erreur ligne $LINENO — code $?" >&2' ERR
```

### D3. Audit caching des commandes

Les commandes qui injectent du contenu dynamique (`$ARGUMENTS`, dates) en début
de prompt provoquent des cache miss.

**Règle** : contenu statique d'abord, `$ARGUMENTS` / dates toujours en fin de prompt.

**À vérifier** : `.claude/commands/*.md` + `.gemini/commands/*.toml`

### B-reste. Fix `grep "🌐"` dans obsidian-sync.sh

`_global/lessons.md` n'est pas alimenté : `grep "🌐"` retourne vide sous Windows
Git Bash (problème encodage UTF-8 dans les pipes bash).

**À investiguer** : tester `grep -P "\x{1F310}"` ou `grep $'\xf0\x9f\x8c\x90'`
comme alternatives à `grep "🌐"`.

### C-reste. Template daily note

Ajouter `Energie : /5` en tête + section `## Victoires` dans le template Obsidian.

**Impact** : `/check-in` et `/wins` ont leur signal énergétique.

### A-reste. Snapshot partiel sessions.md

Au lieu de dumper tout `memory.md`, ne capturer que : Focus Actuel + Récap sessions
+ Leçons. Réduit la taille des snapshots.

**Fichier** : `scripts/obsidian-sync.sh` — étape 7.

---

## Priorité 3 — Low / Plus tard

### E6. Constante `MAX_SESSIONS` dans `obsidian-sync.sh`

`max=10` codé en dur dans `rotate_sessions()` — extraire en variable en tête de script.

### E7. Headers de documentation dans les scripts

Ajouter en tête de chaque script : `Usage`, `Description`, `Dépendances`.

### E8. Exit codes différenciés dans `check_memory.sh`

Actuellement retourne 0 ou 1 — préciser :
- `2` = section requise manquante
- `3` = `memory.md` absent

### B-reste. Migration nexus_hive + openfun

Renommer `journal.md` → `sessions.md`, créer `lessons.md` + `decisions.md`,
brancher sur `obsidian-sync.sh` standard.

### D4. MCP vers outil de tâches / calendrier

Connecter Claude à un task manager externe pour enrichir `/check-in` et `/focus`
avec les vraies tâches du jour.

### A-reste. Template memory.md → fichier externe

Extraire le heredoc de 80 lignes de `new-project.sh` vers
`scripts/templates/memory.md.tpl` + lecture par `sed`.
