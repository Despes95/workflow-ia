# vault-check — Vérifie l'intégrité des wikilinks dans le vault

Vérifie que tous les liens `[[wikilinks]]` dans le vault Obsidian pointent vers des fichiers existants.

## Usage

```
/vault-check [vault-path]
```

## Description

- Par défaut, vérifie `_forge/workflow-ia/`
- Accepte un chemin optionnel vers un autre vault
- Affiche le nombre de liens trouvés et d'orphelins
- Exit code 0 si OK, 1 si liens cassés

## Exemples

```
/vault-check
/vault-check C:\Users\Despes\iCloudDrive\iCloud~md~obsidian\DespesNotes
```

$ARGUMENTS
