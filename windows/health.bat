@echo off
REM Diagnostics: Windows system health report

setlocal

echo == System ==
hostname
ver
systeminfo | findstr /C:"OS Name" /C:"OS Version" /C:"System Boot Time" /C:"System Manufacturer" /C:"System Model"

echo.
echo == Disk ==
wmic logicaldisk get caption,description,freespace,size,volumename

echo.
echo == Memory ==
wmic OS get FreePhysicalMemory,TotalVisibleMemorySize /Value

echo.
echo == Top Processes ==
powershell -NoProfile -Command "Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Id,ProcessName,CPU,WorkingSet | Format-Table -AutoSize"

echo.
echo == Services Not Running But Automatic ==
powershell -NoProfile -Command "Get-Service | Where-Object { $_.StartType -eq 'Automatic' -and $_.Status -ne 'Running' } | Select-Object -First 30 Name,Status,StartType | Format-Table -AutoSize"

echo.
echo == Recent System Errors ==
powershell -NoProfile -Command "Get-WinEvent -FilterHashtable @{LogName='System'; Level=2; StartTime=(Get-Date).AddDays(-7)} -MaxEvents 20 | Select-Object TimeCreated,ProviderName,Id,Message | Format-List"

if not "%NO_PAUSE%"=="1" pause
