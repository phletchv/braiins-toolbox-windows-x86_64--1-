@echo off
REM Braiins Toolbox - Hiveon OS Connection Script (Windows)
REM This script manages connections to Hiveon OS miners and pools

setlocal enabledelayedexpansion

set SCRIPT_DIR=%~dp0
set CONFIG_FILE=%SCRIPT_DIR%hiveon-config.json
set LOG_FILE=%SCRIPT_DIR%hiveon-connection.log

REM Check if the configuration file exists
if not exist "%CONFIG_FILE%" (
    echo Error: Configuration file not found: %CONFIG_FILE%
    exit /b 1
)

REM Log function
set "timestamp="
for /f "tokens=1-4 delims=/ " %%a in ('date /t') do set "timestamp=%%c-%%a-%%b"
for /f "tokens=1-2 delims=: " %%a in ('time /t') do set "timestamp=!timestamp! %%a:%%b"

echo %timestamp% - Hiveon OS Connection Script Started >> "%LOG_FILE%"

REM Show usage
if "%1"=="" goto :show_usage
if "%1"=="help" goto :show_usage
if "%1"=="-h" goto :show_usage
if "%1"=="--help" goto :show_usage

REM Handle commands
if "%1"=="config" goto :show_config
if "%1"=="validate" goto :validate_config
if "%1"=="test-simple" goto :test_simple
if "%1"=="generate-simple" goto :generate_simple

echo Unknown command: %1
echo.
goto :show_usage

:show_config
echo === Hiveon OS Configuration Summary ===
echo Configuration file: %CONFIG_FILE%
echo.
echo Note: For detailed configuration parsing, use the Linux script or install JSON parsing tools.
echo Use 'connect-hiveon.bat validate' to check if the file exists.
echo.
goto :end

:validate_config
echo Validating configuration file...
if exist "%CONFIG_FILE%" (
    echo ^| Configuration file found: %CONFIG_FILE%
    echo %timestamp% - Configuration validation: SUCCESS >> "%LOG_FILE%"
) else (
    echo X Configuration file not found: %CONFIG_FILE%
    echo %timestamp% - Configuration validation: FAILED >> "%LOG_FILE%"
    exit /b 1
)
goto :end

:test_simple
echo === Testing Basic Connectivity ===
echo Testing Hiveon pool connectivity...
echo.

REM Test basic connectivity to Hiveon pool
echo Testing connection to eth-us-east1.hiveon.net:4444...
ping -n 2 eth-us-east1.hiveon.net >nul 2>&1
if %errorlevel%==0 (
    echo ^| Hiveon pool server is reachable
    echo %timestamp% - Pool connectivity test: SUCCESS >> "%LOG_FILE%"
) else (
    echo X Hiveon pool server is not reachable
    echo %timestamp% - Pool connectivity test: FAILED >> "%LOG_FILE%"
)

echo.
echo Testing Hiveon API connectivity...
curl -s --connect-timeout 10 https://hiveon.net >nul 2>&1
if %errorlevel%==0 (
    echo ^| Hiveon API endpoint is reachable
    echo %timestamp% - API connectivity test: SUCCESS >> "%LOG_FILE%"
) else (
    echo X Hiveon API endpoint is not reachable or curl not available
    echo %timestamp% - API connectivity test: FAILED >> "%LOG_FILE%"
)
goto :end

:generate_simple
echo === Generating Basic Miner Configuration ===
set OUTPUT_FILE=%SCRIPT_DIR%miner-config-hiveon.conf

echo # Hiveon OS Miner Configuration > "%OUTPUT_FILE%"
echo # Generated on %date% %time% >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo # Pool Configuration >> "%OUTPUT_FILE%"
echo POOL1_URL="stratum+tcp://eth-us-east1.hiveon.net:4444" >> "%OUTPUT_FILE%"
echo POOL1_USER="YOUR_WALLET_ADDRESS.worker01" >> "%OUTPUT_FILE%"
echo POOL1_PASS="x" >> "%OUTPUT_FILE%"
echo POOL1_ALGO="ethash" >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo # Backup Pool >> "%OUTPUT_FILE%"
echo POOL2_URL="stratum+ssl://eth-us-east1.hiveon.net:24443" >> "%OUTPUT_FILE%"
echo POOL2_USER="YOUR_WALLET_ADDRESS.worker01" >> "%OUTPUT_FILE%"
echo POOL2_PASS="x" >> "%OUTPUT_FILE%"
echo POOL2_ALGO="ethash" >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo # Miner Settings >> "%OUTPUT_FILE%"
echo WORKER_NAME="worker01" >> "%OUTPUT_FILE%"
echo POWER_LIMIT=80 >> "%OUTPUT_FILE%"
echo TEMP_LIMIT=85 >> "%OUTPUT_FILE%"
echo FAN_SPEED="auto" >> "%OUTPUT_FILE%"

echo ^| Basic miner configuration written to: %OUTPUT_FILE%
echo %timestamp% - Generated basic miner configuration >> "%LOG_FILE%"
goto :end

:show_usage
echo Braiins Toolbox - Hiveon OS Connection Manager (Windows)
echo.
echo Usage: %0 [COMMAND]
echo.
echo Commands:
echo   config        Show configuration summary
echo   validate      Check if configuration file exists
echo   test-simple   Test basic connectivity to Hiveon services
echo   generate-simple Generate basic miner configuration file
echo   help          Show this help message
echo.
echo Configuration file: %CONFIG_FILE%
echo Log file: %LOG_FILE%
echo.
echo Note: For advanced features, use the Linux version (connect-hiveon.sh)
echo       or install JSON parsing tools for Windows.
goto :end

:end
echo %timestamp% - Script execution completed >> "%LOG_FILE%"