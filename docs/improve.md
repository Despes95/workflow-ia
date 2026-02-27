# Améliorations workflow-ia

> Analyse du projet — propositions structurées par impact

---

## 1. Code à simplifier

| Impact | Fichier | Problème | Solution |
|--------|---------|----------|----------|
| **High** | `install-commands.sh` (lignes 28-93) | Code dupliqué pour chaque mode (--global, --gemini, --opencode, --all, --project) | Créer une fonction `deploy_commands()` paramétrable |
| **Medium** | `obsidian-sync.sh` (lignes 138-188) | Extraction bugs et leçons en double — même logique itérative | Factoriser en `extract_section()` avec motif regex en paramètre |
| **Low** | `check_memory.sh` | Script très court, déjà optimal | — |
| **Low** | `new-project.cmd` / `commands-list.cmd` | Simples et lisibles | — |

---

## 2. Architecture à améliorer

| Impact | Problème | Fichiers concernés | Solution |
|--------|----------|-------------------|----------|
| **High** | **Incohérence documentation** : `install-commands.sh` ligne 105 vérifie `12` fichiers, mais memory.md indique **28 commands** × 3 outils | `install-commands.sh`, `memory.md` | Corriger le check de 12 → 28, ou documenter pourquoi 12 |
| **Medium** | **Redondance triple** : 28 commands_dupliquées en 3 formats (.md Claude, .toml Gemini, .opencode .md) | `.claude/`, `.gemini/`, `.opencode/` | Envisager un générateur unique ou un script de sync |
| **Medium** | **Couplage path硬codé** : `obsidian-sync.sh` ligne 11 contient un chemin Windows `/c/Users/Despes/...` non paramétrable | `obsidian-sync.sh` | Extraire config dans fichier `.env` ou variables |

---

## 3. Performance

| Impact | Problème | Fichiers | Solution |
|--------|----------|----------|----------|
| **Low** | `obsidian-sync.sh` : boucle `while IFS` + 2 grep pour nettoyer (lignes 150-151, 177) | `obsidian-sync.sh` | Pipeline sed/awk unique au lieu de grep cascade |
| **Low** | Chaque déploiement (`--all`) copie 3 × 28 fichiers séquentiellement | `install-commands.sh` | Copies parallèles si volumineux (non critique ici) |

---

## 4. Maintenabilité

| Impact | Problème | Fichiers | Solution |
|--------|----------|----------|----------|
| **High** | **Pas de tests** : aucun test automatisé des scripts | Tous | Ajouter `scripts/test_*.sh` ou CI minimale |
| **Medium** | **Incohérence shebang** : `#!/bin/bash` vs `#!/usr/bin/env bash` | `check_memory.sh` vs autres | Uniformiser en `#!/usr/bin/env bash` |
| **Medium** | **Hypothèses implicites** : `new-project.sh` suppose dossier `projects` existant (ligne 45) | `new-project.sh` | `mkdir -p` implicite ou message clair |
| **Low** | Couleurs (`GREEN`, `CYAN`…) dupliquées dans 3 scripts | `install-commands.sh`, `new-project.sh`, `obsidian-sync.sh` | Extraire dans `scripts/_commons.sh` source |

---

## 5. Bonnes pratiques

| Impact | Problème | Fichiers | Solution |
|--------|----------|----------|----------|
| **High** | **Gestion d'erreurs incomplète** : `check_memory.sh` n'utilise pas `set -euo pipefail` (ligne 1) | `check_memory.sh` | Ajouter `set -euo pipefail` |
| **Medium** | **Validation manquante** : `install-commands.sh` ne vérifie pas si `$HOME` est défini avant de l'utiliser | `install-commands.sh` | Ajouter `: "${HOME:?}"` au début |
| **Low** | `obsidian-sync.sh` utilise `sed -i` (ligne 193) — comportement GNU vs BSD différent | `obsidian-sync.sh` | Préciser `sed -i.bak` + cleanup ou utiliser `awk` portable |
| **Low** | Chemins mixing Windows/Linux (`C:\` dans .cmd, `/c/` dans .sh) | `new-project.cmd`, `new-project.sh` | OK pour projet Windows + Git Bash, documenter |

---

## Priorisation recommandée

| Rang | Action | Impact |
|------|--------|--------|
| 1 | Corriger le check `12` → `28` dans `install-commands.sh` | High |
| 2 | Ajouter `set -euo pipefail` à `check_memory.sh` | High |
| 3 | Ajouter tests minimal (CI) | High |
| 4 | Factoriser `deploy_commands()` dans `install-commands.sh` | Medium |
| 5 | Paramétrer le chemin Obsidian (`.env` ou config) | Medium |
| 6 | Uniformiser shebangs | Low |

---

## 6. Amélioration workflow /close + obsidian-sync.sh

> Contexte : `/close` fait tout automatiquement SAUF les étapes 6b et 6c qui nécessitent une édition manuelle de `sessions.md`.

| Impact | Problème | Fichiers | Solution |
|--------|----------|----------|----------|
| **High** | **Étapes 6b/6c manuelles** : Callouts et wikilinks都需要编辑 sessions.md après sync | `/close`, `obsidian-sync.sh` | Automatiser dans obsidian-sync.sh |
| **High** | **Pas d'extraction décisions** : memory.md n'a pas de section décisions, donc decisions.md n'est jamais alimenté | `obsidian-sync.sh` | Ajouter extraction `## 📚 Décisions` |
| **Medium** | **Callouts non standardisés** : Format varie selon l'IA qui fait la session | `/close` | Générer automatiquement dans obsidian-sync.sh |
| **Medium** | **Wikilinks manquants** : Navigation cross-notes incomplète | `sessions.md` | Ajouter automatiquement dans le snapshot |

### Solutions détaillées

#### 6.1 Extraction décisions automatique

Ajouter dans `obsidian-sync.sh` :
```bash
# Extraction decisions (section ## 📚 Décisions)
DECISIONS_SECTION=""
in_decisions=0
while IFS= read -r line; do
  if [[ "$line" =~ ^##[[:space:]]*📚 ]]; then
    in_decisions=1
  elif [[ "$in_decisions" -eq 1 && "$line" =~ ^## ]]; then
    in_decisions=0
  elif [[ "$in_decisions" -eq 1 ]]; then
    DECISIONS_SECTION+="${line}"$'\n'
  fi
done < "$MEMORY_FILE"
```

#### 6.2 Callouts automatiques dans snapshot

Modifier le bloc snapshot sessions.md pour générer :
```markdown
> [!insight]
> - Leçon 1
> - Leçon 2

> [!warning]
> - Bug 1

> [!decision]
> - Décision 1
```

#### 6.3 Wikilinks automatiques

```markdown
→ [[lessons]]
→ [[bugs]]
→ [[decisions]]
```

#### 6.4 Simplifier /close

| Avant | Après |
|-------|-------|
| 6a. `bash scripts/obsidian-sync.sh` | 6a. `bash scripts/obsidian-sync.sh` |
| 6b. Éditer sessions.md (manuel) | ❌ Supprimé (auto) |
| 6c. Ajouter wikilinks (manuel) | ❌ Supprimé (auto) |
| 6d. git commit + push | 6b. git commit + push |

#### 6.5 Ajouter section Décisions dans memory.md

Template à ajouter dans memory.md :
```markdown
## 📚 Décisions

- [decision]
```

---

## Priorisation mise à jour

| Rang | Action | Impact |
|------|--------|--------|
| 1 | Corriger le check `12` → `28` dans `install-commands.sh` | High |
| 2 | Automatiser callouts + wikilinks dans obsidian-sync.sh | High |
| 3 | Ajouter extraction décisions | High |
| 4 | Simplifier /close (supprimer 6b/6c) | High |
| 5 | Ajouter `set -euo pipefail` à `check_memory.sh` | High |
| 6 | Ajouter tests minimal (CI) | High |
| 7 | Factoriser `deploy_commands()` dans `install-commands.sh` | Medium |
| 8 | Paramétrer le chemin Obsidian (`.env` ou config) | Medium |
| 9 | Uniformiser shebangs | Low |

---

## Résultat attendu

Après `/close` :
1. `obsidian-sync.sh` exécuté
2. `sessions.md` contient automatiquement :
   - Callouts (!insight, !warning, !decision)
   - Wikilinks (→ [[lessons]], → [[bugs]], → [[decisions]])
3. `decisions.md` alimenté automatiquement
4. Commit + push automatique

**Workflow 100% automatique — zéro manip manuelle.**

---

## Notes

- Ce rapport est généré automatiquement par la commande `/improve`
- Dernière mise à jour : 2026-02-27 (ajout section 6 : workflow /close + obsidian-sync.sh)
- Aucune modification appliquée — propositions à valider
