#!/bin/bash

# Go Web App Kubernetes Undeployment Script
# This script removes the Go web application from Kubernetes

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
        print_error "kubectl is not installed. Please install kubectl first."
        exit 1
    fi
    print_success "kubectl is available"
}

# Check if cluster is accessible
check_cluster() {
    if ! kubectl cluster-info &> /dev/null; then
        print_error "Cannot connect to Kubernetes cluster. Please check your kubeconfig."
        exit 1
    fi
    print_success "Connected to Kubernetes cluster"
}

# Delete resources
delete_resources() {
    print_status "Deleting Kubernetes resources..."
    
    # Delete in reverse order of dependencies
    print_status "Deleting Ingress..."
    kubectl delete -f go-ingress.yaml --ignore-not-found=true
    
    print_status "Deleting HPA..."
    kubectl delete -f go-hpa.yaml --ignore-not-found=true
    
    print_status "Deleting NetworkPolicy..."
    kubectl delete -f go-networkpolicy.yaml --ignore-not-found=true
    
    print_status "Deleting Service..."
    kubectl delete -f go-service.yaml --ignore-not-found=true
    
    print_status "Deleting Deployment..."
    kubectl delete -f go-deployment.yaml --ignore-not-found=true
    
    print_status "Deleting PVC..."
    kubectl delete -f go-pvc.yaml --ignore-not-found=true
    
    print_status "Deleting Secrets..."
    kubectl delete -f go-secrets.yaml --ignore-not-found=true
    
    print_status "Deleting ConfigMap..."
    kubectl delete -f go-configmap.yaml --ignore-not-found=true
    
    print_success "All resources deleted"
}

# Delete namespace (optional)
delete_namespace() {
    read -p "Do you want to delete the namespace as well? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Deleting namespace..."
        kubectl delete namespace go-web-app --ignore-not-found=true
        print_success "Namespace deleted"
    else
        print_warning "Namespace kept. You can delete it manually with: kubectl delete namespace go-web-app"
    fi
}

# Clean up Docker images (optional)
cleanup_images() {
    read -p "Do you want to remove the Docker image as well? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Removing Docker image..."
        docker rmi go-web-app:latest --force 2>/dev/null || true
        print_success "Docker image removed"
    else
        print_warning "Docker image kept. You can remove it manually with: docker rmi go-web-app:latest"
    fi
}

# Show remaining resources
show_remaining() {
    print_status "Checking for remaining resources..."
    echo ""
    
    # Check for remaining pods
    PODS=$(kubectl get pods -l app=go-web-app --no-headers 2>/dev/null | wc -l)
    if [ "$PODS" -gt 0 ]; then
        print_warning "Found $PODS remaining pods:"
        kubectl get pods -l app=go-web-app
    else
        print_success "No remaining pods found"
    fi
    
    # Check for remaining services
    SERVICES=$(kubectl get services -l app=go-web-app --no-headers 2>/dev/null | wc -l)
    if [ "$SERVICES" -gt 0 ]; then
        print_warning "Found $SERVICES remaining services:"
        kubectl get services -l app=go-web-app
    else
        print_success "No remaining services found"
    fi
    
    # Check for remaining PVCs
    PVCS=$(kubectl get pvc -l app=go-web-app --no-headers 2>/dev/null | wc -l)
    if [ "$PVCS" -gt 0 ]; then
        print_warning "Found $PVCS remaining PVCs:"
        kubectl get pvc -l app=go-web-app
    else
        print_success "No remaining PVCs found"
    fi
}

# Main undeployment function
main() {
    print_status "Starting Go Web App Kubernetes Undeployment"
    echo "=================================================="
    echo ""
    
    check_kubectl
    check_cluster
    
    # Confirm deletion
    print_warning "This will delete all Go web app resources from Kubernetes."
    read -p "Are you sure you want to continue? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Undeployment cancelled."
        exit 0
    fi
    
    delete_resources
    show_remaining
    delete_namespace
    cleanup_images
    
    print_success "Undeployment completed successfully!"
}

# Run main function
main "$@"
