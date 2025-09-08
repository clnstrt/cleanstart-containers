@echo off
REM Kubernetes Sample Projects Local Testing Script
REM This script tests the Docker Compose versions of our K8s samples

echo ========================================
echo Kubernetes Sample Projects Test Script
echo ========================================
echo.

REM Check if Docker is running
echo [INFO] Checking Docker status...
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker is not running. Please start Docker Desktop.
    pause
    exit /b 1
)
echo [SUCCESS] Docker is running
echo.

REM Function to test Python sample
:test_python
echo [INFO] Testing Python Kubernetes Sample...
cd images\python\sample-project\kubernetes

echo [INFO] Starting Python sample services...
docker-compose -f docker-compose-simple.yml up -d

echo [INFO] Waiting for services to be healthy...
timeout /t 30 /nobreak >nul

echo [INFO] Testing Python application endpoints...

REM Test direct Python app
curl -f http://localhost:5000/health >nul 2>&1
if %errorlevel% equ 0 (
    echo [SUCCESS] Python app health check: OK
) else (
    echo [WARNING] Python app health check: FAILED
)

REM Test through Nginx proxy
curl -f http://localhost:8080/health >nul 2>&1
if %errorlevel% equ 0 (
    echo [SUCCESS] Nginx proxy health check: OK
) else (
    echo [WARNING] Nginx proxy health check: FAILED
)

echo [SUCCESS] Python sample test completed!
echo [INFO] Access URLs:
echo   - Dashboard: http://localhost:8080
echo   - Python App: http://localhost:5000
echo.
cd ..\..\..\..
goto :eof

REM Function to test Nginx sample
:test_nginx
echo [INFO] Testing Nginx Kubernetes Sample...
cd images\nginx\sample-project\kubernetes

echo [INFO] Starting Nginx sample services...
docker-compose -f docker-compose-simple.yml up -d

echo [INFO] Waiting for services to be healthy...
timeout /t 30 /nobreak >nul

echo [INFO] Testing Nginx application endpoints...

REM Test main Nginx app
curl -f http://localhost:8080/health >nul 2>&1
if %errorlevel% equ 0 (
    echo [SUCCESS] Nginx app health check: OK
) else (
    echo [WARNING] Nginx app health check: FAILED
)

REM Test load balancer
curl -f http://localhost:8081/health >nul 2>&1
if %errorlevel% equ 0 (
    echo [SUCCESS] Nginx LB health check: OK
) else (
    echo [WARNING] Nginx LB health check: FAILED
)

echo [SUCCESS] Nginx sample test completed!
echo [INFO] Access URLs:
echo   - Nginx App: http://localhost:8080
echo   - Load Balancer: http://localhost:8081
echo   - LB Status: http://localhost:8081/backend-status
echo.
cd ..\..\..\..
goto :eof

REM Function to show running services
:show_status
echo [INFO] Current running services:
docker-compose ps
goto :eof

REM Function to stop services
:stop_services
echo [INFO] Stopping services...
docker-compose down
echo [SUCCESS] Services stopped
goto :eof

REM Function to clean up
:cleanup
echo [INFO] Cleaning up...
docker-compose down -v
docker system prune -f
echo [SUCCESS] Cleanup completed
goto :eof

REM Main script logic
if "%1"=="python" goto test_python
if "%1"=="nginx" goto test_nginx
if "%1"=="all" (
    call :test_python
    echo.
    call :test_nginx
    goto :eof
)
if "%1"=="status" goto show_status
if "%1"=="stop" goto stop_services
if "%1"=="cleanup" goto cleanup
if "%1"=="help" goto show_help
if "%1"=="" goto show_help

echo [ERROR] Unknown command: %1
echo Use 'test-local-samples.bat help' for available commands
exit /b 1

:show_help
echo Usage: test-local-samples.bat [command]
echo.
echo Commands:
echo   python     Test Python Kubernetes sample
echo   nginx      Test Nginx Kubernetes sample
echo   all        Test both samples
echo   status     Show running services
echo   stop       Stop all services
echo   cleanup    Stop services and clean up volumes
echo   help       Show this help message
echo.
echo Examples:
echo   test-local-samples.bat python    # Test Python sample
echo   test-local-samples.bat nginx     # Test Nginx sample
echo   test-local-samples.bat all       # Test both samples
echo.
pause
