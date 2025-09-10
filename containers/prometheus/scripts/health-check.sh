#!/bin/bash

# Prometheus Health Check Script
# This script checks the health of Prometheus and its targets

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

# Check if Prometheus is running
check_prometheus() {
    print_status "Checking Prometheus health..."
    
    if curl -s http://localhost:9090/-/healthy > /dev/null; then
        print_success "Prometheus is healthy"
        return 0
    else
        print_error "Prometheus is not responding"
        return 1
    fi
}

# Check Prometheus targets
check_targets() {
    print_status "Checking Prometheus targets..."
    
    local targets=$(curl -s http://localhost:9090/api/v1/targets | jq -r '.data.activeTargets[] | select(.health != "up") | .labels.job')
    
    if [ -z "$targets" ]; then
        print_success "All targets are healthy"
        return 0
    else
        print_warning "Some targets are down: $targets"
        return 1
    fi
}

# Check Prometheus configuration
check_config() {
    print_status "Checking Prometheus configuration..."
    
    if curl -s http://localhost:9090/api/v1/status/config > /dev/null; then
        print_success "Prometheus configuration is valid"
        return 0
    else
        print_error "Prometheus configuration is invalid"
        return 1
    fi
}

# Check Prometheus rules
check_rules() {
    print_status "Checking Prometheus rules..."
    
    local rules=$(curl -s http://localhost:9090/api/v1/rules | jq -r '.data.groups[] | select(.rules | length == 0) | .name')
    
    if [ -z "$rules" ]; then
        print_success "All rule groups have rules"
        return 0
    else
        print_warning "Some rule groups are empty: $rules"
        return 1
    fi
}

# Check Prometheus storage
check_storage() {
    print_status "Checking Prometheus storage..."
    
    local storage_stats=$(curl -s http://localhost:9090/api/v1/status/tsdb | jq -r '.data')
    
    if [ "$storage_stats" != "null" ]; then
        print_success "Prometheus storage is accessible"
        return 0
    else
        print_error "Prometheus storage is not accessible"
        return 1
    fi
}

# Main health check function
main() {
    print_status "Starting Prometheus health check..."
    
    local exit_code=0
    
    check_prometheus || exit_code=1
    check_targets || exit_code=1
    check_config || exit_code=1
    check_rules || exit_code=1
    check_storage || exit_code=1
    
    if [ $exit_code -eq 0 ]; then
        print_success "All health checks passed!"
    else
        print_error "Some health checks failed!"
    fi
    
    exit $exit_code
}

# Run main function
main "$@"
