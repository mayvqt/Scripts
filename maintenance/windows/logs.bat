@echo off
REM Maintenance: Clean Windows logs and temporary files
REM Note: Requires Administrator privileges

setlocal

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script must be run as Administrator.
    pause
    exit /b 1
)

echo == Maintenance: cleanup logs ==
echo Started: %date% %time%

echo Exporting event log names and clearing logs...
for /F "tokens=*" %%G in ('wevtutil el') do (
    wevtutil cl "%%G" 2>nul
)

echo Cleaning CBS and DISM archived logs...
del /Q /S "%SystemRoot%\Logs\CBS\*.cab" 2>nul
del /Q /S "%SystemRoot%\Logs\DISM\*.log" 2>nul

echo Cleaning Windows Error Reporting archives...
del /Q /S "%ProgramData%\Microsoft\Windows\WER\ReportArchive\*" 2>nul
del /Q /S "%ProgramData%\Microsoft\Windows\WER\ReportQueue\*" 2>nul

echo.
echo Finished: %date% %time%
if not "%NO_PAUSE%"=="1" pause
