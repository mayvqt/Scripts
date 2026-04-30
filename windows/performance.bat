@echo off
REM Optimization: Conservative Windows performance maintenance
REM Note: Requires Administrator privileges

setlocal

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script must be run as Administrator.
    pause
    exit /b 1
)

echo == Optimization: Performance maintenance ==
echo Started: %date% %time%

echo Flushing DNS cache...
ipconfig /flushdns

echo Resetting Windows Store cache when available...
wsreset.exe -i 2>nul

echo Setting active power plan to balanced...
powercfg /setactive SCHEME_BALANCED

echo Cleaning thumbnail cache...
taskkill /f /im explorer.exe >nul 2>&1
del /f /s /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" 2>nul
start explorer.exe

echo Checking system image health...
Dism.exe /Online /Cleanup-Image /ScanHealth

echo.
echo Finished: %date% %time%
if not "%NO_PAUSE%"=="1" pause
