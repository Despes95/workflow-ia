# /wins — Victoires de la semaine

Détermine d'abord le PROJECT_NAME depuis le dossier de travail actuel (basename du chemin).
Ex : si tu es dans `/c/IA/Projects/workflow-ia`, PROJECT_NAME = `workflow-ia`.

Lis dans cet ordre :
1. `git log --oneline --since="7 days ago"` (historique des commits)
2. Les 5 dernières sessions de `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/_forge/$PROJECT_NAME/sessions.md`
3. Les 5 dernières daily notes de `C:/Users/Despes/iCloudDrive/iCloud~md~obsidian/DespesNotes/_daily/`

Liste uniquement les victoires :
- Features livrées ou bugs résolus (depuis les commits)
- Leçons apprises qui ont changé quelque chose
- Décisions prises (même les petites comptent)
- Moments où tu as avancé malgré un blocage

Format court, positif, 1 ligne par victoire.
Termine par une phrase : "Cette semaine tu as [résumé en une phrase]."

⚠️ Ne touche à aucun fichier.
