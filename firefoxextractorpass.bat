@echo off
setlocal

REM Définir le répertoire de travail pour Firefox Decrypt
set "decrypt_dir=%~dp0firefox_decrypt"
set "python_exe=python"

REM Vérifier si Python est installé
where %python_exe% >nul 2>&1
if errorlevel 1 (
    echo Python n'est pas installé. Veuillez installer Python depuis https://www.python.org/downloads/.
    pause
    exit /b 1
)

REM Créer le répertoire de travail pour Firefox Decrypt s'il n'existe pas
if not exist "%decrypt_dir%" (
    mkdir "%decrypt_dir%"
)

REM Naviguer vers le répertoire de travail
cd "%decrypt_dir%"

REM Télécharger Firefox Decrypt si nécessaire
if not exist "firefox_decrypt.py" (
    echo Téléchargement de Firefox Decrypt...
    %python_exe% -m pip install requests >nul 2>&1
    %python_exe% -c "import requests; r = requests.get('https://raw.githubusercontent.com/unode/firefox_decrypt/master/firefox_decrypt.py'); open('firefox_decrypt.py', 'wb').write(r.content)"
)

REM Vérifier si Firefox Decrypt a été téléchargé
if not exist "firefox_decrypt.py" (
    echo Échec du téléchargement de Firefox Decrypt.
    pause
    exit /b 1
)

REM Naviguer vers le dossier des profils Firefox
cd %APPDATA%\Mozilla\Firefox\Profiles

REM Lister tous les dossiers contenant ".default" dans leur nom
for /d %%d in (*.default*) do (
    echo.
    echo ===== Extraction des mots de passe pour le profil %%d =====
    cd %%d
    %python_exe% "%decrypt_dir%\firefox_decrypt.py" -d .
    cd ..
    echo ========================================
    echo.
)

pause
