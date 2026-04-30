@echo off
REM Maintenance: Windows configuration snapshot

setlocal

set BACKUP_ROOT=%BACKUP_ROOT%
if "%BACKUP_ROOT%"=="" set BACKUP_ROOT=%SystemDrive%\sysadmin-script-backups

for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd-HHmmss"') do set STAMP=%%I
set DEST=%BACKUP_ROOT%\%STAMP%

mkdir "%DEST%" 2>nul

echo == Windows configuration snapshot ==
echo Destination: %DEST%

systeminfo > "%DEST%\systeminfo.txt"
driverquery /v > "%DEST%\drivers.txt"
sc query type= service state= all > "%DEST%\services.txt"
schtasks /query /fo LIST /v > "%DEST%\scheduled-tasks.txt"
netsh advfirewall export "%DEST%\firewall-policy.wfw" >nul 2>&1
reg export HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall "%DEST%\installed-software.reg" /y >nul 2>&1

echo Backup snapshot completed: %DEST%
if not "%NO_PAUSE%"=="1" pause
