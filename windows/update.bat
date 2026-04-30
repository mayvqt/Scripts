@echo off
REM Maintenance: Windows Update (Windows version)
REM Note: Requires Administrator privileges

setlocal enabledelayedexpansion

REM Check for admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script must be run as Administrator.
    pause
    exit /b 1
)

echo == Maintenance: Windows Update ==
echo Started: %date% %time%

echo Starting Windows Update service...
net start wuauserv 2>nul
net start bits 2>nul

echo Checking for and installing Windows updates...
powershell -NoProfile -ExecutionPolicy Bypass -Command "if (Get-Command Install-WindowsUpdate -ErrorAction SilentlyContinue) { Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot } else { UsoClient StartScan; UsoClient StartDownload; UsoClient StartInstall }"

if errorlevel 1 (
    echo Note: Automated update install may not be available on this system.
    echo Please check Windows Update manually through Settings ^> Update ^& Security.
)

echo.
echo Finished: %date% %time%
echo System may require restart to complete updates.
if not "%NO_PAUSE%"=="1" pause
