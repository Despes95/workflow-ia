@echo off
chcp 65001 >nul
cls

echo.
echo  ============================================================
echo   workflow-ia                         32 commandes
echo   Claude Code  -  Gemini CLI  -  OpenCode
echo  ============================================================
echo.
echo   Vault  : DespesNotes\_daily
echo   Forge  : _forge\workflow-ia
echo.

echo  -- SESSION (10) --------------------------------------------
echo    /start          Demarre avec contexte complet + git status
echo    /today          Priorites du matin
echo    /context        Recharge le contexte du projet actif
echo    /close          Fin de session -- vault sync + commit
echo    /close-day      Bilan de journee + apprentissages
echo    /backup         Sauvegarde vault + git push
echo    /switch         Passage de relais vers une autre IA
echo    /schedule       Planifie la journee selon ton energie
echo    /7plan          Reshape les 7 prochains jours
echo    /check-in  *    Etat du jour : energie + mode + intention
echo.

echo  -- PROJET (8) ----------------------------------------------
echo    /improve        Propose des ameliorations techniques
echo    /audit          Analyse bugs et refactorisation
echo    /my-world       Charge tous les projets actifs
echo    /global-connect Patterns cross-projets
echo    /ideas     *    Inbox QuestionsIA + patterns du projet courant
echo    /ideas-global * Inbox QuestionsIA route vers le bon projet ou futur
echo    /debug     *    Analyse un bug precis
echo    /wins      *    Victoires de la semaine
echo.

echo  -- VAULT (14) ----------------------------------------------
echo    /map             Vue topologique du vault
echo    /weekly-learnings Resume hebdo des insights
echo    /learned         Lecons  ^>  post "What I Learned"
echo    /graduate        Daily notes  ^>  notes permanentes
echo    /backlinks       Notes qui devraient se lier
echo    /compound        Meme question a differents moments du vault
echo    /stranger        Portrait de toi vu de l'exterieur
echo    /drift           Sujets que tu evites silencieusement
echo    /contradict      Deux croyances incompatibles
echo    /ghost           Repond a une question en ton nom
echo    /trace           Evolution d'une decision dans le temps
echo    /emerge          Patterns implicites jamais formules
echo    /connect         Ponts inattendus entre domaines
echo    /challenge       Contre-teste une croyance avec tes notes
echo.

echo  ------------------------------------------------------------
echo    32 commandes  -  Claude Code / Gemini CLI / OpenCode
echo    * nouvelles : /check-in  /debug  /wins  /ideas  /ideas-global
echo  ------------------------------------------------------------
echo.
pause
