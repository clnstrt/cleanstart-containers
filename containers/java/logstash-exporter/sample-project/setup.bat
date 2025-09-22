@echo off
setlocal enabledelayedexpansion

REM Logstash Exporter Sample Project Setup Script for Windows
REM This script helps you set up and run the different examples

title Logstash Exporter Sample Projects Setup

:main_loop
cls
echo ==========================================
echo     Logstash Exporter Sample Projects
echo ==========================================
echo.
echo Choose an example to run:
echo.
echo 1) Basic Monitoring
echo 2) Multi-Instance Monitoring
echo 3) Production Setup
echo 4) Integration Examples
echo 5) Stop All Containers
echo 6) Cleanup All
echo 7) Exit
echo.

set /p choice="Enter your choice (1-7): "

if "%choice%"=="1" goto basic_monitoring
if "%choice%"=="2" goto multi_instance
if "%choice%"=="3" goto production_setup
if "%choice%"=="4" goto integration_examples
if "%choice%"=="5" goto stop_all_containers
if "%choice%"=="6" goto cleanup
if "%choice%"=="7" goto exit_script
goto invalid_choice

:basic_monitoring
echo [INFO] Starting Basic Monitoring example...
cd basic-monitoring

REM Check if docker-compose.yml exists
if not exist "docker-compose.yml" (
    echo [ERROR] docker-compose.yml not found in basic-monitoring directory
    cd ..
    pause
    goto main_loop
)

echo [INFO] Starting services...
docker-compose up -d

echo [SUCCESS] Basic monitoring started!
echo.
echo Access points:
echo - Logstash: http://localhost:9600
echo - logstash-exporter: http://localhost:9198
echo - Log Generator: http://localhost:8080
echo - Test App: http://localhost:8081
echo.
echo Use 'docker-compose logs -f' to view logs
echo Use 'docker-compose down' to stop
cd ..
pause
goto main_loop

:multi_instance
echo [INFO] Starting Multi-Instance Monitoring example...
cd multi-instance

if not exist "docker-compose.yml" (
    echo [ERROR] docker-compose.yml not found in multi-instance directory
    cd ..
    pause
    goto main_loop
)

echo [INFO] Starting services...
docker-compose up -d

echo [SUCCESS] Multi-instance monitoring started!
echo.
echo Access points:
echo - Logstash Instances: http://localhost:9600, http://localhost:9601
echo - logstash-exporter: http://localhost:9198
echo - Load Balancer: http://localhost:8080
echo.
echo Use 'docker-compose logs -f' to view logs
echo Use 'docker-compose down' to stop
cd ..
pause
goto main_loop

:production_setup
echo [INFO] Starting Production Setup example...
cd production-setup

if not exist "docker-compose.yml" (
    echo [ERROR] docker-compose.yml not found in production-setup directory
    cd ..
    pause
    goto main_loop
)

echo [INFO] Starting production monitoring stack...
docker-compose up -d

echo [SUCCESS] Production setup started!
echo.
echo Access points:
echo - logstash-exporter: http://localhost:9198
echo - Prometheus: http://localhost:9090
echo - Grafana: http://localhost:3000 (admin/admin123)
echo - AlertManager: http://localhost:9093
echo.
echo Use 'docker-compose logs -f' to view logs
echo Use 'docker-compose down' to stop
cd ..
pause
goto main_loop

:integration_examples
echo [INFO] Starting Integration Examples...
cd integration-examples

if not exist "docker-compose.yml" (
    echo [ERROR] docker-compose.yml not found in integration-examples directory
    cd ..
    pause
    goto main_loop
)

echo [INFO] Starting integration services...
docker-compose up -d

echo [SUCCESS] Integration examples started!
echo.
echo Check the README.md file for specific access points
echo Use 'docker-compose logs -f' to view logs
echo Use 'docker-compose down' to stop
cd ..
pause
goto main_loop

:stop_all_containers
echo [INFO] Stopping all containers...

REM Stop containers in each directory
for %%d in (basic-monitoring multi-instance production-setup integration-examples) do (
    if exist "%%d" (
        cd "%%d"
        if exist "docker-compose.yml" (
            docker-compose down >nul 2>&1
            echo [SUCCESS] Stopped containers in %%d
        )
        cd ..
    )
)

echo [SUCCESS] All containers stopped
pause
goto main_loop

:cleanup
echo [INFO] Cleaning up all containers and volumes...

REM Stop and remove containers in each directory
for %%d in (basic-monitoring multi-instance production-setup integration-examples) do (
    if exist "%%d" (
        cd "%%d"
        if exist "docker-compose.yml" (
            docker-compose down -v --remove-orphans >nul 2>&1
            echo [SUCCESS] Cleaned up %%d
        )
        cd ..
    )
)

echo [SUCCESS] All containers and volumes cleaned up
pause
goto main_loop

:invalid_choice
echo [ERROR] Invalid choice. Please enter a number between 1 and 7.
timeout /t 2 >nul
goto main_loop

:exit_script
echo [INFO] Exiting...
exit /b 0
