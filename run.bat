@echo off
REM Run a Windows maintenance action by short name. Defaults to health.

setlocal enabledelayedexpansion

set "ACTION=%~1"
if "%ACTION%"=="" (
    set "ACTION=health"
) else (
    shift
)

set "SCRIPT_DIR=%~dp0"
set "TARGET=%SCRIPT_DIR%windows\%ACTION%.bat"

if not exist "%TARGET%" (
    echo Unknown action "%ACTION%" for Windows.
    echo Available actions:
    for %%F in ("%SCRIPT_DIR%windows\*.bat") do echo   %%~nF
    exit /b 2
)

set "ARGS="
:collect_args
if "%~1"=="" goto run_target
set ARGS=!ARGS! "%~1"
shift
goto collect_args

:run_target
call "%TARGET%" %ARGS%
