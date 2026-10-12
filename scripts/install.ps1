# ==============================================================================
# Thunderbird Better Unread - One-Click Installer (Windows PowerShell)
# ==============================================================================

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "   Thunderbird Better Unread - One-Click Installer (PowerShell)        " -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceCss = Join-Path (Split-Path -Parent $ScriptDir) "chrome\userChrome.css"
$TbProfilesDir = Join-Path $env:APPDATA "Thunderbird\Profiles"

if (-not (Test-Path $SourceCss)) {
    Write-Host "[ERROR] userChrome.css not found at: $SourceCss" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $TbProfilesDir)) {
    Write-Host "[ERROR] Thunderbird profiles directory not found at: $TbProfilesDir" -ForegroundColor Red
    Write-Host "Please make sure Mozilla Thunderbird is installed and has been run at least once." -ForegroundColor Yellow
    exit 1
}

Write-Host "[1/3] Detecting Thunderbird profiles..." -ForegroundColor Yellow
$Profiles = Get-ChildItem -Path $TbProfilesDir -Directory

if ($Profiles.Count -eq 0) {
    Write-Host "[WARNING] No profile folders found under $TbProfilesDir" -ForegroundColor Red
    exit 1
}

$SuccessCount = 0

foreach ($Profile in $Profiles) {
    Write-Host "  - Found profile: $($Profile.Name)" -ForegroundColor White
    $ChromeDir = Join-Path $Profile.FullName "chrome"
    $DestCss = Join-Path $ChromeDir "userChrome.css"
    $UserJs = Join-Path $Profile.FullName "user.js"

    # 1. Create chrome directory
    if (-not (Test-Path $ChromeDir)) {
        New-Item -ItemType Directory -Path $ChromeDir -Force | Out-Null
    }

    # 2. Copy userChrome.css
    Copy-Item -Path $SourceCss -Destination $DestCss -Force
    if (Test-Path $DestCss) {
        Write-Host "    --> [SUCCESS] Copied userChrome.css" -ForegroundColor Green
    } else {
        Write-Host "    --> [FAILED] Failed to copy userChrome.css" -ForegroundColor Red
    }

    # 3. Ensure stylesheet preference in user.js
    $PrefLine = 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);'
    if (Test-Path $UserJs) {
        $Content = Get-Content -Path $UserJs -Raw
        if ($Content -notmatch "toolkit\.legacyUserProfileCustomizations\.stylesheets") {
            Add-Content -Path $UserJs -Value "`n$PrefLine" -Encoding UTF8
            Write-Host "    --> [CONFIG] Added stylesheet preference to user.js" -ForegroundColor Green
        } else {
            Write-Host "    --> [CONFIG] Stylesheet preference already present in user.js" -ForegroundColor Gray
        }
    } else {
        Set-Content -Path $UserJs -Value "$PrefLine`n" -Encoding UTF8
        Write-Host "    --> [CONFIG] Created user.js and enabled stylesheet preference" -ForegroundColor Green
    }

    $SuccessCount++
}

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "[DONE] Installation completed successfully for $SuccessCount profile(s)!" -ForegroundColor Green

$TbProcess = Get-Process -Name "thunderbird" -ErrorAction SilentlyContinue
if ($TbProcess) {
    Write-Host ""
    Write-Host "[!] Thunderbird is currently running!" -ForegroundColor Yellow
    Write-Host "    You MUST completely close and restart Thunderbird for changes to take effect." -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "Important Notice: Start Thunderbird to enjoy enhanced unread cards styling." -ForegroundColor White
}
Write-Host "======================================================================" -ForegroundColor Cyan
