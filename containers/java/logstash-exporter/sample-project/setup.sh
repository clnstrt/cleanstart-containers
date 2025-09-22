#!/bin/bash

# Logstash Exporter Sample Project Setup Script
# This script helps you set up and run the different examples

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

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
    print_success "Docker is running"
}

# Function to check if Docker Compose is available
check_docker_compose() {
    if ! command -v docker-compose > /dev/null 2>&1; then
        print_error "Docker Compose is not installed. Please install Docker Compose and try again."
        exit 1
    fi
    print_success "Docker Compose is available"
}

# Function to check port availability
check_port() {
    local port=$1
    if netstat -tuln 2>/dev/null | grep -q ":$port "; then
        print_warning "Port $port is already in use"
        return 1
    else
        print_success "Port $port is available"
        return 0
    fi
}

# Function to show main menu
show_menu() {
    clear
    echo "=========================================="
    echo "    Logstash Exporter Sample Projects"
    echo "=========================================="
    echo
    echo "Choose an example to run:"
    echo
    echo "1) Basic Monitoring"
    echo "2) Multi-Instance Monitoring"
    echo "3) Production Setup"
    echo "4) Integration Examples"
    echo "5) Stop All Containers"
    echo "6) Cleanup All"
    echo "7) Exit"
    echo
}

# Function to run basic monitoring
run_basic_monitoring() {
    print_status "Starting Basic Monitoring example..."
    cd basic-monitoring
    
    # Check if required files exist
    if [ ! -f "docker-compose.yml" ]; then
        print_error "docker-compose.yml not found in basic-monitoring directory"
        cd ..
        return 1
    fi
    
    # Check ports
    check_port 9198
    check_port 9600
    check_port 8080
    check_port 8081
    
    print_status "Starting services..."
    docker-compose up -d
    
    print_success "Basic monitoring started!"
    echo
    echo "Access points:"
    echo "- Logstash: http://localhost:9600"
    echo "- logstash-exporter: http://localhost:9198"
    echo "- Log Generator: http://localhost:8080"
    echo "- Test App: http://localhost:8081"
    echo
    echo "Use 'docker-compose logs -f' to view logs"
    echo "Use 'docker-compose down' to stop"
    cd ..
}

# Function to run multi-instance monitoring
run_multi_instance() {
    print_status "Starting Multi-Instance Monitoring example..."
    cd multi-instance
    
    if [ ! -f "docker-compose.yml" ]; then
        print_error "docker-compose.yml not found in multi-instance directory"
        cd ..
        return 1
    fi
    
    print_status "Starting services..."
    docker-compose up -d
    
    print_success "Multi-instance monitoring started!"
    echo
    echo "Access points:"
    echo "- Logstash Instances: http://localhost:9600, http://localhost:9601"
    echo "- logstash-exporter: http://localhost:9198"
    echo "- Load Balancer: http://localhost:8080"
    echo
    echo "Use 'docker-compose logs -f' to view logs"
    echo "Use 'docker-compose down' to stop"
    cd ..
}

# Function to run production setup
run_production_setup() {
    print_status "Starting Production Setup example..."
    cd production-setup
    
    if [ ! -f "docker-compose.yml" ]; then
        print_error "docker-compose.yml not found in production-setup directory"
        cd ..
        return 1
    fi
    
    # Check ports
    check_port 9198
    check_port 9090
    check_port 3000
    check_port 9093
    
    print_status "Starting production monitoring stack..."
    docker-compose up -d
    
    print_success "Production setup started!"
    echo
    echo "Access points:"
    echo "- logstash-exporter: http://localhost:9198"
    echo "- Prometheus: http://localhost:9090"
    echo "- Grafana: http://localhost:3000 (admin/admin123)"
    echo "- AlertManager: http://localhost:9093"
    echo
    echo "Use 'docker-compose logs -f' to view logs"
    echo "Use 'docker-compose down' to stop"
    cd ..
}

# Function to run integration examples
run_integration_examples() {
    print_status "Starting Integration Examples..."
    cd integration-examples
    
    if [ ! -f "docker-compose.yml" ]; then
        print_error "docker-compose.yml not found in integration-examples directory"
        cd ..
        return 1
    fi
    
    print_status "Starting integration services..."
    docker-compose up -d
    
    print_success "Integration examples started!"
    echo
    echo "Check the README.md file for specific access points"
    echo "Use 'docker-compose logs -f' to view logs"
    echo "Use 'docker-compose down' to stop"
    cd ..
}

# Function to stop all containers
stop_all_containers() {
    print_status "Stopping all containers..."
    
    # Stop containers in each directory
    for dir in basic-monitoring multi-instance production-setup integration-examples; do
        if [ -d "$dir" ]; then
            cd "$dir"
            if [ -f "docker-compose.yml" ]; then
                docker-compose down 2>/dev/null || true
                print_success "Stopped containers in $dir"
            fi
            cd ..
        fi
    done
    
    print_success "All containers stopped"
}

# Function to clean up all
cleanup() {
    print_status "Cleaning up all containers and volumes..."
    
    # Stop and remove containers in each directory
    for dir in basic-monitoring multi-instance production-setup integration-examples; do
        if [ -d "$dir" ]; then
            cd "$dir"
            if [ -f "docker-compose.yml" ]; then
                docker-compose down -v --remove-orphans 2>/dev/null || true
                print_success "Cleaned up $dir"
            fi
            cd ..
        fi
    done
    
    print_success "All containers and volumes cleaned up"
}

# Function to wait for services
wait_for_services() {
    local service_name=$1
    local url=$2
    local max_attempts=30
    local attempt=1
    
    print_status "Waiting for $service_name to be ready..."
    
    while [ $attempt -le $max_attempts ]; do
        if curl -s -f "$url" > /dev/null 2>&1; then
            print_success "$service_name is ready!"
            return 0
        fi
        
        echo -n "."
        sleep 2
        attempt=$((attempt + 1))
    done
    
    print_warning "$service_name may not be fully ready yet"
    return 1
}

# Main script
main() {
    # Check prerequisites
    check_docker
    check_docker_compose
    
    # Main loop
    while true; do
        show_menu
        read -p "Enter your choice (1-7): " choice
        
        case $choice in
            1)
                run_basic_monitoring
                if [ $? -eq 0 ]; then
                    echo
                    read -p "Press Enter to continue..."
                fi
                ;;
            2)
                run_multi_instance
                if [ $? -eq 0 ]; then
                    echo
                    read -p "Press Enter to continue..."
                fi
                ;;
            3)
                run_production_setup
                if [ $? -eq 0 ]; then
                    echo
                    read -p "Press Enter to continue..."
                fi
                ;;
            4)
                run_integration_examples
                if [ $? -eq 0 ]; then
                    echo
                    read -p "Press Enter to continue..."
                fi
                ;;
            5)
                stop_all_containers
                echo
                read -p "Press Enter to continue..."
                ;;
            6)
                cleanup
                echo
                read -p "Press Enter to continue..."
                ;;
            7)
                print_status "Exiting..."
                exit 0
                ;;
            *)
                print_error "Invalid choice. Please enter a number between 1 and 7."
                sleep 2
                ;;
        esac
    done
}

# Run main function
main "$@"
