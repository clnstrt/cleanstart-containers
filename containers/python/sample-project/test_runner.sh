#!/bin/bash

# Test Runner Script for Flask User Management Application
# This script runs various tests to verify the application works correctly

set -e  # Exit on any error

echo "🧪 Flask User Management Application Test Suite"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    case $status in
        "SUCCESS")
            echo -e "${GREEN}✅ $message${NC}"
            ;;
        "ERROR")
            echo -e "${RED}❌ $message${NC}"
            ;;
        "WARNING")
            echo -e "${YELLOW}⚠️  $message${NC}"
            ;;
        "INFO")
            echo -e "${BLUE}ℹ️  $message${NC}"
            ;;
    esac
}

# Check if Python is available
check_python() {
    print_status "INFO" "Checking Python installation..."
    if command -v python3 &> /dev/null; then
        PYTHON_CMD="python3"
    elif command -v python &> /dev/null; then
        PYTHON_CMD="python"
    else
        print_status "ERROR" "Python is not installed or not in PATH"
        exit 1
    fi
    print_status "SUCCESS" "Python found: $($PYTHON_CMD --version)"
}

# Install dependencies
install_dependencies() {
    print_status "INFO" "Installing dependencies..."
    if [ -f "requirements.txt" ]; then
        $PYTHON_CMD -m pip install -r requirements.txt --quiet
        print_status "SUCCESS" "Dependencies installed"
    else
        print_status "ERROR" "requirements.txt not found"
        exit 1
    fi
}

# Run unit tests
run_unit_tests() {
    print_status "INFO" "Running unit tests..."
    if [ -f "test_app.py" ]; then
        if $PYTHON_CMD -m pytest test_app.py -v --tb=short; then
            print_status "SUCCESS" "Unit tests passed"
        else
            print_status "ERROR" "Unit tests failed"
            return 1
        fi
    else
        print_status "WARNING" "test_app.py not found, skipping unit tests"
    fi
}

# Run integration tests
run_integration_tests() {
    print_status "INFO" "Running integration tests..."
    if [ -f "integration_test.py" ]; then
        if $PYTHON_CMD integration_test.py; then
            print_status "SUCCESS" "Integration tests passed"
        else
            print_status "ERROR" "Integration tests failed"
            return 1
        fi
    else
        print_status "WARNING" "integration_test.py not found, skipping integration tests"
    fi
}

# Test Docker build
test_docker_build() {
    print_status "INFO" "Testing Docker build..."
    if command -v docker &> /dev/null; then
        if docker build -t flask-user-management-test . --quiet; then
            print_status "SUCCESS" "Docker build successful"
            
            # Test running the container
            print_status "INFO" "Testing Docker container..."
            CONTAINER_ID=$(docker run -d -p 5001:5000 flask-user-management-test)
            sleep 3
            
            # Test health endpoint
            if curl -s http://localhost:5001/health > /dev/null; then
                print_status "SUCCESS" "Docker container is running and responding"
            else
                print_status "ERROR" "Docker container is not responding"
            fi
            
            # Clean up
            docker stop $CONTAINER_ID > /dev/null
            docker rm $CONTAINER_ID > /dev/null
            docker rmi flask-user-management-test > /dev/null
        else
            print_status "ERROR" "Docker build failed"
            return 1
        fi
    else
        print_status "WARNING" "Docker not available, skipping Docker tests"
    fi
}

# Main test execution
main() {
    local exit_code=0
    
    # Run all test phases
    check_python
    install_dependencies
    
    echo ""
    print_status "INFO" "Starting test phases..."
    echo ""
    
    # Unit tests
    if ! run_unit_tests; then
        exit_code=1
    fi
    
    echo ""
    
    # Integration tests
    if ! run_integration_tests; then
        exit_code=1
    fi
    
    echo ""
    
    # Docker tests
    if ! test_docker_build; then
        exit_code=1
    fi
    
    echo ""
    echo "=============================================="
    
    if [ $exit_code -eq 0 ]; then
        print_status "SUCCESS" "All tests passed! 🎉"
    else
        print_status "ERROR" "Some tests failed! 😞"
    fi
    
    exit $exit_code
}

# Run main function
main "$@"
