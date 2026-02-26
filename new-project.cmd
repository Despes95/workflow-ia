@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo.
echo =============================================
echo   workflow-ia -- Bootstrap nouveau projet
echo =============================================
echo.

:: Demande le nom du projet
set /p PROJECT_NAME=Nom du projet :
if "!PROJECT_NAME!"=="" (
    echo Erreur : le nom du projet est requis.
    pause
    exit /b 1
)

:: Chemin cible (defaut = C:\IA\projects\<nom>)
set "DEFAULT_TARGET=C:\IA\projects\!PROJECT_NAME!"
echo.
set /p TARGET_INPUT=Chemin cible [!DEFAULT_TARGET!] (Entree = defaut) :
if "!TARGET_INPUT!"=="" set "TARGET_INPUT=!DEFAULT_TARGET!"

echo.
echo Projet  : !PROJECT_NAME!
echo Cible   : !TARGET_INPUT!
echo.

:: Chemin du script bash relatif a ce .cmd
set "SCRIPT_DIR=%~dp0"

:: Appel bash — passe le chemin tel quel, le .sh normalize C:\ -> /c/
bash "!SCRIPT_DIR!scripts/new-project.sh" "!PROJECT_NAME!" "!TARGET_INPUT!"

echo.
pause
