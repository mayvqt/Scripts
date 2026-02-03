@echo off
REM Maintenance: System health check and diagnostics (Windows)

setlocal enabledelayedexpansion

echo == Maintenance: System health check and diagnostics ==
echo Started: %date% %time%

echo.
echo === Disk Usage ===
wmic logicaldisk get name,size,freespace /format:list | find "C:"

echo.
echo === Memory Usage ===
wmic os get totalvisiblememorysizve,freephysicalmemory /format:list

echo.
echo === System Uptime ===
systeminfo | find "System Boot Time"

echo.
echo === Running Processes (Top 10) ===
tasklist /v | findstr /i "running" | head -10

echo.
echo === Network Connections ===
netstat -an | find "ESTABLISHED" | wc -l

echo.
echo === Disk Health ===
wmic logicaldisk get name,freespace,size

echo.
echo === Event Log Summary (Last 24 Hours) ===
powershell -Command "Get-EventLog -LogName System -After (Get-Date).AddDays(-1) | Group-Object -Property EntryType | Select-Object Name, Count"

echo.
echo === Services Status ===
tasklist /svc | find "svchost" | head -5

echo.
echo Finished: %date% %time%
pause
