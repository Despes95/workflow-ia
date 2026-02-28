# /review-improve — Consolide et traite les rapports /improve accumulés

Détermine le PROJECT_NAME depuis le dossier courant (basename du chemin).

Lis `improve-inbox.md` (racine du projet).

Si le fichier est vide ou ne contient aucun rapport : dis-le et arrête.

Sinon, procède en 4 phases :

## Phase 1 — Analyse et déduplication

- Identifie toutes les suggestions, tous rapports confondus
- Note combien d'outils ont signalé chaque point (Claude / Gemini / OpenCode)
- Suggestion présente dans 2+ rapports = **signal fort**, à prioriser

## Phase 2 — Classification ROI

Classe chaque suggestion :
- **HIGH** : impact fort + effort raisonnable → action directe
- **MEDIUM** : utile mais non urgent → décision requise
- **LOW** : marginal ou déjà traité → ignore

Vérifie aussi : déjà présent dans `backlog.md` du vault ? → ne pas dupliquer.

## Phase 3 — Rapport consolidé

Présente sous ce format :

> **[suggestion]** — signalé par [outils]
> → Impact : HIGH/MEDIUM/LOW | Effort : H/M/L
> → Déjà backlog : OUI/NON

## Phase 4 — Actions

- Items **HIGH** non déjà dans backlog → appende dans
  `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/{PROJECT_NAME}/backlog.md`
  Format : `### [Titre court]\n[description + rationale ROI]`
- Items **MEDIUM** → liste-les, demande confirmation avant d'agir
- Items **LOW** → mentionne en une ligne, ignore

## Phase 5 — Nettoyage

Vide `improve-inbox.md` : remplace son contenu par :

```
# improve-inbox — Rapports /improve accumulés

> Fichier local, gitignored. Traité via `/review-improve` dans Claude.
> Format : un bloc par rapport, séparé par `---`.

```

⚠️ Seules modifications autorisées : `backlog.md` du vault (append) + `improve-inbox.md` (vidé).
