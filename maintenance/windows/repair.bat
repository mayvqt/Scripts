@echo off
REM Repair: Windows component store, protected files, and online disk scan.
REM Note: Requires Administrator privileges.

setlocal

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script must be run as Administrator.
    pause
    exit /b 1
)

echo == Windows repair ==
echo Started: %date% %time%

echo.
echo == Component Store ==
Dism.exe /Online /Cleanup-Image /CheckHealth
Dism.exe /Online /Cleanup-Image /ScanHealth
Dism.exe /Online /Cleanup-Image /RestoreHealth

echo.
echo == System File Checker ==
sfc /scannow

echo.
echo == Online Disk Scan ==
for /F "tokens=1" %%D in ('wmic logicaldisk where "drivetype=3" get name ^| findstr /R "[A-Z]:"') do (
    echo Scanning %%D
    chkdsk %%D /scan
)

echo.
echo Finished: %date% %time%
echo A restart may be required if repairs were applied.
if not "%NO_PAUSE%"=="1" pause
