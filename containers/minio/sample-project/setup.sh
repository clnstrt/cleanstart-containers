#!/bin/bash

# MinIO Sample Projects Setup Script
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
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Function to check if Docker is installed and running
check_docker() {
    print_status "Checking Docker installation..."
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker Desktop first."
        echo "Visit: https://www.docker.com/products/docker-desktop"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        print_error "Docker is not running. Please start Docker Desktop."
        exit 1
    fi
    
    print_status "Docker is installed and running ✓"
}

# Function to check if Docker Compose is available
check_docker_compose() {
    print_status "Checking Docker Compose..."
    
    if ! command -v docker-compose &> /dev/null; then
        print_warning "Docker Compose not found. Trying 'docker compose'..."
        if ! docker compose version &> /dev/null; then
            print_error "Docker Compose is not available. Please install Docker Compose."
            exit 1
        else
            DOCKER_COMPOSE="docker compose"
        fi
    else
        DOCKER_COMPOSE="docker-compose"
    fi
    
    print_status "Docker Compose is available ✓"
}

# Function to pull MinIO image
pull_minio_image() {
    print_status "Pulling MinIO image from Docker Hub..."
    docker pull cleanstart/minio:latest
    print_status "MinIO image pulled successfully ✓"
}

# Function to run basic storage example
run_basic_storage() {
    print_header "Running Basic Storage Example"
    
    cd basic-storage
    print_status "Starting MinIO basic storage..."
    $DOCKER_COMPOSE up -d
    
    print_status "Waiting for MinIO to start..."
    sleep 10
    
    print_status "Basic storage is running!"
    echo -e "${GREEN}Access MinIO Console:${NC} http://localhost:9001"
    echo -e "${GREEN}Login:${NC} minioadmin / minioadmin123"
    echo ""
    echo "Press Enter to continue..."
    read
}

# Function to run file upload app example
run_file_upload_app() {
    print_header "Running File Upload App Example"
    
    cd file-upload-app
    print_status "Starting file upload application..."
    $DOCKER_COMPOSE up -d
    
    print_status "Waiting for services to start..."
    sleep 15
    
    print_status "File upload app is running!"
    echo -e "${GREEN}Access Web App:${NC} http://localhost:8080"
    echo -e "${GREEN}Access MinIO Console:${NC} http://localhost:9001"
    echo -e "${GREEN}Login:${NC} minioadmin / minioadmin123"
    echo ""
    echo "Press Enter to continue..."
    read
}

# Function to run backup system example
run_backup_system() {
    print_header "Running Backup System Example"
    
    cd backup-system
    print_status "Starting backup system..."
    $DOCKER_COMPOSE up -d
    
    print_status "Waiting for services to start..."
    sleep 15
    
    print_status "Backup system is running!"
    echo -e "${GREEN}Access Backup App:${NC} http://localhost:8080"
    echo -e "${GREEN}Access MinIO Console:${NC} http://localhost:9001"
    echo -e "${GREEN}Login:${NC} minioadmin / minioadmin123"
    echo ""
    echo "Press Enter to continue..."
    read
}

# Function to stop all containers
stop_all_containers() {
    print_header "Stopping All Containers"
    
    print_status "Stopping containers in all projects..."
    
    for project in basic-storage file-upload-app backup-system; do
        if [ -d "$project" ]; then
            cd "$project"
            if [ -f "docker-compose.yml" ]; then
                print_status "Stopping $project..."
                $DOCKER_COMPOSE down
            fi
            cd ..
        fi
    done
    
    print_status "All containers stopped ✓"
    echo ""
    echo "Press Enter to continue..."
    read
}

# Function to clean up everything
cleanup() {
    print_header "Cleaning Up Everything"
    
    print_warning "This will remove all containers, networks, and volumes!"
    echo "Are you sure? (y/N): "
    read -r response
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        print_status "Removing all containers, networks, and volumes..."
        
        for project in basic-storage file-upload-app backup-system; do
            if [ -d "$project" ]; then
                cd "$project"
                if [ -f "docker-compose.yml" ]; then
                    print_status "Cleaning up $project..."
                    $DOCKER_COMPOSE down --volumes --remove-orphans
                fi
                cd ..
            fi
        done
        
        print_status "Cleanup completed ✓"
    else
        print_status "Cleanup cancelled."
    fi
    
    echo ""
    echo "Press Enter to continue..."
    read
}

# Function to show status
show_status() {
    print_header "Container Status"
    
    print_status "Running containers:"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    
    echo ""
    print_status "Available services:"
    echo -e "${GREEN}Basic Storage:${NC} http://localhost:9001 (if running)"
    echo -e "${GREEN}File Upload App:${NC} http://localhost:8080 (if running)"
    echo -e "${GREEN}Backup System:${NC} http://localhost:8080 (if running)"
    
    echo ""
    echo "Press Enter to continue..."
    read
}

# Function to show main menu
show_menu() {
    clear
    print_header "MinIO Sample Projects Setup"
    echo ""
    echo "Choose an option:"
    echo "1) Run Basic Storage Example"
    echo "2) Run File Upload App Example"
    echo "3) Run Backup System Example"
    echo "4) Stop All Containers"
    echo "5) Show Container Status"
    echo "6) Clean Up Everything"
    echo "7) Exit"
    echo ""
    echo -n "Enter your choice (1-7): "
}

# Main script
main() {
    print_header "MinIO Sample Projects Setup Script"
    echo "This script helps you run MinIO sample projects easily."
    echo ""
    
    # Check prerequisites
    check_docker
    check_docker_compose
    pull_minio_image
    
    # Main menu loop
    while true; do
        show_menu
        read -r choice
        
        case $choice in
            1)
                run_basic_storage
                ;;
            2)
                run_file_upload_app
                ;;
            3)
                run_backup_system
                ;;
            4)
                stop_all_containers
                ;;
            5)
                show_status
                ;;
            6)
                cleanup
                ;;
            7)
                print_status "Goodbye!"
                exit 0
                ;;
            *)
                print_error "Invalid choice. Please enter a number between 1-7."
                echo "Press Enter to continue..."
                read
                ;;
        esac
    done
}

# Run main function
main "$@"
