#!/bin/bash

# Nginx Sample Projects Setup Script
# This script helps you run the different nginx examples

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

# Function to check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    print_success "Docker and Docker Compose are installed"
}

# Function to check if Docker daemon is running
check_docker_daemon() {
    if ! docker info &> /dev/null; then
        print_error "Docker daemon is not running. Please start Docker first."
        exit 1
    fi
    
    print_success "Docker daemon is running"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  static-site     Run the static site example"
    echo "  reverse-proxy   Run the reverse proxy example"
    echo "  load-balancer   Run the load balancer example"
    echo "  all             Run all examples (on different ports)"
    echo "  stop            Stop all running containers"
    echo "  clean           Stop and remove all containers and images"
    echo "  help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 static-site"
    echo "  $0 reverse-proxy"
    echo "  $0 load-balancer"
    echo "  $0 stop"
}

# Function to run static site
run_static_site() {
    print_status "Starting static site example..."
    cd static-site
    
    print_status "Building Docker image..."
    docker build -t nginx-static-site .
    
    print_status "Running container..."
    docker run -d --name nginx-static -p 8080:80 nginx-static-site
    
    print_success "Static site is running at http://localhost:8080"
    print_status "To stop: docker stop nginx-static && docker rm nginx-static"
}

# Function to run reverse proxy
run_reverse_proxy() {
    print_status "Starting reverse proxy example..."
    cd reverse-proxy
    
    print_status "Building and starting services..."
    docker-compose up -d --build
    
    print_success "Reverse proxy is running at http://localhost"
    print_success "Backend API is available at http://localhost/api"
    print_status "To stop: cd reverse-proxy && docker-compose down"
}

# Function to run load balancer
run_load_balancer() {
    print_status "Starting load balancer example..."
    cd load-balancer
    
    print_status "Building and starting services..."
    docker-compose up -d --build
    
    print_success "Load balancer is running at http://localhost"
    print_success "Backend APIs are load balanced across 3 servers"
    print_status "To stop: cd load-balancer && docker-compose down"
}

# Function to run all examples
run_all() {
    print_status "Starting all examples on different ports..."
    
    # Static site on port 8080
    print_status "Starting static site on port 8080..."
    cd static-site
    docker build -t nginx-static-site . > /dev/null 2>&1
    docker run -d --name nginx-static -p 8080:80 nginx-static-site > /dev/null 2>&1
    
    # Reverse proxy on port 8081
    print_status "Starting reverse proxy on port 8081..."
    cd ../reverse-proxy
    sed -i 's/- "80:80"/- "8081:80"/' docker-compose.yml
    docker-compose up -d --build > /dev/null 2>&1
    
    # Load balancer on port 8082
    print_status "Starting load balancer on port 8082..."
    cd ../load-balancer
    sed -i 's/- "80:80"/- "8082:80"/' docker-compose.yml
    docker-compose up -d --build > /dev/null 2>&1
    
    print_success "All examples are running:"
    print_success "  Static site: http://localhost:8080"
    print_success "  Reverse proxy: http://localhost:8081"
    print_success "  Load balancer: http://localhost:8082"
}

# Function to stop all containers
stop_all() {
    print_status "Stopping all nginx sample containers..."
    
    # Stop static site
    docker stop nginx-static 2>/dev/null || true
    docker rm nginx-static 2>/dev/null || true
    
    # Stop reverse proxy
    cd reverse-proxy 2>/dev/null && docker-compose down 2>/dev/null || true
    
    # Stop load balancer
    cd ../load-balancer 2>/dev/null && docker-compose down 2>/dev/null || true
    
    print_success "All containers stopped"
}

# Function to clean everything
clean_all() {
    print_status "Cleaning all containers and images..."
    
    stop_all
    
    # Remove images
    docker rmi nginx-static-site 2>/dev/null || true
    docker rmi nginx-reverse-proxy_nginx 2>/dev/null || true
    docker rmi nginx-reverse-proxy_backend 2>/dev/null || true
    docker rmi nginx-load-balancer_nginx 2>/dev/null || true
    docker rmi nginx-load-balancer_backend1 2>/dev/null || true
    docker rmi nginx-load-balancer_backend2 2>/dev/null || true
    docker rmi nginx-load-balancer_backend3 2>/dev/null || true
    
    print_success "Cleanup completed"
}

# Main script
main() {
    # Check if we're in the right directory
    if [ ! -f "README.md" ]; then
        print_error "Please run this script from the nginx sample-project directory"
        exit 1
    fi
    
    # Check Docker installation
    check_docker
    check_docker_daemon
    
    # Parse command line arguments
    case "${1:-help}" in
        "static-site")
            run_static_site
            ;;
        "reverse-proxy")
            run_reverse_proxy
            ;;
        "load-balancer")
            run_load_balancer
            ;;
        "all")
            run_all
            ;;
        "stop")
            stop_all
            ;;
        "clean")
            clean_all
            ;;
        "help"|*)
            show_usage
            ;;
    esac
}

# Run main function
main "$@"
