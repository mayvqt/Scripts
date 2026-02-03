@echo off
REM Optimization: Disable unnecessary services (Windows)
REM Note: Requires Administrator privileges

setlocal enabledelayedexpansion

REM Check for admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script must be run as Administrator.
    pause
    exit /b 1
)

echo == Optimization: Disable unnecessary services ==
echo Started: %date% %time%

REM Services to disable (modify based on your needs)
REM Uncomment services you want to disable

REM Bluetooth support
echo Configuring Bluetooth service...
sc config bthserv start= disabled 2>nul

REM Print Spooler (if you don't print)
REM echo Disabling Print Spooler...
REM net stop spooler 2>nul
REM sc config spooler start= disabled 2>nul

REM Windows Search (if you don't use Windows Search)
REM echo Disabling Windows Search...
REM net stop WSearch 2>nul
REM sc config WSearch start= disabled 2>nul

REM DiagTrack (Diagnostic Tracking Service)
echo Disabling DiagTrack...
sc config DiagTrack start= disabled 2>nul
net stop DiagTrack 2>nul

REM dmwappushservice
echo Disabling dmwappushservice...
sc config dmwappushservice start= disabled 2>nul
net stop dmwappushservice 2>nul

REM Connected User Experiences and Telemetry
echo Disabling telemetry services...
sc config DiagTrack start= disabled 2>nul
sc config dmwappushservice start= disabled 2>nul

echo.
echo Finished: %date% %time%
echo Note: Some services may require a system restart to take effect.
pause
