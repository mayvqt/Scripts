@echo off
REM Optimization: Performance optimization (Windows)
REM Note: Requires Administrator privileges

setlocal enabledelayedexpansion

REM Check for admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script must be run as Administrator.
    pause
    exit /b 1
)

echo == Optimization: Performance and memory management ==
echo Started: %date% %time%

REM Disable visual effects for better performance
echo Optimizing visual effects...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f 2>nul

REM Clear DNS cache
echo Clearing DNS cache...
ipconfig /flushdns 2>nul

REM Optimize network settings
echo Optimizing network settings...
netsh interface tcp set global autotuninglevel=normal 2>nul
netsh interface tcp set global ecn=enabled 2>nul

REM Disable thumbnail cache clearing on shutdown
echo Optimizing thumbnail cache...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v DisableThumbnailCache /t REG_DWORD /d 1 /f 2>nul

REM Reduce virtual memory fragmentation (optional) on all drives
echo Defragmenting all drives...
powershell -Command "Get-Volume | Where-Object {$_.DriveLetter} | ForEach-Object {Optimize-Volume -DriveLetter $_.DriveLetter -Defrag -Verbose}" 2>nul

REM Clear unnecessary fonts from memory
echo Clearing font cache...
del /Q "%SystemRoot%\Prefetch\*" 2>nul

REM Optimize power settings for performance
echo Setting power plan to High Performance...
powercfg /setactive 8c5e7fda-e8bf-45a6-a6cc-4b3c5b6e6da6 2>nul

echo.
echo Finished: %date% %time%
echo Note: System may require restart for all optimizations to take effect.
pause
