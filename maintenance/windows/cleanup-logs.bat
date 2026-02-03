@echo off
REM Maintenance: cleanup logs (Windows version)
REM Note: Requires Administrator privileges

setlocal enabledelayedexpansion

REM Check for admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script must be run as Administrator.
    pause
    exit /b 1
)

echo == Maintenance: cleanup logs ==
echo Started: %date% %time%

REM Clear Windows Event Logs
for /F %%x in ('wevtutil.exe el') do (
    echo Clearing %%x...
    wevtutil.exe cl "%%x" 2>nul
)

REM Clear temporary files in %TEMP%
echo Cleaning %TEMP%...
del /Q /S "%TEMP%\*" 2>nul

REM Clear temporary files in system temp
echo Cleaning system temp...
del /Q /S "%SystemRoot%\Temp\*" 2>nul

REM Run Disk Cleanup (if installed)
echo Running Disk Cleanup...
cleanmgr /sagerun:1 2>nul

echo.
echo Finished: %date% %time%
pause
