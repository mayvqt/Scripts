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

REM Start Windows Update service if not running
echo Starting Windows Update service...
net start wuauserv 2>nul

REM Check for updates and install them
echo Checking for and installing Windows updates...
powershell -Command "Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot" 2>nul

if errorlevel 1 (
    echo Note: PowerShell Windows Update module may not be installed on this system.
    echo Please check Windows Update manually through Settings ^> Update ^& Security.
)

echo.
echo Finished: %date% %time%
echo System may require restart to complete updates.
pause
