#!/bin/bash

# PostgreSQL Kubernetes Deployment Script
# This script deploys PostgreSQL to a Kubernetes cluster

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

# Check if kubectl is installed
check_kubectl() {
    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl is not installed or not in PATH"
        exit 1
    fi
    print_success "kubectl is available"
}

# Check if cluster is accessible
check_cluster() {
    if ! kubectl cluster-info &> /dev/null; then
        print_error "Cannot connect to Kubernetes cluster"
        exit 1
    fi
    print_success "Connected to Kubernetes cluster"
}

# Deploy PostgreSQL
deploy_postgres() {
    local namespace=${1:-default}
    local use_secrets=${2:-false}
    
    print_status "Deploying PostgreSQL to namespace: $namespace"
    
    # Create namespace if it doesn't exist
    kubectl create namespace $namespace --dry-run=client -o yaml | kubectl apply -f -
    
    # Apply PVC
    print_status "Creating PersistentVolumeClaim..."
    kubectl apply -f postgres-pvc.yaml -n $namespace
    
    # Apply ConfigMap
    print_status "Creating ConfigMap..."
    kubectl apply -f postgres-configmap.yaml -n $namespace
    
    # Apply Secret
    print_status "Creating Secret..."
    kubectl apply -f postgres-secret.yaml -n $namespace
    
    # Apply Service
    print_status "Creating Service..."
    kubectl apply -f postgres-service.yaml -n $namespace
    
    # Apply Deployment
    if [ "$use_secrets" = "true" ]; then
        print_status "Creating Deployment with Secrets..."
        kubectl apply -f postgres-deployment-with-secrets.yaml -n $namespace
    else
        print_status "Creating Deployment..."
        kubectl apply -f postgres-deployment.yaml -n $namespace
    fi
    
    # Apply HPA (optional)
    if [ "$3" = "hpa" ]; then
        print_status "Creating HorizontalPodAutoscaler..."
        kubectl apply -f postgres-hpa.yaml -n $namespace
    fi
    
    # Apply Ingress (optional)
    if [ "$4" = "ingress" ]; then
        print_status "Creating Ingress..."
        kubectl apply -f postgres-ingress.yaml -n $namespace
    fi
    
    print_success "PostgreSQL deployment completed!"
}

# Wait for deployment to be ready
wait_for_deployment() {
    local namespace=${1:-default}
    local deployment_name=${2:-postgres-deployment}
    
    print_status "Waiting for deployment to be ready..."
    kubectl wait --for=condition=available --timeout=300s deployment/$deployment_name -n $namespace
    
    print_success "Deployment is ready!"
}

# Show deployment status
show_status() {
    local namespace=${1:-default}
    
    print_status "Deployment Status:"
    kubectl get pods -n $namespace -l app=postgres
    
    print_status "Services:"
    kubectl get services -n $namespace -l app=postgres
    
    print_status "PVCs:"
    kubectl get pvc -n $namespace -l app=postgres
}

# Connect to PostgreSQL
connect_to_postgres() {
    local namespace=${1:-default}
    local pod_name=$(kubectl get pods -n $namespace -l app=postgres -o jsonpath='{.items[0].metadata.name}')
    
    if [ -z "$pod_name" ]; then
        print_error "No PostgreSQL pod found in namespace $namespace"
        exit 1
    fi
    
    print_status "Connecting to PostgreSQL pod: $pod_name"
    kubectl exec -it $pod_name -n $namespace -- psql -U postgres -d helloworld
}

# Clean up deployment
cleanup() {
    local namespace=${1:-default}
    
    print_warning "Cleaning up PostgreSQL deployment in namespace: $namespace"
    
    kubectl delete -f postgres-deployment.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f postgres-deployment-with-secrets.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f postgres-service.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f postgres-hpa.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f postgres-ingress.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f postgres-configmap.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f postgres-secret.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f postgres-pvc.yaml -n $namespace --ignore-not-found=true
    
    print_success "Cleanup completed!"
}

# Show help
show_help() {
    echo "PostgreSQL Kubernetes Deployment Script"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  deploy [namespace] [use_secrets] [hpa] [ingress]  Deploy PostgreSQL"
    echo "  status [namespace]                                Show deployment status"
    echo "  connect [namespace]                               Connect to PostgreSQL"
    echo "  cleanup [namespace]                               Clean up deployment"
    echo "  help                                              Show this help"
    echo ""
    echo "Options:"
    echo "  namespace    Kubernetes namespace (default: default)"
    echo "  use_secrets  Use secrets for credentials (true/false, default: false)"
    echo "  hpa          Enable HorizontalPodAutoscaler (default: false)"
    echo "  ingress      Enable Ingress (default: false)"
    echo ""
    echo "Examples:"
    echo "  $0 deploy                                    # Deploy to default namespace"
    echo "  $0 deploy postgres-db true                  # Deploy with secrets"
    echo "  $0 deploy postgres-db true hpa ingress      # Deploy with all features"
    echo "  $0 status postgres-db                       # Show status"
    echo "  $0 connect postgres-db                      # Connect to database"
    echo "  $0 cleanup postgres-db                      # Clean up"
}

# Main script logic
main() {
    case "${1:-help}" in
        deploy)
            check_kubectl
            check_cluster
            deploy_postgres "${2:-default}" "${3:-false}" "${4:-}" "${5:-}"
            wait_for_deployment "${2:-default}"
            show_status "${2:-default}"
            ;;
        status)
            check_kubectl
            show_status "${2:-default}"
            ;;
        connect)
            check_kubectl
            connect_to_postgres "${2:-default}"
            ;;
        cleanup)
            check_kubectl
            cleanup "${2:-default}"
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
