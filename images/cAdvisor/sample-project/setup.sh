#!/bin/bash

# cAdvisor Sample Project Setup Script
# This script helps you set up and run different cAdvisor monitoring examples

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

# Function to pull the cAdvisor image
pull_cadvisor_image() {
    print_status "Pulling cAdvisor image..."
    docker pull cleanstart/cadvisor:latest
    print_success "cAdvisor image pulled successfully"
}

# Function to show menu
show_menu() {
    echo
    echo "=========================================="
    echo "    cAdvisor Sample Project Setup"
    echo "=========================================="
    echo
    echo "Choose an example to run:"
    echo "1) Basic Monitoring (Single container monitoring)"
    echo "2) Multi-Container Monitoring (Full application stack)"
    echo "3) Production Setup (With Prometheus, Grafana, AlertManager)"
    echo "4) Stop all containers"
    echo "5) Clean up (remove all containers and volumes)"
    echo "6) Exit"
    echo
}

# Function to run basic monitoring
run_basic_monitoring() {
    print_status "Starting Basic Monitoring example..."
    cd basic-monitoring
    docker-compose up -d
    print_success "Basic monitoring started!"
    echo
    echo "Access points:"
    echo "- cAdvisor Web UI: http://localhost:8080"
    echo "- Test App: http://localhost:8081"
    echo
    echo "Use 'docker-compose logs -f' to view logs"
    echo "Use 'docker-compose down' to stop"
}

# Function to run multi-container monitoring
run_multi_container() {
    print_status "Starting Multi-Container Monitoring example..."
    cd multi-container
    docker-compose up -d
    print_success "Multi-container monitoring started!"
    echo
    echo "Access points:"
    echo "- cAdvisor Web UI: http://localhost:8080"
    echo "- Web App: http://localhost:8081"
    echo "- API Server: http://localhost:8082"
    echo "- Database: localhost:5432"
    echo "- Redis Cache: localhost:6379"
    echo
    echo "Use 'docker-compose logs -f' to view logs"
    echo "Use 'docker-compose down' to stop"
}

# Function to run production setup
run_production_setup() {
    print_status "Starting Production Setup example..."
    cd production-setup
    
    # Check if required files exist
    if [ ! -f "prometheus.yml" ]; then
        print_warning "prometheus.yml not found. Creating default configuration..."
        create_prometheus_config
    fi
    
    if [ ! -f "alertmanager.yml" ]; then
        print_warning "alertmanager.yml not found. Creating default configuration..."
        create_alertmanager_config
    fi
    
    docker-compose up -d
    print_success "Production setup started!"
    echo
    echo "Access points:"
    echo "- cAdvisor Web UI: http://localhost:8080"
    echo "- Prometheus: http://localhost:9090"
    echo "- Grafana: http://localhost:3000 (admin/admin123)"
    echo "- AlertManager: http://localhost:9093"
    echo
    echo "Use 'docker-compose logs -f' to view logs"
    echo "Use 'docker-compose down' to stop"
}

# Function to create Prometheus configuration
create_prometheus_config() {
    cat > prometheus.yml << 'EOF'
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']
    metrics_path: /metrics
    scrape_interval: 15s
EOF
}

# Function to create AlertManager configuration
create_alertmanager_config() {
    cat > alertmanager.yml << 'EOF'
global:
  resolve_timeout: 5m

route:
  group_by: ['alertname']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h
  receiver: 'web.hook'
receivers:
  - name: 'web.hook'
    webhook_configs:
      - url: 'http://127.0.0.1:5001/'
inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'dev', 'instance']
EOF
}

# Function to stop all containers
stop_all_containers() {
    print_status "Stopping all containers..."
    
    # Stop containers in each directory
    for dir in basic-monitoring multi-container production-setup; do
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

# Function to clean up
cleanup() {
    print_status "Cleaning up all containers and volumes..."
    
    # Stop and remove containers in each directory
    for dir in basic-monitoring multi-container production-setup; do
        if [ -d "$dir" ]; then
            cd "$dir"
            if [ -f "docker-compose.yml" ]; then
                docker-compose down -v --rmi all 2>/dev/null || true
                print_success "Cleaned up $dir"
            fi
            cd ..
        fi
    done
    
    # Remove any dangling containers
    docker container prune -f 2>/dev/null || true
    docker volume prune -f 2>/dev/null || true
    
    print_success "Cleanup completed"
}

# Main script
main() {
    print_status "Checking prerequisites..."
    check_docker
    check_docker_compose
    
    print_status "Pulling required images..."
    pull_cadvisor_image
    
    while true; do
        show_menu
        read -p "Enter your choice (1-6): " choice
        
        case $choice in
            1)
                run_basic_monitoring
                ;;
            2)
                run_multi_container
                ;;
            3)
                run_production_setup
                ;;
            4)
                stop_all_containers
                ;;
            5)
                cleanup
                ;;
            6)
                print_status "Exiting..."
                exit 0
                ;;
            *)
                print_error "Invalid choice. Please enter a number between 1 and 6."
                ;;
        esac
        
        echo
        read -p "Press Enter to continue..."
    done
}

# Run main function
main "$@"
