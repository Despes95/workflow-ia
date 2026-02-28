---
description: Propose des améliorations techniques sur le projet actif
---

Analyse le projet actif et propose des améliorations.

Détermine d'abord le PROJECT_NAME depuis le dossier de travail actuel (basename du chemin).
Ex : si tu es dans `/c/IA/Projects/workflow-ia`, PROJECT_NAME = `workflow-ia`.

Puis lis dans cet ordre :
1. @memory.md (sections Focus Actuel, Architecture, Fichiers clés, Bugs connus)
2. Lis `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/{PROJECT_NAME}/bugs.md` (bugs ouverts du vault)
3. Lis `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/{PROJECT_NAME}/backlog.md` (backlog actif du vault)
4. Lis `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/{PROJECT_NAME}/architecture.md`
5. Liste les fichiers du projet (cherche les fichiers source : .js, .ts, .py, .sh, etc.)

⚠️ Avant de proposer quoi que ce soit : croise avec les bugs connus de memory.md et bugs.md.
Ne propose pas comme amélioration ce qui est déjà un bug ouvert documenté.

Propose des améliorations structurées :

## 1. Code à simplifier
- Fonctions trop longues (>50 lignes)
- Code dupliqué
- Variables mal nommées

## 2. Architecture à améliorer
- Couplage fort entre fichiers
- Responsabilités multiples dans un même fichier

## 3. Performance
- Requêtes N+1, loops inutiles
- Assets non optimisés

## 4. Maintenabilité
- Tests manquants
- Documentation absente
- Complexité cyclomatique élevée

## 5. Bonnes pratiques
- Patterns de code cohérents
- Gestion d'erreurs
- Conventions de nommage

Trie les propositions par impact (high/medium/low).

Après avoir présenté le rapport dans la session, **appende-le** dans `improve-inbox.md`
(racine du projet) avec ce format exact :

```
## Rapport /improve — OpenCode — [DATE_AUJOURD'HUI]

[reproduis ici le rapport complet]

---
```

⚠️ Seule modification autorisée : appender dans `improve-inbox.md`. Ne touche à aucun autre fichier.
