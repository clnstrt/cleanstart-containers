#!/bin/bash

# Kubernetes Sample Projects Test Script
# This script tests the Docker Compose versions of our K8s samples

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
    if ! docker info &> /dev/null; then
        print_error "Docker is not running. Please start Docker Desktop."
        exit 1
    fi
    print_success "Docker is running"
}

# Function to test Python sample
test_python_sample() {
    print_status "Testing Python Kubernetes Sample..."
    
    cd images/python/sample-project/kubernetes
    
    # Start services
    print_status "Starting Python sample services..."
    docker-compose up -d
    
    # Wait for services to be healthy
    print_status "Waiting for services to be healthy..."
    sleep 30
    
    # Test endpoints
    print_status "Testing Python application endpoints..."
    
    # Test direct Python app
    if curl -f http://localhost:5000/health &> /dev/null; then
        print_success "Python app health check: OK"
    else
        print_warning "Python app health check: FAILED"
    fi
    
    # Test through Nginx proxy
    if curl -f http://localhost:8080/health &> /dev/null; then
        print_success "Nginx proxy health check: OK"
    else
        print_warning "Nginx proxy health check: FAILED"
    fi
    
    # Test dashboard
    if curl -f http://localhost:8080/ &> /dev/null; then
        print_success "Dashboard accessible: OK"
    else
        print_warning "Dashboard accessible: FAILED"
    fi
    
    print_success "Python sample test completed!"
    print_status "Access URLs:"
    echo "  - Dashboard: http://localhost:8080"
    echo "  - Python App: http://localhost:5000"
    echo "  - Prometheus: http://localhost:9090"
    echo "  - Grafana: http://localhost:3000 (admin/admin)"
    echo "  - Redis: localhost:6379"
    
    cd ../../../..
}

# Function to test Nginx sample
test_nginx_sample() {
    print_status "Testing Nginx Kubernetes Sample..."
    
    cd images/nginx/sample-project/kubernetes
    
    # Start services
    print_status "Starting Nginx sample services..."
    docker-compose up -d
    
    # Wait for services to be healthy
    print_status "Waiting for services to be healthy..."
    sleep 30
    
    # Test endpoints
    print_status "Testing Nginx application endpoints..."
    
    # Test main Nginx app
    if curl -f http://localhost:8080/health &> /dev/null; then
        print_success "Nginx app health check: OK"
    else
        print_warning "Nginx app health check: FAILED"
    fi
    
    # Test load balancer
    if curl -f http://localhost:8081/health &> /dev/null; then
        print_success "Nginx LB health check: OK"
    else
        print_warning "Nginx LB health check: FAILED"
    fi
    
    # Test load balancer status
    if curl -f http://localhost:8081/backend-status &> /dev/null; then
        print_success "Load balancer status page: OK"
    else
        print_warning "Load balancer status page: FAILED"
    fi
    
    print_success "Nginx sample test completed!"
    print_status "Access URLs:"
    echo "  - Nginx App: http://localhost:8080"
    echo "  - Load Balancer: http://localhost:8081"
    echo "  - LB Status: http://localhost:8081/backend-status"
    echo "  - Prometheus: http://localhost:9091"
    
    cd ../../../..
}

# Function to show running services
show_services() {
    print_status "Current running services:"
    docker-compose ps
}

# Function to show logs
show_logs() {
    local service=$1
    if [ -z "$service" ]; then
        print_status "Showing logs for all services..."
        docker-compose logs --tail=50
    else
        print_status "Showing logs for $service..."
        docker-compose logs --tail=50 $service
    fi
}

# Function to stop services
stop_services() {
    print_status "Stopping services..."
    docker-compose down
    print_success "Services stopped"
}

# Function to clean up
cleanup() {
    print_status "Cleaning up..."
    docker-compose down -v
    docker system prune -f
    print_success "Cleanup completed"
}

# Function to run load test
run_load_test() {
    print_status "Running load test..."
    
    # Test load balancer with multiple requests
    for i in {1..10}; do
        echo "Request $i:"
        curl -s http://localhost:8081/ | grep -o "Backend ID: [^<]*" || echo "No backend ID found"
        sleep 1
    done
    
    print_success "Load test completed"
}

# Main script logic
main() {
    echo "Kubernetes Sample Projects Test Script"
    echo "======================================"
    
    # Check prerequisites
    check_docker
    
    # Parse command line arguments
    case "${1:-help}" in
        "python")
            test_python_sample
            ;;
        "nginx")
            test_nginx_sample
            ;;
        "all")
            test_python_sample
            echo ""
            test_nginx_sample
            ;;
        "status")
            show_services
            ;;
        "logs")
            show_logs "$2"
            ;;
        "stop")
            stop_services
            ;;
        "cleanup")
            cleanup
            ;;
        "load-test")
            run_load_test
            ;;
        "help"|"-h"|"--help")
            echo "Usage: $0 [command]"
            echo ""
            echo "Commands:"
            echo "  python     Test Python Kubernetes sample"
            echo "  nginx      Test Nginx Kubernetes sample"
            echo "  all        Test both samples"
            echo "  status     Show running services"
            echo "  logs       Show logs (optionally specify service name)"
            echo "  stop       Stop all services"
            echo "  cleanup    Stop services and clean up volumes"
            echo "  load-test  Run load test on load balancer"
            echo "  help       Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0 python          # Test Python sample"
            echo "  $0 nginx           # Test Nginx sample"
            echo "  $0 all             # Test both samples"
            echo "  $0 logs python-app # Show logs for python-app service"
            ;;
        *)
            print_error "Unknown command: $1"
            echo "Use '$0 help' for available commands"
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
