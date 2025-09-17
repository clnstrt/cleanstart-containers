#!/bin/bash

# ArgoCD Extension Installer Sample Projects Setup Script
# For Linux and macOS users

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check Docker installation
check_docker() {
    print_status "Checking Docker installation..."
    
    if ! command_exists docker; then
        print_error "Docker is not installed. Please install Docker first."
        print_status "Visit: https://www.docker.com/products/docker-desktop"
        exit 1
    fi
    
    if ! docker info >/dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker Desktop."
        exit 1
    fi
    
    print_success "Docker is installed and running"
}

# Function to check Docker Compose installation
check_docker_compose() {
    print_status "Checking Docker Compose installation..."
    
    if ! command_exists docker-compose; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    print_success "Docker Compose is installed"
}

# Function to pull ArgoCD Extension Installer image
pull_image() {
    print_status "Pulling ArgoCD Extension Installer image..."
    
    if docker pull cleanstart/argocd-extension-installer:latest; then
        print_success "ArgoCD Extension Installer image pulled successfully"
    else
        print_warning "Failed to pull image from Docker Hub. Will build locally if needed."
    fi
}

# Function to show menu
show_menu() {
    echo
    echo "=========================================="
    echo "  ArgoCD Extension Installer Sample Projects"
    echo "=========================================="
    echo
    echo "Available projects:"
    echo "1. Basic Extensions (Recommended for beginners)"
    echo "2. Advanced Extensions (Complex configurations)"
    echo "3. Custom Extensions (Development environment)"
    echo "4. Stop all projects"
    echo "5. Clean up everything"
    echo "6. Exit"
    echo
    read -p "Choose an option (1-6): " choice
}

# Function to run basic extensions
run_basic_extensions() {
    print_status "Starting Basic Extensions project..."
    
    cd basic-extensions
    
    if docker-compose up -d; then
        print_success "Basic Extensions project started successfully!"
        echo
        echo "Access the web interface at: http://localhost:8080"
        echo "Extension Dashboard: http://localhost:8080/dashboard"
        echo
        echo "To stop this project, run: docker-compose down"
    else
        print_error "Failed to start Basic Extensions project"
        exit 1
    fi
}

# Function to run advanced extensions
run_advanced_extensions() {
    print_status "Starting Advanced Extensions project..."
    
    cd advanced-extensions
    
    if docker-compose up -d; then
        print_success "Advanced Extensions project started successfully!"
        echo
        echo "Access the web interface at: http://localhost:8080"
        echo "Advanced Dashboard: http://localhost:8080/advanced"
        echo
        echo "To stop this project, run: docker-compose down"
    else
        print_error "Failed to start Advanced Extensions project"
        exit 1
    fi
}

# Function to run custom extensions
run_custom_extensions() {
    print_status "Starting Custom Extensions project..."
    
    cd custom-extensions
    
    if docker-compose up -d; then
        print_success "Custom Extensions project started successfully!"
        echo
        echo "Access the development interface at: http://localhost:8080"
        echo "Extension Builder: http://localhost:8080/builder"
        echo
        echo "To stop this project, run: docker-compose down"
    else
        print_error "Failed to start Custom Extensions project"
        exit 1
    fi
}

# Function to stop all projects
stop_all_projects() {
    print_status "Stopping all ArgoCD Extension Installer projects..."
    
    for project in basic-extensions advanced-extensions custom-extensions; do
        if [ -d "$project" ]; then
            cd "$project"
            if [ -f "docker-compose.yml" ]; then
                print_status "Stopping $project..."
                docker-compose down
                print_success "$project stopped"
            fi
            cd ..
        fi
    done
    
    print_success "All projects stopped"
}

# Function to clean up everything
cleanup() {
    print_status "Cleaning up all ArgoCD Extension Installer resources..."
    
    # Stop all projects
    stop_all_projects
    
    # Remove containers
    print_status "Removing containers..."
    docker ps -a --filter "name=argocd" --format "{{.ID}}" | xargs -r docker rm -f
    
    # Remove networks
    print_status "Removing networks..."
    docker network ls --filter "name=argocd" --format "{{.ID}}" | xargs -r docker network rm
    
    # Remove volumes
    print_status "Removing volumes..."
    docker volume ls --filter "name=argocd" --format "{{.Name}}" | xargs -r docker volume rm
    
    print_success "Cleanup completed"
}

# Main script
main() {
    echo "🚀 ArgoCD Extension Installer Sample Projects Setup"
    echo "=================================================="
    
    # Check prerequisites
    check_docker
    check_docker_compose
    pull_image
    
    # Main loop
    while true; do
        show_menu
        
        case $choice in
            1)
                run_basic_extensions
                ;;
            2)
                run_advanced_extensions
                ;;
            3)
                run_custom_extensions
                ;;
            4)
                stop_all_projects
                ;;
            5)
                cleanup
                ;;
            6)
                print_status "Goodbye!"
                exit 0
                ;;
            *)
                print_error "Invalid option. Please choose 1-6."
                ;;
        esac
        
        echo
        read -p "Press Enter to continue..."
    done
}

# Run main function
main "$@"
