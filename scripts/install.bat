@echo off
chcp 65001 >nul
title Thunderbird Better Unread - Installer

echo ======================================================================
echo    Thunderbird Better Unread - One-Click Installer (Windows)
echo ======================================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "SOURCE_CSS=%SCRIPT_DIR%..\chrome\userChrome.css"
set "TB_PROFILES_DIR=%APPDATA%\Thunderbird\Profiles"

if not exist "%SOURCE_CSS%" (
    echo [ERROR] userChrome.css not found at: "%SOURCE_CSS%"
    pause
    exit /b 1
)

if not exist "%TB_PROFILES_DIR%" (
    echo [ERROR] Thunderbird profiles directory not found!
    echo Looked in: "%TB_PROFILES_DIR%"
    echo Please make sure Mozilla Thunderbird is installed and has been run at least once.
    pause
    exit /b 1
)

echo [1/3] Detecting Thunderbird profiles...
set /a FOUND_PROFILES=0

for /d %%D in ("%TB_PROFILES_DIR%\*") do (
    set /a FOUND_PROFILES+=1
    echo   - Found profile: %%~nxD
    
    REM Create chrome directory if not exists
    if not exist "%%D\chrome" (
        mkdir "%%D\chrome" 2>nul
    )
    
    REM Copy userChrome.css
    copy /y "%SOURCE_CSS%" "%%D\chrome\userChrome.css" >nul
    if %errorlevel% equ 0 (
        echo     ^--^> [SUCCESS] Copied userChrome.css to %%~nxD\chrome\
    ) else (
        echo     ^--^> [FAILED] Could not copy userChrome.css to %%~nxD\chrome\
    )

    REM Automatically enable toolkit.legacyUserProfileCustomizations.stylesheets in user.js
    set "USER_JS=%%D\user.js"
    findstr /c:"toolkit.legacyUserProfileCustomizations.stylesheets" "%%D\user.js" >nul 2>&1
    if %errorlevel% neq 0 (
        echo user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true); >> "%%D\user.js"
        echo     ^--^> [CONFIG] Enabled stylesheets pref in user.js
    ) else (
        echo     ^--^> [CONFIG] Stylesheets pref already enabled in user.js
    )
)

if %FOUND_PROFILES% equ 0 (
    echo [WARNING] No profile folders found under "%TB_PROFILES_DIR%".
    pause
    exit /b 1
)

echo.
echo ======================================================================
echo  [DONE] Installation completed successfully!
echo.
echo  Important Notice:
echo  1. Restart Thunderbird if it is currently running.
echo  2. If the custom styles do not take effect, verify in Thunderbird:
echo     Settings -^> General -^> Config Editor (about:config)
echo     Search: "toolkit.legacyUserProfileCustomizations.stylesheets"
echo     Ensure it is set to "true".
echo ======================================================================
echo.
pause
