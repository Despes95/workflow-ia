# Tutorial Optimisation Workflow IA — v2.6

> Windows 11 · Git Bash · `C:\IA\` comme racine
> 📍 Chaque commande précise depuis quel dossier la lancer
> ✅ Chaque étape a une vérification — ne passe pas à la suite sans l'avoir faite

---

---

## ⚠️ À lire avant de commencer

Ce workflow n'est **pas** fait pour :
- tester une IA en 10 minutes
- prendre des notes rapides
- remplacer Obsidian par magie

Il est fait pour :
- travailler des **mois** sur des projets complexes
- **capitaliser** sur tes décisions et tes patterns
- changer d'IA sans perdre ton raisonnement
- construire un cerveau externe versionnable et auditable

> 👉 **Si tu n'as pas encore un projet actif en cours**, commence par la [Version Starter (30 min)](#-version-starter--par-où-commencer-30-min) uniquement.
> Le reste vient naturellement quand tu en ressens le besoin.

---

## Vue d'ensemble — Ce qu'on va faire

| Phase | Durée estimée | Impact |
|---|---|---|
| **Phase 1** — Unification des règles IA | ~45 min | Immédiat — moins de fichiers à maintenir |
| **Phase 2** — Amélioration de memory.md | ~20 min | Immédiat — l'IA se repère mieux |
| **Phase 3** — Remplacement de memory_all.md par le vault Obsidian | ~3h | Mémoire longue durée exploitable |
| **Phase 4** — Connecter l'IA au vault (accès direct) | ~30 min | L'IA lit le vault par chemin absolu, sans CLI |
| **Phase 5** — Custom slash commands | ~2h | Automatisation des rituels de session |
| **Phase 6** — Leçons transversales (global lessons) | ~1h | Capital intellectuel qui s'accumule sur tous les projets |
| **Phase 7** — Momentum Transfer (passage de relais inter-IA) | ~30 min | L'IA suivante reprend exactement là où la précédente s'est arrêtée |
| **Phase 8** *(Roadmap)* — Rehydration + multi-projets auto | future | Reconstruire memory.md depuis le vault, orchestration cross-projets |

---

## 🚀 Version Starter — Par où commencer (30 min)

> Tu n'as pas encore de projet actif ou tu veux tester sans tout mettre en place d'un coup ?
> Commence par ces 3 phases uniquement. Le reste vient naturellement ensuite.

| Étape | Ce que tu fais | Temps |
|---|---|---|
| **Phase 1** | Unifier les règles IA (AGENTS.md) | ~45 min |
| **Phase 2** | Améliorer memory.md (section fichiers clés) | ~20 min |
| **Phase 5** | Installer les slash commands de base (`/context`, `/close`) | ~20 min |

**Résultat starter :** Une IA qui se souvient d'une session à l'autre, avec 2 commandes essentielles.
**Quand ajouter la suite :** Quand tu sens que tu perds du contexte entre les sessions (→ Phase 3 + 4), ou quand tu veux capitaliser sur tes patterns (→ Phase 6).

> ℹ️ La Phase 7 (Momentum Transfer) est réservée au moment où tu switches régulièrement entre plusieurs IA sur le même projet. Inutile avant.

---

## ⚡ Modes de session — Adapte le niveau de rigueur

> Un système contourné meurt. Ces modes sont là pour que tu ne contournes jamais le tien.

| Mode | Quand | Ce que tu fais |
|---|---|---|
| **Mode complet** | Session de fond, feature importante | `/my-world` → dev → `/close` → push |
| **Mode rapide** | Session courte, correctif, exploration | `/context` → action → `/close` |
| **Mode urgence** | Hotfix, idée flash, moins de 20 min | `/context` → action → commit manuel |

**Règle :** Le mode urgence est légitime. Un `/close` raté vaut mieux qu'un système abandonné.

---

## PHASE 1 — Unifier les règles IA (un seul fichier au lieu de trois)

### Pourquoi

Tu maintiens actuellement `GEMINI.md`, `CLAUDE.md`, et `AGENTS.md` qui disent essentiellement la même chose. Gemini CLI peut lire `AGENTS.md` directement via sa config — inutile de dupliquer.

### Étape 1.1 — Configurer Gemini CLI pour lire AGENTS.md

```bash
# 📍 Depuis Git Bash — n'importe où
cat ~/.gemini/settings.json
```

Tu dois voir le contenu actuel. Note ce qu'il contient.

> ⚠️ **La commande suivante écrase tout le fichier.**
> Si tu avais une clé API ou d'autres préférences dans `settings.json`,
> recopie-les manuellement dans le nouveau fichier avant de valider.

On va l'enrichir :

```bash
# 📍 Depuis Git Bash — n'importe où
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

cat ~/.gemini/settings.json
# ✅ Doit afficher les 4 clés dont "contextFileName": "AGENTS.md"
```

> ℹ️ Gemini CLI va maintenant charger automatiquement `AGENTS.md` au démarrage,
> exactement comme il chargeait `GEMINI.md`. Tu peux supprimer `GEMINI.md` de tes projets.

---

### Étape 1.2 — Faire pointer CLAUDE.md vers AGENTS.md

Claude Code charge `CLAUDE.md` en priorité. Au lieu de dupliquer le contenu,
on fait pointer `CLAUDE.md` vers `AGENTS.md` via une directive d'import.

Ouvre le template `CLAUDE.md` dans `_setup` :

```bash
# 📍 Depuis Git Bash — n'importe où
cat > /c/IA/_setup/claude-setup/CLAUDE.md << 'EOF'
# [Nom du Projet] — Règles Claude Code

@AGENTS.md

## Règles spécifiques Claude Code

- Toujours utiliser Plan Mode avant de toucher au code
- `/plan` en début de session si non activé automatiquement
- Confirmer avec l'utilisateur avant tout refactor touchant plus de 3 fichiers
EOF

cat /c/IA/_setup/claude-setup/CLAUDE.md
# ✅ Doit afficher la directive @AGENTS.md + les règles spécifiques
```

> ℹ️ `@AGENTS.md` dit à Claude Code "charge aussi ce fichier". AGENTS.md contient
> les règles communes. CLAUDE.md contient uniquement ce qui est spécifique à Claude.

---

### Étape 1.3 — Mettre à jour le template AGENTS.md

Le fichier `AGENTS.md` devient la source de vérité unique. Mets-le à jour dans `_setup` :

```bash
# 📍 Depuis Git Bash — n'importe où
cat > /c/IA/_setup/opencode-setup/AGENTS.md << 'EOF'
# [Nom du Projet] — Règles communes (OpenCode · Gemini CLI · Claude Code)

## Comportement général

- Tu réponds TOUJOURS en français, sans exception
- Toujours lire `memory.md` en PREMIER avant d'agir
- Toujours lire `_forge/[Nom du Projet]/index.md` pour le contexte long terme
- Git First : `git status` + `git diff` + `git log --oneline -10` avant toute action
- Commits autonomes aux checkpoints (feature, refactor, bug, fin session)
- Marqueurs de maturité dans memory.md : `Stable` / `En cours` / `Expérimental` / `Déprécié`
- Historique memory.md : 5 entrées max dans la section Récap sessions

## Règles de mémoire

- En début de session : lire memory.md + _forge/[Nom du Projet]/index.md
- En fin de session (prompt "fin de session") : mettre à jour memory.md EN ENTIER,
  puis alimenter les fichiers _forge correspondants

## Règles Git

- Ne jamais committer sans inclure memory.md
- Un commit par checkpoint logique, pas un seul commit massif en fin
- Format commit : `type: description courte` (feat, fix, refactor, chore, docs)

## Modes de session

- **Mode complet** : `/my-world` → dev → `/close` → push
- **Mode rapide** : `/context` → action → `/close`
- **Mode urgence** : `/context` → action → commit manuel (pas de `/close`)

**Le mode urgence est légitime. Un `/close` raté vaut mieux qu'un système abandonné.**
**Un système contourné meurt. Ces modes existent pour que tu ne contournes jamais le tien.**

## Détection de patterns (pré-Phase 8)

Si un pattern apparaît dans ≥ 3 sessions ou ≥ 2 projets différents :
- Le signaler explicitement à l'utilisateur
- Le formuler comme : "Ce pattern revient — candidat à une leçon globale 🌐"
- Ne pas l'écrire dans le vault sans validation

## Cold Start Protocol

Si la dernière session date de plus de 7 jours :
1. Lire uniquement `index.md` + `architecture.md` (PAS `sessions.md`)
2. Poser ces 3 questions précises (une par une, pas toutes d'un coup) :
   - "Quel est le dernier fichier que tu as modifié ?" → met à jour `Fichiers clés`
   - "Y a-t-il une décision prise hors IA depuis la dernière session ?" → `decisions.md` si oui
   - "Quelle était la prochaine étape que tu avais en tête ?" → met à jour `Focus Actuel`
3. Résumer : "Reprise après X jours. Fichier actif : [X]. Prochaine étape : [Y]."
4. Attendre confirmation avant toute autre action

## Daily Notes (capture iOS)

- Chemin vault : `$USERPROFILE/iCloudDrive/iCloud~md~obsidian/Daily/`
- Les commandes `/emerge` et `/my-world` lisent les 7 dernières daily notes
- Ces notes sont en lecture seule — ne jamais y écrire programmatiquement
- Elles alimentent la détection de patterns implicites (idées random → insights)

## Dictionnaire des Vibes (Momentum)

- **Fonctionnel-pur** : Pas de classes, pas d'état mutable, composition de fonctions
- **Défensif/tests-first** : Tout commit doit avoir des tests, même minimaux
- **Exploratoire** : Code jetable, pas de tests, objectif = apprendre vite
- **Optimisé-perf** : Vitesse d'exécution prioritaire (temporaire, documenter pourquoi)
- **Minimaliste/MVP** : Le moins de code possible, zéro généralisation prématurée
- **Debug** : Logs partout, rien à refactorer, objectif = comprendre le bug

## Contraintes

- Ne jamais modifier opencode.json ou AGENTS.md sans validation explicite
- Toujours montrer un plan avant tout refactor ou suppression de fichier
- Ne toucher à aucun fichier tant que l'utilisateur n'a pas confirmé
EOF

cat /c/IA/_setup/opencode-setup/AGENTS.md
# ✅ Doit afficher les 4 sections
```

---

### Étape 1.4 — Mettre à jour init-master.sh pour supprimer GEMINI.md

```bash
# 📍 Depuis Git Bash — n'importe où
# On ouvre le script dans un éditeur pour modifier la section "Copie des fichiers de règles"
# Remplace la ligne qui copie GEMINI.md par une copie de AGENTS.md uniquement

# Avant (dans init-master.sh, section 5) :
# cp "$SETUP_DIR/gemini-setup/GEMINI.md" ./GEMINI.md
# cp "$SETUP_DIR/claude-setup/CLAUDE.md" ./CLAUDE.md
# cp "$SETUP_DIR/opencode-setup/AGENTS.md" ./AGENTS.md

# Après :
# cp "$SETUP_DIR/opencode-setup/AGENTS.md" ./AGENTS.md
# cp "$SETUP_DIR/claude-setup/CLAUDE.md" ./CLAUDE.md
# (plus de GEMINI.md)
```

Édite le fichier directement :

```bash
# 📍 Depuis Git Bash — n'importe où
sed -i 's|cp "\$SETUP_DIR/gemini-setup/GEMINI.md" ./GEMINI.md|# GEMINI.md supprimé — Gemini lit AGENTS.md via settings.json|g' \
  /c/IA/_setup/init-master.sh

grep "GEMINI" /c/IA/_setup/init-master.sh
# ✅ Doit afficher la ligne commentée, pas de copie active
```

---

### Étape 1.5 — Vérification Phase 1

```bash
# 📍 Depuis Git Bash — n'importe où

# Vérifier config Gemini
cat ~/.gemini/settings.json | grep contextFileName
# ✅ Doit afficher : "contextFileName": "AGENTS.md"

# Vérifier template CLAUDE.md
grep "@AGENTS.md" /c/IA/_setup/claude-setup/CLAUDE.md
# ✅ Doit afficher : @AGENTS.md

# Vérifier template AGENTS.md
wc -l /c/IA/_setup/opencode-setup/AGENTS.md
# ✅ Doit afficher > 20 lignes
```

✅ **Phase 1 terminée. Tu passes de 3 fichiers de règles à 1 seul.**

---

## PHASE 2 — Améliorer memory.md (section fichiers clés)

### Pourquoi

Sans une section `📁 Fichiers clés`, l'IA passe du temps à explorer le mauvais
endroit du code. Cette section lui donne une carte immédiate du projet.

### Étape 2.1 — Mettre à jour le template memory.md

```bash
# 📍 Depuis Git Bash — n'importe où
cat > /c/IA/_setup/opencode-setup/memory.md << 'EOF'
# [Nom du Projet] — Memory

**Dernière mise à jour :** YYYY-MM-DD
**Dernier outil CLI utilisé :** [OpenCode / Gemini CLI / Claude Code] — [modèle]

---

## 🎯 Focus Actuel

- **Mission en cours** : [ce sur quoi tu travailles en ce moment]
- **Prochaine étape** : [la prochaine chose à faire]
- **Zone sensible** : [fichiers ou fonctions qui peuvent casser]
- **État git** : Propre

---

## 🏗️ Architecture

- **Objectif** : [ce que fait le projet en une phrase]
- **Stack** : [ex: React + Tailwind + TypeScript + Vite]
- **Workflow dev** : Plan Mode → validation → code

---

## 📁 Fichiers clés

<!-- Format : `chemin/fichier` — rôle en une phrase — [Stable|En cours|Expérimental|Déprécié] -->
- `[fichier_principal]` — [rôle] — [maturité]
- `[fichier_2]` — [rôle] — [maturité]

> ℹ️ Ne pas lister tous les fichiers — seulement ceux qu'on touche souvent
> ou ceux qui cassent tout si on les modifie sans précaution.

---

## 📜 Récap sessions (5 max)

### Résumé global

- [état actuel du projet en 2-3 phrases]

### Historique

- YYYY-MM-DD | [outil] | [ce qui a été fait] | [fichiers touchés] | [Stable/En cours]

---

## ✅ Todo

- [ ] [tâche en cours]

---

## 🐛 Bugs connus

- Aucun connu actuellement

---

## 📝 Leçons apprises

- [ex: "Le composant Card plante si props manquantes — ajouter valeurs par défaut"]

---

## ⛔ Contraintes & Interdits

- [ex: "Ne pas modifier le système de routing — tout casse"]
- Ne jamais modifier AGENTS.md sans validation

## ⚠️ Règle d'or — Écriture dans le vault

Tu as un droit de **lecture total** sur `_forge/`.
L'écriture dans `_forge/` est **exclusivement réservée** à :
- La commande `/session-end` ou `/close`
- Une demande explicite avec diff affiché avant écriture

**Ne jamais modifier un fichier `_forge/` sans montrer d'abord ce que tu vas écrire.**

Les commandes `/my-world`, `/emerge`, `/challenge`, `/connect`, `/ideas`, `/trace`, `/today`, `/global-connect`, `/context` sont **en lecture seule**. Elles ne créent, ne modifient, ne suppriment aucun fichier.
EOF

wc -l /c/IA/_setup/opencode-setup/memory.md
# ✅ Doit afficher > 40 lignes
```

---

### Étape 2.2 — Mettre à jour le hook pre-commit pour vérifier la section fichiers clés

```bash
# 📍 Depuis Git Bash — n'importe où
# Le hook vérifie déjà les sections obligatoires.
# On ajoute "Fichiers clés" à la liste.

# Dans .git/hooks/pre-commit des projets existants, remplace la ligne check "Architecture"
# par ces deux vérifications (ou fais-le manuellement dans chaque projet) :
# check "Focus Actuel"; check "Architecture"; check "Fichiers clés"; check "sessions"; check "Todo"; check "Contraintes"
```

> ℹ️ Pour les nouveaux projets, `init-master.sh` installera automatiquement
> le hook mis à jour. Pour les projets existants, refais l'étape d'installation du hook
> décrite dans le CAS 2 du tuto principal.

✅ **Phase 2 terminée. L'IA aura maintenant une carte des fichiers dès le démarrage.**

---

## PHASE 3 — Remplacer memory_all.md par un vault Obsidian structuré

### Pourquoi

`memory_all.md` est un fichier chronologique illisible. Ni toi ni l'IA ne pouvez
trouver une information précise dedans. On le remplace par des fichiers thématiques
dans Obsidian, consultables par sujet.

### Structure cible dans Obsidian

```
C:\Users\Despes\iCloudDrive\iCloud~md~obsidian\_forge\
└── <nom-du-projet>\
    ├── index.md          ← hub central — liens vers tous les fichiers
    ├── sessions.md       ← journal chronologique (ce qu'était memory_all.md)
    ├── decisions.md      ← pourquoi telle archi, pourquoi tel choix tech
    ├── bugs.md           ← bug → cause → fix → comment éviter
    ├── features.md       ← features terminées avec leur contexte
    ├── lessons.md        ← leçons réutilisables sur d'autres projets
    ├── architecture.md   ← état de l'archi, schémas textuels, fichiers clés
    └── ideas.md          ← backlog non-prioritaire, idées en vrac
```

---

### Étape 3.1 — Créer les templates dans _setup

```bash
# 📍 Depuis Git Bash — n'importe où
mkdir -p /c/IA/_setup/obsidian-templates
```

Crée chaque template :

**index.md :**

```bash
cat > /c/IA/_setup/obsidian-templates/index.md << 'EOF'
# [Nom du Projet] — Index

**Dernière sync :** YYYY-MM-DD

## Liens rapides

- [[sessions]] — journal des sessions
- [[decisions]] — choix d'architecture
- [[bugs]] — bugs résolus et patterns
- [[features]] — features livrées
- [[lessons]] — leçons apprises
- [[architecture]] — état actuel de l'archi
- [[ideas]] — backlog et idées

## Résumé du projet

[copier la section Architecture de memory.md]

## État actuel

[copier la section Focus Actuel de memory.md]
EOF
```

**sessions.md :**

```bash
cat > /c/IA/_setup/obsidian-templates/sessions.md << 'EOF'
# [Nom du Projet] — Journal des sessions

> Alimenté automatiquement par obsidian-sync.sh
> Chaque session est un bloc daté avec liens vers [[decisions]], [[bugs]], [[features]]

---

## Template session

### YYYY-MM-DD HH:MM — [outil] — [résumé en 5 mots]

**Objectif :** [ce qu'on voulait faire]
**Réalisé :** [ce qui a été fait]
**Fichiers touchés :** `fichier1`, `fichier2`
**Décisions prises :** → [[decisions#ancre-si-besoin]]
**Bugs rencontrés :** → [[bugs#ancre-si-besoin]]
**Prochaine étape :** [suite logique]
EOF
```

**decisions.md :**

```bash
cat > /c/IA/_setup/obsidian-templates/decisions.md << 'EOF'
# [Nom du Projet] — Décisions d'architecture

> Chaque décision importante avec son contexte et ses alternatives rejetées.
> Format ADR léger (Architecture Decision Record).

---

## Template décision

### YYYY-MM-DD — [Titre de la décision]

**Contexte :** [pourquoi on a dû décider quelque chose]
**Décision :** [ce qu'on a choisi]
**Alternatives rejetées :** [ce qu'on a écarté et pourquoi]
**Conséquences :** [ce que ça implique pour la suite]
**Lié à :** [[sessions#date-session]], [[architecture#section]]
EOF
```

**bugs.md :**

```bash
cat > /c/IA/_setup/obsidian-templates/bugs.md << 'EOF'
# [Nom du Projet] — Bugs résolus

> Format : symptôme → cause → fix → prévention

---

## Template bug

### YYYY-MM-DD — [Symptôme en une phrase]

**Symptôme :** [ce qu'on observait]
**Cause racine :** [pourquoi ça arrivait]
**Fix appliqué :** [ce qu'on a fait]
**Comment éviter :** [règle ou pattern à retenir]
**Session :** [[sessions#date-session]]
EOF
```

**lessons.md :**

```bash
cat > /c/IA/_setup/obsidian-templates/lessons.md << 'EOF'
# [Nom du Projet] — Leçons apprises

> Leçons réutilisables. Celles marquées 🌐 sont transversales à tous les projets.

---

## Template leçon

### [Titre de la leçon] 🌐

**Contexte :** [dans quelle situation]
**Leçon :** [ce qu'on a appris]
**Application :** [comment l'appliquer la prochaine fois]
**Source :** [[sessions#date]] ou [[bugs#bug]]
EOF
```

**architecture.md :**

```bash
cat > /c/IA/_setup/obsidian-templates/architecture.md << 'EOF'
# [Nom du Projet] — Architecture

> Miroir de la section Architecture + Fichiers clés de memory.md
> Mis à jour à chaque changement structurel important

## Stack

[technologies utilisées]

## Structure des fichiers clés

```
src/
├── [dossier]   — [rôle]
└── [fichier]   — [rôle] — [Stable/En cours]
```

## Flux de données

[schéma textuel si utile]

## Décisions structurantes

→ [[decisions#titre-decision]]
EOF
```

**features.md et ideas.md :**

```bash
cat > /c/IA/_setup/obsidian-templates/features.md << 'EOF'
# [Nom du Projet] — Features livrées

---

## Template feature

### [Nom de la feature] — YYYY-MM-DD

**Description :** [ce que ça fait]
**Fichiers :** `fichier1`, `fichier2`
**Session :** [[sessions#date]]
**Notes :** [particularités, limitations]
EOF

cat > /c/IA/_setup/obsidian-templates/ideas.md << 'EOF'
# [Nom du Projet] — Idées & Backlog

> Idées non-prioritaires. Promouvoir vers Todo dans memory.md quand pertinent.

---

- [ ] [idée] — [contexte]
EOF
```

Vérifier :

```bash
ls /c/IA/_setup/obsidian-templates/
# ✅ Doit afficher : index.md sessions.md decisions.md bugs.md lessons.md architecture.md features.md ideas.md
```

---

### Étape 3.2 — Mettre à jour obsidian-sync.sh

```bash
# 📍 Depuis Git Bash — n'importe où
cat > /c/IA/_setup/gemini-setup/obsidian-sync.sh << 'SYNCEOF'
#!/bin/bash

# ============================================================
# obsidian-sync.sh — Sync memory.md → vault Obsidian structuré
# Usage : ./scripts/obsidian-sync.sh
# ============================================================

set -euo pipefail

RED='\033[0;31m'; YELLOW='\033[1;33m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; NC='\033[0m'

PROJECT_NAME=$(basename "$PWD")
# Chemin Obsidian — adapté automatiquement à l'utilisateur courant
OBSIDIAN_BASE="${USERPROFILE}/iCloudDrive/iCloud~md~obsidian/_forge"
# Fallback si USERPROFILE n'est pas défini (Git Bash parfois)
[ -z "$OBSIDIAN_BASE" ] && OBSIDIAN_BASE="${HOME}/iCloudDrive/iCloud~md~obsidian/_forge"  # fallback Git Bash
FORGE_DIR="$OBSIDIAN_BASE/$PROJECT_NAME"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M")
DATE=$(date +"%Y-%m-%d")
SESSION_ID=$(date +%s)   # ID unique pour relier bugs/leçons à cette session
SETUP_DIR="/c/IA/_setup"

echo -e "${CYAN}📚 Sync Obsidian — $PROJECT_NAME${NC}"

# Vérifier que memory.md existe
if [ ! -f "memory.md" ]; then
  echo -e "${RED}ERREUR : memory.md introuvable dans $PWD${NC}"
  exit 1
fi

# Créer le dossier _forge du projet si absent
mkdir -p "$FORGE_DIR"

# --- Initialiser les fichiers s'ils n'existent pas ---
for template in index sessions decisions bugs features lessons architecture ideas; do
  TARGET="$FORGE_DIR/$template.md"
  if [ ! -f "$TARGET" ]; then
    cp "$SETUP_DIR/obsidian-templates/$template.md" "$TARGET"
    sed -i "s/\[Nom du Projet\]/$PROJECT_NAME/g" "$TARGET"
    echo -e "${GREEN}✓ Créé : $template.md${NC}"
  fi
done

# --- Archivage automatique de sessions.md (max 40 sessions) ---
SESSION_COUNT=$(grep -c "^## 20" "$FORGE_DIR/sessions.md" 2>/dev/null || echo "0")
if [ "$SESSION_COUNT" -ge 40 ]; then
  QUARTER=$(date +"%Y-Q$(( ($(date +%-m)-1)/3+1 ))")
  ARCHIVE_FILE="$FORGE_DIR/sessions-archive-$QUARTER.md"
  cp "$FORGE_DIR/sessions.md" "$ARCHIVE_FILE"
  # Garde uniquement les 10 dernières sessions dans sessions.md
  HEAD_LINES=$(grep -n "^## 20" "$FORGE_DIR/sessions.md" | tail -10 | head -1 | cut -d: -f1)
  if [ -n "$HEAD_LINES" ]; then
    tail -n +"$HEAD_LINES" "$FORGE_DIR/sessions.md" > "$FORGE_DIR/sessions.tmp"
    echo "# ${PROJECT_NAME} — Sessions (suite de $ARCHIVE_FILE)" | cat - "$FORGE_DIR/sessions.tmp" > "$FORGE_DIR/sessions.md"
    rm "$FORGE_DIR/sessions.tmp"
  fi
  echo -e "${YELLOW}! sessions.md archivé → $ARCHIVE_FILE (était $SESSION_COUNT sessions)${NC}"
fi

# --- Ajouter un snapshot dans sessions.md ---
echo -e "\n---\n## $TIMESTAMP  <!-- session-id: $SESSION_ID -->" >> "$FORGE_DIR/sessions.md"
cat memory.md >> "$FORGE_DIR/sessions.md"
# Ajouter les marqueurs de signal vides (à remplir manuellement ou via /close)
cat >> "$FORGE_DIR/sessions.md" << MARKEOF

> [!decision] 🧠 Décision
> [À remplir — quelle décision structurante a été prise ?]

> [!insight] 💡 Insight
> [À remplir — quelle compréhension nouvelle ?]

> [!warning] ⚠️ Regret / Anti-pattern
> [À remplir — quoi éviter à l'avenir ?]
MARKEOF
echo -e "${GREEN}✓ Snapshot ajouté dans sessions.md (avec callouts Obsidian visibles)${NC}"

# --- Extraire les bugs vers bugs.md (si section non vide) ---
BUGS=$(awk '/^## 🐛/,/^## /' memory.md | grep -v "^## " | grep -v "^$" | grep -v "Aucun connu")
if [ -n "$BUGS" ]; then
  echo -e "\n---\n### $DATE — Session <!-- session-id: $SESSION_ID -->\n$BUGS" >> "$FORGE_DIR/bugs.md"
  echo -e "${GREEN}✓ Bugs extraits vers bugs.md${NC}"
fi

# --- Extraire les leçons vers lessons.md ---
LESSONS=$(awk '/^## 📝 Leçons/,/^## /' memory.md | grep -v "^## " | grep -v "^$" | grep "^-")
if [ -n "$LESSONS" ]; then
  echo -e "\n---\n### $DATE — Leçons de session <!-- session-id: $SESSION_ID -->\n$LESSONS" >> "$FORGE_DIR/lessons.md"
  echo -e "${GREEN}✓ Leçons extraites vers lessons.md${NC}"
fi

# --- Mettre à jour index.md avec la date ---
sed -i "s/\*\*Dernière sync :\*\*.*/\*\*Dernière sync :\*\* $DATE/" "$FORGE_DIR/index.md"
echo -e "${GREEN}✓ index.md mis à jour${NC}"

# --- Sauvegarder dans _archives ---
ARCHIVE_DIR="/c/IA/_archives/$PROJECT_NAME"
mkdir -p "$ARCHIVE_DIR"
cp memory.md "$ARCHIVE_DIR/memory-$DATE.md"
echo -e "${GREEN}✓ Archive créée : $ARCHIVE_DIR/memory-$DATE.md${NC}"

echo -e "\n${GREEN}════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Sync terminée → $FORGE_DIR${NC}"
echo -e "${GREEN}════════════════════════════════════${NC}"
SYNCEOF

chmod +x /c/IA/_setup/gemini-setup/obsidian-sync.sh

# Copier pour opencode aussi
cp /c/IA/_setup/gemini-setup/obsidian-sync.sh /c/IA/_setup/opencode-setup/obsidian-sync.sh

echo "✅ obsidian-sync.sh mis à jour"
```

---

### Étape 3.3 — Migrer un projet existant (si tu en as un)

```bash
# 📍 Depuis /c/IA/Projects/<ton-projet>
cd /c/IA/Projects/<ton-projet>

# Copier le script mis à jour
cp /c/IA/_setup/gemini-setup/obsidian-sync.sh scripts/obsidian-sync.sh
chmod +x scripts/obsidian-sync.sh

# Lancer la première sync (crée la structure _forge automatiquement)
./scripts/obsidian-sync.sh

# ✅ Vérifier que le vault a bien été créé
ls "${USERPROFILE}/iCloudDrive/iCloud~md~obsidian/_forge/<ton-projet>/"
# ✅ Doit afficher : index.md sessions.md decisions.md bugs.md features.md lessons.md architecture.md ideas.md
```

---

### Étape 3.4 — Supprimer memory_all.md des projets existants

```bash
# 📍 Depuis /c/IA/Projects/<ton-projet>

# Vérifier que memory_all.md est bien dans .gitignore
grep "memory_all.md" .gitignore
# ✅ Doit afficher la ligne — sinon : echo "memory_all.md" >> .gitignore

# Le contenu de memory_all.md a maintenant migré dans _forge/sessions.md
# Tu peux supprimer memory_all.md (ou le garder, il ne fait pas de mal)
rm memory_all.md

git add .gitignore
git commit -m "chore: suppression memory_all.md — vault Obsidian prend le relais"
git push origin main
```

✅ **Phase 3 terminée. Tu as maintenant un vault Obsidian structuré par thème.**

---

## PHASE 4 — Connecter l'IA au vault (accès direct par chemin)

### Pourquoi

L'Obsidian CLI officiel est en **Early Access** (payant 25$, setup Windows complexe).
Tu n'en as pas besoin : ton vault `_forge/` est juste des fichiers `.md` dans un dossier.
Claude Code les lit **directement par chemin absolu** — c'est suffisant pour tout faire.

> ℹ️ Si un jour l'Obsidian CLI devient gratuit et simple à installer,
> les commandes `/my-world` etc. s'adapteront sans rien changer d'autre.

### Étape 4.1 — Mettre à jour AGENTS.md pour référencer le vault

```bash
# 📍 Depuis Git Bash — n'importe où

cat >> /c/IA/_setup/opencode-setup/AGENTS.md << 'EOF'

## Vault Obsidian

Le vault `_forge/[Nom du Projet]/` contient la mémoire longue terme du projet.
Chemin d'accès direct : `$USERPROFILE/iCloudDrive/iCloud~md~obsidian/_forge/[Nom du Projet]/`

Fichiers à lire en début de session si le contexte est flou :
- `index.md` → point d'entrée, liens vers tout le reste
- `architecture.md` → état de l'archi et fichiers clés
- `sessions.md` → historique chronologique
- `decisions.md` → pourquoi telle archi, alternatives rejetées
- `bugs.md` → bugs résolus et patterns à éviter
- `lessons.md` → leçons réutilisables

Règle d'or : tu lis le vault, tu ne l'écris pas sans validation explicite.
EOF

tail -15 /c/IA/_setup/opencode-setup/AGENTS.md
# ✅ Doit afficher la nouvelle section Vault Obsidian
```

---

### Étape 4.2 — Prompts de démarrage et fin de session

> ℹ️ Les prompts complets (démarrage, fin, cold start) sont dans la section
> **🔑 Prompts essentiels** juste avant la Phase 5 — une seule fois, bien visibles.

> ℹ️ Avec les custom commands de la Phase 5, Claude Code utilise `/context` ou `/my-world`
> à la place du prompt long. Les prompts sont utiles pour Gemini CLI et OpenCode.

✅ **Phase 4 terminée. L'IA peut maintenant lire le vault directement.**

---

---

## 🔑 Prompts essentiels — À copier-coller

> Ces 2 prompts remplacent toute la mise en contexte manuelle.
> Garde-les dans un fichier texte ou dans ton gestionnaire de snippets.

### Prompt de démarrage (début de session)

**Pour Claude Code** — tape `/context` ou colle ce prompt :
```
Lis CLAUDE.md puis AGENTS.md. Lis memory.md.
Lis $USERPROFILE/iCloudDrive/iCloud~md~obsidian/_forge/<nom-projet>/index.md
et $USERPROFILE/iCloudDrive/iCloud~md~obsidian/_forge/<nom-projet>/architecture.md
Fais git status + git log --oneline -10.
Résume l'état du projet en 5 points : état, blocages, prochaine étape, zone sensible, dette technique.
Ne touche à aucun fichier tant que je n'ai pas confirmé.
```

**Pour Gemini CLI / OpenCode** — colle ce prompt :
```
Lis AGENTS.md puis memory.md.
Lis $USERPROFILE/iCloudDrive/iCloud~md~obsidian/_forge/<nom-projet>/index.md
Fais git status + git log --oneline -10.
Résume l'état du projet en 5 points. Ne touche à rien.
```

**Cold Start (retour après +7 jours d'absence)** :
```
Lis uniquement index.md + architecture.md du projet.
Ne lis pas tout l'historique sessions.md.
Demande-moi : "Qu'est-ce qui a changé depuis ta dernière session ?"
Met à jour la section Focus Actuel de memory.md après ma réponse.
Ne touche à rien d'autre avant confirmation.
```

---

### Prompt de fin de session

**Pour Claude Code** — tape `/close` ou colle ce prompt :
```
Fin de session. Demande-moi ce qui s'est passé.
Attends ma réponse puis :
1. Extrais les action items
2. Identifie décisions (→ decisions.md), bugs (→ bugs.md), leçons (→ lessons.md, 🌐 si transversal)
3. Remplis les callouts `> [!decision]` / `> [!insight]` / `> [!warning]` dans sessions.md
4. Montre le diff complet de memory.md que tu proposes
5. Attends ma validation explicite avant d'écrire quoi que ce soit
```

**Pour Gemini CLI / OpenCode** — colle ce prompt :
```
Fin de session. Mets à jour memory.md EN ENTIER :
Focus Actuel, Fichiers clés (maturités), Récap sessions (5 max),
Todo, Bugs, Leçons, Contraintes.
Montre le diff avant d'écrire. Attends ma confirmation.
Puis : git add memory.md && git commit -m "chore: fin de session"
```

---

## PHASE 5 — Custom slash commands

### Pourquoi

Tes rituels de session (démarrage, fin, vérification, idées) sont toujours les mêmes.
Au lieu de les retaper ou de les coller, tu tapes `/context` ou `/session-end`.
Les custom commands de Claude Code sont des fichiers Markdown dans `.claude/commands/`.

### Les 10 commands disponibles

| Commande | Quand | Ce qu'elle fait |
|---|---|---|
| `/my-world` | Début de journée | Charge tout le vault global + tous projets actifs |
| `/today` | Matin | Plan du jour basé sur le Focus Actuel |
| `/close` | Soir | Extraction + proposition de mise à jour validée |
| `/context` | Début de session projet | Contexte court terme du projet actif |
| `/emerge` | Quand tu veux voir plus loin | Patterns implicites jamais formulés |
| `/challenge` | Quand tu veux te challenger | Pression-test de tes croyances |
| `/connect` | Quand tu bloques | Ponts non-évidents entre les fichiers |
| `/trace <sujet>` | Pour comprendre un choix | Timeline d'une décision |
| `/ideas` | Quand tu cherches quoi faire | Améliorations depuis les patterns |
| `/global-connect` | Vue macro | Cross-projets, leçons à promouvoir |

> ⚠️ **Règle d'or dans chaque commande** : aucune ne crée de note dans le vault.
> Elles lisent et proposent — tu valides et tu écris.

### Contenu des 4 commandes essentielles

> Ces 4 commandes couvrent 80 % de l'usage quotidien.
> **Les 7 autres (`/trace`, `/connect`, `/challenge`, `/ideas`, `/global-connect`, `/context`, `/switch`) sont dans le pack — ajoute-les quand tu en ressens le besoin, pas avant.**
> Commence avec ces 4. Ajoute `/switch` quand tu switches entre IA. Ajoute `/trace` quand tu veux remonter une décision.

---

**`/my-world` — Charge mon monde entier (début de journée)**

```markdown
Tu es mon partenaire de pensée. Charge tout ce contexte avant de répondre.

## 1. Vault global
- Lis `$USERPROFILE/iCloudDrive/iCloud~md~obsidian/_forge/_global/lessons.md`
- Lis `$USERPROFILE/iCloudDrive/iCloud~md~obsidian/_forge/_global/index.md`

## 2. Projets actifs
Pour chaque projet listé dans `_global/index.md`,
lis son `index.md` et son `architecture.md`.

## 3. Daily Notes (si présentes)
Lis `$USERPROFILE/iCloudDrive/iCloud~md~obsidian/Daily/` — les 3 dernières.
Ces notes capturent les idées random iOS. Cherche ce qui recoupe les projets actifs.

## 4. Résumé en 5 points
1. Projet le plus actif en ce moment + son état
2. Ce qui bloque ou risque de bloquer
3. Pattern récurrent des dernières sessions
4. Une connexion entre deux projets/idées — vault + daily notes compris
5. La prochaine action logique

⚠️ Lecture seule. Tu lis, tu résumes, tu poses une question max.
```

---

**`/today` — Plan de la journée (rituel du matin)**

```markdown
Lis dans cet ordre :
1. `$USERPROFILE/iCloudDrive/iCloud~md~obsidian/_forge/_global/index.md`
2. Le `memory.md` du projet actif (demande-moi lequel si pas clair)
3. Les 3 dernières entrées de sessions.md du projet actif

Réponds avec exactement 4 points :
- Ce sur quoi je travaille aujourd'hui (basé sur le Focus Actuel)
- Un risque à surveiller aujourd'hui
- Une connexion que je pourrais explorer
- Une seule question pour clarifier les priorités si c'est flou

⚠️ Lecture seule. Ne touche à aucun fichier.
```

---

**`/close` — Fin de session (rituel du soir)**

```markdown
Demande-moi : "Qu'est-ce qui s'est passé aujourd'hui ?"
Attends ma réponse, puis :

1. Extrais les action items de ma réponse
2. Identifie les décisions prises → candidates pour `decisions.md`
3. Identifie les bugs rencontrés → candidats pour `bugs.md`
4. Identifie les leçons → candidates pour `lessons.md`
   (marque 🌐 si le pattern est transversal à d'autres projets)
5. Montre-moi le diff complet `memory.md` que tu proposes
6. Attends ma validation explicite avant d'écrire quoi que ce soit

⚠️ Tu proposes, je valide, PUIS tu écris.
Ne modifie aucun fichier avant confirmation explicite.
```

---

**`/emerge` — Surface les patterns implicites**

```markdown
Lis :
1. `$USERPROFILE/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/sessions.md`
   (les 10 dernières entrées)
2. `$USERPROFILE/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/lessons.md`
3. `$USERPROFILE/iCloudDrive/iCloud~md~obsidian/_forge/_global/lessons.md`
4. `$USERPROFILE/iCloudDrive/iCloud~md~obsidian/Daily/` (les 7 dernières daily notes)
   → idées random capturées sur iOS — souvent le signal le plus brut et non filtré

Cherche des idées que mes notes IMPLIQUENT mais que je n'ai jamais formulées.
Pas ce que j'ai écrit — ce que mes patterns suggèrent.

Croise particulièrement :
- Les bugs qui reviennent en session ET les frustrations dans les daily notes
- Les décisions annulées ET les idées alternatives capturées sur iOS
- Les leçons jamais appliquées ET les intentions notées en daily

Format :
> "D'après tes notes, tu sembles croire que [X]. Tu n'as jamais écrit ça,
> mais [réf session] + [réf daily note] pointent vers ça."

3 insights max. Formule comme hypothèses.

⚠️ Lecture seule. Tu ne crées AUCUNE note dans le vault ni dans Daily/.
```

---



> 📦 **Les 11 fichiers `.md` + `install-commands.sh` + `install-all.sh` sont fournis avec ce tuto.**
> Tu n'as rien à écrire manuellement. Si tu veux voir le contenu d'une commande,
> ouvre le fichier correspondant dans `_setup/claude-setup/.claude/commands/`.
>
> Commandes essentielles à connaître en premier :
> - `/my-world` : charge `_global/lessons.md` + `_global/index.md` → résumé 5 points (lecture seule)
> - `/today` : plan de la journée depuis le Focus Actuel de memory.md (lecture seule)
> - `/close` : extrait bugs/leçons/décisions + rempli les marqueurs 🧠💡⚠️ → propose diff → attend validation
> - `/emerge` : surface patterns implicites dans tes sessions et leçons (lecture seule)
> - `/switch` : remplit le Momentum, commit, génère le prompt bootstrap pour l'IA suivante

---

### Étape 5.1 — Copier les fichiers dans _setup

> ℹ️ Les **11 fichiers** `.md` (`/switch` inclus) + `install-commands.sh` + `install-all.sh`
> sont fournis prêts à l'emploi dans le pack de ce tuto. Tu n'as rien à créer manuellement.
> `install-all.sh` déploie **tout le workflow v2.6** sur un projet existant en une commande.

```bash
# 📍 Depuis le dossier où tu as téléchargé les fichiers du pack
# (là où sont les .md + install-commands.sh)

# Crée le dossier de destination
mkdir -p /c/IA/_setup/claude-setup/.claude/commands

# Copie les 10 fichiers de commands
cp my-world.md today.md close.md context.md emerge.md \
   challenge.md connect.md trace.md ideas.md global-connect.md \
   /c/IA/_setup/claude-setup/.claude/commands/

# Copie le script d'installation
cp install-commands.sh /c/IA/_setup/
chmod +x /c/IA/_setup/install-commands.sh

# Vérifier
ls /c/IA/_setup/claude-setup/.claude/commands/
# ✅ Doit afficher les 10 fichiers .md

ls /c/IA/_setup/install-commands.sh
# ✅ Doit exister
```

---

### Étape 5.2 — Mettre à jour init-master.sh pour déployer les commands automatiquement

Ouvre `/c/IA/_setup/init-master.sh` dans VSCode et ajoute ces lignes
**juste avant la section `# 9. Commit initial`** :

```bash
# Custom slash commands Claude Code
mkdir -p .claude/commands
cp -r "$SETUP_DIR/claude-setup/.claude/commands/"* .claude/commands/
echo -e "${GREEN}✓ Custom slash commands installés${NC}"
```

Vérifier :

```bash
grep "slash commands" /c/IA/_setup/init-master.sh
# ✅ Doit afficher la ligne ajoutée
```

> ℹ️ Désormais tout nouveau projet créé avec `init-master.sh`
> aura les 10 commands installés automatiquement.

---

### Étape 5.3 — Déployer sur un projet existant

**Option A — Script automatique (recommandé) :**

```bash
# 📍 Depuis /c/IA/Projects/<ton-projet>
cd /c/IA/Projects/<ton-projet>
bash /c/IA/_setup/install-commands.sh --project

ls .claude/commands/
# ✅ Doit afficher les 10 fichiers .md
```

**Option B — Manuel :**

```bash
# 📍 Depuis /c/IA/Projects/<ton-projet>
mkdir -p .claude/commands
cp /c/IA/_setup/claude-setup/.claude/commands/*.md .claude/commands/
```

**Versionner les commands (optionnel mais recommandé) :**

```bash
# 📍 Depuis /c/IA/Projects/<ton-projet>
# Vérifie que .claude/ n'est pas dans .gitignore
grep ".claude" .gitignore || echo "non ignoré — OK"

git add .claude/
git commit -m "feat: ajout custom slash commands Claude Code"
git push origin main
```

---

### Étape 5.4 — Tester

```bash
# 📍 Depuis /c/IA/Projects/<ton-projet>
claude

# Dans l'interface Claude Code, tape :
/my-world
# ✅ Claude doit lire _global/lessons.md + _global/index.md
#    et te répondre avec 5 points sur l'état de tes projets

/today
# ✅ Claude doit demander quel projet est actif si pas clair,
#    puis te donner un plan de journée

/context
# ✅ Claude doit lire memory.md + index.md + architecture.md
#    et te résumer le projet en 5 points
```

✅ **Phase 5 terminée. Tes rituels de session sont maintenant des commandes d'une ligne.**

---

## PHASE 6 — Leçons transversales (capital qui s'accumule sur tous les projets)

### Pourquoi

`lessons.md` par projet c'est bien. Mais les vraies pépites — les patterns qui
se répètent sur TOUS tes projets — méritent un fichier global. C'est ce qui te permet
un jour de dire à l'IA "quels patterns tu vois dans ma façon de travailler ?"
et d'obtenir une réponse qui croise Nexus Hive, ton setup IA et ton prochain projet.

### Étape 6.1 — Créer le fichier global lessons

```bash
# 📍 Depuis Git Bash — n'importe où
mkdir -p "${USERPROFILE}/iCloudDrive/iCloud~md~obsidian/_forge/_global"

cat > "${USERPROFILE}/iCloudDrive/iCloud~md~obsidian/_forge/_global/lessons.md" << 'EOF'
# Leçons globales — Tous projets

> Alimenté manuellement depuis les lessons.md de chaque projet.
> Les entrées marquées 🌐 dans les fichiers projets sont candidates ici.

## Patterns techniques récurrents

<!-- Ajoute ici les patterns qui se répètent sur plusieurs projets -->

## Patterns de workflow

<!-- Ex: "Quand je skip le Plan Mode, je casse quelque chose dans 80% des cas" -->

## Patterns d'architecture

<!-- Ex: "Les modules > 500 lignes deviennent incontrôlables — découper dès 300" -->

## Ce qui fonctionne systématiquement

<!-- Tes best practices validées par l'expérience -->

## Ce qui ne fonctionne jamais

<!-- Les choses à ne plus essayer -->
EOF

ls "${USERPROFILE}/iCloudDrive/iCloud~md~obsidian/_forge/_global/"
# ✅ Doit afficher : lessons.md
```

---

### Étape 6.2 — Créer un index global du vault

```bash
cat > "${USERPROFILE}/iCloudDrive/iCloud~md~obsidian/_forge/_global/index.md" << 'EOF'
# Index global — Tous projets

> Vue d'ensemble de tous les projets actifs et archivés.

## Projets actifs

<!-- Ajoute un lien vers chaque _forge/<projet>/index.md -->
- [[nexus_hive/index|Nexus Hive]] — orchestrateur multi-agents
- [[_setup/index|_setup]] — infrastructure IA

## Patterns cross-projets

→ [[lessons|Leçons globales]]

## Stats rapides

- Nombre de projets : X
- Dernier projet créé : YYYY-MM-DD
EOF
```

---

### Étape 6.3 — Ajouter `/global-connect` dans les custom commands

```bash
cat > /c/IA/_setup/claude-setup/.claude/commands/global-connect.md << 'EOF'
Lis ces fichiers :
1. $USERPROFILE/iCloudDrive/iCloud~md~obsidian/_forge/_global/lessons.md
2. $USERPROFILE/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/lessons.md
3. $USERPROFILE/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/bugs.md

Compare les patterns du projet actuel ($PROJECT_NAME) avec les patterns globaux.
Identifie :
1. Les leçons du projet qui méritent d'être promues en leçons globales (🌐)
2. Les patterns globaux qui s'appliquent à des risques actuels du projet
3. Une suggestion d'amélioration du workflow basée sur l'historique global

EOF

cp /c/IA/_setup/claude-setup/.claude/commands/global-connect.md \
   .claude/commands/global-connect.md 2>/dev/null || true
```

✅ **Phase 6 terminée. Tu as maintenant un capital intellectuel qui s'accumule sur tous les projets.**

---

## PHASE 7 — Momentum Transfer (passage de relais inter-IA)

### Pourquoi

Quand tu switches d'une IA à une autre (Claude → Gemini, ou Claude → OpenCode),
l'IA lit l'état du projet — mais elle perd le **momentum** :
l'intention immédiate, le raisonnement en cours, le style de code de la session.

Cette phase ajoute une section volatile dans `memory.md` + une commande `/switch`
qui transmet exactement "là où l'IA s'était arrêtée de penser".

---

### Étape 7.1 — Ajouter la section Momentum dans le template memory.md

Ouvre `/c/IA/_setup/opencode-setup/memory.md` et ajoute ce bloc
**après la section Focus Actuel** :

```markdown
---

## 🧠 Momentum (Handoff)

> Section volatile — remplie par l'IA avant un switch, effacée après reprise.

- **Pensée en cours** : [l'idée que j'avais mais pas encore codée]
- **Vibe / Style** : [Fonctionnel-pur | Orienté-objet | Défensif/tests-first | Exploratoire | Optimisé-perf | Minimaliste/MVP | Debug]
- **Contraintes actives** : [ex : "pas de nouvelles dépendances", "compat mobile obligatoire"]
- **Le prochain petit pas** : [l'action atomique immédiate à faire]
- **Contexte chaud** : [ce qu'il faut savoir que les fichiers ne disent pas encore]
```

> ℹ️ Cette section est **vide par défaut**.
> Elle est remplie uniquement quand tu tapes `/switch` avant de changer d'IA.
> L'IA qui reprend l'efface une fois le momentum adopté.

Vérifier :

```bash
grep "Momentum" /c/IA/_setup/opencode-setup/memory.md
# ✅ Doit afficher la ligne du titre de section
```

---

### Étape 7.2 — Créer la commande /switch

```bash
# 📍 Depuis Git Bash — n'importe où
cat > /c/IA/_setup/claude-setup/.claude/commands/switch.md << 'EOF'
# /switch — Passage de relais vers une autre IA

Prépare un handoff propre. Exécute dans cet ordre :

1. Remplis la section `## 🧠 Momentum (Handoff)` dans `memory.md` :
   - Pensée en cours : l'idée que tu avais mais pas encore implémentée
   - Vibe / Style : comment tu raisonnais (fonctionnel ? défensif ? exploratoire ?)
   - Le prochain petit pas : l'action atomique exacte à faire en premier
   - Contexte chaud : ce que les fichiers ne disent pas encore mais qui compte

2. Mets à jour le reste de memory.md (Focus Actuel, Todo, Bugs si besoin)

3. Fais un commit :
   `git add memory.md && git commit -m "chore: handoff — momentum capturé"`

4. Donne-moi le **prompt bootstrap exact** à coller dans l'IA suivante,
   sous ce format :
   ```
   Lis AGENTS.md puis memory.md (section Momentum en priorité).
   Lis _forge/<nom-projet>/index.md + architecture.md.
   Reprise du momentum : [résumé d'une phrase].
   Adopte immédiatement le style : [vibe/style de la section Momentum].
   Commence par le prochain petit pas : [action atomique].
   Ne touche à aucun fichier avant confirmation.
   ```

5. **Après confirmation de reprise par l'utilisateur** : efface le contenu
   de la section `## 🧠 Momentum (Handoff)` dans `memory.md`
   (laisse le titre, efface juste les 4 lignes de contenu).
   Cela évite toute confusion pour les sessions suivantes.
EOF

chmod +x /c/IA/_setup/claude-setup/.claude/commands/switch.md 2>/dev/null || true

ls /c/IA/_setup/claude-setup/.claude/commands/switch.md
# ✅ Doit exister
```

---

### Étape 7.3 — Ajouter la règle Handoff dans AGENTS.md

```bash
# 📍 Depuis Git Bash — n'importe où

cat >> /c/IA/_setup/opencode-setup/AGENTS.md << 'EOF'

## Règle de reprise (Handoff)

Si la section `## 🧠 Momentum (Handoff)` de `memory.md` n'est **pas vide** :
- Adopte immédiatement le style et l'intention décrits
- Ta première réponse commence par : "Reprise du momentum : [résumé d'une phrase]"
- **Ne commence pas à coder avant que l'utilisateur ait confirmé la reprise**
- Une fois confirmé : efface les lignes de contenu de cette section (garde le titre vide)
  pour éviter toute confusion dans les sessions suivantes
EOF

tail -10 /c/IA/_setup/opencode-setup/AGENTS.md
# ✅ Doit afficher la règle de reprise
```

---

### Étape 7.4 — Déployer /switch sur les projets existants

```bash
# Option A — Script
cd /c/IA/Projects/<ton-projet>
cp /c/IA/_setup/claude-setup/.claude/commands/switch.md .claude/commands/

# Option B — Si install-commands.sh est à jour (il inclut déjà switch.md)
bash /c/IA/_setup/install-commands.sh --project
```

---

### Exemple concret d'un switch Claude → Gemini

```
# Dans Claude Code, tu tapes :
/switch

# Claude répond avec la section Momentum remplie et le prompt bootstrap :
---
## 🧠 Momentum (Handoff)
- Pensée en cours : Refactorer le router pour supporter les agents sans état
- Vibe / Style : Fonctionnel strict, pas d'état mutable, fonctions pures
- Le prochain petit pas : Extraire `route()` de `agent_manager.py` dans `router.py`
- Contexte chaud : On venait de découvrir que l'agent "stratege" retient un état
  parasite — la solution est dans router.py, pas dans l'agent lui-même

# Prompt bootstrap généré automatiquement :
Lis AGENTS.md puis memory.md (section Momentum en priorité).
Lis _forge/nexus_hive/index.md + architecture.md.
Reprise du momentum : refactoring router pour agents sans état.
Adopte : style fonctionnel strict, fonctions pures, pas d'état mutable.
Commence par : extraire route() de agent_manager.py vers router.py.
Ne touche à aucun fichier avant confirmation.
```

✅ **Phase 7 terminée. Tes IA se passent le relais sans perdre le fil.**

---

---

## 🗺️ Roadmap — Ce qui vient après (ne pas implémenter maintenant)

> Ces fonctionnalités sont logiques dans la continuité du système.
> Elles ne sont pas urgentes — elles deviendront évidentes quand le setup actuel sera stable.

### Phase 8 — Rehydration (vault → memory.md)

**Problème futur :** Aujourd'hui, `memory.md` est la source primaire et le vault est alimenté depuis elle.
À long terme, c'est le vault qui doit devenir la source de vérité.

**Ce que ça fera :** Une commande `/rehydrate` qui reconstruit `memory.md` complet depuis :
- `_forge/<projet>/index.md` + `architecture.md` → section Architecture + Fichiers clés
- `_forge/<projet>/sessions.md` (5 dernières) → section Récap sessions
- `_forge/<projet>/bugs.md` (ouverts) → section Bugs connus
- `_forge/<projet>/lessons.md` (récentes) → section Leçons

**Quand l'implémenter :** Quand tu auras eu au moins 20-30 sessions dans le vault
et que tu sentiras que `memory.md` diverge de ce qui est dans `_forge/`.

**Ébauche de la commande `/rehydrate` (à créer le moment venu) :**
```markdown
# /rehydrate — Reconstruit memory.md depuis le vault

Lis dans l'ordre :
1. _forge/$PROJECT_NAME/index.md
2. _forge/$PROJECT_NAME/architecture.md
3. _forge/$PROJECT_NAME/sessions.md (les 5 dernières entrées)
4. _forge/$PROJECT_NAME/bugs.md (bugs non résolus uniquement)
5. _forge/$PROJECT_NAME/lessons.md (les 5 dernières leçons)

Propose une reconstruction complète de memory.md.
Montre le diff complet avant d'écrire quoi que ce soit.
Attends confirmation explicite.
```

---

### Commandes futures proches (simples à créer)

**`/learn` — Apprentissage incrémental des préférences** :
```markdown
# .claude/commands/learn.md
L'utilisateur va me donner une correction ou préférence.
Je dois :
1. La formuler comme une règle concise
2. Proposer où l'ajouter dans AGENTS.md (section appropriée)
3. Montrer le diff exact
4. N'appliquer qu'après validation

Exemple : "Arrête de proposer du TypeScript"
→ Ajout AGENTS.md : "Stack : Python par défaut, jamais TypeScript sauf demande"
```

**`/compress` — Résumé périodique des sessions** :
```markdown
# .claude/commands/compress.md
Analyse les 10 dernières entrées de sessions.md.
Identifie 3 patterns récurrents et 2 erreurs systématiques.
Propose un résumé à ajouter en haut de lessons.md.
N'écris rien. Montre uniquement le diff proposé.
```

> ℹ️ À créer quand `sessions.md` commence à dépasser 20-25 entrées.
> `/compress` devient alors le rituel mensuel de nettoyage cognitif.

---

### Idées notées (à explorer plus tard)

- **Multi-projets automatique** : `/my-world` qui détecte automatiquement les projets actifs
  sans avoir à les lister manuellement dans `_global/index.md`
- **Archivage intelligent** : Au lieu d'archiver par quota, archiver par thème
  (ex: `sessions-feature-routing.md` regroupant toutes les sessions liées au routing)
- **Leçons datées avec statut** : Ajouter `Validé / À confirmer / Abandonné` dans `lessons.md`
  pour ne pas sacraliser trop tôt des apprentissages provisoires
- **Parsing automatique des marqueurs** : Un script qui extrait automatiquement les `🧠 DECISION`,
  `💡 INSIGHT`, `⚠️ REGRET` de `sessions.md` vers `decisions.md` / `lessons.md` / un fichier dédié
- **Mode multi-IA explicit** : Section dans `AGENTS.md` qui précise quel outil pour quel usage
  (Claude → raisonnement & structure · Gemini → exploration & alternatives · Local → bulk / refactor)

---

## Workflow quotidien mis à jour

```bash
# ══════════════════════════════════════════════
# MODE COMPLET — session de fond
# ══════════════════════════════════════════════
cd /c/IA/Projects/<nom-du-projet>
claude   # ou : gemini  ou : opencode

/my-world          # charge tout le vault global (début de journée)
/today             # plan de la journée
# → dev, refactor, feature...
/connect           # quand tu bloques : ponts non-évidents
/trace <sujet>     # pour comprendre un choix passé
/emerge            # patterns implicites dans le vault
/close             # fin de session : extraction + diff + commit
# Si tu switches d'IA → /switch avant de fermer
/switch            # (optionnel) — si tu continues sur Gemini ou OpenCode
git push origin main

# ══════════════════════════════════════════════
# MODE RAPIDE — correctif, courte session
# ══════════════════════════════════════════════
cd /c/IA/Projects/<nom-du-projet>
claude
/context           # charge le contexte projet en une commande
# → action ciblée
/close             # fin de session
git push origin main

# ══════════════════════════════════════════════
# MODE URGENCE — hotfix, moins de 20 min
# ══════════════════════════════════════════════
# ⚡ CE MODE EST LÉGITIME. Utilise-le sans culpabilité.
#    Un /close raté vaut mieux qu'un système abandonné.
#    Un système contourné meurt — ces modes existent pour toi.
# ══════════════════════════════════════════════
cd /c/IA/Projects/<nom-du-projet>
claude
/context
# → action flash
git add memory.md && git commit -m "fix: ..."   # commit manuel
git push origin main

# ══════════════════════════════════════════════
# SYNC OBSIDIAN (optionnel, fait automatiquement par /close)
# ══════════════════════════════════════════════
./scripts/obsidian-sync.sh   # archivage auto si sessions.md > 40 entrées

# ══════════════════════════════════════════════
# MÉNAGE TRIMESTRIEL (1x par trimestre, ~30 min)
# ══════════════════════════════════════════════
# /compress          # résumé des 10 dernières sessions → lessons.md
# Supprimer leçons marquées "Abandonné" dans lessons.md
# Archiver manuellement les sessions > 3 mois dans sessions-archive-YYYY-QX.md
# Mettre à jour _global/lessons.md avec les leçons 🌐 du trimestre
```

---

## Référence rapide — Nouvelles commandes

### Commandes similaires — Quand utiliser quoi ?

> Ces commandes semblent se chevaucher mais ont des rôles distincts.

| Commandes | Différence |
|---|---|
| `/my-world` vs `/context` | `/my-world` = vue globale de **tous** tes projets (début de journée). `/context` = contexte du **projet actif uniquement** (début de session ciblée). |
| `/emerge` vs `/ideas` | `/emerge` cherche des patterns **implicites** que tu n'as jamais formulés (insights profonds, 1x/semaine). `/ideas` cherche des **améliorations concrètes** depuis l'historique (prochaines actions, 1x/sprint). |
| `/connect` vs `/global-connect` | `/connect` relie bugs/leçons/décisions **d'un seul projet**. `/global-connect` compare les patterns **entre tous tes projets** pour promouvoir des leçons 🌐. |

---

```bash
# ── Custom slash commands (Claude Code) ────────────────────────
/my-world             # début de journée : charge tout le vault global
/today                # plan de la journée
/context              # début de session : contexte du projet actif
/trace <sujet>        # évolution d'une décision dans le temps
/connect              # ponts non-évidents entre les patterns
/emerge               # patterns implicites jamais formulés
/challenge            # pression-test de tes croyances
/ideas                # améliorations depuis l'historique
/close                # rituel du soir : extraction + diff validé
/switch               # passage de relais vers une autre IA
/global-connect       # cross-projets, leçons à promouvoir

# ── Vault Obsidian (accès direct) ─────────────────────────────
# Chemin : $USERPROFILE/iCloudDrive/iCloud~md~obsidian/_forge/
# Lire directement par chemin absolu depuis Claude Code

# ── Structure vault Obsidian ───────────────────────────────────
# _forge/<projet>/index.md       ← hub central
# _forge/<projet>/sessions.md    ← journal (ex memory_all.md)
# _forge/<projet>/decisions.md   ← ADR légers
# _forge/<projet>/bugs.md        ← bugs résolus
# _forge/<projet>/lessons.md     ← leçons du projet
# _forge/_global/lessons.md      ← leçons transversales
# Daily/                         ← daily notes iOS (lecture seule par l'IA)
```

---

---

## 🚨 Récupération — Que faire quand ça part en vrille ?

> Ces scénarios arrivent. Avoir la procédure écrite évite la panique.

### Session coupée brutalement (crash, coupure, fermeture accidentelle)

```bash
# 📍 Depuis /c/IA/Projects/<ton-projet>

# 1. Vérifier l'état git
git status
git stash list

# 2. Vérifier memory.md — est-il cohérent ?
cat memory.md | head -30
# Si memory.md est vide ou corrompu → récupère depuis les archives
ls /c/IA/_archives/<ton-projet>/
cp /c/IA/_archives/<ton-projet>/memory-$(date +%Y-%m-%d).md ./memory.md

# 3. Reprendre via Claude Code
claude
# Puis : /context (pas /my-world — tu veux juste ce projet)
```

### memory.md diverge du vault (incohérences)

```bash
# Dans Claude Code :
/context
# Puis dire à l'IA :
# "memory.md et le vault semblent incohérents.
#  Lis index.md + les 3 dernières sessions.
#  Propose une correction de memory.md — diff complet, attends validation."
```

> ℹ️ C'est la pré-Phase 8 manuelle. `/rehydrate` automatisera ça plus tard.

### Vault Obsidian inaccessible (iCloud pas sync, chemin cassé)

```bash
# Vérifier le chemin
ls "${USERPROFILE}/iCloudDrive/iCloud~md~obsidian/_forge/"

# Si iCloud ne sync pas → forcer la sync depuis Windows
# Panneau de configuration → iCloud → Sync maintenant

# En attendant : continuer avec memory.md uniquement
# (le vault est un bonus, pas un bloquant)
claude
# Puis : "Le vault est indisponible. Travaille uniquement avec memory.md."
```

### La section Momentum est remplie mais l'IA ne la voit pas

```bash
# Dans le projet, vérifier que memory.md contient bien la section
grep "Momentum" memory.md

# Si absent → l'ajouter manuellement (template dans Phase 7)
# Si présent mais IA ne réagit pas → coller explicitement dans le prompt :
# "Lis la section ## 🧠 Momentum (Handoff) dans memory.md et adopte ce contexte."
```

### `/close` interrompu avant la fin (validation pas faite)

```bash
# Pas de panique : /close ne modifie rien sans ta validation.
# Si la session a planté après la proposition de diff mais avant confirmation :
# → les fichiers ne sont PAS modifiés
# → relance /close : "Reprends le close de la session précédente"
# → Claude va reproposer le diff

# Worst case : commit manuel
git add memory.md
git commit -m "chore: fin de session (close interrompu)"
```

---

## Troubleshooting

### Gemini ne lit plus GEMINI.md après la migration

Normal — c'est voulu. Gemini lit maintenant `AGENTS.md`. Vérifie :

```bash
cat ~/.gemini/settings.json | grep contextFileName
# ✅ Doit afficher "contextFileName": "AGENTS.md"
```

Si tu as un projet avec un vieux `GEMINI.md`, tu peux le supprimer :

```bash
# 📍 Depuis /c/IA/Projects/<ton-projet>
git rm GEMINI.md
git commit -m "chore: suppression GEMINI.md — Gemini lit AGENTS.md"
git push origin main
```

### `@AGENTS.md` ne fonctionne pas dans CLAUDE.md

Vérifie que `AGENTS.md` existe bien à la racine du projet (même dossier que `CLAUDE.md`) :

```bash
# 📍 Depuis /c/IA/Projects/<ton-projet>
ls AGENTS.md CLAUDE.md
# ✅ Les deux doivent exister dans le même dossier
```

### obsidian-sync.sh : "dossier introuvable"

```bash
# Vérifie que la variable USERPROFILE est bien définie
echo $USERPROFILE
# ✅ Doit afficher ton chemin utilisateur, ex: C:/Users/Despes

# Vérifie que le vault est accessible
ls "${USERPROFILE}/iCloudDrive/iCloud~md~obsidian/"
# ✅ Doit afficher _forge/ et d'autres dossiers

# Si le chemin iCloud est différent → édite obsidian-sync.sh ligne OBSIDIAN_BASE
nano /c/IA/_setup/gemini-setup/obsidian-sync.sh
# Change la ligne : OBSIDIAN_BASE="${USERPROFILE}/ton-vrai-chemin/_forge"
```

### Le slash command `/context` ne se trouve pas

Les custom commands doivent être dans `.claude/commands/` à la **racine du projet** :

```bash
# 📍 Depuis /c/IA/Projects/<ton-projet>
ls .claude/commands/
# ✅ Doit afficher les fichiers .md

# Si absent → copie depuis _setup
mkdir -p .claude/commands
cp /c/IA/_setup/claude-setup/.claude/commands/*.md .claude/commands/
```

### `$PROJECT_NAME` non résolu dans les commands

Claude Code remplace `$PROJECT_NAME` automatiquement par le nom du dossier courant.
Si ce n'est pas le cas, utilise le nom directement dans le prompt ou configure :

```bash
# 📍 Depuis /c/IA/Projects/<ton-projet>
echo $PROJECT_NAME
# Si vide → exporte la variable :
export PROJECT_NAME=$(basename "$PWD")
```

---

---

## 🛠️ Déploiement express — install-all.sh

> **Tu as déjà des projets et tu veux tout déployer d'un coup ?**
> `install-all.sh` applique tout le workflow v2.6 sur un projet existant en une commande.

```bash
# 📍 Depuis la racine de ton projet existant
cd /c/IA/Projects/<ton-projet>
bash /c/IA/_setup/install-all.sh

# Pour un nouveau projet (crée tout depuis zéro) :
bash /c/IA/_setup/install-all.sh --new <nom-du-projet>
```

Ce que le script fait automatiquement :
- Copie `AGENTS.md`, `CLAUDE.md` depuis `_setup` (supprime `GEMINI.md`)
- Installe les 11 slash commands dans `.claude/commands/`
- Copie `obsidian-sync.sh` dans `scripts/`
- Initialise le vault `_forge/<projet>/` avec les 8 templates
- Ajoute la section `## 🧠 Momentum (Handoff)` dans `memory.md` si absente
- Fait un commit de mise à jour

> ℹ️ `install-all.sh` est fourni dans le pack. Vois la section suivante pour le contenu complet.

**Audit de santé du workflow :**

```bash
# Crée health-check.sh dans _setup/
cat > /c/IA/_setup/health-check.sh << 'HEALTHEOF'
#!/bin/bash
# health-check.sh — Diagnostic workflow IA v2.6
# Usage : bash /c/IA/_setup/health-check.sh (depuis un projet)

FORGE_DIR="${USERPROFILE}/iCloudDrive/iCloud~md~obsidian/_forge/$(basename $PWD)"
echo "🔍 Health Check — $(basename $PWD)"
echo "════════════════════════════════"

# Fraîcheur de memory.md
LAST_MOD=$(stat -c %Y memory.md 2>/dev/null || echo "0")
DAYS_SINCE=$(( ($(date +%s) - LAST_MOD) / 86400 ))
[ $DAYS_SINCE -gt 7 ] && echo "⚠️  memory.md vieux de $DAYS_SINCE jours → Cold Start recommandé" || echo "✅ memory.md frais ($DAYS_SINCE jours)"

# Taille sessions.md
SESSION_LINES=$(wc -l < "$FORGE_DIR/sessions.md" 2>/dev/null || echo "0")
[ $SESSION_LINES -gt 500 ] && echo "⚠️  sessions.md > 500 lignes → lancer /compress" || echo "✅ sessions.md OK ($SESSION_LINES lignes)"

# Momentum non nettoyé
if grep -q "Pensée en cours.*\[" memory.md 2>/dev/null; then
  echo "⚠️  Section Momentum non vide → reprise en cours ou oubli de cleanup"
else
  echo "✅ Momentum propre"
fi

# Commands installées
CMD_COUNT=$(ls .claude/commands/*.md 2>/dev/null | wc -l)
[ $CMD_COUNT -lt 4 ] && echo "⚠️  Seulement $CMD_COUNT commands — installe le pack complet" || echo "✅ $CMD_COUNT commands installées"

echo "════════════════════════════════"
echo "💡 Si > 2 warnings → relancer install-all.sh ou contacter le tuto"
HEALTHEOF
chmod +x /c/IA/_setup/health-check.sh
echo "✅ health-check.sh créé"
```

---

## Checklist finale — Vérification globale

```bash
# 📍 Depuis Git Bash — n'importe où

echo "=== Phase 1 : Règles unifiées ==="
cat ~/.gemini/settings.json | grep contextFileName
grep "@AGENTS.md" /c/IA/_setup/claude-setup/CLAUDE.md
grep "Vault Obsidian" /c/IA/_setup/opencode-setup/AGENTS.md

echo "=== Phase 2 : memory.md enrichi ==="
grep "Fichiers clés" /c/IA/_setup/opencode-setup/memory.md

echo "=== Phase 3 : Templates vault ==="
ls /c/IA/_setup/obsidian-templates/
grep "DECISION\|INSIGHT\|REGRET" /c/IA/_setup/obsidian-templates/sessions.md

echo "=== Phase 4 : Vault Obsidian ==="
ls "${USERPROFILE}/iCloudDrive/iCloud~md~obsidian/_forge/" && echo "✅ Vault accessible"

echo "=== Phase 5 : Custom commands ==="
ls /c/IA/_setup/claude-setup/.claude/commands/

echo "=== Phase 6 : Global lessons ==="
ls "${USERPROFILE}/iCloudDrive/iCloud~md~obsidian/_forge/_global/"

echo "=== Phase 7 : Momentum Transfer ==="
grep "Momentum" /c/IA/_setup/opencode-setup/memory.md
grep "Règle de reprise" /c/IA/_setup/opencode-setup/AGENTS.md
ls /c/IA/_setup/claude-setup/.claude/commands/switch.md

echo "=== Modes de session ==="
grep "Mode complet" /c/IA/_setup/opencode-setup/AGENTS.md

echo "=== Archivage sessions ==="
grep "SESSION_COUNT" /c/IA/_setup/gemini-setup/obsidian-sync.sh

echo "=== Scripts de déploiement ==="
ls /c/IA/_setup/install-all.sh
ls /c/IA/_setup/install-commands.sh
```

Chaque ligne doit retourner un résultat sans erreur.

```bash
# Audit santé complet sur un projet existant :
cd /c/IA/Projects/<ton-projet>
bash /c/IA/_setup/health-check.sh
# ✅ Doit afficher 4 lignes vertes sans warning
```

---

*Ce tuto remplace et complète `tutorial-setup.md`. À stocker dans `/c/IA/_setup/tutorial-optimisation-v2.6.md`.*
