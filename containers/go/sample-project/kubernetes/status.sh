#!/bin/bash

# Go Web App Kubernetes Status Script
# This script shows the status of the Go web application in Kubernetes

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_header() {
    echo -e "${CYAN}================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}================================${NC}"
}

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
}

# Check if cluster is accessible
check_cluster() {
    if ! kubectl cluster-info &> /dev/null; then
        print_error "Cannot connect to Kubernetes cluster. Please check your kubeconfig."
        exit 1
    fi
}

# Show cluster information
show_cluster_info() {
    print_header "CLUSTER INFORMATION"
    kubectl cluster-info
    echo ""
    kubectl get nodes
    echo ""
}

# Show namespace information
show_namespace_info() {
    print_header "NAMESPACE INFORMATION"
    kubectl get namespaces | grep -E "(NAME|go-web-app|default)"
    echo ""
}

# Show pod information
show_pod_info() {
    print_header "POD INFORMATION"
    kubectl get pods -l app=go-web-app -o wide
    echo ""
    
    # Show pod details
    PODS=$(kubectl get pods -l app=go-web-app --no-headers 2>/dev/null | wc -l)
    if [ "$PODS" -gt 0 ]; then
        print_status "Pod Details:"
        kubectl describe pods -l app=go-web-app
        echo ""
    else
        print_warning "No pods found for go-web-app"
    fi
}

# Show service information
show_service_info() {
    print_header "SERVICE INFORMATION"
    kubectl get services -l app=go-web-app
    echo ""
    
    # Show service details
    SERVICES=$(kubectl get services -l app=go-web-app --no-headers 2>/dev/null | wc -l)
    if [ "$SERVICES" -gt 0 ]; then
        print_status "Service Details:"
        kubectl describe services -l app=go-web-app
        echo ""
    else
        print_warning "No services found for go-web-app"
    fi
}

# Show ingress information
show_ingress_info() {
    print_header "INGRESS INFORMATION"
    kubectl get ingress -l app=go-web-app
    echo ""
    
    # Show ingress details
    INGRESS=$(kubectl get ingress -l app=go-web-app --no-headers 2>/dev/null | wc -l)
    if [ "$INGRESS" -gt 0 ]; then
        print_status "Ingress Details:"
        kubectl describe ingress -l app=go-web-app
        echo ""
    else
        print_warning "No ingress found for go-web-app"
    fi
}

# Show HPA information
show_hpa_info() {
    print_header "HORIZONTAL POD AUTOSCALER INFORMATION"
    kubectl get hpa -l app=go-web-app
    echo ""
    
    # Show HPA details
    HPA=$(kubectl get hpa -l app=go-web-app --no-headers 2>/dev/null | wc -l)
    if [ "$HPA" -gt 0 ]; then
        print_status "HPA Details:"
        kubectl describe hpa -l app=go-web-app
        echo ""
    else
        print_warning "No HPA found for go-web-app"
    fi
}

# Show PVC information
show_pvc_info() {
    print_header "PERSISTENT VOLUME CLAIM INFORMATION"
    kubectl get pvc -l app=go-web-app
    echo ""
    
    # Show PVC details
    PVCS=$(kubectl get pvc -l app=go-web-app --no-headers 2>/dev/null | wc -l)
    if [ "$PVCS" -gt 0 ]; then
        print_status "PVC Details:"
        kubectl describe pvc -l app=go-web-app
        echo ""
    else
        print_warning "No PVCs found for go-web-app"
    fi
}

# Show ConfigMap information
show_configmap_info() {
    print_header "CONFIGMAP INFORMATION"
    kubectl get configmap -l app=go-web-app
    echo ""
    
    # Show ConfigMap details
    CONFIGMAPS=$(kubectl get configmap -l app=go-web-app --no-headers 2>/dev/null | wc -l)
    if [ "$CONFIGMAPS" -gt 0 ]; then
        print_status "ConfigMap Details:"
        kubectl describe configmap -l app=go-web-app
        echo ""
    else
        print_warning "No ConfigMaps found for go-web-app"
    fi
}

# Show Secret information
show_secret_info() {
    print_header "SECRET INFORMATION"
    kubectl get secret -l app=go-web-app
    echo ""
    
    # Show Secret details (without values)
    SECRETS=$(kubectl get secret -l app=go-web-app --no-headers 2>/dev/null | wc -l)
    if [ "$SECRETS" -gt 0 ]; then
        print_status "Secret Details:"
        kubectl describe secret -l app=go-web-app
        echo ""
    else
        print_warning "No Secrets found for go-web-app"
    fi
}

# Show NetworkPolicy information
show_networkpolicy_info() {
    print_header "NETWORK POLICY INFORMATION"
    kubectl get networkpolicy -l app=go-web-app
    echo ""
    
    # Show NetworkPolicy details
    POLICIES=$(kubectl get networkpolicy -l app=go-web-app --no-headers 2>/dev/null | wc -l)
    if [ "$POLICIES" -gt 0 ]; then
        print_status "NetworkPolicy Details:"
        kubectl describe networkpolicy -l app=go-web-app
        echo ""
    else
        print_warning "No NetworkPolicies found for go-web-app"
    fi
}

# Show logs
show_logs() {
    print_header "APPLICATION LOGS"
    PODS=$(kubectl get pods -l app=go-web-app --no-headers 2>/dev/null | wc -l)
    if [ "$PODS" -gt 0 ]; then
        print_status "Recent logs from all pods:"
        kubectl logs -l app=go-web-app --tail=50
        echo ""
    else
        print_warning "No pods found to show logs"
    fi
}

# Show access information
show_access_info() {
    print_header "ACCESS INFORMATION"
    
    # Check for NodePort service
    NODEPORT=$(kubectl get service go-web-service-nodeport --no-headers 2>/dev/null | awk '{print $5}' | cut -d: -f2 | cut -d/ -f1)
    if [ ! -z "$NODEPORT" ]; then
        print_status "NodePort Access:"
        echo "  kubectl get nodes -o wide"
        echo "  Access via: http://<NODE_IP>:$NODEPORT"
        echo ""
    fi
    
    # Check for ClusterIP service
    CLUSTERIP=$(kubectl get service go-web-service --no-headers 2>/dev/null | awk '{print $3}')
    if [ ! -z "$CLUSTERIP" ]; then
        print_status "Port Forward Access:"
        echo "  kubectl port-forward service/go-web-service 8080:80"
        echo "  Access via: http://localhost:8080"
        echo ""
    fi
    
    # Check for Ingress
    INGRESS_HOST=$(kubectl get ingress -l app=go-web-app --no-headers 2>/dev/null | awk '{print $2}')
    if [ ! -z "$INGRESS_HOST" ] && [ "$INGRESS_HOST" != "<none>" ]; then
        print_status "Ingress Access:"
        echo "  Access via: http://$INGRESS_HOST"
        echo ""
    fi
}

# Show resource usage
show_resource_usage() {
    print_header "RESOURCE USAGE"
    kubectl top pods -l app=go-web-app 2>/dev/null || print_warning "Metrics server not available"
    echo ""
}

# Main status function
main() {
    print_header "GO WEB APP KUBERNETES STATUS"
    echo ""
    
    check_kubectl
    check_cluster
    
    show_cluster_info
    show_namespace_info
    show_pod_info
    show_service_info
    show_ingress_info
    show_hpa_info
    show_pvc_info
    show_configmap_info
    show_secret_info
    show_networkpolicy_info
    show_logs
    show_access_info
    show_resource_usage
    
    print_success "Status check completed!"
}

# Run main function
main "$@"
