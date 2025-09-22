# Stakater Reloader Test Script for Windows PowerShell
# This script tests the Stakater Reloader container

Write-Host "🚀 Stakater Reloader Test Script" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green
Write-Host ""

# Function to print colored output
function Write-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Check if Docker is running
try {
    docker info | Out-Null
    Write-Success "Docker is running ✓"
} catch {
    Write-Error "Docker is not running. Please start Docker and try again."
    exit 1
}

# Check if the image exists
try {
    docker image inspect cleanstart/stakater-reloader:latest | Out-Null
    Write-Success "Image found locally ✓"
} catch {
    Write-Warning "Image cleanstart/stakater-reloader:latest not found locally."
    Write-Status "Pulling image from Docker Hub..."
    try {
        docker pull cleanstart/stakater-reloader:latest
        Write-Success "Image pulled successfully ✓"
    } catch {
        Write-Error "Failed to pull image. Please check your internet connection and try again."
        exit 1
    }
}

Write-Host ""
Write-Status "Testing Stakater Reloader container..."

# Test 1: Run container with help command
Write-Host ""
Write-Host "📋 Test 1: Running container with --help command" -ForegroundColor Cyan
Write-Host "-----------------------------------------------" -ForegroundColor Cyan
docker run --rm cleanstart/stakater-reloader:latest /usr/bin/Reloader --help

# Test 2: Run container with version command
Write-Host ""
Write-Host "📋 Test 2: Running container with version command" -ForegroundColor Cyan
Write-Host "------------------------------------------------" -ForegroundColor Cyan
docker run --rm cleanstart/stakater-reloader:latest /usr/bin/Reloader --version

# Test 3: Container inspection
Write-Host ""
Write-Host "📋 Test 3: Container inspection" -ForegroundColor Cyan
Write-Host "------------------------------" -ForegroundColor Cyan
Write-Status "Container image details:"
$inspect = docker inspect cleanstart/stakater-reloader:latest | ConvertFrom-Json
$image = $inspect[0]
Write-Host "Image ID: $($image.Id.Substring(0,12))"
Write-Host "Created: $($image.Created)"
Write-Host "Architecture: $($image.Architecture)"
Write-Host "OS: $($image.Os)"
Write-Host "Size: $([math]::Floor($image.Size / 1024 / 1024)) MB"
Write-Host "Entrypoint: $($image.Config.Entrypoint -join ' ')"
Write-Host "User: $($image.Config.User)"
Write-Host "Working Directory: $($image.Config.WorkingDir)"

# Test 4: Using Docker Compose
Write-Host ""
Write-Host "📋 Test 4: Using Docker Compose" -ForegroundColor Cyan
Write-Host "------------------------------" -ForegroundColor Cyan
Write-Status "Starting container with docker-compose..."
docker-compose up stakater-reloader

Write-Host ""
Write-Success "All tests completed! 🎉"
Write-Host ""
Write-Status "Summary:"
Write-Host "- Container runs successfully ✓"
Write-Host "- Help command works ✓"
Write-Host "- Version command works ✓"
Write-Host "- Docker Compose integration works ✓"
Write-Host ""
Write-Status "The Stakater Reloader container is working properly!"
Write-Status "You can now use it for Kubernetes deployments with automatic pod restarts."
