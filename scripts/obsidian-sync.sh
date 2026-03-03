#!/usr/bin/env bash
# obsidian-sync.sh — v2.6.1 (pure bash, sans dépendance IA)
# Synchronise memory.md vers le vault Obsidian
# Usage : bash scripts/obsidian-sync.sh (depuis workflow-ia/)

set -euo pipefail

# ── CONFIG ────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.env
source "${SCRIPT_DIR}/config.env"
PROJECT_NAME="$(basename "$PWD")"
MEMORY_FILE="memory.md"
PROJECT_DIR="${PROJECTS_DIR}/${PROJECT_NAME}"
DATE="$(date '+%Y-%m-%d')"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M')"
SESSION_ID="$(date '+%Y%m%d-%H%M%S')"

# ── VÉRIFICATIONS ─────────────────────────────────────────────────────────────
if [[ ! -f "$MEMORY_FILE" ]]; then
  echo "❌ Erreur : $MEMORY_FILE introuvable. Lancer depuis workflow-ia/"
  exit 1
fi

# I2 — Validation pre-flight iCloud (config.env)
echo "🔍 Vérification iCloud..."
if ! timeout 3s ls "$FORGE_DIR" >/dev/null 2>&1; then
  echo "⚠️  Erreur : iCloud Drive semble hors ligne ou non synchronisé (timeout)."
  echo "    Vérifiez l'accès à $FORGE_DIR"
  exit 1
fi

# ── DOSSIER FORGE ─────────────────────────────────────────────────────────────
mkdir -p "$PROJECT_DIR"
echo "📂 Forge : $PROJECT_DIR"

# ── HELPER : extract_section ──────────────────────────────────────────────────
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

# ── HELPER : extract_diff_section (G5 — Incrémental) ──────────────────────────
extract_diff_section() {
  local pattern="$1"
  # echo "DEBUG: Looking for $pattern" >&2
  git --no-pager diff -U10000 HEAD "$MEMORY_FILE" 2>/dev/null | awk -v pat="$pattern" '
    BEGIN { in_sec=0 }
    # Détection du début de section (header peut être inchangé " " ou ajouté "+")
    $0 ~ "^[+ ]##" && $0 ~ pat { in_sec=1; next }
    # Détection de la fin de section (prochain header)
    in_sec && $0 ~ "^[+ ]##" { in_sec=0 }
    # Si on est dans la section, on ne garde que les lignes ajoutées (commençant par +)
    # On ignore le header du diff (+++)
    in_sec && $0 ~ "^\\+" && $0 !~ "^\\+\\+\\+" { 
      print substr($0, 2) 
    }
  '
}

# ── HELPER : append_section (I3) ──────────────────────────────────────────────
# Ajoute du contenu à un fichier, déduplique et maintient les lignes vides
append_section() {
  local file="$1"
  local title="$2"
  local content="$3"
  local label="$4"

  {
    echo ""
    echo "---"
    echo ""
    echo "### ${title} du ${DATE}"
    echo ""
    echo "$content"
  } >> "$file"
  
  # Déduplication (K3 — préserve lignes vides)
  awk '!seen[$0]++ || !NF' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
  echo "  ${label} extraits → $(basename "$file")"
}

# ── HELPER : rotate_sessions ──────────────────────────────────────────────────
rotate_sessions() {
  local file="$1"
  local max="${2:-10}"
  local count
  count=$(grep -c "^## Session" "$file" 2>/dev/null || true)
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

# ── HELPER : init_file (F5 — footer commun) ───────────────────────────────────
init_file() {
  local filepath="$1"
  local content="$2"
  if [[ ! -f "$filepath" ]]; then
    # F5 — Ajout footer de navigation
    {
      echo "$content"
      echo ""
      echo "---"
      echo "[[index|🏠 Index]] | [[sessions|🕒 Sessions]] | [[backlog|📋 Backlog]]"
    } > "$filepath"
    echo "  ✅ Créé : $(basename "$filepath")"
  fi
}

# ── INIT : templates des 8 fichiers ───────────────────────────────────────────
init_file "${PROJECT_DIR}/index.md" "# ${PROJECT_NAME} — Index

> Dernière sync : ${TIMESTAMP}

## 📊 Statistiques
- **Sessions** : 0
- **Leçons** : 0
- **Bugs résolus** : 0

## 📂 Fichiers du vault

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
"

init_file "${PROJECT_DIR}/bugs.md" "# ${PROJECT_NAME} — Bugs

> Bugs connus, en cours et résolus
"

init_file "${PROJECT_DIR}/features.md" "# ${PROJECT_NAME} — Features

> Fonctionnalités en cours et planifiées
"

init_file "${PROJECT_DIR}/lessons.md" "# ${PROJECT_NAME} — Leçons apprises

> Extraites automatiquement depuis memory.md
"

init_file "${PROJECT_DIR}/architecture.md" "# ${PROJECT_NAME} — Architecture

> Vue d'ensemble technique du projet
"

init_file "${PROJECT_DIR}/ideas.md" "# ${PROJECT_NAME} — Idées

> Pistes et idées à explorer
"

init_file "${PROJECT_DIR}/backlog.md" "# ${PROJECT_NAME} — Backlog actif

> Tâches détaillées avec rationale
"

# ── ÉTAPES 4-6 : extraction sections memory.md (Incrémental G5) ───────────────
BUGS_CLEANED=$(extract_diff_section "Bugs" | grep -v '^[[:space:]]*$' | grep -v -i 'aucun connu' | grep -v '^---' || true)
LESSONS_CLEANED=$(extract_diff_section "Le.ons" | grep -v '^[[:space:]]*$' | grep -v '^---' || true)
DECISIONS_CLEANED=$(extract_diff_section "D.cisions" | grep -v '^[[:space:]]*$' | grep -v -i 'aucune décision' | grep -v '^---' || true)

# ── ÉTAPE 7 : snapshot PARTIEL dans sessions.md ───────────────────────────────
FOCUS_SNAP=$(extract_section "Focus")
MOMENTUM_SNAP=$(extract_section "Momentum")
ARCH_SNAP=$(extract_section "Architecture")

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

# ── ÉTAPES 8-10 : refactor append_section (I3) ────────────────────────────────
[[ -n "$BUGS_CLEANED" ]]      && append_section "${PROJECT_DIR}/bugs.md" "Extrait" "$BUGS_CLEANED" "🐛 Bugs"
[[ -n "$LESSONS_CLEANED" ]]   && append_section "${PROJECT_DIR}/lessons.md" "Leçons" "$LESSONS_CLEANED" "📝 Leçons"
[[ -n "$DECISIONS_CLEANED" ]] && append_section "${PROJECT_DIR}/decisions.md" "Décisions" "$DECISIONS_CLEANED" "📚 Décisions"

# ── ÉTAPE 11 : mise à jour "Dernière sync" et Stats (F5) dans index.md ────────
if [[ -f "${PROJECT_DIR}/index.md" ]]; then
  # Stats dynamiques
  S_COUNT=$(grep -c "^## Session" "${PROJECT_DIR}/sessions.md" || true)
  L_COUNT=$(grep -c "^### Leçons du" "${PROJECT_DIR}/lessons.md" || true)
  B_COUNT=$(grep -c "^### Extrait du" "${PROJECT_DIR}/bugs.md" || true)

  sed -i "s/^> Dernière sync :.*$/> Dernière sync : ${TIMESTAMP}/" "${PROJECT_DIR}/index.md"
  sed -i "s/- \*\*Sessions\*\* :.*/- \*\*Sessions\*\* : ${S_COUNT}/" "${PROJECT_DIR}/index.md"
  sed -i "s/- \*\*Leçons\*\* :.*/- \*\*Leçons\*\* : ${L_COUNT}/" "${PROJECT_DIR}/index.md"
  sed -i "s/- \*\*Bugs résolus\*\* :.*/- \*\*Bugs résolus\*\* : ${B_COUNT}/" "${PROJECT_DIR}/index.md"
  echo "  📊 Stats index.md mises à jour"
fi

# ── ÉTAPE 12 : rotation sessions.md (max 10) ──────────────────────────────────
rotate_sessions "${PROJECT_DIR}/sessions.md" 10

# ── ÉTAPE 13 : _global/lessons.md ─────────────────────────────────────────────
if [[ -d "$GLOBAL_DIR" && -n "$LESSONS_CLEANED" ]]; then
  GLOBAL_LESSONS=""
  while IFS= read -r line; do
    [[ "$line" == *"🌐"* ]] && GLOBAL_LESSONS+="${line}"$'\n'
  done <<< "$LESSONS_CLEANED"
  if [[ -n "$GLOBAL_LESSONS" ]]; then
    append_section "${GLOBAL_DIR}/lessons.md" "Leçons globales (${PROJECT_NAME})" "$GLOBAL_LESSONS" "🌐 Leçons globales"
  fi
fi

# ── ÉTAPE 14 : _global/index.md ───────────────────────────────────────────────
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
