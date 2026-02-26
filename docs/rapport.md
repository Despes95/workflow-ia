# Rapport de test — Custom Slash Commands

**Date** : 2026-02-26  
**Projet** : workflow-ia  
**Statut** : 🔴 Non fonctionnel — correction nécessaire

---

## Résumé exécutif

Les 26 commandes personnalisées (custom slash commands) pour **Gemini CLI** (TOML) et **OpenCode** (MD) **ne fonctionnent pas en session réelle**. La syntaxe `@{path}` / `!{cmd}` n'a pas pu être testée car les commandes elles-mêmes ne sont pas détectées par les outils.

---

## Tests effectués

### OpenCode (v1.2.15)

| Test | Résultat |
|------|----------|
| `/help` | ❌ Interprété comme chemin fichier (`C:/Program Files/Git/help`) |
| `/start` | ❌ Non reconnu comme commande |
| `/context` | ❌ Interprété comme chemin (`C:/Program Files/Git/context`) |
| `.opencode/commands/` | ❌ Custom commands non détectées |

**Observation** : OpenCode interprète tout argument commençant par `/` comme un chemin de fichier, pas comme une commande.

### Gemini CLI (v0.30.0)

| Test | Résultat |
|------|----------|
| `/test` | ❌ Non reconnu |
| `/context` | ❌ Non reconnu |
| `~/.gemini/commands/test.toml` | ❌ Fichier créé manuellement, non détecté |
| `gemini skills list` | ✅ Fonctionne (skills différents des commands) |

**Observation** : Gemini CLI distingue "skills" (MCP) des "slash commands" (TOML). Les commands dans `.gemini/commands/` ne sont pas chargées automatiquement.

---

## Problèmes identifiés

### 1. OpenCode — Custom commands non supportées ou mal documentées
- La doc officielle mentionne `.opencode/commands/` mais le système ne les reconnaît pas
- Le format attendu semble être JSON (`opencode.json`) plutôt que MD
- Issue GitHub #299 suggère que les custom slash commands sont en développement

### 2. Gemini CLI — Commands non chargées automatiquement
- Les fichiers `.toml` dans `.gemini/commands/` ne sont pas découverts
- Le help ne mentionne pas les slash commands
- `gemini skills list` montre que skills ≠ commands

### 3. Impact sur le bootstrapper
- `new-project.cmd/.sh` copie les commands dans les nouveaux projets
- Si les commands ne fonctionnent pas, les projets boostrapés hériteront du bug
- Risque de confusion pour les utilisateurs

---

## Plan de correction

### Étape 1 — Valider le support OpenCode

**Objectif** : Confirmer si OpenCode supporte vraiment les custom slash commands.

- [ ] Consulter la doc officielle OpenCode sur les commands
- [ ] Tester avec `opencode.json` (format JSON au lieu de MD)
- [ ] Créer un test minimal dans `.opencode/commands/test.md`
- [ ] Si non supporté : documenter comme "Déprécié" dans memory.md

### Étape 2 — Valider le support Gemini CLI

**Objectif** : Comprendre pourquoi les commands TOML ne sont pas chargées.

- [ ] Consulter la doc Gemini CLI v0.30.0 sur les custom commands
- [ ] Vérifier si le dossier `.gemini/commands/` existe et est correct
- [ ] Tester avec un fichier TOML minimal (copier l'exemple officiel)
- [ ] Si non supporté : adapter le format ou abandonner cette tool

### Étape 3 — Corriger les fichiers de commands

**Objectif** : Mettre à jour les 26 commands pour le format fonctionnel.

- [ ] Identifier le format correct pour chaque tool
- [ ] Modifier les fichiers dans `.gemini/commands/*.toml`
- [ ] Modifier les fichiers dans `.opencode/commands/*.md` (ou `.json`)
- [ ] Tester chaque command individuellement

### Étape 4 — Mettre à jour le bootstrapper

**Objectif** : Corriger `new-project.cmd/.sh` pour éviter d'hériter du bug.

- [ ] Modifier `scripts/new-project.sh` pour copier le format correct
- [ ] Tester le bootstrapper sur un projet test
- [ ] Valider que les commands fonctionnent dans le nouveau projet

### Étape 5 — Déployer globally (optionnel)

**Objectif** : Rendre les commands disponibles globalement.

- [ ] Lancer `install-commands.sh --all`
- [ ] Tester dans un autre projet
- [ ] Mettre à jour memory.md avec le statut final

---

## Fichiers impactés

| Fichier | Action |
|---------|--------|
| `.gemini/commands/*.toml` | Corriger le format |
| `.opencode/commands/*.md` | Convertir en JSON ou corriger |
| `scripts/new-project.sh` | Adapter au format fonctionnel |
| `memory.md` | Documenter le statut après correction |

---

## Risques résiduels

- Les custom slash commands peuvent ne pas être supportées dans les versions actuelles
- Le temps de correction peut être significatif
- Peut nécessiter de repenser l'approche (alternatives : scripts bash, alias, etc.)

---

## Recommandation

**Priorité haute** : Valider le support avant de corriger. Si les tools ne supportent pas les custom slash commands, documenter comme "Déprécié" et explorer des alternatives (scripts shell, aliases, etc.).

---

*Rapport généré lors de la session de test du 2026-02-26*
