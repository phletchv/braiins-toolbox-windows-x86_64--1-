@echo off
REM Braiins Pool Connection Test Script
REM This script tests connectivity to Braiins Pool servers

echo Testing Braiins Pool Connectivity...
echo.

echo Testing primary stratum server (port 3333)...
ping -n 1 stratum.braiins.com
if %errorlevel% equ 0 (
    echo [SUCCESS] Can reach stratum.braiins.com
) else (
    echo [ERROR] Cannot reach stratum.braiins.com
)
echo.

echo Testing stratum port 3333...
telnet stratum.braiins.com 3333 2>nul
if %errorlevel% equ 0 (
    echo [SUCCESS] Port 3333 is accessible
) else (
    echo [WARNING] Port 3333 may be blocked by firewall
)
echo.

echo Testing backup stratum port 3336...
telnet stratum.braiins.com 3336 2>nul
if %errorlevel% equ 0 (
    echo [SUCCESS] Port 3336 is accessible
) else (
    echo [WARNING] Port 3336 may be blocked by firewall
)
echo.

echo Testing SSL stratum port 3334...
telnet stratum.braiins.com 3334 2>nul
if %errorlevel% equ 0 (
    echo [SUCCESS] Port 3334 is accessible
) else (
    echo [WARNING] Port 3334 may be blocked by firewall
)
echo.

echo.
echo Connectivity test complete!
echo.
echo If you see any errors:
echo 1. Check your internet connection
echo 2. Verify firewall settings
echo 3. Contact your network administrator
echo.
pause