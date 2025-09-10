#!/bin/bash

# Prometheus Kubernetes Deployment Script
# This script deploys Prometheus monitoring stack to a Kubernetes cluster

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

# Create namespace
create_namespace() {
    local namespace=${1:-monitoring}
    
    print_status "Creating namespace: $namespace"
    kubectl create namespace $namespace --dry-run=client -o yaml | kubectl apply -f -
    print_success "Namespace $namespace created/verified"
}

# Deploy Prometheus
deploy_prometheus() {
    local namespace=${1:-monitoring}
    
    print_status "Deploying Prometheus to namespace: $namespace"
    
    # Apply RBAC
    print_status "Creating RBAC configuration..."
    kubectl apply -f prometheus-rbac.yaml -n $namespace
    
    # Apply PVC
    print_status "Creating PersistentVolumeClaim..."
    kubectl apply -f prometheus-pvc.yaml -n $namespace
    
    # Apply ConfigMap
    print_status "Creating Prometheus configuration..."
    kubectl apply -f prometheus-configmap.yaml -n $namespace
    
    # Apply Rules
    print_status "Creating alerting rules..."
    kubectl apply -f prometheus-rules.yaml -n $namespace
    
    # Apply Deployment
    print_status "Creating Prometheus deployment..."
    kubectl apply -f prometheus-deployment.yaml -n $namespace
    
    # Apply Service
    print_status "Creating Prometheus service..."
    kubectl apply -f prometheus-service.yaml -n $namespace
    
    print_success "Prometheus deployment completed!"
}

# Deploy Node Exporter
deploy_node_exporter() {
    local namespace=${1:-monitoring}
    
    print_status "Deploying Node Exporter..."
    
    # Apply Node Exporter
    print_status "Creating Node Exporter DaemonSet..."
    kubectl apply -f node-exporter.yaml -n $namespace
    
    print_success "Node Exporter deployment completed!"
}

# Deploy Grafana
deploy_grafana() {
    local namespace=${1:-monitoring}
    
    print_status "Deploying Grafana..."
    
    # Apply Grafana
    print_status "Creating Grafana deployment..."
    kubectl apply -f grafana-deployment.yaml -n $namespace
    
    print_success "Grafana deployment completed!"
}

# Deploy Ingress
deploy_ingress() {
    local namespace=${1:-monitoring}
    
    print_status "Deploying Ingress..."
    
    # Apply Ingress
    print_status "Creating Prometheus Ingress..."
    kubectl apply -f prometheus-ingress.yaml -n $namespace
    
    print_success "Ingress deployment completed!"
}

# Wait for deployment to be ready
wait_for_deployment() {
    local namespace=${1:-monitoring}
    local deployment_name=${2:-prometheus}
    
    print_status "Waiting for deployment to be ready..."
    kubectl wait --for=condition=available --timeout=300s deployment/$deployment_name -n $namespace
    
    print_success "Deployment is ready!"
}

# Show deployment status
show_status() {
    local namespace=${1:-monitoring}
    
    print_status "Prometheus Status:"
    kubectl get pods -n $namespace -l app=prometheus
    
    print_status "Node Exporter Status:"
    kubectl get pods -n $namespace -l app=node-exporter
    
    print_status "Grafana Status:"
    kubectl get pods -n $namespace -l app=grafana
    
    print_status "Services:"
    kubectl get services -n $namespace -l app=prometheus
    kubectl get services -n $namespace -l app=node-exporter
    kubectl get services -n $namespace -l app=grafana
    
    print_status "PVCs:"
    kubectl get pvc -n $namespace
}

# Connect to Prometheus
connect_to_prometheus() {
    local namespace=${1:-monitoring}
    local pod_name=$(kubectl get pods -n $namespace -l app=prometheus -o jsonpath='{.items[0].metadata.name}')
    
    if [ -z "$pod_name" ]; then
        print_error "No Prometheus pod found in namespace $namespace"
        exit 1
    fi
    
    print_status "Connecting to Prometheus pod: $pod_name"
    kubectl exec -it $pod_name -n $namespace -- /bin/sh
}

# Port forward services
port_forward() {
    local namespace=${1:-monitoring}
    
    print_status "Setting up port forwarding..."
    print_status "Prometheus: http://localhost:9090"
    print_status "Grafana: http://localhost:3000 (admin/admin)"
    print_status "Node Exporter: http://localhost:9100"
    
    # Port forward in background
    kubectl port-forward svc/prometheus-service 9090:9090 -n $namespace &
    kubectl port-forward svc/grafana 3000:3000 -n $namespace &
    kubectl port-forward svc/node-exporter 9100:9100 -n $namespace &
    
    print_success "Port forwarding started. Press Ctrl+C to stop."
    wait
}

# Test Prometheus
test_prometheus() {
    local namespace=${1:-monitoring}
    
    print_status "Testing Prometheus..."
    
    # Test Prometheus health
    if kubectl exec -n $namespace deployment/prometheus -- wget -qO- http://localhost:9090/-/healthy; then
        print_success "Prometheus health check passed"
    else
        print_error "Prometheus health check failed"
        return 1
    fi
    
    # Test metrics endpoint
    if kubectl exec -n $namespace deployment/prometheus -- wget -qO- http://localhost:9090/metrics | grep -q "prometheus_"; then
        print_success "Prometheus metrics endpoint working"
    else
        print_error "Prometheus metrics endpoint not working"
        return 1
    fi
    
    # Test targets
    if kubectl exec -n $namespace deployment/prometheus -- wget -qO- http://localhost:9090/api/v1/targets | grep -q "up"; then
        print_success "Prometheus targets discovered"
    else
        print_warning "No targets discovered yet"
    fi
}

# Clean up deployment
cleanup() {
    local namespace=${1:-monitoring}
    
    print_warning "Cleaning up Prometheus deployment in namespace: $namespace"
    
    kubectl delete -f prometheus-ingress.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f grafana-deployment.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f node-exporter.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f prometheus-service.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f prometheus-deployment.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f prometheus-rules.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f prometheus-configmap.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f prometheus-pvc.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f prometheus-rbac.yaml -n $namespace --ignore-not-found=true
    
    print_success "Cleanup completed!"
}

# Show help
show_help() {
    echo "Prometheus Kubernetes Deployment Script"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  deploy [namespace] [node-exporter] [grafana] [ingress]  Deploy Prometheus"
    echo "  prometheus [namespace]                                  Deploy Prometheus only"
    echo "  node-exporter [namespace]                               Deploy Node Exporter only"
    echo "  grafana [namespace]                                     Deploy Grafana only"
    echo "  ingress [namespace]                                     Deploy Ingress only"
    echo "  status [namespace]                                      Show deployment status"
    echo "  connect [namespace]                                     Connect to Prometheus"
    echo "  port-forward [namespace]                                Port forward services"
    echo "  test [namespace]                                        Test Prometheus"
    echo "  cleanup [namespace]                                     Clean up deployment"
    echo "  help                                                    Show this help"
    echo ""
    echo "Options:"
    echo "  namespace        Kubernetes namespace (default: monitoring)"
    echo "  node-exporter    Deploy Node Exporter (true/false, default: false)"
    echo "  grafana          Deploy Grafana (true/false, default: false)"
    echo "  ingress          Deploy Ingress (true/false, default: false)"
    echo ""
    echo "Examples:"
    echo "  $0 deploy                                    # Deploy to default namespace"
    echo "  $0 deploy monitoring true true true         # Deploy with all features"
    echo "  $0 prometheus monitoring                     # Deploy Prometheus only"
    echo "  $0 status monitoring                         # Show status"
    echo "  $0 connect monitoring                        # Connect to Prometheus"
    echo "  $0 port-forward monitoring                   # Port forward services"
    echo "  $0 test monitoring                           # Test Prometheus"
    echo "  $0 cleanup monitoring                        # Clean up"
}

# Main script logic
main() {
    case "${1:-help}" in
        deploy)
            check_kubectl
            check_cluster
            create_namespace "${2:-monitoring}"
            deploy_prometheus "${2:-monitoring}"
            wait_for_deployment "${2:-monitoring}" "prometheus"
            
            if [ "${3:-false}" = "true" ]; then
                deploy_node_exporter "${2:-monitoring}"
            fi
            
            if [ "${4:-false}" = "true" ]; then
                deploy_grafana "${2:-monitoring}"
            fi
            
            if [ "${5:-false}" = "true" ]; then
                deploy_ingress "${2:-monitoring}"
            fi
            
            show_status "${2:-monitoring}"
            test_prometheus "${2:-monitoring}"
            ;;
        prometheus)
            check_kubectl
            check_cluster
            create_namespace "${2:-monitoring}"
            deploy_prometheus "${2:-monitoring}"
            wait_for_deployment "${2:-monitoring}" "prometheus"
            show_status "${2:-monitoring}"
            ;;
        node-exporter)
            check_kubectl
            deploy_node_exporter "${2:-monitoring}"
            show_status "${2:-monitoring}"
            ;;
        grafana)
            check_kubectl
            deploy_grafana "${2:-monitoring}"
            show_status "${2:-monitoring}"
            ;;
        ingress)
            check_kubectl
            deploy_ingress "${2:-monitoring}"
            show_status "${2:-monitoring}"
            ;;
        status)
            check_kubectl
            show_status "${2:-monitoring}"
            ;;
        connect)
            check_kubectl
            connect_to_prometheus "${2:-monitoring}"
            ;;
        port-forward)
            check_kubectl
            port_forward "${2:-monitoring}"
            ;;
        test)
            check_kubectl
            test_prometheus "${2:-monitoring}"
            ;;
        cleanup)
            check_kubectl
            cleanup "${2:-monitoring}"
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
