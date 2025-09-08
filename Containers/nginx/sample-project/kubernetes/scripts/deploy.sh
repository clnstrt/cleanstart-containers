#!/bin/bash

# Nginx Kubernetes Deployment Script
# This script deploys Nginx applications to Kubernetes

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

# Function to check if kubectl is available
check_kubectl() {
    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl is not installed or not in PATH"
        exit 1
    fi
    print_success "kubectl is available"
}

# Function to check if cluster is accessible
check_cluster() {
    if ! kubectl cluster-info &> /dev/null; then
        print_error "Cannot connect to Kubernetes cluster"
        exit 1
    fi
    print_success "Connected to Kubernetes cluster"
}

# Function to deploy basic Nginx
deploy_basic() {
    print_status "Deploying basic Nginx application..."
    
    kubectl apply -f nginx-deployment.yaml
    kubectl apply -f nginx-service.yaml
    kubectl apply -f nginx-configmap.yaml
    
    print_success "Basic Nginx deployment completed"
}

# Function to deploy with ingress
deploy_with_ingress() {
    print_status "Deploying Nginx with Ingress..."
    
    deploy_basic
    kubectl apply -f nginx-ingress.yaml
    
    print_success "Nginx with Ingress deployment completed"
}

# Function to deploy with HPA
deploy_with_hpa() {
    print_status "Deploying Nginx with HPA..."
    
    deploy_basic
    kubectl apply -f nginx-hpa.yaml
    
    print_success "Nginx with HPA deployment completed"
}

# Function to deploy reverse proxy
deploy_reverse_proxy() {
    print_status "Deploying Nginx reverse proxy..."
    
    kubectl apply -f reverse-proxy/nginx-reverse-proxy.yaml
    
    print_success "Nginx reverse proxy deployment completed"
}

# Function to deploy load balancer
deploy_load_balancer() {
    print_status "Deploying Nginx load balancer..."
    
    kubectl apply -f load-balancer/backend-deployments.yaml
    kubectl apply -f load-balancer/nginx-lb.yaml
    
    print_success "Nginx load balancer deployment completed"
}

# Function to deploy production setup
deploy_production() {
    print_status "Deploying production setup..."
    
    deploy_basic
    kubectl apply -f nginx-ingress.yaml
    kubectl apply -f nginx-hpa.yaml
    
    print_success "Production setup deployment completed"
}

# Function to check deployment status
check_status() {
    print_status "Checking deployment status..."
    
    echo "Deployments:"
    kubectl get deployments -l app=nginx-app
    
    echo -e "\nServices:"
    kubectl get services -l app=nginx-app
    
    echo -e "\nPods:"
    kubectl get pods -l app=nginx-app
    
    echo -e "\nIngress:"
    kubectl get ingress -l app=nginx-app 2>/dev/null || echo "No ingress found"
    
    echo -e "\nHPA:"
    kubectl get hpa -l app=nginx-app 2>/dev/null || echo "No HPA found"
}

# Function to show access information
show_access_info() {
    print_status "Access information:"
    
    # Get service information
    SERVICE_IP=$(kubectl get service nginx-service -o jsonpath='{.spec.clusterIP}' 2>/dev/null || echo "N/A")
    SERVICE_PORT=$(kubectl get service nginx-service -o jsonpath='{.spec.ports[0].port}' 2>/dev/null || echo "N/A")
    
    echo "Service: nginx-service"
    echo "Cluster IP: $SERVICE_IP"
    echo "Port: $SERVICE_PORT"
    
    # Port forward command
    echo -e "\nTo access the application locally:"
    echo "kubectl port-forward svc/nginx-service 8080:80"
    echo "Then open: http://localhost:8080"
    
    # Ingress information
    INGRESS_HOST=$(kubectl get ingress nginx-ingress -o jsonpath='{.spec.rules[0].host}' 2>/dev/null || echo "N/A")
    if [ "$INGRESS_HOST" != "N/A" ]; then
        echo -e "\nIngress Host: $INGRESS_HOST"
    fi
}

# Function to run health checks
run_health_checks() {
    print_status "Running health checks..."
    
    # Wait for pods to be ready
    kubectl wait --for=condition=ready pod -l app=nginx-app --timeout=300s
    
    # Get a pod name
    POD_NAME=$(kubectl get pods -l app=nginx-app -o jsonpath='{.items[0].metadata.name}')
    
    if [ -n "$POD_NAME" ]; then
        print_status "Testing health endpoint on pod: $POD_NAME"
        kubectl exec $POD_NAME -- curl -f http://localhost/health || print_warning "Health check failed"
    fi
    
    print_success "Health checks completed"
}

# Function to show logs
show_logs() {
    print_status "Showing application logs..."
    kubectl logs -l app=nginx-app --tail=50
}

# Function to clean up
cleanup() {
    print_status "Cleaning up deployments..."
    
    kubectl delete -f nginx-deployment.yaml --ignore-not-found=true
    kubectl delete -f nginx-service.yaml --ignore-not-found=true
    kubectl delete -f nginx-configmap.yaml --ignore-not-found=true
    kubectl delete -f nginx-ingress.yaml --ignore-not-found=true
    kubectl delete -f nginx-hpa.yaml --ignore-not-found=true
    kubectl delete -f reverse-proxy/nginx-reverse-proxy.yaml --ignore-not-found=true
    kubectl delete -f load-balancer/nginx-lb.yaml --ignore-not-found=true
    kubectl delete -f load-balancer/backend-deployments.yaml --ignore-not-found=true
    
    print_success "Cleanup completed"
}

# Main script logic
main() {
    echo "Nginx Kubernetes Deployment Script"
    echo "=================================="
    
    # Check prerequisites
    check_kubectl
    check_cluster
    
    # Parse command line arguments
    case "${1:-basic}" in
        "basic")
            deploy_basic
            ;;
        "ingress")
            deploy_with_ingress
            ;;
        "hpa")
            deploy_with_hpa
            ;;
        "reverse-proxy")
            deploy_reverse_proxy
            ;;
        "load-balancer")
            deploy_load_balancer
            ;;
        "production")
            deploy_production
            ;;
        "status")
            check_status
            ;;
        "access")
            show_access_info
            ;;
        "health")
            run_health_checks
            ;;
        "logs")
            show_logs
            ;;
        "cleanup")
            cleanup
            ;;
        "help"|"-h"|"--help")
            echo "Usage: $0 [command]"
            echo ""
            echo "Commands:"
            echo "  basic          Deploy basic Nginx application (default)"
            echo "  ingress        Deploy with Ingress"
            echo "  hpa            Deploy with Horizontal Pod Autoscaler"
            echo "  reverse-proxy  Deploy reverse proxy setup"
            echo "  load-balancer  Deploy load balancer setup"
            echo "  production     Deploy production setup"
            echo "  status         Check deployment status"
            echo "  access         Show access information"
            echo "  health         Run health checks"
            echo "  logs           Show application logs"
            echo "  cleanup        Remove all deployments"
            echo "  help           Show this help message"
            ;;
        *)
            print_error "Unknown command: $1"
            echo "Use '$0 help' for available commands"
            exit 1
            ;;
    esac
    
    if [ "$1" != "status" ] && [ "$1" != "access" ] && [ "$1" != "health" ] && [ "$1" != "logs" ] && [ "$1" != "cleanup" ] && [ "$1" != "help" ]; then
        echo ""
        check_status
        echo ""
        show_access_info
    fi
}

# Run main function with all arguments
main "$@"
