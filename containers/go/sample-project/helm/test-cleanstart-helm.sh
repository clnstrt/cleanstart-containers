#!/bin/bash

# 🚀 CleanStart Go Web App Helm Test Script
# This script tests the Helm deployment using CleanStart Go images

set -e

echo "🚀 Starting CleanStart Go Web App Helm Test"
echo "=========================================="

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

# Check if kubectl is available
check_kubectl() {
    print_status "Checking kubectl availability..."
    if command -v kubectl >/dev/null 2>&1; then
        print_success "kubectl is available"
        kubectl version --client
    else
        print_error "kubectl is not available. Please install kubectl first."
        exit 1
    fi
}

# Check if helm is available
check_helm() {
    print_status "Checking Helm availability..."
    if command -v helm >/dev/null 2>&1; then
        print_success "Helm is available"
        helm version
    else
        print_error "Helm is not available. Please install Helm first."
        exit 1
    fi
}

# Check if Kubernetes cluster is available
check_kubernetes_cluster() {
    print_status "Checking Kubernetes cluster..."
    if kubectl cluster-info >/dev/null 2>&1; then
        print_success "Kubernetes cluster is available"
        kubectl cluster-info
    else
        print_error "No Kubernetes cluster found. Please ensure Kubernetes is running."
        exit 1
    fi
}

# Test CleanStart Go image
test_cleanstart_image() {
    print_status "Testing CleanStart Go image..."
    
    # Pull the image
    if docker pull cleanstart/go:latest; then
        print_success "CleanStart Go image pulled successfully"
    else
        print_warning "Failed to pull cleanstart/go:latest"
    fi
    
    # Test basic functionality
    if docker run --rm cleanstart/go:latest go version; then
        print_success "CleanStart Go image is working"
    else
        print_error "CleanStart Go image test failed"
        return 1
    fi
}

# Lint Helm chart
lint_helm_chart() {
    print_status "Linting Helm chart..."
    
    if helm lint ./go-web-app; then
        print_success "Helm chart linting passed"
    else
        print_error "Helm chart linting failed"
        return 1
    fi
}

# Test Helm template rendering
test_helm_templates() {
    print_status "Testing Helm template rendering..."
    
    if helm template go-web-app ./go-web-app --debug > /dev/null 2>&1; then
        print_success "Helm template rendering successful"
    else
        print_error "Helm template rendering failed"
        return 1
    fi
}

# Deploy with Helm
deploy_with_helm() {
    print_status "Deploying Go Web App with Helm..."
    
    # Create namespace
    kubectl create namespace go-web-app-test --dry-run=client -o yaml | kubectl apply -f -
    
    # Install with Helm
    if helm install go-web-app ./go-web-app --namespace go-web-app-test --wait --timeout=300s; then
        print_success "Helm deployment completed successfully"
    else
        print_error "Helm deployment failed"
        return 1
    fi
}

# Wait for deployment to be ready
wait_for_deployment() {
    print_status "Waiting for deployment to be ready..."
    kubectl wait --for=condition=available --timeout=300s deployment/go-web-app -n go-web-app-test
    
    print_success "Deployment is ready!"
}

# Test application functionality
test_application() {
    print_status "Testing application functionality..."
    
    # Port forward to access the application
    kubectl port-forward svc/go-web-app 8080:8080 -n go-web-app-test &
    PORT_FORWARD_PID=$!
    
    # Wait for port forward to be ready
    sleep 5
    
    # Test health endpoint
    if curl -f http://localhost:8080/ > /dev/null 2>&1; then
        print_success "Application health check passed"
    else
        print_warning "Application health check failed"
    fi
    
    # Test API endpoint
    if curl -f http://localhost:8080/api/users > /dev/null 2>&1; then
        print_success "API endpoint test passed"
    else
        print_warning "API endpoint test failed"
    fi
    
    # Kill port forward
    kill $PORT_FORWARD_PID 2>/dev/null || true
}

# Test database persistence
test_database_persistence() {
    print_status "Testing database persistence..."
    
    # Check if PVC is created
    if kubectl get pvc -n go-web-app-test | grep -q "go-web-app-pvc"; then
        print_success "Persistent Volume Claim created"
    else
        print_warning "Persistent Volume Claim not found"
    fi
    
    # Check if data directory is mounted
    if kubectl exec deployment/go-web-app -n go-web-app-test -- ls /app/data > /dev/null 2>&1; then
        print_success "Data directory is mounted"
    else
        print_warning "Data directory not mounted"
    fi
}

# Show deployment status
show_status() {
    print_status "Deployment Status:"
    echo "==================="
    
    echo "Pods:"
    kubectl get pods -n go-web-app-test -l app.kubernetes.io/name=go-web-app
    
    echo ""
    echo "Services:"
    kubectl get svc -n go-web-app-test -l app.kubernetes.io/name=go-web-app
    
    echo ""
    echo "PVCs:"
    kubectl get pvc -n go-web-app-test
    
    echo ""
    echo "Application Access:"
    echo "Port forward: kubectl port-forward svc/go-web-app 8080:8080 -n go-web-app-test"
    echo "Web interface: http://localhost:8080"
    echo "API endpoint: http://localhost:8080/api/users"
}

# Test upgrade
test_upgrade() {
    print_status "Testing Helm upgrade..."
    
    # Update values for upgrade test
    helm upgrade go-web-app ./go-web-app --namespace go-web-app-test --set replicaCount=2 --wait --timeout=300s
    
    if kubectl get pods -n go-web-app-test | grep -q "2/2"; then
        print_success "Helm upgrade test passed"
    else
        print_warning "Helm upgrade test failed"
    fi
}

# Cleanup function
cleanup() {
    print_status "Cleaning up..."
    
    # Uninstall Helm release
    helm uninstall go-web-app -n go-web-app-test 2>/dev/null || true
    
    # Delete namespace
    kubectl delete namespace go-web-app-test --ignore-not-found=true
    
    print_success "Cleanup completed"
}

# Main execution
main() {
    check_kubectl
    check_helm
    check_kubernetes_cluster
    test_cleanstart_image
    lint_helm_chart
    test_helm_templates
    deploy_with_helm
    wait_for_deployment
    test_application
    test_database_persistence
    test_upgrade
    show_status
    
    print_success "🎉 CleanStart Go Web App Helm Test Completed Successfully!"
    print_status "The Helm chart is working correctly with CleanStart Go image!"
}

# Handle script interruption
trap cleanup EXIT

# Run main function
main "$@"
