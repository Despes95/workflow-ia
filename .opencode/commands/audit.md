---
description: Analyse les bugs potentiels et les opportunités de refactorisation
---

Analyse le projet actif pour identifier les bugs potentiels et les opportunités de refactorisation.

Lis dans cet ordre :
1. @memory.md (sections Bugs connus, Todo)
2. @C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/bugs.md
3. Liste les fichiers du projet

## Bugs potentiels à détecter
- Variables non définies ou mal typées
- Conditions toujours vraies/fausses
- Ressources non libérées (fichiers, connexions)
- Exceptions non catchées
- Race conditions potentielles

## Refactorisation à suggerer
- Fonctions avec trop de paramètres (>4)
- Classes/modules trop grands
- Duplication de code
- DRY violations
- God objects ou God functions
- Circular dependencies

## Métriques rapides
- Nombre de fichiers
- Lignes de code par langage
- Ratio commentaires/code

Présente les résultats par catégorie avec severity (critical/warning/info).

Après avoir présenté le rapport dans la session, **appende-le** dans `improve-inbox.md`
(racine du projet) avec ce format exact :

```
## Rapport /audit — OpenCode — 2026-03-01

[reproduis ici le rapport complet]

---
```

⚠️ Seule modification autorisée : appender dans `improve-inbox.md`. Ne touche à aucun autre fichier.