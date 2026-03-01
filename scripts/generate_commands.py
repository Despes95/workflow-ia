#!/usr/bin/env python3
"""
generate_commands.py — SSoT pour les commandes OpenCode
Génère les fichiers .opencode/commands/*.md depuis une spec centralisée.
"""

import json
import os
from pathlib import Path
from datetime import date

SPEC_FILE = Path(__file__).parent / "commands_spec.json"
OUTPUT_DIR = Path(__file__).parent.parent / ".opencode" / "commands"

COMMANDS = [
    {
        "name": "context",
        "description": "Charge le contexte du projet actif",
        "template": """---
description: {description}
---

Lis dans cet ordre :
1. @memory.md (état court terme du projet)
2. @C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/Projects/workflow-ia/index.md
3. @C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/Projects/workflow-ia/architecture.md

Résume en 5 points :
1. État actuel du projet
2. Blocages ou risques identifiés
3. Prochaine étape logique
4. Zone sensible (fichiers à ne pas toucher sans précaution)
5. Dette technique visible

⚠️ Ne touche à aucun fichier."""
    },
    {
        "name": "close",
        "description": "Rituel de fin de journée — analyse session + sync vault + commit",
        "template": """---
description: {description}
---

Analyse la session en cours.

Données git :
!git status && git log --oneline -10 && git diff HEAD~3..HEAD

Contenu memory.md actuel :
@memory.md

À partir de l'historique git, infère ce qui s'est passé durant cette session.

Puis :
1. Extrais les action items depuis les commits et diffs
2. Identifie décisions (→ decisions.md)
3. Identifie bugs (→ bugs.md)
4. Identifie leçons (→ lessons.md, 🌐 si transversal)
5. Montre le diff complet de memory.md que tu proposes
   - Si memory.md doit changer : écris les changements, puis enchaîne
   - Si memory.md est déjà à jour : enchaîne directement

6. Après analyse :
   a. Lance : !bash scripts/obsidian-sync.sh
   b. Dans l'entrée sessions.md créée, remplis les callouts :
      - `> [!decision]` ← décisions identifiées
      - `> [!insight]` ← leçons identifiées
      - `> [!warning]` ← bugs / anti-patterns
   c. Ajoute les wikilinks dans l'entrée sessions.md :
      - Si décisions → `→ [[decisions]]`
      - Si bugs → `→ [[bugs]]`
      - Si leçons → `→ [[lessons]]`
   d. !git add memory.md && git commit -m "chore: fin de session" && git push
   e. Revois ce qui a été accompli et identifie les changements à reporter dans docs/tutorial-valider.md"""
    },
    {
        "name": "audit",
        "description": "Analyse les bugs potentiels et les opportunités de refactorisation",
        "template": """---
description: {description}
---

Analyse le projet actif pour identifier les bugs potentiels et les opportunités de refactorisation.

Lis dans cet ordre :
1. @memory.md (sections Bugs connus, Todo)
2. @C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/Projects/$PROJECT_NAME/bugs.md
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
## Rapport /audit — OpenCode — {date}

[reproduis ici le rapport complet]

---
```

⚠️ Seule modification autorisée : appender dans `improve-inbox.md`. Ne touche à aucun autre fichier."""
    },
    {
        "name": "start",
        "description": "Rituel de début de session — charge contexte + status git",
        "template": """---
description: {description}
---

1. Lis @memory.md pour reprendre le contexte
2. Lance : !git status && git log --oneline -5
3. Identifie les tâches en cours depuis la section "Momentum (Handoff)"
4. Demande confirmation avant de commencer

⚠️ Ne touche à aucun fichier."""
    },
    {
        "name": "improve",
        "description": "Brainstorming améliorations futures (prospectif)",
        "template": """---
description: {description}
---

Propose des améliorations pour le projet actif.

Lis d'abord :
1. @memory.md (section Leçons, Décisions)
2. @C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/Projects/workflow-ia/backlog.md
3. Liste les fichiers du projet

Catégories suggérées :
- DX (Developer Experience)
- Performance
- Maintenabilité
- Sécurité
- Nouvelles fonctionnalités

Pour chaque idée propose :
- Titre court
- Rationale (pourquoi utile)
- Effort estimé (XS/S/M/L)

Après le brainstorm, appende les idées dans `improve-inbox.md` avec :
```
## Rapport /improve — OpenCode — {date}

[idées ici]

---
```"""
    },
    {
        "name": "backup",
        "description": "Backup complet du projet (zip + git push)",
        "template": """---
description: {description}
---

1. Crée un backup zip du projet (excluant .git, node_modules, __pycache__)
2. Sauvegarde dans un dossier backups/ avec date
3. Commit et push si nécessaire

⚠️ Utilise uniquement les fichiers existants, ne crée pas de nouveaux fichiers."""
    },
    {
        "name": "focus",
        "description": "Affiche le focus actuel du projet",
        "template": """---
description: {description}
---

Lis @memory.md et affiche uniquement :
- Section "Focus Actuel"
- Section "Momentum (Handoff)"

⚠️ Ne modifie rien."""
    },
    {
        "name": "debug",
        "description": "Aide au debugging (analyse erreur + propose solutions)",
        "template": """---
description: {description}
---

Analyse l'erreur/problème décrit et propose des solutions.

Format attendu :
1. Description de l'erreur
2. Contexte (commande, fichier, ligne)
3. Solutions potentielles avec优先级

Lis d'abord les fichiers pertinents pour comprendre le contexte."""
    },
    {
        "name": "trace",
        "description": "Trace l'exécution d'un script ou commande",
        "template": """---
description: {description}
---

Trace et explique pas à pas l'exécution d'un script ou commande.

Affiche :
1. Commandes exécutées
2. Variables d'environnement pertinentes
3. Points de décision
4. Sortie attendue vs réelle"""
    },
    {
        "name": "learned",
        "description": "Documente une leçon apprise pendant la session",
        "template": """---
description: {description}
---

Documente une leçon apprise.

Après documentation, propose une mise à jour de memory.md (section Leçons) si pertinent."""
    },
    {
        "name": "map",
        "description": "Affiche la carte des fichiers du projet",
        "template": """---
description: {description}
---

Liste les fichiers du projet par catégorie :
- Scripts
- Tests
- Config
- Docs

Affiche les dépendances si pertinent."""
    },
    {
        "name": "schedule",
        "description": "Affiche ou planifie des tâches",
        "template": """---
description: {description}
---

Lis @memory.md pour le contexte actuel.

Affiche le schedule/todo actuel ou propose d'en créer un."""
    },
    {
        "name": "wins",
        "description": "Célébre les victoires et progrès",
        "template": """---
description: {description}
---

Lis l'historique git récent et identifie les wins Accomplis cette session.

Celebre les succès et propose des mises à jour de memory.md si pertinent."""
    },
    {
        "name": "connect",
        "description": "Connecte des concepts ou fichiers liés",
        "template": """---
description: {description}
---

Identifie les connexions entre concepts/fichiers du projet.

Affiche un mini-graph des relations."""
    },
    {
        "name": "ghost",
        "description": "Mode fantôme — analyse sans modifier",
        "template": """---
description: {description}
---

Analyse le projet SANS aucune modification.

Lis les fichiers nécessaires et fournis ton analyse."""
    },
    {
        "name": "contradict",
        "description": "Trouve les contradictions dans le code ou la doc",
        "template": """---
description: {description}
---

Recherche les contradictions entre :
- Code et documentation
- Différentes sections de la doc
- Comportement attendu vs réel"""
    },
    {
        "name": "drift",
        "description": "Détecte le drift entre docs et implémentation",
        "template": """---
description: {description}
---

Compare la documentation avec l'implémentation actuelle.

Identifie les sections obsolètes ou，需更新."""
    },
    {
        "name": "compound",
        "description": "Combine plusieurs commandes en une",
        "template": """---
description: {description}
---

Propose une commande composée qui combine plusieurs actions."""
    },
    {
        "name": "backlinks",
        "description": "Trouve les backlinks vers un fichier",
        "template": """---
description: {description}
---

Recherche tous les fichiers qui référencent le fichier donné."""
    },
    {
        "name": "graduate",
        "description": "Promouvoir une feature du backlog vers prod",
        "template": """---
description: {description}
---

Aide à promouvoir une feature du backlog vers la production.

Étapes :
1. Lis le backlog
2. Identifie les critères de done
3. Propose les vérifications nécessaires"""
    },
    {
        "name": "weekly-learnings",
        "description": "Synthèse hebdomadaire des apprentissages",
        "template": """---
description: {description}
---

Génère une synthèse hebdomadaire depuis memory.md et sessions.md vault."""
    },
    {
        "name": "7plan",
        "description": "Planification sur 7 jours",
        "template": """---
description: {description}
---

Propose un plan sur 7 jours basé sur le backlog et les priorités."""
    },
    {
        "name": "close-day",
        "description": "Rituel de fin de journée",
        "template": """---
description: {description}
---

Rituel de fin de journée :
1. Résumé des accomplissements
2. Mise à jour memory.md
3. Sync vault
4. Commit et push"""
    },
    {
        "name": "today",
        "description": "Affiche le focus du jour",
        "template": """---
description: {description}
---

Affiche le focus du jour depuis memory.md."""
    },
    {
        "name": "switch",
        "description": "Switch de contexte/projet",
        "template": """---
description: {description}
---

Aide à switcher de contexte ou projet."""
    },
    {
        "name": "check-in",
        "description": "Check-in rapide (status, blockers)",
        "template": """---
description: {description}
---

Check-in rapide :
1. Status git
2. blockers identifiées
3. Prochaines actions"""
    },
    {
        "name": "challenge",
        "description": "Challenge une décision ou assumption",
        "template": """---
description: {description}
---

Challenge une décision ou assumption récente.

Questionne les présupposés et propose des alternatives."""
    },
    {
        "name": "emerge",
        "description": "Fait émerger des patterns ou thèmes",
        "template": """---
description: {description}
---

Analyse les fichiers et fait émerger des patterns ou thèmes récurrents."""
    },
    {
        "name": "stranger",
        "description": "Treat project as if you've never seen it",
        "template": """---
description: {description}
---

Analyse le projet comme si tu ne l'avais jamais vu.

Fournis une perspective fraîche et identifie ce qui manque en termes de docs."""
    },
    {
        "name": "global-connect",
        "description": "Connecte le projet au vault global",
        "template": """---
description: {description}
---

Crée des liens entre le projet actif et le vault global (Decisions, Bugs, Lessons)."""
    },
    {
        "name": "my-world",
        "description": "Mode développement intensif — contexte complet + dev",
        "template": """---
description: {description}
---

Mode développement intensif :
1. Lis @memory.md (Focus + Momentum)
2. Lis vault (index + architecture)
3. Git status + log
4. Prêt pour développement

⚠️ Ne modifie que les fichiers demandés par l'utilisateur."""
    },
    {
        "name": "ideas",
        "description": "Brainstorming libre (alias improve)",
        "template": """---
description: {description}
---

Version courte de /improve pour brainstorming rapide.

Lis @memory.md et propose des idées d'amélioration."""
    },
    {
        "name": "review-improve",
        "description": "Review et triage improve-inbox",
        "template": """---
description: {description}
---

Review le fichier improve-inbox.md et triage les entrées :
- Nx = Next (à faire)
- Sx = Someday (un jour)
- Bx = Backlog (reporté)
- Rx = Rejected (rejeté)

Propose des mises à jour de backlog.md vault."""
    },
    {
        "name": "vault-check",
        "description": "Vérifie les wikilinks dans le vault",
        "template": """---
description: {description}
---

Vérifie les wikilinks dans le vault Obsidian.

Lis scripts/vault-check.sh pour comprendre le format attendu et lance la vérification."""
    }
]


def generate_commands():
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    
    today = date.today().strftime("%Y-%m-%d")
    
    for cmd in COMMANDS:
        content = cmd["template"].format(
            description=cmd["description"],
            date=today
        )
        output_path = OUTPUT_DIR / f"{cmd['name']}.md"
        output_path.write_text(content, encoding="utf-8")
        print(f"Generated: {output_path.name}")
    
    print(f"\nOK: {len(COMMANDS)} commands generated in {OUTPUT_DIR}")


if __name__ == "__main__":
    generate_commands()
