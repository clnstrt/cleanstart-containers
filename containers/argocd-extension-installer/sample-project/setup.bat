@echo off
setlocal enabledelayedexpansion

REM ArgoCD Extension Installer Sample Projects Setup Script
REM For Windows users

echo 🚀 ArgoCD Extension Installer Sample Projects Setup
echo ==================================================

REM Function to check if command exists
:check_command
set "command=%~1"
where %command% >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] %command% is not installed or not in PATH
    exit /b 1
) else (
    echo [SUCCESS] %command% is available
    exit /b 0
)

REM Function to check Docker installation
:check_docker
echo [INFO] Checking Docker installation...
call :check_command docker
if %errorlevel% neq 0 (
    echo [ERROR] Docker is not installed. Please install Docker first.
    echo [INFO] Visit: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker is not running. Please start Docker Desktop.
    pause
    exit /b 1
)

echo [SUCCESS] Docker is installed and running
goto :eof

REM Function to check Docker Compose installation
:check_docker_compose
echo [INFO] Checking Docker Compose installation...
call :check_command docker-compose
if %errorlevel% neq 0 (
    echo [ERROR] Docker Compose is not installed. Please install Docker Compose first.
    pause
    exit /b 1
)

echo [SUCCESS] Docker Compose is installed
goto :eof

REM Function to pull ArgoCD Extension Installer image
:pull_image
echo [INFO] Pulling ArgoCD Extension Installer image...
docker pull cleanstart/argocd-extension-installer:latest
if %errorlevel% equ 0 (
    echo [SUCCESS] ArgoCD Extension Installer image pulled successfully
) else (
    echo [WARNING] Failed to pull image from Docker Hub. Will build locally if needed.
)
goto :eof

REM Function to show menu
:show_menu
echo.
echo ==========================================
echo   ArgoCD Extension Installer Sample Projects
echo ==========================================
echo.
echo Available projects:
echo 1. Basic Extensions (Recommended for beginners)
echo 2. Advanced Extensions (Complex configurations)
echo 3. Custom Extensions (Development environment)
echo 4. Stop all projects
echo 5. Clean up everything
echo 6. Exit
echo.
set /p choice="Choose an option (1-6): "
goto :eof

REM Function to run basic extensions
:run_basic_extensions
echo [INFO] Starting Basic Extensions project...
cd basic-extensions

docker-compose up -d
if %errorlevel% equ 0 (
    echo [SUCCESS] Basic Extensions project started successfully!
    echo.
    echo Access the web interface at: http://localhost:8080
    echo Extension Dashboard: http://localhost:8080/dashboard
    echo.
    echo To stop this project, run: docker-compose down
) else (
    echo [ERROR] Failed to start Basic Extensions project
    pause
    exit /b 1
)

cd ..
goto :eof

REM Function to run advanced extensions
:run_advanced_extensions
echo [INFO] Starting Advanced Extensions project...
cd advanced-extensions

docker-compose up -d
if %errorlevel% equ 0 (
    echo [SUCCESS] Advanced Extensions project started successfully!
    echo.
    echo Access the web interface at: http://localhost:8080
    echo Advanced Dashboard: http://localhost:8080/advanced
    echo.
    echo To stop this project, run: docker-compose down
) else (
    echo [ERROR] Failed to start Advanced Extensions project
    pause
    exit /b 1
)

cd ..
goto :eof

REM Function to run custom extensions
:run_custom_extensions
echo [INFO] Starting Custom Extensions project...
cd custom-extensions

docker-compose up -d
if %errorlevel% equ 0 (
    echo [SUCCESS] Custom Extensions project started successfully!
    echo.
    echo Access the development interface at: http://localhost:8080
    echo Extension Builder: http://localhost:8080/builder
    echo.
    echo To stop this project, run: docker-compose down
) else (
    echo [ERROR] Failed to start Custom Extensions project
    pause
    exit /b 1
)

cd ..
goto :eof

REM Function to stop all projects
:stop_all_projects
echo [INFO] Stopping all ArgoCD Extension Installer projects...

if exist "basic-extensions\docker-compose.yml" (
    echo [INFO] Stopping basic-extensions...
    cd basic-extensions
    docker-compose down
    echo [SUCCESS] basic-extensions stopped
    cd ..
)

if exist "advanced-extensions\docker-compose.yml" (
    echo [INFO] Stopping advanced-extensions...
    cd advanced-extensions
    docker-compose down
    echo [SUCCESS] advanced-extensions stopped
    cd ..
)

if exist "custom-extensions\docker-compose.yml" (
    echo [INFO] Stopping custom-extensions...
    cd custom-extensions
    docker-compose down
    echo [SUCCESS] custom-extensions stopped
    cd ..
)

echo [SUCCESS] All projects stopped
goto :eof

REM Function to clean up everything
:cleanup
echo [INFO] Cleaning up all ArgoCD Extension Installer resources...

REM Stop all projects
call :stop_all_projects

REM Remove containers
echo [INFO] Removing containers...
for /f "tokens=*" %%i in ('docker ps -a --filter "name=argocd" --format "{{.ID}}" 2^>nul') do (
    docker rm -f %%i
)

REM Remove networks
echo [INFO] Removing networks...
for /f "tokens=*" %%i in ('docker network ls --filter "name=argocd" --format "{{.ID}}" 2^>nul') do (
    docker network rm %%i
)

REM Remove volumes
echo [INFO] Removing volumes...
for /f "tokens=*" %%i in ('docker volume ls --filter "name=argocd" --format "{{.Name}}" 2^>nul') do (
    docker volume rm %%i
)

echo [SUCCESS] Cleanup completed
goto :eof

REM Main script
:main
REM Check prerequisites
call :check_docker
call :check_docker_compose
call :pull_image

REM Main loop
:menu_loop
call :show_menu

if "%choice%"=="1" (
    call :run_basic_extensions
) else if "%choice%"=="2" (
    call :run_advanced_extensions
) else if "%choice%"=="3" (
    call :run_custom_extensions
) else if "%choice%"=="4" (
    call :stop_all_projects
) else if "%choice%"=="5" (
    call :cleanup
) else if "%choice%"=="6" (
    echo [INFO] Goodbye!
    exit /b 0
) else (
    echo [ERROR] Invalid option. Please choose 1-6.
)

echo.
pause
goto menu_loop

REM Run main function
call :main
