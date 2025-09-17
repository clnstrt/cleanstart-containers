#!/bin/bash

# CleanStart Python App Helm Chart Installation Script
# This script helps you install the Python application using Helm

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
    local release_name=${1:-python-app}
    local namespace=${2:-default}
    local values_file=${3:-""}
    
    print_status "Installing Python app with release name: $release_name"
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
        print_success "Python app installed successfully!"
    else
        print_error "Failed to install Python app"
        exit 1
    fi
}

# Upgrade the chart
upgrade_chart() {
    local release_name=${1:-python-app}
    local namespace=${2:-default}
    local values_file=${3:-""}
    
    print_status "Upgrading Python app with release name: $release_name"
    print_status "Namespace: $namespace"
    
    local upgrade_cmd="helm upgrade $release_name . --namespace $namespace"
    if [ -n "$values_file" ]; then
        upgrade_cmd="$upgrade_cmd --values $values_file"
        print_status "Using values file: $values_file"
    fi
    
    if eval "$upgrade_cmd"; then
        print_success "Python app upgraded successfully!"
    else
        print_error "Failed to upgrade Python app"
        exit 1
    fi
}

# Uninstall the chart
uninstall_chart() {
    local release_name=${1:-python-app}
    local namespace=${2:-default}
    
    print_status "Uninstalling Python app with release name: $release_name"
    print_status "Namespace: $namespace"
    
    if helm uninstall "$release_name" --namespace "$namespace"; then
        print_success "Python app uninstalled successfully!"
    else
        print_error "Failed to uninstall Python app"
        exit 1
    fi
}

# Show status
show_status() {
    local release_name=${1:-python-app}
    local namespace=${2:-default}
    
    print_status "Checking status of Python app..."
    
    echo -e "\n${BLUE}=== Helm Release Status ===${NC}"
    helm status "$release_name" --namespace "$namespace" || true
    
    echo -e "\n${BLUE}=== Pods Status ===${NC}"
    kubectl get pods --namespace "$namespace" -l "app.kubernetes.io/name=python-app" || true
    
    echo -e "\n${BLUE}=== Service Status ===${NC}"
    kubectl get svc --namespace "$namespace" -l "app.kubernetes.io/name=python-app" || true
    
    echo -e "\n${BLUE}=== Ingress Status ===${NC}"
    kubectl get ingress --namespace "$namespace" -l "app.kubernetes.io/name=python-app" || true
    
    echo -e "\n${BLUE}=== HPA Status ===${NC}"
    kubectl get hpa --namespace "$namespace" -l "app.kubernetes.io/name=python-app" || true
}

# Show logs
show_logs() {
    local release_name=${1:-python-app}
    local namespace=${2:-default}
    
    print_status "Showing logs for Python app..."
    kubectl logs --namespace "$namespace" -l "app.kubernetes.io/name=python-app" -f
}

# Port forward
port_forward() {
    local release_name=${1:-python-app}
    local namespace=${2:-default}
    local local_port=${3:-8080}
    local pod_port=${4:-5000}
    
    print_status "Setting up port forwarding..."
    print_status "Local port: $local_port -> Pod port: $pod_port"
    
    local pod_name=$(kubectl get pods --namespace "$namespace" -l "app.kubernetes.io/name=python-app" -o jsonpath="{.items[0].metadata.name}")
    
    if [ -n "$pod_name" ]; then
        print_success "Port forwarding to pod: $pod_name"
        kubectl port-forward --namespace "$namespace" "$pod_name" "$local_port:$pod_port"
    else
        print_error "No pods found for Python app"
        exit 1
    fi
}

# Show help
show_help() {
    echo "CleanStart Python App Helm Chart Installation Script"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  install [RELEASE_NAME] [NAMESPACE] [VALUES_FILE]  Install the chart"
    echo "  upgrade [RELEASE_NAME] [NAMESPACE] [VALUES_FILE]  Upgrade the chart"
    echo "  uninstall [RELEASE_NAME] [NAMESPACE]             Uninstall the chart"
    echo "  status [RELEASE_NAME] [NAMESPACE]                Show status"
    echo "  logs [RELEASE_NAME] [NAMESPACE]                  Show logs"
    echo "  port-forward [RELEASE_NAME] [NAMESPACE] [LOCAL_PORT] [POD_PORT]  Port forward"
    echo "  validate                                         Validate chart"
    echo "  help                                             Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 install my-python-app default"
    echo "  $0 install my-python-app production custom-values.yaml"
    echo "  $0 upgrade my-python-app default"
    echo "  $0 status my-python-app default"
    echo "  $0 logs my-python-app default"
    echo "  $0 port-forward my-python-app default 8080 5000"
    echo "  $0 uninstall my-python-app default"
    echo ""
    echo "Default values:"
    echo "  RELEASE_NAME: python-app"
    echo "  NAMESPACE: default"
    echo "  LOCAL_PORT: 8080"
    echo "  POD_PORT: 5000"
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
            check_kubectl
            check_cluster
            show_status "$2" "$3"
            ;;
        logs)
            check_kubectl
            check_cluster
            show_logs "$2" "$3"
            ;;
        port-forward)
            check_kubectl
            check_cluster
            port_forward "$2" "$3" "$4" "$5"
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
