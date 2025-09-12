@echo off
setlocal enabledelayedexpansion

REM cAdvisor Sample Project Setup Script for Windows
REM This script helps you set up and run different cAdvisor monitoring examples

title cAdvisor Sample Project Setup

echo.
echo ==========================================
echo     cAdvisor Sample Project Setup
echo ==========================================
echo.

REM Function to check if Docker is running
:check_docker
echo [INFO] Checking if Docker is running...
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker is not running. Please start Docker Desktop and try again.
    pause
    exit /b 1
)
echo [SUCCESS] Docker is running
goto :eof

REM Function to check if Docker Compose is available
:check_docker_compose
echo [INFO] Checking Docker Compose...
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker Compose is not available. Please install Docker Compose and try again.
    pause
    exit /b 1
)
echo [SUCCESS] Docker Compose is available
goto :eof

REM Function to pull the cAdvisor image
:pull_cadvisor_image
echo [INFO] Pulling cAdvisor image...
docker pull cleanstart/cadvisor:latest
if %errorlevel% neq 0 (
    echo [ERROR] Failed to pull cAdvisor image
    pause
    exit /b 1
)
echo [SUCCESS] cAdvisor image pulled successfully
goto :eof

REM Function to show menu
:show_menu
cls
echo.
echo ==========================================
echo     cAdvisor Sample Project Setup
echo ==========================================
echo.
echo Choose an example to run:
echo 1) Basic Monitoring (Single container monitoring)
echo 2) Multi-Container Monitoring (Full application stack)
echo 3) Production Setup (With Prometheus, Grafana, AlertManager)
echo 4) Stop all containers
echo 5) Clean up (remove all containers and volumes)
echo 6) Exit
echo.
goto :eof

REM Function to run basic monitoring
:run_basic_monitoring
echo [INFO] Starting Basic Monitoring example...
cd basic-monitoring
docker-compose up -d
if %errorlevel% neq 0 (
    echo [ERROR] Failed to start basic monitoring
    cd ..
    pause
    goto :main_loop
)
echo [SUCCESS] Basic monitoring started!
echo.
echo Access points:
echo - cAdvisor Web UI: http://localhost:8080
echo - Test App: http://localhost:8081
echo.
echo Use 'docker-compose logs -f' to view logs
echo Use 'docker-compose down' to stop
cd ..
pause
goto :main_loop

REM Function to run multi-container monitoring
:run_multi_container
echo [INFO] Starting Multi-Container Monitoring example...
cd multi-container
docker-compose up -d
if %errorlevel% neq 0 (
    echo [ERROR] Failed to start multi-container monitoring
    cd ..
    pause
    goto :main_loop
)
echo [SUCCESS] Multi-container monitoring started!
echo.
echo Access points:
echo - cAdvisor Web UI: http://localhost:8080
echo - Web App: http://localhost:8081
echo - API Server: http://localhost:8082
echo - Database: localhost:5432
echo - Redis Cache: localhost:6379
echo.
echo Use 'docker-compose logs -f' to view logs
echo Use 'docker-compose down' to stop
cd ..
pause
goto :main_loop

REM Function to run production setup
:run_production_setup
echo [INFO] Starting Production Setup example...
cd production-setup

REM Check if required files exist
if not exist "prometheus.yml" (
    echo [WARNING] prometheus.yml not found. Creating default configuration...
    call :create_prometheus_config
)

if not exist "alertmanager.yml" (
    echo [WARNING] alertmanager.yml not found. Creating default configuration...
    call :create_alertmanager_config
)

docker-compose up -d
if %errorlevel% neq 0 (
    echo [ERROR] Failed to start production setup
    cd ..
    pause
    goto :main_loop
)
echo [SUCCESS] Production setup started!
echo.
echo Access points:
echo - cAdvisor Web UI: http://localhost:8080
echo - Prometheus: http://localhost:9090
echo - Grafana: http://localhost:3000 (admin/admin123)
echo - AlertManager: http://localhost:9093
echo.
echo Use 'docker-compose logs -f' to view logs
echo Use 'docker-compose down' to stop
cd ..
pause
goto :main_loop

REM Function to create Prometheus configuration
:create_prometheus_config
(
echo global:
echo   scrape_interval: 15s
echo   evaluation_interval: 15s
echo.
echo rule_files:
echo   # - "first_rules.yml"
echo   # - "second_rules.yml"
echo.
echo scrape_configs:
echo   - job_name: 'prometheus'
echo     static_configs:
echo       - targets: ['localhost:9090']
echo.
echo   - job_name: 'cadvisor'
echo     static_configs:
echo       - targets: ['cadvisor:8080']
echo     metrics_path: /metrics
echo     scrape_interval: 15s
) > prometheus.yml
goto :eof

REM Function to create AlertManager configuration
:create_alertmanager_config
(
echo global:
echo   resolve_timeout: 5m
echo.
echo route:
echo   group_by: ['alertname']
echo   group_wait: 10s
echo   group_interval: 10s
echo   repeat_interval: 1h
echo   receiver: 'web.hook'
echo receivers:
echo   - name: 'web.hook'
echo     webhook_configs:
echo       - url: 'http://127.0.0.1:5001/'
echo inhibit_rules:
echo   - source_match:
echo       severity: 'critical'
echo     target_match:
echo       severity: 'warning'
echo     equal: ['alertname', 'dev', 'instance']
) > alertmanager.yml
goto :eof

REM Function to stop all containers
:stop_all_containers
echo [INFO] Stopping all containers...

REM Stop containers in each directory
for %%d in (basic-monitoring multi-container production-setup) do (
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
goto :main_loop

REM Function to clean up
:cleanup
echo [INFO] Cleaning up all containers and volumes...

REM Stop and remove containers in each directory
for %%d in (basic-monitoring multi-container production-setup) do (
    if exist "%%d" (
        cd "%%d"
        if exist "docker-compose.yml" (
            docker-compose down -v --rmi all >nul 2>&1
            echo [SUCCESS] Cleaned up %%d
        )
        cd ..
    )
)

REM Remove any dangling containers
docker container prune -f >nul 2>&1
docker volume prune -f >nul 2>&1

echo [SUCCESS] Cleanup completed
pause
goto :main_loop

REM Main script
:main
echo [INFO] Checking prerequisites...
call :check_docker
call :check_docker_compose

echo [INFO] Pulling required images...
call :pull_cadvisor_image

:main_loop
call :show_menu
set /p choice="Enter your choice (1-6): "

if "%choice%"=="1" goto :run_basic_monitoring
if "%choice%"=="2" goto :run_multi_container
if "%choice%"=="3" goto :run_production_setup
if "%choice%"=="4" goto :stop_all_containers
if "%choice%"=="5" goto :cleanup
if "%choice%"=="6" (
    echo [INFO] Exiting...
    exit /b 0
)

echo [ERROR] Invalid choice. Please enter a number between 1 and 6.
pause
goto :main_loop

REM Start the script
call :main
