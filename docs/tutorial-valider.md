# Tutorial validé — workflow-ia v2.6

> Version nettoyée et validée du `tutorial-optimisation-v2.6.md`
> Chaque phase est validée, implémentée, et documentée avec les écarts réels.
> Les références à `_setup` ont été remplacées par les chemins `workflow-ia/`.

**Repo de référence :** `C:\IA\Projects\workflow-ia\`
**Commit de référence de la validation complète :** voir tableau ci-dessous

---

## Vue d'ensemble

| Phase | Statut | Commit | Durée réelle |
|---|---|---|---|
| Phase 1 — Unification règles IA | ✅ Stable | `c76414b` | ~30 min |
| Phase 2 — Amélioration memory.md | ✅ Stable | `31faaff` | ~20 min |
| Phase 3 — Vault Obsidian | ✅ Stable | `7ed0855` | ~45 min |
| Déplacement git repo | ✅ Stable | `40b0a6e` | ~20 min |
| Phase 4 — Connexion vault | ✅ Stable | `ecced2e` | ~20 min |
| Phase 5 — Custom slash commands | ✅ Stable | `ecced2e` | ~30 min |
| Phase 8 — Bootstrapper new-project | ✅ Stable | `9b291aa` | ~20 min |
| Phase 9 — /improve | ✅ Stable | session 2026-02-28 | ~30 min |
| Phase 10 — Vault infra | ✅ Stable | session 2026-02-28 | ~45 min |
| Phase 11 — Tests shell + git-info | ✅ Stable | `d31468a` | ~30 min |
| Phase 12 — A-reste + F4 + G2/G5 | ✅ Stable | `190a50a` | ~20 min |
| Phase 13 — S1 statusline + N3 E2E + gemini-close.sh | ✅ Stable | `a714734` | ~30 min |

---

## Phase 1 — Unification règles IA ✅ (commit `c76414b`)

### Objectif

Passer de 3 fichiers de règles (`GEMINI.md`, `CLAUDE.md`, `AGENTS.md`) à 1 seul
fichier source (`AGENTS.md`) que tous les outils IA chargent.

### Étape 1.1 — Configurer Gemini CLI pour lire AGENTS.md

```bash
# 📍 Depuis Git Bash — n'importe où
# ATTENTION : lire le fichier existant avant d'écraser (section security.auth à préserver)
cat ~/.gemini/settings.json
```

Mettre à jour en préservant les clés existantes :

```bash
cat > ~/.gemini/settings.json << 'EOF'
{
  "contextFileName": "AGENTS.md",
  "general": {
    "defaultApprovalMode": "plan"
  },
  "experimental": {
    "plan": true
  }
}
EOF

cat ~/.gemini/settings.json | grep contextFileName
# ✅ Doit afficher : "contextFileName": "AGENTS.md"
```

> ⚠️ **Écart réel :** Le fichier `~/.gemini/settings.json` contenait déjà une section
> `security.auth` à préserver. Toujours lire avant d'écraser.

### Étape 1.2 — Créer CLAUDE.md pointant vers AGENTS.md

```bash
# 📍 Depuis /c/IA/Projects/workflow-ia
cat > CLAUDE.md << 'EOF'
# workflow-ia — Règles Claude Code

@AGENTS.md

## Règles spécifiques Claude Code

- Toujours utiliser Plan Mode avant de toucher au code
- Confirmer avec l'utilisateur avant tout refactor touchant plus de 3 fichiers
- Ne jamais modifier un fichier sans montrer le diff d'abord
EOF

grep "@AGENTS.md" CLAUDE.md
# ✅ Doit afficher : @AGENTS.md
```

### Étape 1.3 — Créer AGENTS.md (source unique)

```bash
# 📍 Depuis /c/IA/Projects/workflow-ia
cat > AGENTS.md << 'EOF'
# workflow-ia — Règles communes (OpenCode · Gemini CLI · Claude Code)

## Comportement général

- Tu réponds TOUJOURS en français, sans exception
- Toujours lire `memory.md` en PREMIER avant d'agir
- Git First : `git status` + `git diff` + `git log --oneline -10` avant toute action
- Commits autonomes aux checkpoints (feature, refactor, bug, fin session)
- Marqueurs de maturité : `Stable` / `En cours` / `Expérimental` / `Déprécié`
- Historique memory.md : 5 entrées max

## Règles Git

- Ne jamais committer sans inclure memory.md
- Un commit par checkpoint logique
- Format : `type: description courte` (feat, fix, refactor, chore, docs)

## Garde-fous

- Ne jamais modifier un fichier sans montrer le diff d'abord
- Toujours montrer un plan avant tout refactor ou suppression de fichier
- Ne toucher à aucun fichier tant que l'utilisateur n'a pas confirmé

## Modes de session

- **Mode complet** : `/my-world` → dev → `/close` → push
- **Mode rapide** : `/context` → action → `/close`
- **Mode urgence** : `/context` → action → commit manuel
EOF

wc -l AGENTS.md
# ✅ Doit afficher > 20 lignes
```

### Vérification Phase 1

```bash
# 📍 Depuis /c/IA/Projects/workflow-ia
cat ~/.gemini/settings.json | grep contextFileName   # → "contextFileName": "AGENTS.md"
grep "@AGENTS.md" CLAUDE.md                          # → @AGENTS.md
wc -l AGENTS.md                                      # → > 20 lignes
```

### Commit Phase 1

```bash
git add AGENTS.md CLAUDE.md memory.md
git commit -m "feat: phase 1 - unification règles IA (AGENTS.md source unique)"
```

---

## Phase 2 — Amélioration memory.md ✅ (commit `31faaff`)

### Objectif

Structurer `memory.md` avec des sections claires pour que l'IA trouve
l'information immédiatement, sans explorer le projet.

### Étape 2.1 — Créer memory.md structuré

```bash
# 📍 Depuis /c/IA/Projects/workflow-ia
cat > memory.md << 'EOF'
# workflow-ia — Memory

**Dernière mise à jour :** YYYY-MM-DD
**Dernier outil CLI utilisé :** Claude Code — claude-sonnet-4-6

---

## 🎯 Focus Actuel

- **Mission en cours** : [ce sur quoi tu travailles]
- **Prochaine étape** : [la prochaine chose à faire]
- **Zone sensible** : AGENTS.md — ne pas modifier sans validation
- **État git** : Propre

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

- Projet initialisé.

### Historique

- YYYY-MM-DD | Claude Code | [ce qui a été fait] | [fichiers] | Stable

---

## ✅ Todo

- [ ] Phase X

---

## 🐛 Bugs connus

- Aucun connu actuellement

---

## 📝 Leçons apprises

- [leçon]

---

## ⛔ Contraintes & Interdits

- Ne jamais modifier AGENTS.md sans validation explicite
EOF
```

### Étape 2.2 — Installer le hook pre-commit

```bash
# 📍 Depuis /c/IA/Projects/workflow-ia
cat > .git/hooks/pre-commit << 'HOOKEOF'
#!/bin/bash
# Vérifie que memory.md est inclus dans chaque commit
if ! git diff --cached --name-only | grep -q "memory.md"; then
  echo "⛔ Commit bloqué : memory.md doit être inclus"
  exit 1
fi

# Vérifie les sections obligatoires
check() {
  if ! grep -q "$1" memory.md; then
    echo "⛔ Section manquante dans memory.md : $1"
    exit 1
  fi
}
check "Focus Actuel"
check "Architecture"
check "Fichiers clés"
check "sessions"
check "Todo"
check "Contraintes"
HOOKEOF
chmod +x .git/hooks/pre-commit
```

### Vérification Phase 2

```bash
grep "Fichiers clés" memory.md    # → section présente
cat .git/hooks/pre-commit | head -5  # → script présent
```

### Commit Phase 2

```bash
git add memory.md .git/hooks/pre-commit
git commit -m "feat: phase 2 - memory.md structuré + pre-commit hook"
```

---

## Phase 3 — Vault Obsidian ✅ (commit `7ed0855`)

### Objectif

Créer `scripts/obsidian-sync.sh` pour synchroniser `memory.md` vers un vault
Obsidian structuré dans `_forge/workflow-ia/`.

> ⚠️ **Écart réel :** Le vault `_forge/workflow-ia/` était déjà partiellement peuplé
> (fichiers créés lors de sessions précédentes). Le script s'est adapté sans écraser
> les fichiers existants (logique `if [ ! -f "$TARGET" ]`).

### Structure cible dans Obsidian

```
C:\Users\Despes\iCloudDrive\iCloud~md~obsidian\_forge\
└── workflow-ia\
    ├── index.md
    ├── sessions.md
    ├── decisions.md
    ├── bugs.md
    ├── backlog.md      ← backlog actif avec rationale (hors repo git)
    ├── features.md     ← roadmap haut niveau (phases, complété/planifié)
    ├── lessons.md
    ├── architecture.md
    └── ideas.md
```

### Étape 3.1 — Créer obsidian-sync.sh

```bash
# 📍 Depuis /c/IA/Projects/workflow-ia
mkdir -p scripts

cat > scripts/obsidian-sync.sh << 'SYNCEOF'
#!/bin/bash

# ============================================================
# obsidian-sync.sh — Sync memory.md → vault Obsidian structuré
# Usage : bash scripts/obsidian-sync.sh
# ============================================================

set -euo pipefail

RED='\033[0;31m'; YELLOW='\033[1;33m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; NC='\033[0m'

PROJECT_NAME=$(basename "$PWD")
OBSIDIAN_BASE="${USERPROFILE}/iCloudDrive/iCloud~md~obsidian/_forge"
FORGE_DIR="$OBSIDIAN_BASE/$PROJECT_NAME"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M")
DATE=$(date +"%Y-%m-%d")
SESSION_ID=$(date +%s)

echo -e "${CYAN}📚 Sync Obsidian — $PROJECT_NAME${NC}"

if [ ! -f "memory.md" ]; then
  echo -e "${RED}ERREUR : memory.md introuvable dans $PWD${NC}"
  exit 1
fi

mkdir -p "$FORGE_DIR"

# Initialiser les fichiers s'ils n'existent pas
for template in index sessions decisions bugs features lessons architecture ideas; do
  TARGET="$FORGE_DIR/$template.md"
  if [ ! -f "$TARGET" ]; then
    echo "# $PROJECT_NAME — $template" > "$TARGET"
    echo -e "${GREEN}✓ Créé : $template.md${NC}"
  fi
done

# Snapshot dans sessions.md
echo -e "\n---\n## $TIMESTAMP  <!-- session-id: $SESSION_ID -->" >> "$FORGE_DIR/sessions.md"
cat memory.md >> "$FORGE_DIR/sessions.md"
echo -e "${GREEN}✓ Snapshot ajouté dans sessions.md${NC}"

# Extraire bugs
BUGS=$(awk '/^## 🐛/,/^## /' memory.md | grep -v "^## " | grep -v "^$" | grep -v "Aucun connu")
if [ -n "$BUGS" ]; then
  echo -e "\n---\n### $DATE\n$BUGS" >> "$FORGE_DIR/bugs.md"
  echo -e "${GREEN}✓ Bugs extraits${NC}"
fi

# Extraire leçons
LESSONS=$(awk '/^## 📝 Leçons/,/^## /' memory.md | grep -v "^## " | grep -v "^$" | grep "^-")
if [ -n "$LESSONS" ]; then
  echo -e "\n---\n### $DATE\n$LESSONS" >> "$FORGE_DIR/lessons.md"
  echo -e "${GREEN}✓ Leçons extraites${NC}"
fi

# Mettre à jour index.md
sed -i "s/\*\*Dernière sync :\*\*.*/\*\*Dernière sync :\*\* $DATE/" "$FORGE_DIR/index.md" 2>/dev/null || \
  echo "**Dernière sync :** $DATE" >> "$FORGE_DIR/index.md"
echo -e "${GREEN}✓ index.md mis à jour${NC}"

echo -e "\n${GREEN}════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Sync terminée → $FORGE_DIR${NC}"
echo -e "${GREEN}════════════════════════════════════${NC}"
SYNCEOF

chmod +x scripts/obsidian-sync.sh
```

### Étape 3.2 — Lancer la première sync

```bash
# 📍 Depuis /c/IA/Projects/workflow-ia
bash scripts/obsidian-sync.sh

# Vérifier
ls "${USERPROFILE}/iCloudDrive/iCloud~md~obsidian/_forge/workflow-ia/"
# ✅ Doit afficher les fichiers .md
```

### Commit Phase 3

```bash
git add scripts/obsidian-sync.sh memory.md
git commit -m "feat: phase 3 - obsidian-sync.sh (pure bash, v2.6)"
```

---

## Déplacement git repo ✅ (commit `40b0a6e`)

> Cette étape n'est pas dans le tuto original. Elle a été réalisée pour avoir
> un repo propre dans `workflow-ia/` sans préfixe de chemin.

### Contexte

Le repo était initialement dans `C:\IA\Projects\` avec un préfixe `workflow-ia/`
dans tous les chemins git. On l'a déplacé dans `C:\IA\Projects\workflow-ia\`
via `git subtree split`.

### Correction post-déplacement du hook pre-commit

```bash
# Le hook référençait workflow-ia/memory.md — corriger en memory.md
sed -i 's|workflow-ia/memory.md|memory.md|g' .git/hooks/pre-commit
```

> ⚠️ **Leçon :** `git subtree split` réécrit les SHA. Les anciens SHA
> (0ccee34, af2f545, ecb24b2) sont obsolètes après cette opération.

---

## Phase 4 — Connexion vault ✅ (commit `ecced2e`)

### Objectif

Ajouter la section `## Vault Obsidian` dans `AGENTS.md` pour que l'IA sache
où lire le vault et quels fichiers consulter en début de session.

### Étape 4.1 — Ajouter la section Vault dans AGENTS.md

```bash
# 📍 Depuis /c/IA/Projects/workflow-ia
cat >> AGENTS.md << 'EOF'

## Vault Obsidian

Le vault `_forge/workflow-ia/` contient la mémoire long terme du projet.
Chemin d'accès direct : `C:\Users\Despes\iCloudDrive\iCloud~md~obsidian\_forge\workflow-ia\`

Fichiers à lire en début de session si le contexte est flou :
- `index.md` → point d'entrée, liens vers tout le reste
- `architecture.md` → état de l'archi et fichiers clés
- `sessions.md` → historique chronologique
- `decisions.md` → pourquoi telle archi, alternatives rejetées
- `bugs.md` → bugs résolus et patterns à éviter
- `lessons.md` → leçons réutilisables

Règle d'or : tu lis le vault, tu ne l'écris pas sans validation explicite.
EOF

tail -15 AGENTS.md
# ✅ Doit afficher la nouvelle section
```

### Commit Phase 4

```bash
git add AGENTS.md memory.md
git commit -m "feat: phase 4 - vault connexion (section Vault Obsidian dans AGENTS.md)"
```

---

## Phase 5 — Custom slash commands ✅ (commit `ecced2e`)

### Objectif

Installer les 10 custom slash commands Claude Code dans `.claude/commands/`
et les versionner dans le repo.

> **Changement par rapport au tuto original :** Le script `install-commands.sh`
> est maintenant dans `workflow-ia/scripts/` (plus dans `_setup/`).
> Il utilise des chemins relatifs au repo via `SCRIPT_DIR` et `REPO_DIR`.

### Les 10 commandes

| Commande | Usage |
|---|---|
| `/my-world` | Début de journée — charge tout le vault |
| `/today` | Matin — plan du jour |
| `/close` | Soir — fin de session, mise à jour memory.md |
| `/context` | Début de session projet — contexte court terme |
| `/emerge` | Surface les patterns implicites |
| `/challenge` | Pression-test des croyances |
| `/connect` | Ponts non-évidents entre les fichiers |
| `/trace` | Timeline d'une décision |
| `/ideas` | Améliorations depuis les patterns |
| `/global-connect` | Vue macro cross-projets |

### Étape 5.1 — Vérifier que les commands sont en place

```bash
# 📍 Depuis /c/IA/Projects/workflow-ia
ls .claude/commands/
# ✅ Doit afficher les 10 fichiers .md
```

### Étape 5.2 — Tester install-commands.sh (mode check local)

```bash
# 📍 Depuis /c/IA/Projects/workflow-ia
bash scripts/install-commands.sh
# ✅ Doit afficher : "✓ Tous les commands sont présents dans workflow-ia"
```

### Étape 5.3 — Déployer sur un autre projet

```bash
# 📍 Depuis /c/IA/Projects/<ton-projet>
cd /c/IA/Projects/<ton-projet>
bash /c/IA/Projects/workflow-ia/scripts/install-commands.sh --project

ls .claude/commands/
# ✅ Doit afficher les 10 fichiers .md
```

### Étape 5.3b — Déployer globalement (tous projets)

```bash
# 📍 Depuis /c/IA/Projects/workflow-ia
bash scripts/install-commands.sh --global
# → Copie dans ~/.claude/commands/
# ✅ Doit afficher : "✓ Commands déployées globalement dans : /c/Users/<user>/.claude/commands"

ls ~/.claude/commands/
# ✅ Doit lister les 12 fichiers .md
```

> **Note Windows :** Sur Windows avec Claude Code, `~/.claude/commands/` peut ne pas être détecté
> automatiquement selon le contexte de lancement. Si `/close` retourne "Unknown skill",
> utiliser `--project` depuis le dossier actif comme fallback.

### Étape 5.4 — Versionner les commands

```bash
# 📍 Depuis /c/IA/Projects/workflow-ia
# Vérifier que .claude/ n'est pas ignoré
grep ".claude" .gitignore || echo "non ignoré — OK"

git add .claude/commands/
git commit -m "feat: phase 5 - custom slash commands Claude Code"
```

### Commit Phase 4+5 (réalisé en un seul commit)

```bash
git add AGENTS.md .claude/commands/ memory.md
git commit -m "feat: phase 4+5 - vault connexion + slash commands"
```

---

## Phase 6 — Adaptation commands multi-outils ✅ (commit `768dca1`)

**Objectif :** Rendre les 12 commands Claude Code disponibles dans Gemini CLI et OpenCode,
avec adaptation syntaxique par outil.

### Étape 6.1 — Supprimer le mode plan Gemini

```bash
# Vérifier settings.json avant modification
cat ~/.gemini/settings.json

# Supprimer defaultApprovalMode et experimental.plan
# Conserver contextFileName et security.auth
cat > ~/.gemini/settings.json << 'EOF'
{
  "contextFileName": "AGENTS.md",
  "security": {
    "auth": {
      "selectedType": "oauth-personal"
    }
  }
}
EOF

# Vérifier
cat ~/.gemini/settings.json  # → plus de "defaultApprovalMode"
```

> ⚠️ **Règle :** toujours lire `~/.gemini/settings.json` avant d'écraser — il peut contenir des clés à préserver (ex: `security.auth`).

### Étape 6.2 — Créer les commands Gemini CLI (TOML)

```bash
mkdir -p .gemini/commands/
# Créer 12 fichiers .toml (un par command)
# Format : description + prompt avec {{args}}, @{path}, !{cmd}
ls .gemini/commands/  # → 12 fichiers .toml
```

**Mapping de syntaxe Claude → Gemini :**
| Claude | Gemini |
|--------|--------|
| `$ARGUMENTS` | `{{args}}` |
| "Lis memory.md" | `@{memory.md}` |
| "Lance git status" | `!{git status}` |
| `$PROJECT_NAME` | `!{bash -c "basename $(pwd)"}` — résolution dynamique via shell |

> ⚠️ **Ne jamais hardcoder le PROJECT_NAME dans les TOML Gemini.** Utiliser
> `!{bash -c "cat \".../_forge/$(basename $(pwd))/fichier.md\""}` pour que la
> commande fonctionne quel que soit le projet actif.

> ⚠️ **Anti-pattern : date fixe dans les chemins `!{...}`**
> Si une command lit une daily note (ex: `/check-in`, `/wins`), ne jamais hardcoder la date :
> ```toml
> # ❌ À éviter
> !{type ".../_daily/2026/02/26.md" 2>nul}
>
> # ✅ Correct — date dynamique via PowerShell
> !{powershell -NoProfile -Command "Get-Content ([string]::Concat('.../_daily/', (Get-Date -Format 'yyyy/MM/dd'), '.md')) -ErrorAction SilentlyContinue"}
> ```
> Sur Windows, `PowerShell Get-Date` est la seule solution fiable pour les dates dynamiques dans les TOML Gemini.

### Étape 6.3 — Créer les commands OpenCode (Markdown + frontmatter)

```bash
mkdir -p .opencode/commands/
# Créer 12 fichiers .md avec frontmatter YAML
# Format : --- description: ... --- puis body avec $ARGUMENTS, @path, !cmd
ls .opencode/commands/  # → 12 fichiers .md
```

**Mapping de syntaxe Claude → OpenCode :**
| Claude | OpenCode |
|--------|----------|
| `$ARGUMENTS` | `$ARGUMENTS` (identique) |
| "Lis memory.md" | `@memory.md` |
| "Lance git status" | `!git status` |
| `$PROJECT_NAME` | `workflow-ia` (hardcodé) |

### Étape 6.4 — Mettre à jour install-commands.sh

Ajout de 3 nouveaux modes :
```bash
bash scripts/install-commands.sh --gemini    # → ~/.gemini/commands/
bash scripts/install-commands.sh --opencode  # → ~/.config/opencode/commands/
bash scripts/install-commands.sh --all       # → les 3 ensembles globaux

# Vérification (mode défaut)
bash scripts/install-commands.sh
# → ✓ Claude : 12 fichiers .md
# → ✓ Gemini : 12 fichiers .toml
# → ✓ OpenCode : 12 fichiers .md
```

> ⚠️ **Rappel :** après `--global` ou `--all`, relancer Claude Code pour activer les commands globales.

---

## Autonomie complète — Structure finale

Après validation des 5 phases, `workflow-ia` est autonome et ne dépend d'aucune
infrastructure externe.

### Structure complète

```
workflow-ia/
├── AGENTS.md                   ← règles communes tous outils IA
├── CLAUDE.md                   ← @AGENTS.md + règles Claude
├── memory.md                   ← mémoire court terme
├── .claude/
│   ├── settings.local.json     ← permissions Claude Code
│   └── commands/               ← 12 custom slash commands
│       ├── my-world.md, today.md, close.md, context.md
│       ├── emerge.md, challenge.md, connect.md, trace.md
│       ├── ideas.md, global-connect.md, backup.md, switch.md
├── .gemini/
│   └── commands/               ← 12 commands Gemini CLI (TOML)
│       └── *.toml              ← format {{args}}, @{path}, !{cmd}
├── .opencode/
│   └── commands/               ← 12 commands OpenCode (Markdown)
│       └── *.md                ← format $ARGUMENTS, @path, !cmd
├── scripts/
│   ├── obsidian-sync.sh        ← sync memory.md → vault Obsidian
│   ├── install-commands.sh     ← déploie Claude/Gemini/OpenCode (--all)
│   └── new-project.sh          ← bootstrap nouveau projet (stack complète)
├── new-project.cmd             ← launcher Windows double-clic bootstrap
└── docs/
    ├── tutorial-optimisation-v2.6.md   ← référence originale (lecture seule)
    └── tutorial-valider.md             ← ce fichier
```

### Vérification finale

```bash
# 📍 Depuis /c/IA/Projects/workflow-ia

# Structure
ls .claude/
ls .claude/commands/    # → 10 .md + settings.local.json
ls scripts/             # → obsidian-sync.sh + install-commands.sh

# Tester install-commands.sh
bash scripts/install-commands.sh

# Aucune ref _setup dans les fichiers de prod
grep -rn "_setup" . --include="*.sh" --include="*.md" \
  --exclude-dir=".git" --exclude="tutorial-*.md"
# → Résultat attendu : 0 match
```

---

## Phase 7 — /start + 13 commands Obsidian × 3 outils ✅ (commit `0b8cd68`)

**Objectif :** Passer de 12 à 26 commandes — ajouter `/start` (démarrage froid) et 13 commandes
orientées vault Obsidian, disponibles dans les 3 outils.

### Différence /start vs /context

| | `/start` | `/context` |
|---|---|---|
| Lit CLAUDE.md/AGENTS.md | ✅ | ❌ |
| Lit memory.md | ✅ | ✅ |
| Lit vault index + architecture | ✅ | ✅ |
| Fait git status + log | ✅ | ❌ |
| **Vocation** | **Démarrage froid** | **Rechargement rapide** |

### Étape 7.1 — Créer /start (3 outils)

```bash
# .claude/commands/start.md (prompt littéral + $ARGUMENTS implicite)
# .gemini/commands/start.toml ({{args}}, @{path}, !{cmd})
# .opencode/commands/start.md (frontmatter + @path + !cmd)
```

Contenu du prompt `/start` :
1. Lit CLAUDE.md → AGENTS.md (ou AGENTS.md pour Gemini/OpenCode)
2. Lit memory.md
3. Lit vault index.md + architecture.md
4. Lance git status + git log --oneline -10
5. Résume en 5 points (état, blocages, prochaine étape, zones sensibles, dette)

### Étape 7.2 — Créer les 13 commands Obsidian (× 3 outils = 39 fichiers)

| Commande | Vault lu | Vocation |
|----------|---------|----------|
| `/close-day` | sessions (dernière) + memory | Bilan journée → propose màj memory |
| `/schedule` | sessions (3) + lessons + memory | Planning selon patterns d'énergie |
| `/7plan` | sessions (10) + ideas + memory | 7 jours autour des sujets vivants |
| `/map` | index + architecture + sessions (5) + lessons + decisions | Carte topologique |
| `/ghost $q` | lessons + sessions (15) + decisions + _global/lessons | Répond en ton nom |
| `/contradict` | decisions + lessons + sessions (10) | Croyances incompatibles |
| `/drift` | sessions (20) + memory + ideas | Sujets évités silencieusement |
| `/stranger` | _global/lessons + sessions (20) + decisions + lessons | Portrait externe |
| `/compound $q` | sessions (tout) + decisions | Évolution d'une question |
| `/backlinks` | sessions (10) + lessons + ideas | Connexions manquantes |
| `/graduate` | sessions (10) + ideas | Idées → notes permanentes |
| `/learned` | sessions (5) + lessons | Post "What I Learned" |
| `/weekly-learnings` | sessions (7 dernières) | Résumé hebdomadaire |

### Étape 7.3 — Créer docs/commands-list.cmd

Script Windows batch — double-clic → affiche les 26 commandes dans le terminal.

```cmd
# docs/commands-list.cmd
# Sections : SESSION, PLANIFICATION, ANALYSE DU VAULT, RÉFLEXION, IDENTITÉ, EXPORT
```

### Vérification finale

```bash
ls .claude/commands/   # → 26 fichiers .md
ls .gemini/commands/   # → 26 fichiers .toml
ls .opencode/commands/ # → 26 fichiers .md
# Double-clic docs/commands-list.cmd → liste s'affiche

# Déployer globalement :
bash scripts/install-commands.sh --all
# → relancer Claude Code après --global ou --all
```

---

## Phase 8 — Bootstrapper new-project.cmd/.sh ✅ (commit `9b291aa`)

**Objectif :** Permettre de bootstrapper un nouveau projet en double-cliquant sur un fichier Windows.
Déploie toute la stack workflow-ia dans un nouveau dossier, adapté au nom du projet.

### Ce qui est déployé

| Fichier/Dossier | Traitement |
|-----------------|------------|
| `AGENTS.md` | Copie + sed `workflow-ia` → `$PROJECT_NAME` |
| `CLAUDE.md` | Généré depuis template inline |
| `memory.md` | Généré vierge (toutes sections, date du jour) |
| `.claude/settings.local.json` | Copie brute |
| `.claude/commands/*.md` | Copie brute (déjà portables) |
| `.gemini/commands/*.toml` | Copie + sed |
| `.opencode/commands/*.md` | Copie + sed |
| `scripts/*.sh` | Copie brute + `chmod +x` |
| `docs/commands-list.cmd` | Copie brute |

### Étape 8.1 — Utilisation

```cmd
# Double-clic sur new-project.cmd
# → Saisir le nom du projet (ex: mon-projet)
# → Entrée pour le chemin par défaut (C:\IA\projects\mon-projet)
```

Ou depuis bash :
```bash
bash scripts/new-project.sh mon-projet [chemin-optionnel]
```

### Étape 8.2 — Vérification

```bash
ls /c/IA/projects/mon-projet/.claude/commands/ | wc -l   # → 26
ls /c/IA/projects/mon-projet/.gemini/commands/ | wc -l   # → 26
grep "mon-projet" /c/IA/projects/mon-projet/.gemini/commands/context.toml
# → _forge/mon-projet/index.md (plus "workflow-ia")
head -1 /c/IA/projects/mon-projet/memory.md
# → # mon-projet — Memory
```

### Étape 8.3 — Prochaines étapes dans le nouveau projet

```bash
cd /c/IA/projects/mon-projet
git init && git add . && git commit -m "init: bootstrap mon-projet"
bash scripts/install-commands.sh --all
bash scripts/obsidian-sync.sh  # → crée /_forge/mon-projet/ dans le vault
```

> **Leçon :** `normalize_path()` avec BASH_REMATCH est le pattern propre pour convertir
> `C:\foo\bar` → `/c/foo/bar` dans un script bash appelé depuis .cmd Windows.

---

## Notes complémentaires

### Custom Slash Commands — Notes importantes

**OpenCode :**
- Les custom slash commands fonctionnent **uniquement en mode interactif**
- Commande : `opencode` (sans arguments) dans le dossier du projet
- `opencode run "/commande"` **ne fonctionne pas** — les commands ne sont pas reconnues
- Dossier global Windows : `%APPDATA%\opencode\commands\` (pas `~/.config/opencode/commands/`)

**Gemini CLI :**
- Les custom slash commands TOML sont supportées (depuis v0.30.0)
- Dossier local : `<project>/.gemini/commands/`
- Dossier global : `~/.gemini/commands/`
- À tester en mode interactif (`gemini` sans arguments)

---

## Écarts réels vs tuto original

| # | Écart | Raison |
|---|---|---|
| 1 | `~/.gemini/settings.json` avait une section `security.auth` | Toujours lire avant d'écraser |
| 2 | Vault déjà partiellement peuplé en Phase 3 | Script protège les fichiers existants |
| 3 | `git subtree split` a réécrit les SHA | SHA anciens invalides après déplacement |
| 4 | Hook pre-commit référençait un chemin préfixé | Corrigé après déplacement du repo |
| 5 | `install-commands.sh` dans `scripts/` au lieu de `_setup/` | workflow-ia est autonome, pas dépendant de _setup |
| 6 | Phases 4 et 5 commitées ensemble | Logiquement liées dans la même session |
| 7 | Mode plan Gemini (`defaultApprovalMode: plan`) activé par défaut | Supprimé en Phase 6 — trop intrusif pour un usage quotidien |
| 8 | Commands multi-outils absentes du tuto original | Ajoutées en Phase 6 — Gemini (TOML) + OpenCode (MD) + `--all` |
| 9 | 12 → 26 commands absentes du tuto original | Ajoutées en Phase 7 — /start + 13 Obsidian × 3 outils + commands-list.cmd |
| 10 | Bootstrapper absent du tuto original | Ajouté en Phase 8 — new-project.cmd/.sh, portabilité par sed, normalize_path() |
| 11 | Commande `/improve` absente du tuto | Analyse structurée par impact (high/medium/low), output dans vault `backlog.md` |
| 12 | `$PROJECT_NAME` hardcodé dans Gemini TOML | `!{bash -c "basename $(pwd)"}` — résolution dynamique obligatoire pour portabilité |
| 13 | `docs/improve.md` dans le repo git | Migré vers vault `backlog.md` — la planification n'est pas du code |
| 14 | `/improve` sans contexte préalable | Lit `bugs.md` + `backlog.md` avant analyse — sinon résultats génériques hors contexte |
| 15 | `obsidian-sync.sh` réappend toute la section à chaque sync → doublons | F1 — `awk 'NF && !seen[$0]++'` + écriture atomique `.tmp`/`mv` après chaque append |
| 16 | Hook pre-commit copié dans `.git/hooks/` → désynchronisation possible | F2 — `git config core.hooksPath scripts/hooks` lit directement depuis le dossier versionné |
| 17 | `check_memory.sh` ne valide pas les emojis d'ancrage de `obsidian-sync.sh` | F3 — boucle `while read` sur les 8 emojis (🎯🏗️📁📜🐛📝📚⛔) dans les `##` headers |
| 18 | Chemins vault hardcodés `/c/Users/Despes/...` dans les scripts | E2 — `scripts/config.env` sourcé partout, chemins via `$HOME` |
| 19 | `$ARGUMENTS`/`{{args}}` en début de prompt → cache miss à chaque appel | D3 — 4 commandes corrigées (debug, trace, compound, ghost) × 2 outils |
| 20 | `grep "🌐"` silencieusement vide dans les pipes Git Bash Windows | B-reste — remplacé par `[[ "$line" == *"🌐"* ]]` bash native, `_global/lessons.md` désormais alimenté |
| 21 | `install-commands.sh` count hardcodé 31 ≠ 33 commandes actuelles | K1 — count dynamique `REF_COUNT=$(ls ... | wc -l)` |
| 22 | `gemini-daily.sh` : `xargs cat` sans protection entrée vide | K2 — `xargs -r cat` (ne s'exécute pas si vide) |
| 23 | `obsidian-sync.sh` : `awk 'NF && !seen[$0]++'` supprime lignes vides | K3 — `awk '!seen[$0]++ || !NF'` préserve lignes vides |
| 24 | `obsidian-sync.sh` ne vérifie pas si iCloud est accessible | I2 — validation pre-flight `timeout 3s ls "$FORGE_DIR"` |
| 25 | `obsidian-sync.sh` : code dupliqué étapes 8-10 (append+dédup) | I3 — helper `append_section()` factorisé (~30 lignes gagnées) |
| 26 | Vault files : pas de stats ni navigation | F5 — stats dynamiques + footer `[[index|🏠]]` dans chaque fichier |
| 27 | A-reste : heredoc inline dans new-project.sh | scripts/templates/memory.md.tpl + sed — template externalisé |
| 28 | Pas de validation wikilinks dans vault | F4 — /vault-check (34 commands × 3 outils) |
| 29 | Pas d'évaluation rtk/cli-continues | G2/G5 — évaluation documentée, pertinents pour tokens/handoff |

---

## Phase 9 — Commande /improve (analyse technique) ✅

**Objectif :** Permettre à l'IA d'analyser le projet actif et proposer des améliorations structurées,
en tenant compte du contexte réel du projet (bugs ouverts, backlog existant).

### Commande /improve — Ordre de lecture obligatoire

```
1. memory.md  (Focus Actuel, Architecture, Fichiers clés, Bugs connus)
2. vault/bugs.md       ← bugs ouverts (ne pas reproposer comme amélioration)
3. vault/backlog.md    ← backlog actif (ne pas redoubler)
4. vault/architecture.md
5. fichiers source du projet
```

> ⚠️ **Sans la lecture de `bugs.md` + `backlog.md` en amont, `/improve` produit
> une analyse générique hors contexte.** L'IA reproduit ce qui est déjà documenté
> comme bug ou backlog, sans apporter de valeur ajoutée.

### Catégories analysées

| Catégorie | Contenu analysé |
|-----------|-----------------|
| Code | Fonctions >50 lignes, code dupliqué, variables |
| Architecture | Couplage, SRP, redondance |
| Performance | N+1, loops inutiles |
| Maintenabilité | Tests, docs, complexité |
| Bonnes pratiques | Patterns, erreurs, naming |

**Output :** Tableau trié par impact (High/Medium/Low)

### Résultat

- Propositions dans **vault `backlog.md`** (plus dans `docs/improve.md`)
- `backlog.md` = source unique du backlog, hors du repo git (c'est de la planification, pas du code)
- `features.md` = roadmap haut niveau distincte

> **Leçon clé :** Filtrer les rapports IA par ROI et contexte. En moyenne, 1 bonne
> idée sur 8 est retenue d'un rapport générique. Lire `bugs.md` + `backlog.md` avant
> de lancer `/improve` est non négociable.

---

## Phase 10 — Vault infra robuste ✅ (session 2026-02-28)

**Objectif :** Rendre la stack production-grade — 10 améliorations du backlog vault implémentées.

| Item | Fichier modifié | Amélioration |
|------|----------------|--------------|
| F1 | `obsidian-sync.sh` | Dédup `awk` post-append sur bugs/lessons/decisions |
| F2 | `new-project.sh` + `.git/config` | `core.hooksPath scripts/hooks` — hook versionné sans copie |
| F3 | `check_memory.sh` | Validation des 8 emojis d'ancrage avant commit |
| E2 | `scripts/config.env` (nouveau) | Chemins vault portables via `$HOME` |
| D3 | 8 custom commands | `$ARGUMENTS`/`{{args}}` en dernière ligne pour cache hit |
| B-reste | `obsidian-sync.sh` | `grep "🌐"` → `while read` bash native (fix UTF-8 Git Bash) |
| K1 | `install-commands.sh` | Count dynamique (33 au lieu de 31 hardcodé) |
| K2 | `gemini-daily.sh` | `xargs -r` — ne s'exécute pas si entrée vide |
| K3 | `obsidian-sync.sh` | `awk '!seen[$0]++ || !NF'` préserve lignes vides |
| I2 | `obsidian-sync.sh` | Validation pre-flight iCloud (`timeout 3s ls`) |
| I3 | `obsidian-sync.sh` | Helper `append_section()` factorisé |
| F5 | `obsidian-sync.sh` | Stats dynamiques + footer navigation dans vault |

### Patterns réutilisables retenus

- **Dédup vault** : `awk '!seen[$0]++ || !NF'` + écriture atomique `.tmp`/`mv` — compatible `set -euo pipefail`, préserve lignes vides
- **Portabilité scripts** : `source "${SCRIPT_DIR}/config.env"` centralise tous les chemins absolus
- **Emoji en pipe Git Bash** : `grep` échoue sur tous les modes (--a, -F, -P, LC_ALL) — utiliser `[[ "$line" == *emoji* ]]`
- **Cache des prompts** : tout contenu statique en tête, `$ARGUMENTS`/`{{args}}` en toute dernière ligne
- **xargs sécurité** : toujours `xargs -r` pour éviter l'exécution si entrée vide

---

## Phase 11 — Tests shell + gemini-git-info.sh ✅ (session 2026-02-28)

**Objectif :** Couvrir les scripts critiques par des tests automatisés + centraliser les appels git pour Gemini CLI.

| Item | Fichier créé/modifié | Amélioration |
|------|---------------------|--------------|
| I4 | `scripts/gemini-git-info.sh` (nouveau) | Centralise git status/log/diff avec `--no-pager` forcé |
| I1 | `tests/test_check_memory.sh` (nouveau) | 5 cas de test unitaires pour `check_memory.sh` |
| I1 | `tests/test_sync.sh` (nouveau) | 5 cas de test : extract_section, append_section (K3), dedup, rotate_sessions |
| I1 | `tests/test_helpers.sh` (nouveau) | Helpers partagés ok/fail/assert_exit/assert_contains/summary |

### Patterns réutilisables retenus

- **Tests bash** : `source tests/test_helpers.sh` centralise les helpers — tout nouveau script de test doit le sourcer
- **Fonctions dépendantes iCloud** : copier inline dans les tests (pas sourcer) pour éviter le sourcing de `config.env`
- **grep dans les tests** : toujours `-qF` (fixed-string) sauf si ancres regex nécessaires (`^pattern$`)
- **grep -m1** au lieu de `grep | head -1` — un subprocess de moins, pattern recommandé
- **Fixture unique dans `$content`** : lire une fois, réutiliser — évite N subprocesses pour N assertions

### Structure tests/

```
tests/
├── test_helpers.sh         # helpers partagés (sourcer depuis chaque test)
├── test_check_memory.sh    # tests check_memory.sh
└── test_sync.sh            # tests obsidian-sync.sh helpers
```

Usage : `bash tests/test_check_memory.sh && bash tests/test_sync.sh`

---

## Phase 12 — A-reste + F4 /vault-check + G2/G5 évaluation ✅ (session 2026-03-01)

**Objectif :** Finaliser le template externalisé, ajouter une commande de vérification vault, évaluer deux outils pertinents.

| Item | Fichier créé/modifié | Amélioration |
|------|---------------------|--------------|
| A-reste | `scripts/templates/memory.md.tpl` (nouveau) | Template externe pour bootstrap au lieu de heredoc dans new-project.sh |
| A-reste | `scripts/new-project.sh` (modifié) | Utilise `sed` sur le template au lieu de heredoc inline |
| F4 | `scripts/vault-check.sh` (nouveau) | Vérifie wikilinks `[[...]]` dans vault — exit 0 si OK, 1 si orphelins |
| F4 | `.claude/commands/vault-check.md` (nouveau) | Commande Claude |
| F4 | `.gemini/commands/vault-check.toml` (nouveau) | Commande Gemini |
| F4 | `.opencode/commands/vault-check.md` (nouveau) | Commande OpenCode |
| G2 | Évaluation rtk | Outil Rust Token Killer — 1566⭐, réduction 60-90% tokens CLI |
| G5 | Évaluation cli-continues | Outil transfer sessions IA — 639⭐, crossClaude/Gemini/OpenCode |

### Patterns réutilisables retenus

- **Template externalisé** : `sed -e "s|PROJECT_NAME|$PROJECT_NAME|g" -e "s|DATE_PLACEHOLDER|$DATE|g" templates/memory.md.tpl` — plus propre que heredoc, versionnable
- **Wikilinks validation** : `grep -oP '\[\[[^\]]+\]\]'` pour extractor, puis vérifier existence cible avec `-f` ou `-d`

### Évaluations G2/G5

**rtk (Rust Token Killer) :**
- Repo : `rtk-ai/rtk`
- Stars : 1566
- Fonction : CLI proxy compressant les sorties de commandes avant reaches LLM
- Économie : 60-90% tokens
- Compatibilité : Claude Code, Cursor, Gemini CLI, Aider, Codex, Windsurf, Cline
- À faire : installer via `cargo install rtk` ou leur installeur

**cli-continues :**
- Repo : `yigitkonur/cli-continues`
- Stars : 639
- Fonction : Transfère sessions IA entre outils (Claude, Copilot, Gemini, Codex, OpenCode, Droid, Cursor)
- Capture : conversation, shell commands, file edits, reasoning blocks
- À tester : `npx continues`

### Structure scripts/templates/

```
scripts/
├── templates/
│   └── memory.md.tpl    # Template externe pour bootstrap
```

### Structure commands (34 maintenant)

```
.claude/commands/      # 34 fichiers .md
.gemini/commands/       # 34 fichiers .toml
.opencode/commands/     # 34 fichiers .md
```

Usage `/vault-check` :
```bash
/vault-check                          # Vérifie _forge/workflow-ia/
/vault-check C:\path\to\vault        # Vérifie un autre vault
```

---

## Phase 13 — S1 statusline + N3 E2E + gemini-close.sh ✅ (commit `a714734`)

### Objectif

Validation finale de l'infrastructure :
- **S1** : Statusline bash + Python (4 scénarios)
- **N3** : Tests E2E workflow complet (12/12)
- **gemini-close.sh** : Script unifié pour clore session

### Contenu

#### S1 — Statusline

Scripts créés :
- `scripts/statusline.sh` — Prompt bash avec statusline
- `scripts/statusline.py` — Prompt Python avec statusline

4 scénarios testés :
1. ✅ Session normale
2. ✅ Git dirty (fichiers modifiés)
3. ✅ Git ahead (commits en attente)
4. ✅ Combiné (dirty + ahead)

#### N3 — Test E2E

Fichier : `tests/test_workflow_e2e.sh`

12 tests couvrant :
- T1 : Sync sans erreur sur vault mock
- T2 : sessions.md contient snapshot
- T3 : Rotation sessions (11 → 10)
- T4 : _global/lessons.md reçoit les leçons 🌐

#### gemini-close.sh

Script unifié qui remplace les commandes git directes dans `/close.toml` :
```bash
# Équivalent de :
git add memory.md
git commit -m "chore: fin de session"
git push
```

Avantages :
- Évite les freezes Gemini avec les blocs `!{}`
- Une seule autorisation (vs 3)
- Réutilise `obsidian-sync.sh` pour la sync vault

---

## Phase 14 — Tests Python + cli-continues verdict ✅ (session 2026-03-01)

**Objectif :** Ajouter des tests Python pour les scripts Python, évaluer cli-continues.

| Item | Fichier créé | Description |
|------|-------------|-------------|
| O1 | `tests/test_generate_commands.py` | 10 tests pour generate_commands.py (15 assertions) |
| O1 | `tests/test_vault_sync.py` | 12 tests pour vault_sync.py (13 assertions) |
| G5-bis | Évaluation cli-continues | Outil cross-tool session manager |

### Tests Python — Pattern adopté

Pour les scripts Python, préférer des tests Python dédiés plutôt que des tests bash :

```bash
# Exécution
python tests/test_generate_commands.py
python tests/test_vault_sync.py

# Résultat attendu : 28 OK / 0 FAIL
```

**Patterns adoptés :**
- **Emojis dans print()** : Windows cp1252 ne supporte pas les emojis → utiliser `[OK]` / `[FAIL]`
- **Import module** : `importlib.util.spec_from_file_location()` + `module_from_spec()` + `loader.exec_module()`
- **Fichiers temporaires** : `tempfile.TemporaryDirectory()` avec cleanup automatique
- **Assertions** : assert_exit, assert_file_exists, assert_file_contains (style identique aux helpers bash)

### cli-continues — Verdict : Sur-engineering

**Analyse :**
- Fonctionne (164 sessions détectées)
- Cross-tool handoff (`--in claude`) timeout lors du test
- Dépendance npm externe + indexation continue
- 164 sessions = bruit, pas de valeur ajoutée pour mon usage

**Conclusion :** Garder en watchlist, utiliser `/start` + `memory.md` pour reprendre un projet.

---

## Rappels outils MCP

| Outil | Évaluation | Statut |
|-------|-----------|--------|
| rtk | Token killer (60-90% économies) | À tester |
| cli-continues | Cross-tool session manager | Non adopté — sur-engineering |
| GitHub MCP | PAT-based, global | Adopté ✅ |
