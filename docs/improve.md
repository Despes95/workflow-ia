# /improve — Analyse workflow-ia (2026-02-27)

> Analyse après application des améliorations high-priority. Focus sur ce qui reste.

---

## 1. Code à simplifier

| Impact | Fichier | Problème | Solution |
|--------|---------|----------|----------|
| **High** | `obsidian-sync.sh` L.123–163 | 3 boucles `while IFS= read -r line` quasi-identiques (bugs, leçons, décisions) — même pattern, juste l'emoji et le filtre changent | Factoriser en `extract_section() { local emoji="$1" filter="$2" ... }` |
| **Medium** | `new-project.sh` L.86–166 | Template `memory.md` embedded en heredoc de 80 lignes dans le script — difficile à maintenir | Extraire dans `scripts/templates/memory.md.tpl` + `sed` |
| **Low** | `install-commands.sh` | Structure `if/if/if` imbriquée (6 blocs) lisible mais verbeux | Faible priorité — déjà commenté |

---

## 2. Architecture à améliorer

| Impact | Problème | Fichiers | Solution |
|--------|----------|---------|----------|
| **High** | **Hook pre-commit non versionné** : `.git/hooks/pre-commit` n'est pas dans le repo — quiconque clone le projet n'a pas le hook | `.git/hooks/pre-commit` | Copier dans `scripts/hooks/pre-commit` + `install-commands.sh --hooks` pour l'installer |
| **High** | **Double source de vérité** : `check_memory.sh` et `.git/hooks/pre-commit` ont chacun leur liste de sections obligatoires — déjà divergées (hook n'a pas été mis à jour quand on a retiré "Todo") | `check_memory.sh`, `.git/hooks/pre-commit` | Le hook devrait appeler `check_memory.sh` directement au lieu de dupliquer la logique |
| **Medium** | **`settings.local.json` copié dans new-project.sh** (L.171) mais ce fichier est dans `.gitignore` — crash si absent | `new-project.sh` | Remplacer par un `cp` conditionnel ou générer un fichier vide |
| **Medium** | **`sessions.md` grossit sans limite** — chaque sync ajoute l'intégralité de `memory.md` (100+ lignes) | `obsidian-sync.sh` | Limiter le snapshot aux sections Focus/Récap/Leçons au lieu de `cat "$MEMORY_FILE"` entier |

---

## 3. Performance

| Impact | Problème | Fichiers | Solution |
|--------|----------|---------|----------|
| **Medium** | **3 passes sur `memory.md`** : une boucle par section (bugs, leçons, décisions) → 3 lectures séquentielles du même fichier | `obsidian-sync.sh` | Une seule passe avec 3 variables `in_*` actives simultanément |
| **Low** | `ls "$FORGE_DIR" \| wc -l` dans la sortie finale — inutile si on sait qu'on vient d'écrire 8 fichiers | `obsidian-sync.sh` | Mineur |

---

## 4. Maintenabilité

| Impact | Problème | Fichiers | Solution |
|--------|----------|---------|----------|
| **High** | **Couleurs ANSI dupliquées** dans 3 scripts (`GREEN`, `CYAN`, `YELLOW`, `NC`) — si on change une couleur, à faire 3 fois | `install-commands.sh`, `new-project.sh`, `obsidian-sync.sh` | Extraire dans `scripts/_commons.sh` + `source "$SCRIPT_DIR/_commons.sh"` |
| **Medium** | **Template memory.md désynchronisé** : `new-project.sh` génère un `memory.md` avec `## ✅ Todo`, mais `check_memory.sh` ne vérifie plus "Todo" | `new-project.sh` | Retirer `## ✅ Todo` du template heredoc |
| **Low** | `obsidian-sync.sh` : version notée `v2.6` dans le commentaire L.2 mais non incrémentée après modifications | `obsidian-sync.sh` | Mineur — supprimer le numéro de version ou l'incrémenter automatiquement |

---

## 5. Bonnes pratiques

| Impact | Problème | Fichiers | Solution |
|--------|----------|---------|----------|
| **High** | **Hook non installé automatiquement** : `new-project.sh` ne copie pas le hook pre-commit dans `.git/hooks/` du nouveau projet — les nouveaux projets n'ont aucun garde-fou | `new-project.sh` | Ajouter une étape `cp scripts/hooks/pre-commit .git/hooks/ && chmod +x` |
| **Medium** | `new-project.sh` L.171 : `cp "$TEMPLATE/.claude/settings.local.json"` — pas de vérification que le fichier existe avant copie | `new-project.sh` | `[[ -f ... ]] && cp ... \|\| true` |
| **Low** | `obsidian-sync.sh` : `sed -i` sans `.bak` (L.239) — comportement différent GNU/BSD | `obsidian-sync.sh` | `sed -i.bak ... && rm -f ...bak` ou variable tmp |

---

## Priorisation recommandée

| Rang | Action | Impact |
|------|--------|--------|
| 1 | Hook pre-commit → `scripts/hooks/` + versionné + installé par `new-project.sh` | High |
| 2 | Le hook appelle `check_memory.sh` (supprimer la duplication de logique) | High |
| 3 | Factoriser `extract_section()` dans `obsidian-sync.sh` (3 boucles → 1 fonction) | High |
| 4 | Une seule passe sur `memory.md` au lieu de 3 | Medium |
| 5 | `_commons.sh` pour les couleurs ANSI | Medium |
| 6 | Retirer `## ✅ Todo` du template heredoc de `new-project.sh` | Medium |
| 7 | `settings.local.json` copie conditionnelle | Medium |
| 8 | Snapshot partiel dans `sessions.md` (pas tout `memory.md`) | Medium |

---

## Notes

- Ce rapport est généré par la commande `/improve`
- Dernière mise à jour : 2026-02-27
- Aucune modification appliquée — propositions à valider
