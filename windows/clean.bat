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

echo Cleaning user temporary files...
forfiles /p "%TEMP%" /s /m *.* /d -7 /c "cmd /c del /q @path" 2>nul
for /d %%D in ("%TEMP%\*") do rd /s /q "%%D" 2>nul

echo Cleaning system temporary files...
forfiles /p "%SystemRoot%\Temp" /s /m *.* /d -7 /c "cmd /c del /q @path" 2>nul
for /d %%D in ("%SystemRoot%\Temp\*") do rd /s /q "%%D" 2>nul

echo Cleaning internet temporary files...
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8

echo Cleaning recent files...
del /Q /S "%AppData%\Microsoft\Windows\Recent\*" 2>nul

echo Emptying Recycle Bin...
powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"

echo Running component cleanup...
Dism.exe /Online /Cleanup-Image /StartComponentCleanup

echo.
echo Finished: %date% %time%
if not "%NO_PAUSE%"=="1" pause
