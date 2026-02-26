@echo off
chcp 65001 >nul
echo.
echo ===========================================
echo   workflow-ia ^— Commandes disponibles
echo   Claude Code ^| Gemini CLI ^| OpenCode
echo ===========================================
echo.
echo [SESSION]
echo   /start           Demarre une session ^— contexte complet + git status
echo   /context         Recharge le contexte du projet actif
echo   /today           Rituel du matin ^— priorites du jour
echo   /close           Rituel de fin de journee ^— vault sync + commit
echo   /close-day       Revoit la journee, capture les apprentissages
echo   /backup          Sauvegarde vault + git push
echo.
echo [PLANIFICATION]
echo   /schedule        Planifie la journee selon tes patterns d'energie
echo   /7plan           Reshapes les 7 prochains jours autour des sujets actifs
echo   /weekly-learnings Resume hebdomadaire des insights
echo.
echo [ANALYSE DU VAULT]
echo   /map             Vue topologique du vault
echo   /emerge          Patterns implicites jamais formules
echo   /connect         Ponts inattendus entre domaines
echo   /global-connect  Patterns cross-projets
echo   /trace           Evolution d'une decision dans le temps
echo   /compound        Meme question a differents moments du vault
echo   /backlinks       Notes qui devraient se lier mais ne le font pas
echo   /graduate        Idees des daily notes ^-^> notes permanentes
echo.
echo [REFLEXION]
echo   /challenge       Contre-teste une croyance avec tes propres notes
echo   /contradict      Deux croyances incompatibles dans tes notes
echo   /drift           Sujets que tu evites silencieusement
echo   /ideas           Ameliorations depuis les patterns recurrents
echo.
echo [IDENTITE]
echo   /ghost           Repond a une question en ton nom
echo   /stranger        Portrait de toi vu de l'exterieur
echo   /my-world        Charge tous tes projets actifs
echo.
echo [EXPORT]
echo   /learned         Transforme les lecons en post "What I Learned"
echo   /switch          Passage de relais vers une autre IA
echo.
echo -------------------------------------------
echo   Total : 26 commandes
echo   Compatibles : Claude Code, Gemini CLI, OpenCode
echo -------------------------------------------
echo.
pause
