@echo off
REM Run a Windows maintenance action by short name. Defaults to health.

setlocal

set ACTION=%1
if "%ACTION%"=="" set ACTION=health

set SCRIPT_DIR=%~dp0
set TARGET=%SCRIPT_DIR%windows\%ACTION%.bat

if not exist "%TARGET%" (
    echo Unknown action "%ACTION%" for Windows.
    echo Available actions:
    dir /b "%SCRIPT_DIR%windows\*.bat"
    exit /b 2
)

call "%TARGET%"
