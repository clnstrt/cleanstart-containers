#!/bin/bash

# CleanStart Go Web App Helm Chart Installation Script
# This script helps you install the Go application using Helm

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

# Check if Helm is installed
check_helm() {
    if ! command -v helm &> /dev/null; then
        print_error "Helm is not installed. Please install Helm first."
        print_status "Visit: https://helm.sh/docs/intro/install/"
        exit 1
    fi
    print_success "Helm is installed: $(helm version --short)"
}

# Check if kubectl is installed
check_kubectl() {
    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl is not installed. Please install kubectl first."
        print_status "Visit: https://kubernetes.io/docs/tasks/tools/"
        exit 1
    fi
    print_success "kubectl is installed: $(kubectl version --client --short)"
}

# Check if Kubernetes cluster is accessible
check_cluster() {
    if ! kubectl cluster-info &> /dev/null; then
        print_error "Cannot connect to Kubernetes cluster."
        print_status "Please ensure your kubeconfig is properly configured."
        exit 1
    fi
    print_success "Connected to Kubernetes cluster"
}

# Validate Helm chart
validate_chart() {
    print_status "Validating Helm chart..."
    if helm lint . > /dev/null 2>&1; then
        print_success "Helm chart validation passed"
    else
        print_error "Helm chart validation failed"
        helm lint .
        exit 1
    fi
}

# Install the chart
install_chart() {
    local release_name=${1:-go-web-app}
    local namespace=${2:-default}
    local values_file=${3:-""}
    
    print_status "Installing Go web app with release name: $release_name"
    print_status "Namespace: $namespace"
    
    # Create namespace if it doesn't exist
    if ! kubectl get namespace "$namespace" &> /dev/null; then
        print_status "Creating namespace: $namespace"
        kubectl create namespace "$namespace"
    fi
    
    # Install the chart
    local install_cmd="helm install $release_name . --namespace $namespace"
    if [ -n "$values_file" ]; then
        install_cmd="$install_cmd --values $values_file"
        print_status "Using values file: $values_file"
    fi
    
    if eval "$install_cmd"; then
        print_success "Go web app installed successfully!"
    else
        print_error "Failed to install Go web app"
        exit 1
    fi
}

# Upgrade the chart
upgrade_chart() {
    local release_name=${1:-go-web-app}
    local namespace=${2:-default}
    local values_file=${3:-""}
    
    print_status "Upgrading Go web app with release name: $release_name"
    print_status "Namespace: $namespace"
    
    local upgrade_cmd="helm upgrade $release_name . --namespace $namespace"
    if [ -n "$values_file" ]; then
        upgrade_cmd="$upgrade_cmd --values $values_file"
        print_status "Using values file: $values_file"
    fi
    
    if eval "$upgrade_cmd"; then
        print_success "Go web app upgraded successfully!"
    else
        print_error "Failed to upgrade Go web app"
        exit 1
    fi
}

# Uninstall the chart
uninstall_chart() {
    local release_name=${1:-go-web-app}
    local namespace=${2:-default}
    
    print_status "Uninstalling Go web app with release name: $release_name"
    print_status "Namespace: $namespace"
    
    if helm uninstall "$release_name" --namespace "$namespace"; then
        print_success "Go web app uninstalled successfully!"
    else
        print_error "Failed to uninstall Go web app"
        exit 1
    fi
}

# Show status
show_status() {
    local release_name=${1:-go-web-app}
    local namespace=${2:-default}
    
    print_status "Checking status of Go web app..."
    print_status "Release: $release_name"
    print_status "Namespace: $namespace"
    
    echo ""
    print_status "Helm Release Status:"
    helm status "$release_name" --namespace "$namespace" || true
    
    echo ""
    print_status "Pods Status:"
    kubectl get pods --namespace "$namespace" -l app.kubernetes.io/name=go-web-app || true
    
    echo ""
    print_status "Services Status:"
    kubectl get services --namespace "$namespace" -l app.kubernetes.io/name=go-web-app || true
    
    echo ""
    print_status "Ingress Status:"
    kubectl get ingress --namespace "$namespace" -l app.kubernetes.io/name=go-web-app || true
}

# Port forward to access the application
port_forward() {
    local release_name=${1:-go-web-app}
    local namespace=${2:-default}
    local port=${3:-8080}
    
    print_status "Setting up port forwarding..."
    print_status "Release: $release_name"
    print_status "Namespace: $namespace"
    print_status "Port: $port"
    
    print_status "Access the application at: http://localhost:$port"
    print_status "Press Ctrl+C to stop port forwarding"
    
    kubectl port-forward --namespace "$namespace" "service/$release_name" "$port:8080"
}

# Show logs
show_logs() {
    local release_name=${1:-go-web-app}
    local namespace=${2:-default}
    local follow=${3:-false}
    
    print_status "Showing logs for Go web app..."
    print_status "Release: $release_name"
    print_status "Namespace: $namespace"
    
    local pods=$(kubectl get pods --namespace "$namespace" -l app.kubernetes.io/name=go-web-app -o jsonpath='{.items[*].metadata.name}')
    
    if [ -z "$pods" ]; then
        print_error "No pods found for Go web app"
        exit 1
    fi
    
    for pod in $pods; do
        print_status "Showing logs for pod: $pod"
        if [ "$follow" = "true" ]; then
            kubectl logs --namespace "$namespace" -f "$pod"
        else
            kubectl logs --namespace "$namespace" "$pod"
        fi
    done
}

# Test the application
test_application() {
    local release_name=${1:-go-web-app}
    local namespace=${2:-default}
    local port=${3:-8080}
    
    print_status "Testing Go web app..."
    print_status "Release: $release_name"
    print_status "Namespace: $namespace"
    print_status "Port: $port"
    
    # Start port forwarding in background
    kubectl port-forward --namespace "$namespace" "service/$release_name" "$port:8080" &
    local pf_pid=$!
    
    # Wait for port forwarding to be ready
    sleep 5
    
    # Test the application
    print_status "Testing health endpoint..."
    if curl -f "http://localhost:$port/health" > /dev/null 2>&1; then
        print_success "Health check passed!"
    else
        print_warning "Health check failed, trying root endpoint..."
        if curl -f "http://localhost:$port/" > /dev/null 2>&1; then
            print_success "Root endpoint accessible!"
        else
            print_error "Application is not responding"
        fi
    fi
    
    # Test API endpoint
    print_status "Testing API endpoint..."
    if curl -f "http://localhost:$port/api/users" > /dev/null 2>&1; then
        print_success "API endpoint accessible!"
    else
        print_warning "API endpoint not accessible"
    fi
    
    # Stop port forwarding
    kill $pf_pid 2>/dev/null || true
}

# Show help
show_help() {
    echo "CleanStart Go Web App Helm Chart Installation Script"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  install [RELEASE_NAME] [NAMESPACE] [VALUES_FILE]  Install the chart"
    echo "  upgrade [RELEASE_NAME] [NAMESPACE] [VALUES_FILE]   Upgrade the chart"
    echo "  uninstall [RELEASE_NAME] [NAMESPACE]              Uninstall the chart"
    echo "  status [RELEASE_NAME] [NAMESPACE]                 Show status"
    echo "  logs [RELEASE_NAME] [NAMESPACE] [FOLLOW]          Show logs"
    echo "  port-forward [RELEASE_NAME] [NAMESPACE] [PORT]    Port forward"
    echo "  test [RELEASE_NAME] [NAMESPACE] [PORT]            Test application"
    echo "  validate                                          Validate chart"
    echo "  help                                              Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 install                                        Install with default settings"
    echo "  $0 install my-go-app production                   Install in production namespace"
    echo "  $0 install my-go-app default values-production.yaml  Install with custom values"
    echo "  $0 upgrade my-go-app default values-production.yaml   Upgrade with custom values"
    echo "  $0 status my-go-app production                    Show status"
    echo "  $0 logs my-go-app default true                   Follow logs"
    echo "  $0 port-forward my-go-app default 8080          Port forward to 8080"
    echo "  $0 test my-go-app default 8080                   Test application"
    echo ""
    echo "Default values:"
    echo "  RELEASE_NAME: go-web-app"
    echo "  NAMESPACE: default"
    echo "  PORT: 8080"
    echo "  FOLLOW: false"
}

# Main script logic
main() {
    local command=${1:-help}
    
    case $command in
        install)
            check_helm
            check_kubectl
            check_cluster
            validate_chart
            install_chart "$2" "$3" "$4"
            ;;
        upgrade)
            check_helm
            check_kubectl
            check_cluster
            validate_chart
            upgrade_chart "$2" "$3" "$4"
            ;;
        uninstall)
            check_helm
            check_kubectl
            check_cluster
            uninstall_chart "$2" "$3"
            ;;
        status)
            check_helm
            check_kubectl
            check_cluster
            show_status "$2" "$3"
            ;;
        logs)
            check_kubectl
            check_cluster
            show_logs "$2" "$3" "$4"
            ;;
        port-forward)
            check_kubectl
            check_cluster
            port_forward "$2" "$3" "$4"
            ;;
        test)
            check_kubectl
            check_cluster
            test_application "$2" "$3" "$4"
            ;;
        validate)
            check_helm
            validate_chart
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Unknown command: $command"
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
