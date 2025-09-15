@echo off
REM Nginx Sample Projects Setup Script for Windows
REM This script helps you run the different nginx examples

setlocal enabledelayedexpansion

REM Colors for output (Windows doesn't support ANSI colors, so we'll use simple text)
set "INFO=[INFO]"
set "SUCCESS=[SUCCESS]"
set "WARNING=[WARNING]"
set "ERROR=[ERROR]"

REM Function to print status
:print_status
echo %INFO% %~1
goto :eof

REM Function to print success
:print_success
echo %SUCCESS% %~1
goto :eof

REM Function to print warning
:print_warning
echo %WARNING% %~1
goto :eof

REM Function to print error
:print_error
echo %ERROR% %~1
goto :eof

REM Function to check if Docker is installed
:check_docker
docker --version >nul 2>&1
if errorlevel 1 (
    call :print_error "Docker is not installed. Please install Docker Desktop first."
    exit /b 1
)

docker-compose --version >nul 2>&1
if errorlevel 1 (
    call :print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit /b 1
)

call :print_success "Docker and Docker Compose are installed"
goto :eof

REM Function to check if Docker daemon is running
:check_docker_daemon
docker info >nul 2>&1
if errorlevel 1 (
    call :print_error "Docker daemon is not running. Please start Docker Desktop first."
    exit /b 1
)

call :print_success "Docker daemon is running"
goto :eof

REM Function to show usage
:show_usage
echo Usage: %0 [OPTION]
echo.
echo Options:
echo   static-site     Run the static site example
echo   reverse-proxy   Run the reverse proxy example
echo   load-balancer   Run the load balancer example
echo   all             Run all examples ^(on different ports^)
echo   stop            Stop all running containers
echo   clean           Stop and remove all containers and images
echo   help            Show this help message
echo.
echo Examples:
echo   %0 static-site
echo   %0 reverse-proxy
echo   %0 load-balancer
echo   %0 stop
goto :eof

REM Function to run static site
:run_static_site
call :print_status "Starting static site example..."
cd static-site

call :print_status "Building Docker image..."
docker build -t nginx-static-site .

call :print_status "Running container..."
docker run -d --name nginx-static -p 8080:80 nginx-static-site

call :print_success "Static site is running at http://localhost:8080"
call :print_status "To stop: docker stop nginx-static ^&^& docker rm nginx-static"
goto :eof

REM Function to run reverse proxy
:run_reverse_proxy
call :print_status "Starting reverse proxy example..."
cd reverse-proxy

call :print_status "Building and starting services..."
docker-compose up -d --build

call :print_success "Reverse proxy is running at http://localhost"
call :print_success "Backend API is available at http://localhost/api"
call :print_status "To stop: cd reverse-proxy ^&^& docker-compose down"
goto :eof

REM Function to run load balancer
:run_load_balancer
call :print_status "Starting load balancer example..."
cd load-balancer

call :print_status "Building and starting services..."
docker-compose up -d --build

call :print_success "Load balancer is running at http://localhost"
call :print_success "Backend APIs are load balanced across 3 servers"
call :print_status "To stop: cd load-balancer ^&^& docker-compose down"
goto :eof

REM Function to run all examples
:run_all
call :print_status "Starting all examples on different ports..."

REM Static site on port 8080
call :print_status "Starting static site on port 8080..."
cd static-site
docker build -t nginx-static-site . >nul 2>&1
docker run -d --name nginx-static -p 8080:80 nginx-static-site >nul 2>&1

REM Reverse proxy on port 8081
call :print_status "Starting reverse proxy on port 8081..."
cd ..\reverse-proxy
powershell -Command "(Get-Content docker-compose.yml) -replace '- \"80:80\"', '- \"8081:80\"' | Set-Content docker-compose.yml"
docker-compose up -d --build >nul 2>&1

REM Load balancer on port 8082
call :print_status "Starting load balancer on port 8082..."
cd ..\load-balancer
powershell -Command "(Get-Content docker-compose.yml) -replace '- \"80:80\"', '- \"8082:80\"' | Set-Content docker-compose.yml"
docker-compose up -d --build >nul 2>&1

call :print_success "All examples are running:"
call :print_success "  Static site: http://localhost:8080"
call :print_success "  Reverse proxy: http://localhost:8081"
call :print_success "  Load balancer: http://localhost:8082"
goto :eof

REM Function to stop all containers
:stop_all
call :print_status "Stopping all nginx sample containers..."

REM Stop static site
docker stop nginx-static >nul 2>&1
docker rm nginx-static >nul 2>&1

REM Stop reverse proxy
cd reverse-proxy >nul 2>&1 && docker-compose down >nul 2>&1

REM Stop load balancer
cd ..\load-balancer >nul 2>&1 && docker-compose down >nul 2>&1

call :print_success "All containers stopped"
goto :eof

REM Function to clean everything
:clean_all
call :print_status "Cleaning all containers and images..."

call :stop_all

REM Remove images
docker rmi nginx-static-site >nul 2>&1
docker rmi nginx-reverse-proxy_nginx >nul 2>&1
docker rmi nginx-reverse-proxy_backend >nul 2>&1
docker rmi nginx-load-balancer_nginx >nul 2>&1
docker rmi nginx-load-balancer_backend1 >nul 2>&1
docker rmi nginx-load-balancer_backend2 >nul 2>&1
docker rmi nginx-load-balancer_backend3 >nul 2>&1

call :print_success "Cleanup completed"
goto :eof

REM Main script
:main
REM Check if we're in the right directory
if not exist "README.md" (
    call :print_error "Please run this script from the nginx sample-project directory"
    exit /b 1
)

REM Check Docker installation
call :check_docker
if errorlevel 1 exit /b 1

call :check_docker_daemon
if errorlevel 1 exit /b 1

REM Parse command line arguments
if "%1"=="" goto :show_usage
if "%1"=="help" goto :show_usage
if "%1"=="static-site" goto :run_static_site
if "%1"=="reverse-proxy" goto :run_reverse_proxy
if "%1"=="load-balancer" goto :run_load_balancer
if "%1"=="all" goto :run_all
if "%1"=="stop" goto :stop_all
if "%1"=="clean" goto :clean_all

REM If we get here, show usage
goto :show_usage
