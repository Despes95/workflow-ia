# workflow-ia

> Système de workflow IA personnel — 33 commandes cross-outils

## Overview

workflow-ia est un projet template pour valider le workflow IA du tuto v2.6. Il fournit un système de commandes unifié pour **Claude Code**, **Gemini CLI** et **OpenCode**.

## Daily Notes

Les commandes Pensée lisent automatiquement tes daily notes Obsidian pour fournir un contexte plus riche. Le chemin est défini dans `scripts/config.env` via `DESPES_NOTES`.

## Commands (33)

### DEV (14)
| Command | Description |
|---------|-------------|
| `/start` | Démarre une session — contexte complet + git status |
| `/context` | Recharge le contexte du projet actif |
| `/focus` | Recommande 1 action selon Polaris, l'énergie et le backlog |
| `/today` | Rituel du matin — priorités du jour |
| `/close` | Rituel de fin de session — vault sync + commit |
| `/close-day` | Revoit la journée, capture les apprentissages |
| `/backup` | Sauvegarde vault + git push |
| `/switch` | Passage de relais vers une autre IA |
| `/schedule` | Planifie la journée selon tes patterns d'énergie |
| `/7plan` | Reshapes les 7 prochains jours autour des sujets actifs |
| `/map` | Vue topologique du vault |
| `/improve` | Propose des améliorations techniques (multi-rapports) |
| `/audit` | Analyse bugs et refactorisation — vue macro, session dédiée |
| `/review-improve` | Analyse et route les rapports `/improve` vers le backlog |

> **Built-in Claude Code** : `/simplify` revoit le code récemment modifié (`git diff HEAD~1`).
> Cascade recommandée : `/simplify` (micro, post-edit) → `/audit` (macro, session) → `/improve` (prospectif).

### PENSÉE (19)
| Command | Description |
|---------|-------------|
| `/weekly-learnings` | Résumé hebdomadaire des insights |
| `/learned` | Transforme les leçons en post "What I Learned" |
| `/graduate` | Idées des daily notes → notes permanentes |
| `/backlinks` | Notes qui devraient se lier mais ne le font pas |
| `/compound` | Même question à différents moments du vault |
| `/stranger` | Portrait de toi vu de l'extérieur |
| `/drift` | Sujets que tu évites silencieusement |
| `/contradict` | Deux croyances incompatibles dans tes notes |
| `/ghost` | Répond à une question en ton nom |
| `/trace` | Évolution d'une décision dans le temps |
| `/emerge` | Patterns implicites jamais formulés |
| `/connect` | Ponts inattendus entre domaines |
| `/global-connect` | Patterns cross-projets |
| `/challenge` | Contre-teste une croyance avec tes propres notes |
| `/ideas` | Améliorations depuis les patterns récurrents |
| `/my-world` | Charge tous tes projets actifs |
| `/check-in` | Note rapide sur l'énergie, le mode et le moral |
| `/wins` | Capture les victoires de la journée |
| `/debug` | Aide au débogage avec focus sur le contexte vault |

## Installation

```bash
# Cloner le projet
git clone <repo-url>
cd workflow-ia

# 1. Adapter les chemins vault à ta machine (obligatoire)
# Édite scripts/config.env avant tout :
#   OBSIDIAN_BASE="${HOME}/iCloudDrive/iCloud~md~obsidian"
#   DESPES_NOTES="${OBSIDIAN_BASE}/DespesNotes"
nano scripts/config.env

# 2. Installer les commandes globalement (optionnel)
bash scripts/install-commands.sh --all
```

## Configuration

`scripts/config.env` est le **seul fichier à modifier** pour adapter le projet à ta machine.

```bash
OBSIDIAN_BASE="${HOME}/iCloudDrive/iCloud~md~obsidian"  # racine vault
FORGE_DIR="${OBSIDIAN_BASE}/_forge"                      # projets forge
GLOBAL_DIR="${FORGE_DIR}/_global"                        # vault global
DESPES_NOTES="${OBSIDIAN_BASE}/DespesNotes"              # daily notes
```

Ce fichier est sourcé par `obsidian-sync.sh` et toutes les commandes Gemini/bash. Si ton vault est ailleurs (autre drive, autre structure), c'est ici que tu l'adaptes — une fois, pour tout.

## Structure

```
workflow-ia/
├── .claude/commands/     # Commandes Claude Code (.md)
├── .gemini/commands/     # Commandes Gemini CLI (.toml)
├── .opencode/commands/   # Commandes OpenCode (.md)
├── docs/                 # Documentation et références
├── scripts/
│   ├── obsidian-sync.sh      # Sync memory.md → vault
│   ├── install-commands.sh   # Déploiement multi-outils
│   ├── check_memory.sh       # Garde-fou intégrité
│   ├── gemini-git-info.sh    # Helper Git anti-freeze
│   ├── gemini-*.sh           # Helpers d'accès au vault
│   └── config.env            # Configuration centralisée
├── tests/                # Tests unitaires shell (22/22)
├── memory.md             # Mémoire court terme du projet
├── AGENTS.md             # Source unique des règles (tous IA)
├── CLAUDE.md             # Directive spécifique Claude
└── README.md
```

## Stack

- **OS** : Windows 11 + Git Bash
- **Tools IA** : Claude Code, Gemini CLI, OpenCode
- **Vault** : Obsidian (iCloud Drive)

## Prérequis — Nouveau disque

### 1. Outils système (winget)
```bash
winget import scripts/setup-windows.json
# Installe : Git, Node.js, Python 3.11, GitHub CLI, Starship
```

### 2. CLI IA (npm)
```bash
npm install -g @google/gemini-cli
npm install -g opencode-ai
npm install -g @anthropic-ai/claude-code
```

### 3. Terminal (Git Bash UTF-8 + Starship)
Copier `~/.bashrc` et `~/.config/starship.toml` depuis l'ancien disque,
ou relancer T0 : ajouter `env LANG/LC_ALL` dans Windows Terminal settings.json.

## License

MIT
