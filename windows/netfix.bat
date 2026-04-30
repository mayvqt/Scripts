@echo off
REM Repair: Windows DNS and network stack reset.
REM Note: Requires Administrator privileges and may require a restart.

setlocal

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script must be run as Administrator.
    pause
    exit /b 1
)

echo == Network repair ==

echo Flushing DNS cache...
ipconfig /flushdns

echo Releasing and renewing DHCP leases...
ipconfig /release
ipconfig /renew

echo Resetting Winsock and IP stack...
netsh winsock reset
netsh int ip reset

echo.
echo Connectivity check:
ping -n 3 1.1.1.1
ping -n 3 microsoft.com

echo.
echo Network repair completed. Restart Windows if connectivity is still broken.
if not "%NO_PAUSE%"=="1" pause
