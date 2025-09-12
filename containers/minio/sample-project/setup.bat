@echo off
setlocal enabledelayedexpansion

REM MinIO Sample Projects Setup Script
REM For Windows users

title MinIO Sample Projects Setup

REM Colors for output (Windows 10+)
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "NC=[0m"

REM Function to print colored output
:print_status
echo %GREEN%[INFO]%NC% %~1
goto :eof

:print_warning
echo %YELLOW%[WARNING]%NC% %~1
goto :eof

:print_error
echo %RED%[ERROR]%NC% %~1
goto :eof

:print_header
echo %BLUE%================================%NC%
echo %BLUE%~1%NC%
echo %BLUE%================================%NC%
goto :eof

REM Function to check if Docker is installed and running
:check_docker
call :print_status "Checking Docker installation..."
docker --version >nul 2>&1
if errorlevel 1 (
    call :print_error "Docker is not installed. Please install Docker Desktop first."
    echo Visit: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

docker info >nul 2>&1
if errorlevel 1 (
    call :print_error "Docker is not running. Please start Docker Desktop."
    pause
    exit /b 1
)

call :print_status "Docker is installed and running ✓"
goto :eof

REM Function to check if Docker Compose is available
:check_docker_compose
call :print_status "Checking Docker Compose..."

docker-compose --version >nul 2>&1
if errorlevel 1 (
    call :print_warning "Docker Compose not found. Trying 'docker compose'..."
    docker compose version >nul 2>&1
    if errorlevel 1 (
        call :print_error "Docker Compose is not available. Please install Docker Compose."
        pause
        exit /b 1
    ) else (
        set "DOCKER_COMPOSE=docker compose"
    )
) else (
    set "DOCKER_COMPOSE=docker-compose"
)

call :print_status "Docker Compose is available ✓"
goto :eof

REM Function to pull MinIO image
:pull_minio_image
call :print_status "Pulling MinIO image from Docker Hub..."
docker pull cleanstart/minio:latest
call :print_status "MinIO image pulled successfully ✓"
goto :eof

REM Function to run basic storage example
:run_basic_storage
call :print_header "Running Basic Storage Example"

cd basic-storage
call :print_status "Starting MinIO basic storage..."
%DOCKER_COMPOSE% up -d

call :print_status "Waiting for MinIO to start..."
timeout /t 10 /nobreak >nul

call :print_status "Basic storage is running!"
echo %GREEN%Access MinIO Console:%NC% http://localhost:9001
echo %GREEN%Login:%NC% minioadmin / minioadmin123
echo.
pause
goto :eof

REM Function to run file upload app example
:run_file_upload_app
call :print_header "Running File Upload App Example"

cd file-upload-app
call :print_status "Starting file upload application..."
%DOCKER_COMPOSE% up -d

call :print_status "Waiting for services to start..."
timeout /t 15 /nobreak >nul

call :print_status "File upload app is running!"
echo %GREEN%Access Web App:%NC% http://localhost:8080
echo %GREEN%Access MinIO Console:%NC% http://localhost:9001
echo %GREEN%Login:%NC% minioadmin / minioadmin123
echo.
pause
goto :eof

REM Function to run backup system example
:run_backup_system
call :print_header "Running Backup System Example"

cd backup-system
call :print_status "Starting backup system..."
%DOCKER_COMPOSE% up -d

call :print_status "Waiting for services to start..."
timeout /t 15 /nobreak >nul

call :print_status "Backup system is running!"
echo %GREEN%Access Backup App:%NC% http://localhost:8080
echo %GREEN%Access MinIO Console:%NC% http://localhost:9001
echo %GREEN%Login:%NC% minioadmin / minioadmin123
echo.
pause
goto :eof

REM Function to stop all containers
:stop_all_containers
call :print_header "Stopping All Containers"

call :print_status "Stopping containers in all projects..."

if exist "basic-storage" (
    cd basic-storage
    if exist "docker-compose.yml" (
        call :print_status "Stopping basic-storage..."
        %DOCKER_COMPOSE% down
    )
    cd ..
)

if exist "file-upload-app" (
    cd file-upload-app
    if exist "docker-compose.yml" (
        call :print_status "Stopping file-upload-app..."
        %DOCKER_COMPOSE% down
    )
    cd ..
)

if exist "backup-system" (
    cd backup-system
    if exist "docker-compose.yml" (
        call :print_status "Stopping backup-system..."
        %DOCKER_COMPOSE% down
    )
    cd ..
)

call :print_status "All containers stopped ✓"
echo.
pause
goto :eof

REM Function to clean up everything
:cleanup
call :print_header "Cleaning Up Everything"

call :print_warning "This will remove all containers, networks, and volumes!"
set /p response="Are you sure? (y/N): "

if /i "%response%"=="y" (
    call :print_status "Removing all containers, networks, and volumes..."
    
    if exist "basic-storage" (
        cd basic-storage
        if exist "docker-compose.yml" (
            call :print_status "Cleaning up basic-storage..."
            %DOCKER_COMPOSE% down --volumes --remove-orphans
        )
        cd ..
    )
    
    if exist "file-upload-app" (
        cd file-upload-app
        if exist "docker-compose.yml" (
            call :print_status "Cleaning up file-upload-app..."
            %DOCKER_COMPOSE% down --volumes --remove-orphans
        )
        cd ..
    )
    
    if exist "backup-system" (
        cd backup-system
        if exist "docker-compose.yml" (
            call :print_status "Cleaning up backup-system..."
            %DOCKER_COMPOSE% down --volumes --remove-orphans
        )
        cd ..
    )
    
    call :print_status "Cleanup completed ✓"
) else (
    call :print_status "Cleanup cancelled."
)

echo.
pause
goto :eof

REM Function to show status
:show_status
call :print_header "Container Status"

call :print_status "Running containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
call :print_status "Available services:"
echo %GREEN%Basic Storage:%NC% http://localhost:9001 (if running)
echo %GREEN%File Upload App:%NC% http://localhost:8080 (if running)
echo %GREEN%Backup System:%NC% http://localhost:8080 (if running)

echo.
pause
goto :eof

REM Function to show main menu
:show_menu
cls
call :print_header "MinIO Sample Projects Setup"
echo.
echo Choose an option:
echo 1) Run Basic Storage Example
echo 2) Run File Upload App Example
echo 3) Run Backup System Example
echo 4) Stop All Containers
echo 5) Show Container Status
echo 6) Clean Up Everything
echo 7) Exit
echo.
set /p choice="Enter your choice (1-7): "
goto :eof

REM Main script
:main
call :print_header "MinIO Sample Projects Setup Script"
echo This script helps you run MinIO sample projects easily.
echo.

REM Check prerequisites
call :check_docker
call :check_docker_compose
call :pull_minio_image

REM Main menu loop
:menu_loop
call :show_menu

if "%choice%"=="1" (
    call :run_basic_storage
    goto menu_loop
)
if "%choice%"=="2" (
    call :run_file_upload_app
    goto menu_loop
)
if "%choice%"=="3" (
    call :run_backup_system
    goto menu_loop
)
if "%choice%"=="4" (
    call :stop_all_containers
    goto menu_loop
)
if "%choice%"=="5" (
    call :show_status
    goto menu_loop
)
if "%choice%"=="6" (
    call :cleanup
    goto menu_loop
)
if "%choice%"=="7" (
    call :print_status "Goodbye!"
    exit /b 0
)

call :print_error "Invalid choice. Please enter a number between 1-7."
pause
goto menu_loop

REM Run main function
call :main
