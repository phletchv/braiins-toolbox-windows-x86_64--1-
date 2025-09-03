@echo off
REM Braiins Pool Miner Quick Start Script
REM This script helps you quickly configure and start mining

echo ========================================
echo    Braiins Pool Mining Quick Start
echo ========================================
echo.

REM Get user input
set /p USERNAME="Enter your Braiins Pool username: "
if "%USERNAME%"=="" (
    echo Error: Username cannot be empty!
    pause
    exit /b 1
)

set /p WORKER="Enter worker name (e.g., miner01): "
if "%WORKER%"=="" (
    echo Error: Worker name cannot be empty!
    pause
    exit /b 1
)

echo.
echo Your mining configuration:
echo Username: %USERNAME%
echo Worker: %USERNAME%.%WORKER%
echo Pool: stratum+tcp://stratum.braiins.com:3333
echo.

REM Create configuration file
echo Creating miner configuration...

REM For BFGMiner
echo bfgminer.exe -o stratum+tcp://stratum.braiins.com:3333 -u %USERNAME%.%WORKER% -p x > start-bfgminer.bat
echo echo Starting BFGMiner... >> start-bfgminer.bat
echo pause >> start-bfgminer.bat

REM For CGMiner
echo cgminer.exe -o stratum+tcp://stratum.braiins.com:3333 -u %USERNAME%.%WORKER% -p x > start-cgminer.bat
echo echo Starting CGMiner... >> start-cgminer.bat
echo pause >> start-cgminer.bat

echo.
echo Configuration files created:
echo - start-bfgminer.bat (for BFGMiner)
echo - start-cgminer.bat (for CGMiner)
echo.
echo Place these files in your miner directory and run them to start mining!
echo.
echo Next steps:
echo 1. Copy the appropriate .bat file to your miner folder
echo 2. Make sure your miner executable is in the same folder
echo 3. Double-click the .bat file to start mining
echo 4. Monitor your miners at https://pool.braiins.com
echo.
pause