@echo off
REM Braiins Toolbox - Nginx Web Application Runner (Windows)
REM This script runs an nginx container with the specified configuration

set CONTAINER_NAME=mywebapp
set IMAGE_NAME=nginx

echo Starting nginx web application container...
echo Container name: %CONTAINER_NAME%
echo Image: %IMAGE_NAME%
echo Restart policy: always
echo Mode: detached

REM Run the nginx container
docker run --name %CONTAINER_NAME% --restart always -d %IMAGE_NAME%

if %ERRORLEVEL% equ 0 (
    echo Container '%CONTAINER_NAME%' started successfully!
    echo To view logs: docker logs %CONTAINER_NAME%
    echo To stop: docker stop %CONTAINER_NAME%
    echo To remove: docker rm %CONTAINER_NAME%
) else (
    echo Failed to start container. Error code: %ERRORLEVEL%
    exit /b %ERRORLEVEL%
)