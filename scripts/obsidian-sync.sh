#!/usr/bin/env bash
# obsidian-sync.sh — v2.6 (pure bash, sans dépendance IA)
# Synchronise memory.md vers le vault Obsidian
# Usage : bash scripts/obsidian-sync.sh (depuis workflow-ia/)

set -euo pipefail

# ── CONFIG ────────────────────────────────────────────────────────────────────
PROJECT_NAME="$(basename "$PWD")"
MEMORY_FILE="memory.md"
OBSIDIAN_BASE="/c/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge"
FORGE_DIR="${OBSIDIAN_BASE}/${PROJECT_NAME}"
DATE="$(date '+%Y-%m-%d')"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M')"
SESSION_ID="$(date '+%Y%m%d-%H%M%S')"

# ── VÉRIFICATIONS ─────────────────────────────────────────────────────────────
if [[ ! -f "$MEMORY_FILE" ]]; then
  echo "❌ Erreur : $MEMORY_FILE introuvable. Lancer depuis workflow-ia/"
  exit 1
fi

# ── DOSSIER FORGE ─────────────────────────────────────────────────────────────
mkdir -p "$FORGE_DIR"
echo "📂 Forge : $FORGE_DIR"

# ── HELPER : init_file ────────────────────────────────────────────────────────
# Crée un fichier avec template seulement s'il n'existe pas encore
init_file() {
  local filepath="$1"
  local content="$2"
  if [[ ! -f "$filepath" ]]; then
    echo "$content" > "$filepath"
    echo "  ✅ Créé : $(basename "$filepath")"
  fi
}

# ── INIT : templates des 8 fichiers ───────────────────────────────────────────
init_file "${FORGE_DIR}/index.md" "# ${PROJECT_NAME} — Index

> Dernière sync : ${TIMESTAMP}

## Fichiers du vault

| Fichier | Rôle |
|---|---|
| [[sessions]] | Snapshots de memory.md par session |
| [[decisions]] | Décisions d'architecture |
| [[bugs]] | Bugs connus et résolus |
| [[features]] | Fonctionnalités en cours et planifiées |
| [[lessons]] | Leçons apprises |
| [[architecture]] | Vue d'ensemble technique |
| [[ideas]] | Idées et pistes à explorer |
"

init_file "${FORGE_DIR}/sessions.md" "# ${PROJECT_NAME} — Sessions

> Snapshots automatiques de memory.md
"

init_file "${FORGE_DIR}/decisions.md" "# ${PROJECT_NAME} — Décisions

> Décisions d'architecture et de conception importantes

## Template

### [DATE] — Titre décision

**Contexte :** …
**Décision :** …
**Conséquences :** …
"

init_file "${FORGE_DIR}/bugs.md" "# ${PROJECT_NAME} — Bugs

> Bugs connus, en cours et résolus

## En cours

_Aucun_

## Résolus

_Aucun_
"

init_file "${FORGE_DIR}/features.md" "# ${PROJECT_NAME} — Features

> Fonctionnalités en cours et planifiées

## En cours

_Aucune_

## Backlog

_Vide_
"

init_file "${FORGE_DIR}/lessons.md" "# ${PROJECT_NAME} — Leçons apprises

> Extraites automatiquement depuis memory.md
"

init_file "${FORGE_DIR}/architecture.md" "# ${PROJECT_NAME} — Architecture

> Vue d'ensemble technique du projet

## Stack

_À compléter_

## Composants clés

_À compléter_
"

init_file "${FORGE_DIR}/ideas.md" "# ${PROJECT_NAME} — Idées

> Pistes et idées à explorer
"

# ── ÉTAPE 4 : snapshot dans sessions.md ───────────────────────────────────────
{
  echo ""
  echo "---"
  echo ""
  echo "## Session ${SESSION_ID}"
  echo ""
  echo "> Sync automatique — ${TIMESTAMP}"
  echo ""
  cat "$MEMORY_FILE"
  echo ""
} >> "${FORGE_DIR}/sessions.md"
echo "  📸 Snapshot ajouté : sessions.md"

# ── ÉTAPE 5 : extraction bugs ─────────────────────────────────────────────────
BUGS_SECTION=""
in_bugs=0
while IFS= read -r line; do
  if [[ "$line" =~ ^##[[:space:]]*🐛 ]]; then
    in_bugs=1
  elif [[ "$in_bugs" -eq 1 && "$line" =~ ^## ]]; then
    in_bugs=0
  elif [[ "$in_bugs" -eq 1 ]]; then
    BUGS_SECTION+="${line}"$'\n'
  fi
done < "$MEMORY_FILE"

# Filtrer les lignes vides et "Aucun connu"
BUGS_CLEANED=$(echo "$BUGS_SECTION" | grep -v '^[[:space:]]*$' | grep -v -i 'aucun connu' || true)
if [[ -n "$BUGS_CLEANED" ]]; then
  {
    echo ""
    echo "---"
    echo ""
    echo "### Extrait du ${DATE}"
    echo ""
    echo "$BUGS_CLEANED"
  } >> "${FORGE_DIR}/bugs.md"
  echo "  🐛 Bugs extraits → bugs.md"
fi

# ── ÉTAPE 6 : extraction leçons ───────────────────────────────────────────────
LESSONS_SECTION=""
in_lessons=0
while IFS= read -r line; do
  if [[ "$line" =~ ^##[[:space:]]*📝 ]]; then
    in_lessons=1
  elif [[ "$in_lessons" -eq 1 && "$line" =~ ^## ]]; then
    in_lessons=0
  elif [[ "$in_lessons" -eq 1 ]]; then
    LESSONS_SECTION+="${line}"$'\n'
  fi
done < "$MEMORY_FILE"

LESSONS_CLEANED=$(echo "$LESSONS_SECTION" | grep -v '^[[:space:]]*$' || true)
if [[ -n "$LESSONS_CLEANED" ]]; then
  {
    echo ""
    echo "---"
    echo ""
    echo "### Leçons du ${DATE}"
    echo ""
    echo "$LESSONS_CLEANED"
  } >> "${FORGE_DIR}/lessons.md"
  echo "  📝 Leçons extraites → lessons.md"
fi

# ── ÉTAPE 7 : mise à jour "Dernière sync" dans index.md ───────────────────────
# Remplace la ligne de sync existante
if [[ -f "${FORGE_DIR}/index.md" ]]; then
  sed -i "s/^> Dernière sync :.*$/> Dernière sync : ${TIMESTAMP}/" "${FORGE_DIR}/index.md"
  echo "  🔄 Index mis à jour : ${TIMESTAMP}"
fi

# ── RÉSULTAT ──────────────────────────────────────────────────────────────────
echo ""
echo "✅ Sync terminée — ${TIMESTAMP}"
echo "   Vault : ${FORGE_DIR}"
echo "   Fichiers : $(ls "$FORGE_DIR" | wc -l) présents"
