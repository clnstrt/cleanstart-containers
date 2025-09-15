#!/bin/bash

# Go Web App Kubernetes Deployment Script
# This script deploys the Go web application to Kubernetes

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

# Build Docker image
build_image() {
    print_status "Building Docker image..."
    cd ../go-web
    docker build -t go-web-app:latest .
    print_success "Docker image built successfully"
    cd ../kubernetes
}

# Create namespace
create_namespace() {
    print_status "Creating namespace..."
    kubectl create namespace go-web-app --dry-run=client -o yaml | kubectl apply -f -
    print_success "Namespace created/verified"
}

# Deploy ConfigMap
deploy_configmap() {
    print_status "Deploying ConfigMap..."
    kubectl apply -f go-configmap.yaml
    print_success "ConfigMap deployed"
}

# Deploy Secrets
deploy_secrets() {
    print_status "Deploying Secrets..."
    kubectl apply -f go-secrets.yaml
    print_success "Secrets deployed"
}

# Deploy PVC
deploy_pvc() {
    print_status "Deploying PersistentVolumeClaim..."
    kubectl apply -f go-pvc.yaml
    print_success "PVC deployed"
}

# Deploy Deployment
deploy_deployment() {
    print_status "Deploying Deployment..."
    kubectl apply -f go-deployment.yaml
    print_success "Deployment deployed"
}

# Deploy Service
deploy_service() {
    print_status "Deploying Service..."
    kubectl apply -f go-service.yaml
    print_success "Service deployed"
}

# Deploy Ingress
deploy_ingress() {
    print_status "Deploying Ingress..."
    kubectl apply -f go-ingress.yaml
    print_success "Ingress deployed"
}

# Deploy HPA
deploy_hpa() {
    print_status "Deploying HorizontalPodAutoscaler..."
    kubectl apply -f go-hpa.yaml
    print_success "HPA deployed"
}

# Deploy NetworkPolicy
deploy_networkpolicy() {
    print_status "Deploying NetworkPolicy..."
    kubectl apply -f go-networkpolicy.yaml
    print_success "NetworkPolicy deployed"
}

# Wait for deployment to be ready
wait_for_deployment() {
    print_status "Waiting for deployment to be ready..."
    kubectl wait --for=condition=available --timeout=300s deployment/go-web-app
    print_success "Deployment is ready"
}

# Show deployment status
show_status() {
    print_status "Deployment Status:"
    echo ""
    kubectl get pods -l app=go-web-app
    echo ""
    kubectl get services -l app=go-web-app
    echo ""
    kubectl get ingress -l app=go-web-app
    echo ""
    kubectl get hpa -l app=go-web-app
}

# Show access information
show_access_info() {
    print_success "Deployment completed successfully!"
    echo ""
    print_status "Access Information:"
    echo "====================="
    echo ""
    echo "1. NodePort Access:"
    echo "   kubectl get nodes -o wide"
    echo "   Access via: http://<NODE_IP>:30080"
    echo ""
    echo "2. Port Forward (for local testing):"
    echo "   kubectl port-forward service/go-web-service 8080:80"
    echo "   Access via: http://localhost:8080"
    echo ""
    echo "3. Ingress Access (if ingress controller is installed):"
    echo "   Add to /etc/hosts: <INGRESS_IP> go-web.local"
    echo "   Access via: http://go-web.local"
    echo ""
    echo "4. Check logs:"
    echo "   kubectl logs -l app=go-web-app"
    echo ""
    echo "5. Scale deployment:"
    echo "   kubectl scale deployment go-web-app --replicas=5"
}

# Main deployment function
main() {
    print_status "Starting Go Web App Kubernetes Deployment"
    echo "================================================"
    echo ""
    
    check_kubectl
    check_cluster
    
    # Ask if user wants to build image
    read -p "Do you want to build the Docker image? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        build_image
    fi
    
    create_namespace
    deploy_configmap
    deploy_secrets
    deploy_pvc
    deploy_deployment
    deploy_service
    deploy_ingress
    deploy_hpa
    deploy_networkpolicy
    
    wait_for_deployment
    show_status
    show_access_info
}

# Run main function
main "$@"
