# workflow-ia

> Système de workflow IA personnel — 31 commandes cross-outils

## Overview

workflow-ia est un projet template pour valider le workflow IA du tuto v2.6. Il fournit un système de commands unifié pour **Claude Code**, **Gemini CLI** et **OpenCode**.

## Daily Notes

Les commands Pensée lisent automatiquement tes daily notes Obsidian pour fournir un contexte plus riche. Le chemin est défini dans `scripts/config.env` via `DESPES_NOTES`.

## Commands (31)

### DEV (12)
| Command | Description |
|---------|-------------|
| `/start` | Démarre une session — contexte complet + git status |
| `/context` | Recharge le contexte du projet actif |
| `/today` | Rituel du matin — priorités du jour |
| `/close` | Rituel de fin de journée — vault sync + commit |
| `/close-day` | Revoit la journée, capture les apprentissages |
| `/backup` | Sauvegarde vault + git push |
| `/switch` | Passage de relais vers une autre IA |
| `/schedule` | Planifie la journée selon tes patterns d'énergie |
| `/7plan` | Reshapes les 7 prochains jours autour des sujets actifs |
| `/map` | Vue topologique du vault |
| `/improve` | Propose des améliorations techniques |
| `/audit` | Analyse bugs et refactorisation |

### PENSÉE (16)
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

# 2. Installer les commands globalement (optionnel)
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
├── .claude/commands/     # Commands Claude Code (.md)
├── .gemini/commands/     # Commands Gemini CLI (.toml)
├── .opencode/commands/  # Commands OpenCode (.md)
├── docs/
│   ├── commands-list.cmd # Liste des commands (Windows)
│   └── prompts-et-commandes.md
├── scripts/
│   ├── obsidian-sync.sh  # Sync memory.md → vault
│   ├── install-commands.sh
│   ├── config.env        # Configuration centralisee
│   └── check_memory.sh  # Garde-fou integrite
├── tests/                # Tests unitaires shell
├── memory.md             # Memory du projet
├── AGENTS.md            # Regles communes IA
├── CLAUDE.md            # Directives Claude
└── README.md
```
workflow-ia/
├── .claude/commands/     # Commands Claude Code (.md)
├── .gemini/commands/     # Commands Gemini CLI (.toml)
├── .opencode/commands/   # Commands OpenCode (.md)
├── docs/
│   ├── commands-list.cmd # Liste des commands (Windows)
│   └── prompts-et-commandes.md
├── scripts/
│   ├── obsidian-sync.sh  # Sync memory.md → vault
│   └── install-commands.sh
├── memory.md
├── AGENTS.md
└── CLAUDE.md
```

## Stack

- **OS** : Windows 11 + Git Bash
- **Tools IA** : Claude Code, Gemini CLI, OpenCode
- **Vault** : Obsidian (iCloud Drive)

## License

MIT
