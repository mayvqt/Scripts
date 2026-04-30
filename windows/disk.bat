@echo off
REM Optimization: Disk optimization and cleanup (Windows)
REM Note: Requires Administrator privileges

setlocal enabledelayedexpansion

REM Check for admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script must be run as Administrator.
    pause
    exit /b 1
)

echo == Optimization: Disk optimization and cleanup ==
echo Started: %date% %time%

echo Analyzing and optimizing all drives...
powershell -NoProfile -Command "Get-Volume | Where-Object DriveLetter | ForEach-Object { Write-Host ('Optimizing {0}:' -f $_.DriveLetter); Optimize-Volume -DriveLetter $_.DriveLetter -Analyze -ErrorAction SilentlyContinue; Optimize-Volume -DriveLetter $_.DriveLetter -ErrorAction SilentlyContinue }"

echo Cleaning Windows Update download cache...
net stop wuauserv 2>nul
net stop bits 2>nul
del /Q /S "%SystemRoot%\SoftwareDistribution\Download\*" 2>nul
net start bits 2>nul
net start wuauserv 2>nul

echo Running read-only disk scans...
for /F "tokens=1" %%D in ('wmic logicaldisk where "drivetype=3" get name ^| findstr /R "[A-Z]:"') do (
    echo Checking %%D
    chkdsk %%D 2>nul
)

echo Disk usage summary:
wmic logicaldisk get caption,freespace,size,volumename

echo.
echo Finished: %date% %time%
if not "%NO_PAUSE%"=="1" pause
