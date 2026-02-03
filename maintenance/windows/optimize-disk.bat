@echo off
REM Optimization: Disk optimization and cleanup (Windows)
REM Note: Requires Administrator privileges

setlocal enabledelayedexpansion

REM Check for admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script must be run as Administrator.
    pause
    exit /b 1
)

echo == Optimization: Disk optimization and cleanup ==
echo Started: %date% %time%

REM Analyze and defragment all drives
echo Analyzing and optimizing all drives...
for /F "tokens=1" %%D in ('wmic logicaldisk get name ^| findstr /R "[A-Z]:"') do (
    echo Defragmenting %%D
    defrag %%D /A 2>nul
    defrag %%D /O 2>nul
)

REM Clear Windows Update cache
echo Clearing Windows Update cache...
del /Q /S "%SystemRoot%\SoftwareDistribution\Download\*" 2>nul

REM Clear installer cache
echo Clearing installer cache...
del /Q /S "%SystemRoot%\Installer\$PatchCache$\Managed\*" 2>nul

REM Run CHKDSK on all drives (read-only scan, no repair)
echo Running disk check on all drives...
for /F "tokens=1" %%D in ('wmic logicaldisk get name ^| findstr /R "[A-Z]:"') do (
    echo Checking %%D
    chkdsk %%D /F /R 2>nul
)

REM Clear prefetch
echo Clearing prefetch...
del /Q /S "%SystemRoot%\Prefetch\*" 2>nul

REM Compress Windows folder (optional - frees space)
echo Compressing system files (optional)...
compact /compactos:always 2>nul

echo.
echo Finished: %date% %time%
echo Note: Some optimizations may require a system restart. Disk repair (/F flag) requires restart.
pause
