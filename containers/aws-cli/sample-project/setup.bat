@echo off
REM AWS CLI Sample Projects Setup Script
REM For Windows

setlocal enabledelayedexpansion

REM Function to print colored output
:print_status
echo [INFO] %~1
goto :eof

:print_warning
echo [WARNING] %~1
goto :eof

:print_error
echo [ERROR] %~1
goto :eof

:print_header
echo %~1
goto :eof

REM Function to check if command exists
:command_exists
where %~1 >nul 2>&1
if %errorlevel% equ 0 (
    set "command_found=1"
) else (
    set "command_found=0"
)
goto :eof

REM Function to check Docker installation
:check_docker
call :print_status "Checking Docker installation..."
call :command_exists docker
if "%command_found%"=="0" (
    call :print_error "Docker is not installed. Please install Docker first."
    exit /b 1
)

docker info >nul 2>&1
if %errorlevel% neq 0 (
    call :print_error "Docker is not running. Please start Docker first."
    exit /b 1
)

call :print_status "Docker is installed and running."
goto :eof

REM Function to check Docker Compose installation
:check_docker_compose
call :print_status "Checking Docker Compose installation..."
call :command_exists docker-compose
if "%command_found%"=="0" (
    call :print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit /b 1
)

call :print_status "Docker Compose is installed."
goto :eof

REM Function to pull AWS CLI image
:pull_image
call :print_status "Pulling AWS CLI image from Docker Hub..."
docker pull cleanstart/aws-cli:latest
if %errorlevel% equ 0 (
    call :print_status "AWS CLI image pulled successfully."
) else (
    call :print_warning "Failed to pull AWS CLI image. Will use local image if available."
)
goto :eof

REM Function to show menu
:show_menu
echo.
call :print_header "AWS CLI Sample Projects Setup"
echo ==================================
echo 1. Basic AWS Operations
echo 2. S3 File Management
echo 3. EC2 Instance Management
echo 4. Stop All Projects
echo 5. Cleanup
echo 6. Exit
echo.
set /p choice="Choose an option (1-6): "
goto :eof

REM Function to run basic AWS operations
:run_basic_aws_operations
call :print_status "Starting Basic AWS Operations..."
cd basic-aws-operations

docker-compose up -d
if %errorlevel% equ 0 (
    call :print_status "Basic AWS Operations started successfully!"
    echo.
    call :print_status "Container logs:"
    docker logs aws-cli-basic
    echo.
    call :print_status "Available commands:"
    echo   docker exec aws-cli-basic aws --version
    echo   docker exec aws-cli-basic aws s3 ls
    echo   docker exec aws-cli-basic aws ec2 describe-regions
) else (
    call :print_error "Failed to start Basic AWS Operations."
)

cd ..
goto :eof

REM Function to run S3 file management
:run_s3_file_management
call :print_status "Starting S3 File Management..."
cd s3-file-management

docker-compose up -d
if %errorlevel% equ 0 (
    call :print_status "S3 File Management started successfully!"
    echo.
    call :print_status "Container logs:"
    docker logs aws-s3-management
    echo.
    call :print_status "Available commands:"
    echo   docker exec aws-s3-management aws s3 ls
    echo   docker exec aws-s3-management aws s3 mb s3://my-bucket
    echo   docker exec aws-s3-management aws s3 cp file.txt s3://my-bucket/
) else (
    call :print_error "Failed to start S3 File Management."
)

cd ..
goto :eof

REM Function to run EC2 instance management
:run_ec2_instance_management
call :print_status "Starting EC2 Instance Management..."
cd ec2-instance-management

docker-compose up -d
if %errorlevel% equ 0 (
    call :print_status "EC2 Instance Management started successfully!"
    echo.
    call :print_status "Container logs:"
    docker logs aws-ec2-management
    echo.
    call :print_status "Available commands:"
    echo   docker exec aws-ec2-management aws ec2 describe-instances
    echo   docker exec aws-ec2-management aws ec2 describe-regions
    echo   docker exec aws-ec2-management aws ec2 run-instances --help
) else (
    call :print_error "Failed to start EC2 Instance Management."
)

cd ..
goto :eof

REM Function to stop all projects
:stop_all_projects
call :print_status "Stopping all AWS CLI projects..."

REM Stop basic operations
if exist "basic-aws-operations" (
    cd basic-aws-operations
    docker-compose down >nul 2>&1
    cd ..
)

REM Stop S3 management
if exist "s3-file-management" (
    cd s3-file-management
    docker-compose down >nul 2>&1
    cd ..
)

REM Stop EC2 management
if exist "ec2-instance-management" (
    cd ec2-instance-management
    docker-compose down >nul 2>&1
    cd ..
)

call :print_status "All projects stopped."
goto :eof

REM Function to cleanup
:cleanup
call :print_status "Cleaning up AWS CLI containers and networks..."

REM Stop and remove containers
docker-compose -f basic-aws-operations/docker-compose.yml down --volumes --remove-orphans >nul 2>&1
docker-compose -f s3-file-management/docker-compose.yml down --volumes --remove-orphans >nul 2>&1
docker-compose -f ec2-instance-management/docker-compose.yml down --volumes --remove-orphans >nul 2>&1

REM Remove AWS CLI containers
docker rm -f aws-cli-basic aws-s3-management aws-ec2-management aws-cli-helper s3-uploader s3-downloader ec2-launcher ec2-monitor >nul 2>&1

REM Remove AWS CLI networks
docker network rm aws-network s3-network ec2-network >nul 2>&1

call :print_status "Cleanup completed."
goto :eof

REM Main script
:main
echo 🚀 AWS CLI Sample Projects Setup
echo ================================

REM Check prerequisites
call :check_docker
call :check_docker_compose
call :pull_image

REM Main loop
:menu_loop
call :show_menu

if "%choice%"=="1" (
    call :run_basic_aws_operations
) else if "%choice%"=="2" (
    call :run_s3_file_management
) else if "%choice%"=="3" (
    call :run_ec2_instance_management
) else if "%choice%"=="4" (
    call :stop_all_projects
) else if "%choice%"=="5" (
    call :cleanup
) else if "%choice%"=="6" (
    call :print_status "Goodbye!"
    exit /b 0
) else (
    call :print_error "Invalid option. Please choose 1-6."
)

echo.
pause
goto menu_loop

REM Run main function
call :main
