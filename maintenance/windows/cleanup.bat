@echo off
REM Maintenance: cleanup temporary files (Windows version)
REM Note: Requires Administrator privileges

setlocal enabledelayedexpansion

REM Check for admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script must be run as Administrator.
    pause
    exit /b 1
)

echo == Maintenance: cleanup temporary files ==
echo Started: %date% %time%

REM Delete temp files from user temp folder
echo Cleaning user temporary files...
del /Q /S "%TEMP%\*" 2>nul

REM Delete temp files from system temp folder
echo Cleaning system temporary files...
del /Q /S "%SystemRoot%\Temp\*" 2>nul

REM Delete temporary internet files
echo Cleaning internet temporary files...
del /Q /S "%LocalAppData%\Microsoft\Windows\INetCache\*" 2>nul

REM Delete recent files
echo Cleaning recent files...
del /Q /S "%AppData%\Microsoft\Windows\Recent\*" 2>nul

REM Empty Recycle Bin
echo Emptying Recycle Bin...
powershell -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"

echo.
echo Finished: %date% %time%
pause
