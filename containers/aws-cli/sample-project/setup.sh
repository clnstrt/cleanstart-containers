#!/bin/bash

# AWS CLI Sample Projects Setup Script
# For Linux and macOS

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
    echo -e "${BLUE}$1${NC}"
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
        exit 1
    fi
    
    if ! docker info >/dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker first."
        exit 1
    fi
    
    print_status "Docker is installed and running."
}

# Function to check Docker Compose installation
check_docker_compose() {
    print_status "Checking Docker Compose installation..."
    if ! command_exists docker-compose; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    print_status "Docker Compose is installed."
}

# Function to pull AWS CLI image
pull_image() {
    print_status "Pulling AWS CLI image from Docker Hub..."
    if docker pull cleanstart/aws-cli:latest; then
        print_status "AWS CLI image pulled successfully."
    else
        print_warning "Failed to pull AWS CLI image. Will use local image if available."
    fi
}

# Function to show menu
show_menu() {
    echo
    print_header "AWS CLI Sample Projects Setup"
    echo "=================================="
    echo "1. Basic AWS Operations"
    echo "2. S3 File Management"
    echo "3. EC2 Instance Management"
    echo "4. Stop All Projects"
    echo "5. Cleanup"
    echo "6. Exit"
    echo
    read -p "Choose an option (1-6): " choice
}

# Function to run basic AWS operations
run_basic_aws_operations() {
    print_status "Starting Basic AWS Operations..."
    cd basic-aws-operations
    
    if docker-compose up -d; then
        print_status "Basic AWS Operations started successfully!"
        echo
        print_status "Container logs:"
        docker logs aws-cli-basic
        echo
        print_status "Available commands:"
        echo "  docker exec aws-cli-basic aws --version"
        echo "  docker exec aws-cli-basic aws s3 ls"
        echo "  docker exec aws-cli-basic aws ec2 describe-regions"
    else
        print_error "Failed to start Basic AWS Operations."
    fi
    
    cd ..
}

# Function to run S3 file management
run_s3_file_management() {
    print_status "Starting S3 File Management..."
    cd s3-file-management
    
    if docker-compose up -d; then
        print_status "S3 File Management started successfully!"
        echo
        print_status "Container logs:"
        docker logs aws-s3-management
        echo
        print_status "Available commands:"
        echo "  docker exec aws-s3-management aws s3 ls"
        echo "  docker exec aws-s3-management aws s3 mb s3://my-bucket"
        echo "  docker exec aws-s3-management aws s3 cp file.txt s3://my-bucket/"
    else
        print_error "Failed to start S3 File Management."
    fi
    
    cd ..
}

# Function to run EC2 instance management
run_ec2_instance_management() {
    print_status "Starting EC2 Instance Management..."
    cd ec2-instance-management
    
    if docker-compose up -d; then
        print_status "EC2 Instance Management started successfully!"
        echo
        print_status "Container logs:"
        docker logs aws-ec2-management
        echo
        print_status "Available commands:"
        echo "  docker exec aws-ec2-management aws ec2 describe-instances"
        echo "  docker exec aws-ec2-management aws ec2 describe-regions"
        echo "  docker exec aws-ec2-management aws ec2 run-instances --help"
    else
        print_error "Failed to start EC2 Instance Management."
    fi
    
    cd ..
}

# Function to stop all projects
stop_all_projects() {
    print_status "Stopping all AWS CLI projects..."
    
    # Stop basic operations
    if [ -d "basic-aws-operations" ]; then
        cd basic-aws-operations
        docker-compose down 2>/dev/null || true
        cd ..
    fi
    
    # Stop S3 management
    if [ -d "s3-file-management" ]; then
        cd s3-file-management
        docker-compose down 2>/dev/null || true
        cd ..
    fi
    
    # Stop EC2 management
    if [ -d "ec2-instance-management" ]; then
        cd ec2-instance-management
        docker-compose down 2>/dev/null || true
        cd ..
    fi
    
    print_status "All projects stopped."
}

# Function to cleanup
cleanup() {
    print_status "Cleaning up AWS CLI containers and networks..."
    
    # Stop and remove containers
    docker-compose -f basic-aws-operations/docker-compose.yml down --volumes --remove-orphans 2>/dev/null || true
    docker-compose -f s3-file-management/docker-compose.yml down --volumes --remove-orphans 2>/dev/null || true
    docker-compose -f ec2-instance-management/docker-compose.yml down --volumes --remove-orphans 2>/dev/null || true
    
    # Remove AWS CLI containers
    docker rm -f aws-cli-basic aws-s3-management aws-ec2-management aws-cli-helper s3-uploader s3-downloader ec2-launcher ec2-monitor 2>/dev/null || true
    
    # Remove AWS CLI networks
    docker network rm aws-network s3-network ec2-network 2>/dev/null || true
    
    print_status "Cleanup completed."
}

# Main script
main() {
    echo "🚀 AWS CLI Sample Projects Setup"
    echo "================================"

    # Check prerequisites
    check_docker
    check_docker_compose
    pull_image

    # Main loop
    while true; do
        show_menu

        case $choice in
            1)
                run_basic_aws_operations
                ;;
            2)
                run_s3_file_management
                ;;
            3)
                run_ec2_instance_management
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
main
