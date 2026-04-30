@echo off
REM Diagnostics: Windows network summary

setlocal

echo == Interfaces ==
ipconfig /all

echo.
echo == Routes ==
route print

echo.
echo == Connectivity ==
ping -n 3 1.1.1.1
ping -n 3 microsoft.com

echo.
echo == Listening Ports ==
netstat -ano | findstr LISTENING

echo.
echo == DNS Cache Sample ==
ipconfig /displaydns | more

if not "%NO_PAUSE%"=="1" pause
