@echo off
REM Diagnostics: Windows security posture summary

setlocal

echo == Firewall Profiles ==
netsh advfirewall show allprofiles

echo.
echo == Defender Status ==
powershell -NoProfile -Command "Get-MpComputerStatus | Select-Object AMServiceEnabled,AntivirusEnabled,RealTimeProtectionEnabled,AntispywareEnabled,QuickScanAge,FullScanAge | Format-List" 2>nul

echo.
echo == Local Administrators ==
net localgroup administrators

echo.
echo == Open Listening Ports ==
powershell -NoProfile -Command "Get-NetTCPConnection -State Listen | Sort-Object LocalPort | Select-Object LocalAddress,LocalPort,OwningProcess | Format-Table -AutoSize"

echo.
echo == Recent Failed Logons ==
powershell -NoProfile -Command "Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625; StartTime=(Get-Date).AddDays(-1)} -MaxEvents 20 | Select-Object TimeCreated,Id,ProviderName,Message | Format-List" 2>nul

if not "%NO_PAUSE%"=="1" pause
