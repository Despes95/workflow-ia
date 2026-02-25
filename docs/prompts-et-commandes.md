# Prompts & Commandes — Référence opérationnelle

> Tous les prompts et commandes du workflow IA v2.6 en un seul endroit.

---

## Prompts manuels

### Démarrage de session

#### Claude Code (ou tape /context)

```
Lis CLAUDE.md puis AGENTS.md. Lis memory.md.
Lis $USERPROFILE/iCloudDrive/iCloud~md~obsidian/_forge/<nom-projet>/index.md
et $USERPROFILE/iCloudDrive/iCloud~md~obsidian/_forge/<nom-projet>/architecture.md
Fais git status + git log --oneline -10.
Résume l'état du projet en 5 points : état, blocages, prochaine étape, zone sensible, dette technique.
Ne touche à aucun fichier tant que je n'ai pas confirmé.
```

#### Gemini CLI / OpenCode

```
Lis AGENTS.md puis memory.md.
Lis $USERPROFILE/iCloudDrive/iCloud~md~obsidian/_forge/<nom-projet>/index.md
Fais git status + git log --oneline -10.
Résume l'état du projet en 5 points. Ne touche à rien.
```

#### Cold Start (+7 jours)

```
Lis uniquement index.md + architecture.md du projet.
Ne lis pas tout l'historique sessions.md.
Demande-moi : "Qu'est-ce qui a changé depuis ta dernière session ?"
Met à jour la section Focus Actuel de memory.md après ma réponse.
Ne touche à rien d'autre avant confirmation.
```

### Fin de session

#### Claude Code (ou tape /close)

```
Fin de session. Demande-moi ce qui s'est passé.
Attends ma réponse puis :
1. Extrais les action items
2. Identifie décisions (→ decisions.md), bugs (→ bugs.md), leçons (→ lessons.md, 🌐 si transversal)
3. Remplis les callouts `> [!decision]` / `> [!insight]` / `> [!warning]` dans sessions.md
4. Montre le diff complet de memory.md que tu proposes
5. Attends ma validation explicite avant d'écrire quoi que ce soit
```

#### Gemini CLI / OpenCode

```
Fin de session. Demande-moi ce qui s'est passé.
Attends ma réponse puis :
1. Extrais les action items
2. Identifie décisions (→ decisions.md), bugs (→ bugs.md), leçons (→ lessons.md, 🌐 si transversal)
3. Montre le diff complet de memory.md que tu proposes
4. Attends ma validation explicite avant d'écrire quoi que ce soit
5. Après validation :
   a. Lance `bash scripts/obsidian-sync.sh`
   b. Dans l'entrée sessions.md créée, ajoute les wikilinks :
      - Si décisions → `→ [[decisions]]`
      - Si bugs → `→ [[bugs]]`
      - Si leçons → `→ [[lessons]]`
   c. `git add memory.md && git commit -m "chore: fin de session" && git push`
```

> Note Gemini CLI : les commandes bash s'exécutent avec `!bash ...` ou via le shell natif.
> Note OpenCode : les commandes bash s'exécutent normalement.

---

## Les 12 commandes slash

### Tableau récap

| Commande | Usage | Lecture seule |
|---|---|---|
| /my-world | Début de journée | ✅ |
| /today | Matin — plan du jour | ✅ |
| /context | Début de session | ✅ |
| /close | Fin de session (écrit memory.md) | ⚠️ |
| /backup | Sauvegarde complète | ⚠️ |
| /switch | Handoff vers autre IA | ⚠️ |
| /emerge | Patterns implicites | ✅ |
| /challenge | Pression-test | ✅ |
| /connect | Ponts entre domaines | ✅ |
| /trace | Timeline d'une décision | ✅ |
| /ideas | Améliorations | ✅ |
| /global-connect | Cross-projets | ✅ |

### Contenu de chaque commande

#### /my-world

```markdown
# /my-world — Charge mon monde entier

Tu es mon partenaire de pensée. Charge tout ce contexte avant de répondre.

## 1. Vault global
- Lis `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/_global/lessons.md`
- Lis `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/_global/index.md`

## 2. Projets actifs
Pour chaque projet listé dans `_global/index.md`, lis son `index.md` et son `architecture.md`.

## 3. Obsidian CLI (si disponible)
```
obsidian find-orphans
obsidian list-backlinks _forge/_global/lessons.md
```

## 4. Résumé
Réponds avec exactement 5 points :
1. Projet le plus actif en ce moment + son état
2. Ce qui bloque ou risque de bloquer
3. Pattern récurrent des dernières sessions
4. Une connexion entre deux projets/idées que tu vois dans le vault
5. La prochaine action logique

⚠️ Ne touche à aucun fichier. Tu lis, tu résumes, tu poses une question max.
```

#### /today

```markdown
# /today — Rituel du matin

Lis dans cet ordre :
1. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/_global/index.md`
2. Le `memory.md` du projet actif (demande-moi lequel si pas clair)
3. Les 3 dernières entrées de `sessions.md` du projet actif

Réponds avec :
- Ce sur quoi je travaille aujourd'hui (basé sur le Focus Actuel)
- Un risque à surveiller aujourd'hui
- Une connexion que je pourrais explorer
- Une seule question pour clarifier les priorités

⚠️ Ne touche à aucun fichier.
```

#### /context

```markdown
# /context — Charge le contexte du projet actif

Lis dans cet ordre :
1. `memory.md` (état court terme du projet)
2. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/index.md`
3. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/architecture.md`

Résume en 5 points :
1. État actuel du projet
2. Blocages ou risques identifiés
3. Prochaine étape logique
4. Zone sensible (fichiers à ne pas toucher sans précaution)
5. Dette technique visible

⚠️ Ne touche à aucun fichier.
```

#### /close

```markdown
# /close — Rituel de fin de journée

Demande-moi : "Qu'est-ce qui s'est passé aujourd'hui ?"
Attends ma réponse, puis :

1. Extrais les action items de ma réponse
2. Identifie les décisions prises (candidates pour `decisions.md`)
3. Identifie les bugs rencontrés (candidats pour `bugs.md`)
4. Identifie les leçons (candidates pour `lessons.md` — marque 🌐 si transversal)
5. Montre-moi le diff `memory.md` que tu proposes

⚠️ Tu proposes les mises à jour, je valide, PUIS tu écris.
Ne modifie aucun fichier sans confirmation explicite de ma part.

6. Après validation, lance `bash scripts/obsidian-sync.sh`
7. Dans l'entrée sessions.md qui vient d'être créée, ajoute les [[wikilinks]] :
   - Si des décisions ont été prises → `→ [[decisions]]`
   - Si des bugs ont été rencontrés → `→ [[bugs]]`
   - Si des leçons ont été identifiées → `→ [[lessons]]`
8. Commit et push :
   `git add memory.md && git commit -m "chore: fin de session" && git push`
```

#### /backup

```markdown
# /backup — Sauvegarde complète du système

Exécute dans l'ordre :

1. Lance la sync Obsidian :
   `bash scripts/obsidian-sync.sh`

2. Commit memory.md :
   `git add memory.md && git commit -m "chore: backup session"`

3. Push le repo :
   `git push`

4. Confirme : "✅ Sauvegarde terminée — vault + git à jour"

⚠️ Si git push échoue (pas de remote configuré), arrête et signale l'erreur.
```

#### /switch

```markdown
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
   (laisse le titre et les 5 lignes vides avec `—`).
   Cela évite toute confusion pour les sessions suivantes.
```

#### /emerge

```markdown
# /emerge — Surface les patterns implicites

Lis :
1. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/sessions.md` (les 10 dernières entrées)
2. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/lessons.md`
3. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/_global/lessons.md`

Cherche des idées que mes notes IMPLIQUENT mais que je n'ai jamais formulées explicitement.
Pas ce que j'ai écrit — ce que mes patterns suggèrent que je pense ou que je veux faire.

Format de réponse :
> "D'après tes notes, tu sembles croire que [X]. Tu n'as jamais écrit ça directement, mais [référence session/leçon] + [référence session/leçon] pointent vers ça."

3 insights max. Formule comme hypothèses, pas comme certitudes.

⚠️ Ne touche à aucun fichier. Règle d'or : tu ne crées AUCUNE note dans le vault.
```

#### /challenge

```markdown
# /challenge — Pression-test mes croyances

Lis :
1. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/_global/lessons.md`
2. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/lessons.md`
3. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/decisions.md`

Prends une croyance ou un pattern que je semble avoir
(ex : "je préfère toujours X", "je déteste Y", "je contourne toujours Z").
Challenge-la avec des contre-exemples tirés de mes propres notes.
Pose-moi 2-3 questions qui me forcent à clarifier ou à faire évoluer cette croyance.

Sois bienveillant mais direct.

⚠️ Ne touche à aucun fichier.
```

#### /connect

```markdown
# /connect — Ponts entre domaines

Lis :
1. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/bugs.md`
2. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/lessons.md`
3. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/decisions.md`
4. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/_global/lessons.md`

Trouve 3 connexions non-évidentes entre les patterns de ces fichiers.

Par exemple :
- Un type de bug qui se répète → une décision d'archi à revoir
- Une leçon non appliquée → un risque sur le Focus Actuel
- Un pattern du projet actuel → une leçon globale applicable ici

Format : "J'observe que [A] + [B] → ce qui suggère que [insight actionnable]"

⚠️ Ne touche à aucun fichier. Règle d'or : tu ne crées AUCUNE note dans le vault.
```

#### /trace

```markdown
# /trace — Évolution d'une décision dans le temps

Sujet à tracer : $ARGUMENTS

Lis dans l'ordre :
1. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/decisions.md`
2. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/sessions.md`
3. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/architecture.md`

Trace l'évolution de "$ARGUMENTS" dans le temps.

Format de réponse :
- Timeline chronologique (date → ce qui s'est passé)
- Alternatives rejetées et pourquoi
- Ce qui a changé entre le début et maintenant
- État actuel et direction probable

⚠️ Ne touche à aucun fichier.
```

#### /ideas

```markdown
# /ideas — Génère des améliorations depuis les patterns

Lis :
1. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/sessions.md` (les 30 dernières entrées si dispo)
2. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/lessons.md`
3. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/ideas.md`
4. `memory.md` (sections Todo et Bugs)

Analyse les patterns récurrents et les problèmes que j'ai contournés plutôt que résolus.

Propose 3 angles d'amélioration ou d'évolution, format :
> "D'après les sessions de [période], tu contournes [problème] via [méthode].
> Une solution structurelle serait [proposition concrète]."

⚠️ Ne touche à aucun fichier. Règle d'or : tu ne crées AUCUNE note dans le vault.
```

#### /global-connect

```markdown
# /global-connect — Patterns cross-projets

Lis :
1. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/_global/lessons.md`
2. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/lessons.md`
3. `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/bugs.md`

Compare les patterns du projet actuel avec les patterns globaux.

Identifie :
1. Les leçons du projet actuel qui méritent d'être promues en leçons globales (🌐)
2. Les patterns globaux qui s'appliquent à des risques visibles dans le projet actuel
3. Une suggestion d'amélioration du workflow basée sur l'historique cross-projets

⚠️ Ne touche à aucun fichier. Présente les suggestions, attends validation avant toute écriture.
```

---

## Sauvegarder le système

### Ce que /backup fait

1. `bash scripts/obsidian-sync.sh` → memory.md → vault
2. `git add memory.md && git commit`
3. `git push` → repo + commands sauvegardés

### Commande bash équivalente

```bash
bash scripts/obsidian-sync.sh && git add memory.md && git commit -m "chore: fin de session" && git push
```

### Ce qui est sauvegardé où

| Élément | Sauvegarde | Comment |
|---|---|---|
| memory.md | git | `git push` |
| .claude/commands/ | git | `git push` |
| AGENTS.md, CLAUDE.md | git | `git push` |
| Vault sessions.md, bugs.md... | iCloud | automatique |
| _global/lessons.md, index.md | iCloud | automatique |

---

## Rétroliens Obsidian — État et solution

### Ce qui est en place

- `_global/index.md` contient `[[workflow-ia/index]]` etc.
- `index.md` de chaque projet pointe vers les autres fichiers

### Ce qui manque (gap)

- obsidian-sync.sh crée des entrées dans sessions.md sans [[wikilinks]]
- Les sessions ne pointent pas automatiquement vers decisions.md, bugs.md etc.

### Solution mise en place

`/close` injecte maintenant les [[wikilinks]] dans la session après le sync :
- Décisions identifiées → `→ [[decisions]]`
- Bugs identifiés → `→ [[bugs]]`
- Leçons identifiées → `→ [[lessons]]`

### Ce que tu fais manuellement dans Obsidian

- Ajouter `[[decisions#titre]]` pour pointer vers une décision spécifique
- Les backlinks Obsidian se construisent automatiquement dès qu'un [[lien]] existe

### Piste Phase 8

Enrichir obsidian-sync.sh pour injecter des anchors datés automatiquement.
