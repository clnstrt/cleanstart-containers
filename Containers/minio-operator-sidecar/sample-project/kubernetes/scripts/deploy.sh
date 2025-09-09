#!/bin/bash

# MinIO Operator Sidecar Kubernetes Deployment Script
# This script deploys MinIO Operator and tenants to a Kubernetes cluster

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
    local namespace=${1:-minio-operator}
    
    print_status "Creating namespace: $namespace"
    kubectl create namespace $namespace --dry-run=client -o yaml | kubectl apply -f -
    print_success "Namespace $namespace created/verified"
}

# Deploy MinIO Operator
deploy_operator() {
    local namespace=${1:-minio-operator}
    
    print_status "Deploying MinIO Operator to namespace: $namespace"
    
    # Apply RBAC
    print_status "Creating RBAC configuration..."
    kubectl apply -f minio-operator-rbac.yaml -n $namespace
    
    # Apply Operator Deployment
    print_status "Creating MinIO Operator deployment..."
    kubectl apply -f minio-operator-deployment.yaml -n $namespace
    
    print_success "MinIO Operator deployment completed!"
}

# Deploy MinIO Tenant
deploy_tenant() {
    local namespace=${1:-minio-operator}
    local tenant_name=${2:-minio-tenant}
    
    print_status "Deploying MinIO Tenant: $tenant_name"
    
    # Apply Secret
    print_status "Creating MinIO Tenant secret..."
    kubectl apply -f minio-tenant-secret.yaml -n $namespace
    
    # Apply PVC
    print_status "Creating PersistentVolumeClaims..."
    kubectl apply -f minio-sidecar-pvc.yaml -n $namespace
    
    # Apply Tenant
    print_status "Creating MinIO Tenant..."
    kubectl apply -f minio-tenant.yaml -n $namespace
    
    # Apply Services
    print_status "Creating MinIO Tenant services..."
    kubectl apply -f minio-tenant-service.yaml -n $namespace
    
    print_success "MinIO Tenant deployment completed!"
}

# Deploy MinIO Sidecar Pattern
deploy_sidecar() {
    local namespace=${1:-minio-operator}
    
    print_status "Deploying MinIO Sidecar Pattern"
    
    # Apply ConfigMap
    print_status "Creating MinIO Sidecar configuration..."
    kubectl apply -f minio-sidecar-config.yaml -n $namespace
    
    # Apply Sidecar Deployment
    print_status "Creating application with MinIO sidecar..."
    kubectl apply -f minio-sidecar-pattern.yaml -n $namespace
    
    print_success "MinIO Sidecar Pattern deployment completed!"
}

# Deploy Monitoring
deploy_monitoring() {
    local namespace=${1:-minio-operator}
    
    print_status "Deploying MinIO Monitoring"
    
    # Apply Monitoring Configuration
    print_status "Creating monitoring configuration..."
    kubectl apply -f minio-monitoring.yaml -n $namespace
    
    print_success "MinIO Monitoring deployment completed!"
}

# Deploy Ingress
deploy_ingress() {
    local namespace=${1:-minio-operator}
    
    print_status "Deploying MinIO Ingress"
    
    # Apply Ingress
    print_status "Creating MinIO Ingress..."
    kubectl apply -f minio-tenant-ingress.yaml -n $namespace
    
    print_success "MinIO Ingress deployment completed!"
}

# Wait for deployment to be ready
wait_for_deployment() {
    local namespace=${1:-minio-operator}
    local deployment_name=${2:-minio-operator}
    
    print_status "Waiting for deployment to be ready..."
    kubectl wait --for=condition=available --timeout=300s deployment/$deployment_name -n $namespace
    
    print_success "Deployment is ready!"
}

# Wait for tenant to be ready
wait_for_tenant() {
    local namespace=${1:-minio-operator}
    local tenant_name=${2:-minio-tenant}
    
    print_status "Waiting for MinIO tenant to be ready..."
    kubectl wait --for=condition=ready --timeout=300s tenant/$tenant_name -n $namespace
    
    print_success "MinIO tenant is ready!"
}

# Show deployment status
show_status() {
    local namespace=${1:-minio-operator}
    
    print_status "MinIO Operator Status:"
    kubectl get pods -n $namespace -l app=minio-operator
    
    print_status "MinIO Tenant Status:"
    kubectl get pods -n $namespace -l app=minio
    
    print_status "MinIO Services:"
    kubectl get services -n $namespace -l app=minio
    
    print_status "MinIO Tenants:"
    kubectl get tenants -n $namespace
    
    print_status "PVCs:"
    kubectl get pvc -n $namespace
}

# Connect to MinIO
connect_to_minio() {
    local namespace=${1:-minio-operator}
    local pod_name=$(kubectl get pods -n $namespace -l app=minio -o jsonpath='{.items[0].metadata.name}')
    
    if [ -z "$pod_name" ]; then
        print_error "No MinIO pod found in namespace $namespace"
        exit 1
    fi
    
    print_status "Connecting to MinIO pod: $pod_name"
    kubectl exec -it $pod_name -n $namespace -- /bin/bash
}

# Port forward MinIO services
port_forward() {
    local namespace=${1:-minio-operator}
    
    print_status "Setting up port forwarding..."
    print_status "MinIO API: http://localhost:9000"
    print_status "MinIO Console: http://localhost:9001"
    print_status "MinIO Prometheus: http://localhost:9090"
    
    # Port forward in background
    kubectl port-forward svc/minio-tenant 9000:9000 -n $namespace &
    kubectl port-forward svc/minio-tenant-console 9001:9001 -n $namespace &
    kubectl port-forward svc/minio-tenant-prometheus 9090:9090 -n $namespace &
    
    print_success "Port forwarding started. Press Ctrl+C to stop."
    wait
}

# Clean up deployment
cleanup() {
    local namespace=${1:-minio-operator}
    
    print_warning "Cleaning up MinIO deployment in namespace: $namespace"
    
    kubectl delete -f minio-tenant-ingress.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f minio-monitoring.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f minio-sidecar-pattern.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f minio-tenant-service.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f minio-tenant.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f minio-tenant-secret.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f minio-sidecar-pvc.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f minio-sidecar-config.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f minio-operator-deployment.yaml -n $namespace --ignore-not-found=true
    kubectl delete -f minio-operator-rbac.yaml -n $namespace --ignore-not-found=true
    
    print_success "Cleanup completed!"
}

# Show help
show_help() {
    echo "MinIO Operator Sidecar Kubernetes Deployment Script"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  deploy [namespace] [tenant] [sidecar] [monitoring] [ingress]  Deploy MinIO"
    echo "  operator [namespace]                                           Deploy operator only"
    echo "  tenant [namespace] [tenant_name]                               Deploy tenant only"
    echo "  sidecar [namespace]                                            Deploy sidecar pattern"
    echo "  monitoring [namespace]                                         Deploy monitoring"
    echo "  ingress [namespace]                                            Deploy ingress"
    echo "  status [namespace]                                             Show deployment status"
    echo "  connect [namespace]                                            Connect to MinIO"
    echo "  port-forward [namespace]                                       Port forward services"
    echo "  cleanup [namespace]                                            Clean up deployment"
    echo "  help                                                           Show this help"
    echo ""
    echo "Options:"
    echo "  namespace    Kubernetes namespace (default: minio-operator)"
    echo "  tenant_name  MinIO tenant name (default: minio-tenant)"
    echo "  sidecar      Deploy sidecar pattern (true/false, default: false)"
    echo "  monitoring   Deploy monitoring (true/false, default: false)"
    echo "  ingress      Deploy ingress (true/false, default: false)"
    echo ""
    echo "Examples:"
    echo "  $0 deploy                                    # Deploy to default namespace"
    echo "  $0 deploy minio-operator minio-tenant true true true  # Deploy with all features"
    echo "  $0 operator minio-operator                   # Deploy operator only"
    echo "  $0 tenant minio-operator my-tenant           # Deploy tenant only"
    echo "  $0 status minio-operator                     # Show status"
    echo "  $0 connect minio-operator                    # Connect to MinIO"
    echo "  $0 port-forward minio-operator               # Port forward services"
    echo "  $0 cleanup minio-operator                    # Clean up"
}

# Main script logic
main() {
    case "${1:-help}" in
        deploy)
            check_kubectl
            check_cluster
            create_namespace "${2:-minio-operator}"
            deploy_operator "${2:-minio-operator}"
            wait_for_deployment "${2:-minio-operator}" "minio-operator"
            deploy_tenant "${2:-minio-operator}" "${3:-minio-tenant}"
            wait_for_tenant "${2:-minio-operator}" "${3:-minio-tenant}"
            
            if [ "${4:-false}" = "true" ]; then
                deploy_sidecar "${2:-minio-operator}"
            fi
            
            if [ "${5:-false}" = "true" ]; then
                deploy_monitoring "${2:-minio-operator}"
            fi
            
            if [ "${6:-false}" = "true" ]; then
                deploy_ingress "${2:-minio-operator}"
            fi
            
            show_status "${2:-minio-operator}"
            ;;
        operator)
            check_kubectl
            check_cluster
            create_namespace "${2:-minio-operator}"
            deploy_operator "${2:-minio-operator}"
            wait_for_deployment "${2:-minio-operator}" "minio-operator"
            show_status "${2:-minio-operator}"
            ;;
        tenant)
            check_kubectl
            deploy_tenant "${2:-minio-operator}" "${3:-minio-tenant}"
            wait_for_tenant "${2:-minio-operator}" "${3:-minio-tenant}"
            show_status "${2:-minio-operator}"
            ;;
        sidecar)
            check_kubectl
            deploy_sidecar "${2:-minio-operator}"
            show_status "${2:-minio-operator}"
            ;;
        monitoring)
            check_kubectl
            deploy_monitoring "${2:-minio-operator}"
            show_status "${2:-minio-operator}"
            ;;
        ingress)
            check_kubectl
            deploy_ingress "${2:-minio-operator}"
            show_status "${2:-minio-operator}"
            ;;
        status)
            check_kubectl
            show_status "${2:-minio-operator}"
            ;;
        connect)
            check_kubectl
            connect_to_minio "${2:-minio-operator}"
            ;;
        port-forward)
            check_kubectl
            port_forward "${2:-minio-operator}"
            ;;
        cleanup)
            check_kubectl
            cleanup "${2:-minio-operator}"
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
