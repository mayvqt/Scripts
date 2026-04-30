@echo off
REM Optimization: Disable common optional Windows services
REM Note: Requires Administrator privileges. Review before running on shared or managed PCs.

setlocal

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script must be run as Administrator.
    pause
    exit /b 1
)

echo == Optimization: Disable optional services ==
echo Started: %date% %time%

for %%S in (
    DiagTrack
    MapsBroker
    RetailDemo
    XblAuthManager
    XblGameSave
    XboxNetApiSvc
) do (
    sc query "%%S" >nul 2>&1
    if not errorlevel 1 (
        echo Disabling %%S
        sc stop "%%S" >nul 2>&1
        sc config "%%S" start= disabled >nul
    ) else (
        echo Skipping %%S; service not found.
    )
)

echo.
echo Finished: %date% %time%
if not "%NO_PAUSE%"=="1" pause
