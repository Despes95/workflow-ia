#!/usr/bin/env bash
# obsidian-sync.sh — v2.6 (pure bash, sans dépendance IA)
# Synchronise memory.md vers le vault Obsidian
# Usage : bash scripts/obsidian-sync.sh (depuis workflow-ia/)

set -euo pipefail

# ── CONFIG ────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.env
source "${SCRIPT_DIR}/config.env"
PROJECT_NAME="$(basename "$PWD")"
MEMORY_FILE="memory.md"
PROJECT_DIR="${FORGE_DIR}/${PROJECT_NAME}"
DATE="$(date '+%Y-%m-%d')"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M')"
SESSION_ID="$(date '+%Y%m%d-%H%M%S')"

# ── VÉRIFICATIONS ─────────────────────────────────────────────────────────────
if [[ ! -f "$MEMORY_FILE" ]]; then
  echo "❌ Erreur : $MEMORY_FILE introuvable. Lancer depuis workflow-ia/"
  exit 1
fi

# ── DOSSIER FORGE ─────────────────────────────────────────────────────────────
mkdir -p "$PROJECT_DIR"
echo "📂 Forge : $PROJECT_DIR"

# ── HELPER : extract_section ──────────────────────────────────────────────────
# Retourne le contenu d'une section ## <emoji> jusqu'à la prochaine ##
# Usage : extract_section "🐛"
extract_section() {
  local pattern="$1"
  local section=""
  local in_section=0
  while IFS= read -r line; do
    if [[ "$line" =~ ^##[[:space:]]*${pattern} ]]; then
      in_section=1
    elif [[ "$in_section" -eq 1 && "$line" =~ ^## ]]; then
      in_section=0
    elif [[ "$in_section" -eq 1 ]]; then
      section+="${line}"$'\n'
    fi
  done < "$MEMORY_FILE"
  echo "$section"
}

# ── HELPER : rotate_sessions ──────────────────────────────────────────────────
# Garde les MAX dernières sessions dans sessions.md
rotate_sessions() {
  local file="$1"
  local max="${2:-10}"
  local count
  count=$(grep -c "^## Session" "$file" 2>/dev/null || echo 0)
  [[ "$count" -le "$max" ]] && return 0

  local to_skip=$(( count - max ))
  local first_session_line
  first_session_line=$(grep -n "^## Session" "$file" | head -1 | cut -d: -f1)
  local header_end=$(( first_session_line - 4 ))
  [[ "$header_end" -lt 1 ]] && header_end=1

  local start_line
  start_line=$(grep -n "^## Session" "$file" | awk -F: -v n="$(( to_skip + 1 ))" 'NR==n{print $1}')
  [[ -z "$start_line" ]] && return 0

  local print_from=$(( start_line - 2 ))
  [[ "$print_from" -le "$header_end" ]] && print_from=$(( header_end + 1 ))

  {
    head -n "$header_end" "$file"
    tail -n +"$print_from" "$file"
  } > "${file}.tmp" && mv "${file}.tmp" "$file"
  echo "  🔄 Rotation sessions.md (${count} → ${max})"
}

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
init_file "${PROJECT_DIR}/index.md" "# ${PROJECT_NAME} — Index

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

init_file "${PROJECT_DIR}/sessions.md" "# ${PROJECT_NAME} — Sessions

> Snapshots automatiques de memory.md
"

init_file "${PROJECT_DIR}/decisions.md" "# ${PROJECT_NAME} — Décisions

> Décisions d'architecture et de conception importantes

## Template

### [DATE] — Titre décision

**Contexte :** …
**Décision :** …
**Conséquences :** …
"

init_file "${PROJECT_DIR}/bugs.md" "# ${PROJECT_NAME} — Bugs

> Bugs connus, en cours et résolus

## En cours

_Aucun_

## Résolus

_Aucun_
"

init_file "${PROJECT_DIR}/features.md" "# ${PROJECT_NAME} — Features

> Fonctionnalités en cours et planifiées

## En cours

_Aucune_

## Backlog

_Vide_
"

init_file "${PROJECT_DIR}/lessons.md" "# ${PROJECT_NAME} — Leçons apprises

> Extraites automatiquement depuis memory.md
"

init_file "${PROJECT_DIR}/architecture.md" "# ${PROJECT_NAME} — Architecture

> Vue d'ensemble technique du projet

## Stack

_À compléter_

## Composants clés

_À compléter_
"

init_file "${PROJECT_DIR}/ideas.md" "# ${PROJECT_NAME} — Idées

> Pistes et idées à explorer
"

# ── ÉTAPES 4-6 : extraction sections memory.md ────────────────────────────────
BUGS_CLEANED=$(extract_section "🐛" | grep -v '^[[:space:]]*$' | grep -v -i 'aucun connu' | grep -v '^---' || true)
LESSONS_CLEANED=$(extract_section "📝" | grep -v '^[[:space:]]*$' | grep -v '^---' || true)
DECISIONS_CLEANED=$(extract_section "📚" | grep -v '^[[:space:]]*$' | grep -v -i 'aucune décision' | grep -v '^---' || true)

# ── ÉTAPE 7 : snapshot PARTIEL dans sessions.md (Focus + Momentum + Architecture) ──
FOCUS_SNAP=$(extract_section "🎯")
MOMENTUM_SNAP=$(extract_section "🧠")
ARCH_SNAP=$(extract_section "🏗️")

{
  echo ""
  echo "---"
  echo ""
  echo "## Session ${SESSION_ID}"
  echo ""
  echo "> Sync automatique — ${TIMESTAMP}"
  echo ""
  [[ -n "$FOCUS_SNAP" ]]    && { echo "### 🎯 Focus Actuel"; echo "$FOCUS_SNAP"; echo ""; }
  [[ -n "$MOMENTUM_SNAP" ]] && { echo "### 🧠 Momentum";     echo "$MOMENTUM_SNAP"; echo ""; }
  [[ -n "$ARCH_SNAP" ]]     && { echo "### 🏗️ Architecture"; echo "$ARCH_SNAP"; echo ""; }
  if [[ -n "$LESSONS_CLEANED" ]]; then
    echo "> [!insight]"
    echo "$LESSONS_CLEANED" | while IFS= read -r l; do echo "> $l"; done
    echo ""
  fi
  if [[ -n "$BUGS_CLEANED" ]]; then
    echo "> [!warning]"
    echo "$BUGS_CLEANED" | while IFS= read -r l; do echo "> $l"; done
    echo ""
  fi
  if [[ -n "$DECISIONS_CLEANED" ]]; then
    echo "> [!decision]"
    echo "$DECISIONS_CLEANED" | while IFS= read -r l; do echo "> $l"; done
    echo ""
  fi
  [[ -n "$LESSONS_CLEANED" ]] && echo "→ [[lessons]]"
  [[ -n "$BUGS_CLEANED" ]] && echo "→ [[bugs]]"
  [[ -n "$DECISIONS_CLEANED" ]] && echo "→ [[decisions]]"
  echo ""
} >> "${PROJECT_DIR}/sessions.md"
echo "  📸 Snapshot ajouté : sessions.md"

# ── ÉTAPE 8 : append bugs.md ──────────────────────────────────────────────────
if [[ -n "$BUGS_CLEANED" ]]; then
  {
    echo ""
    echo "---"
    echo ""
    echo "### Extrait du ${DATE}"
    echo ""
    echo "$BUGS_CLEANED"
  } >> "${PROJECT_DIR}/bugs.md"
  echo "  🐛 Bugs extraits → bugs.md"
  # F1 — Dédup bugs.md
  awk 'NF && !seen[$0]++' "${PROJECT_DIR}/bugs.md" > "${PROJECT_DIR}/bugs.md.tmp" \
    && mv "${PROJECT_DIR}/bugs.md.tmp" "${PROJECT_DIR}/bugs.md"
fi

# ── ÉTAPE 9 : append lessons.md ───────────────────────────────────────────────
if [[ -n "$LESSONS_CLEANED" ]]; then
  {
    echo ""
    echo "---"
    echo ""
    echo "### Leçons du ${DATE}"
    echo ""
    echo "$LESSONS_CLEANED"
  } >> "${PROJECT_DIR}/lessons.md"
  echo "  📝 Leçons extraites → lessons.md"
  # F1 — Dédup lessons.md
  awk 'NF && !seen[$0]++' "${PROJECT_DIR}/lessons.md" > "${PROJECT_DIR}/lessons.md.tmp" \
    && mv "${PROJECT_DIR}/lessons.md.tmp" "${PROJECT_DIR}/lessons.md"
fi

# ── ÉTAPE 10 : append decisions.md ────────────────────────────────────────────
if [[ -n "$DECISIONS_CLEANED" ]]; then
  {
    echo ""
    echo "---"
    echo ""
    echo "### Décisions du ${DATE}"
    echo ""
    echo "$DECISIONS_CLEANED"
  } >> "${PROJECT_DIR}/decisions.md"
  echo "  📚 Décisions extraites → decisions.md"
  # F1 — Dédup decisions.md
  awk 'NF && !seen[$0]++' "${PROJECT_DIR}/decisions.md" > "${PROJECT_DIR}/decisions.md.tmp" \
    && mv "${PROJECT_DIR}/decisions.md.tmp" "${PROJECT_DIR}/decisions.md"
fi

# ── ÉTAPE 11 : mise à jour "Dernière sync" dans index.md ──────────────────────
if [[ -f "${PROJECT_DIR}/index.md" ]]; then
  sed -i "s/^> Dernière sync :.*$/> Dernière sync : ${TIMESTAMP}/" "${PROJECT_DIR}/index.md"
  echo "  🔄 Index mis à jour : ${TIMESTAMP}"
fi

# ── ÉTAPE 12 : rotation sessions.md (max 10) ──────────────────────────────────
rotate_sessions "${PROJECT_DIR}/sessions.md" 10

# ── ÉTAPE 13 : _global/lessons.md — leçons transversales (🌐) ─────────────────
if [[ -d "$GLOBAL_DIR" && -n "$LESSONS_CLEANED" ]]; then
  # B-reste — grep "🌐" échoue en pipe Windows Git Bash (encodage UTF-8)
  # Remplacement par bash native (même pattern que extract_section)
  GLOBAL_LESSONS=""
  while IFS= read -r line; do
    [[ "$line" == *"🌐"* ]] && GLOBAL_LESSONS+="${line}"$'\n'
  done <<< "$LESSONS_CLEANED"
  if [[ -n "$GLOBAL_LESSONS" ]]; then
    {
      echo ""
      echo "---"
      echo ""
      echo "### Leçons globales du ${DATE} (${PROJECT_NAME})"
      echo ""
      echo "$GLOBAL_LESSONS"
    } >> "${GLOBAL_DIR}/lessons.md"
    echo "  🌐 Leçons globales → _global/lessons.md"
  fi
fi

# ── ÉTAPE 14 : _global/index.md — date de sync + projet actif ─────────────────
if [[ -f "${GLOBAL_DIR}/index.md" ]]; then
  sed -i "s/\*\*Dernière mise à jour :\*\*.*/\*\*Dernière mise à jour :\*\* ${DATE}/" "${GLOBAL_DIR}/index.md"
  sed -i "s/- Dernier projet actif :.*/- Dernier projet actif : ${PROJECT_NAME} (${DATE})/" "${GLOBAL_DIR}/index.md"
  echo "  🌐 _global/index.md mis à jour"
fi

# ── RÉSULTAT ──────────────────────────────────────────────────────────────────
echo ""
echo "✅ Sync terminée — ${TIMESTAMP}"
echo "   Vault : ${PROJECT_DIR}"
echo "   Fichiers : $(ls "$PROJECT_DIR" | wc -l) présents"
