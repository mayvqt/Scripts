@echo off
REM Runs the main Windows maintenance tasks in order.

setlocal

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script must be run as Administrator.
    pause
    exit /b 1
)

set SCRIPT_DIR=%~dp0
set NO_PAUSE=1

call "%SCRIPT_DIR%update.bat"
call "%SCRIPT_DIR%clean.bat"
call "%SCRIPT_DIR%logs.bat"
call "%SCRIPT_DIR%disk.bat"
call "%SCRIPT_DIR%security.bat"
call "%SCRIPT_DIR%health.bat"

echo Windows full maintenance completed.
pause
