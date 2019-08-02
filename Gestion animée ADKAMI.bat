@echo off
setlocal enableDelayedExpansion
title Gestionnaire de page (manga animer) du site web Adkami
color AC

rem cette ligne sauvegarde l url de base du site adkami concernant les mangas
set site_default=http://www.adkami.com/index.php?page=manga

rem etiquete utiliser avec le goto pour revenir au menu par exemple dans le cas d une mauvaise saisie
:revenir_menu
cls
echo                1 : Consulter la liste des animer sauvegarder.
echo.
echo                2 : Ajouter un animer dans le fichier texte.
echo.
set /p reponse_option=Saisissez le numero de l option que vous voulez appliquer : 
if %reponse_option%==1 (
    goto recommencer
)
if %reponse_option%==2 (
    goto ajout_animer
)
if %reponse_option% GTR 2 (
    goto revenir_menu
)

rem permet de revenir en arriere si on veut rajouter un animer ou si une mauvaise saisie est effectuer
:ajout_animer
cls
set /p id_animer=saisissez l id de l animer (l id se trouve generalement dans l url) :
echo.
set /p designation_animer=saisissez le nom de l animer :
rem cette ligne saute d une ligne dans le fichier pour pouvoir ajouter l animer a la ligne
echo.>> "Liste IDS des animees.txt"

echo %id_animer%:%designation_animer% >> "Liste IDS des animees.txt"
echo.
echo.
echo                                Votre animer a ete ajouter ! ! !
echo.
set /p reponse_essaie=Voulez-vous encore ajouter un animer [1 pour oui] [0 pour non] :
if %reponse_essaie% GTR 1 (
    goto revenir_menu
)
if %reponse_essaie%==1 (
    goto ajout_animer
)
if %reponse_essaie%==0 (
    goto revenir_menu
)

rem Cette etiquette  permet de revenir a la liste d animer 
:recommencer
cls
echo                Menu contenant les pages manga animer du site Adkami
echo.
echo -------------------------------------------------------------------------------------------------------
set nbligne=0
    rem Boucle la liste d animer incremente un numero de ligne est inscrie dans le fichier texte dico animer le numero de ligne et le nom de l animer
for /f "skip=2 tokens=1,2 delims=:" %%a in ('type "Liste IDS des animees.txt"') do (
    set /a nbligne+=1
    echo N!nbligne!:%%b >> "dico_animer temporaire.txt"
    echo                    N!nbligne! - %%b
)
echo.
echo -------------------------------------------------------------------------------------------------------
echo.
echo.
set /p numero_animer=Saisssez le numero relier a l animer :
if %numero_animer% LEQ %nbligne% (
    goto reussi
) else goto echec

rem cette etiquette est executer a condition que le numero entrer par l utilisateur soit compris dans la liste
:reussi
set nom_animer=
                rem Boucle sur le fichier lorsque on trouve la valeur avec findstr on recupere le nom de l animer
for /f "tokens=1,2 delims=:" %%a in ('type "dico_animer temporaire.txt" ^| findstr /c:N%numero_animer%') do (
    set nom_animer=%%b
)

set id_animer=default
set ligne=0
rem Boucle sur le fichier lorsque la ligne correspond au numero saisie par l utilisateur on recupere le id de l animer et on sors de la boucle par un goto
for /f "skip=2 tokens=1,2 delims=:" %%a in ('type "Liste IDS des animees.txt"') do (
    set /a ligne+=1
    if !ligne!==!numero_animer! (
        set id_animer=%%a
        goto lancement
    )
)

rem Etiquette est executer lorsque on a trouver le id de l animer
:lancement
"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" -new-window !site_default!"&id="!id_animer!"&episode=001&version=2&genre=1"
goto fini

rem Etiquette executer a condition que le numero saisie par l utilisateur ne soit pas compris dans la liste des animer
:echec
del "dico_animer temporaire.txt" 
echo.
echo                Veuillez saisir un numero compris dans la liste !!!
echo.
pause
goto recommencer

rem Etiquette executer lorsque le programme est fini
:fini
del "dico_animer temporaire.txt" 
exit

endlocal