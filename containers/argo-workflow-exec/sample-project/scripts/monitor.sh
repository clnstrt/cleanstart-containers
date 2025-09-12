#!/bin/bash

# Argo Workflows Sample Project Monitoring Script
# This script provides monitoring and status information for Argo Workflows

set -e

echo "📊 Argo Workflows Monitoring Dashboard"
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_header() {
    echo -e "${PURPLE}$1${NC}"
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

print_metric() {
    echo -e "${CYAN}$1${NC}"
}

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    print_error "kubectl is not installed or not in PATH"
    exit 1
fi

# Check if argo CLI is available
if ! command -v argo &> /dev/null; then
    print_warning "Argo CLI is not installed - some features will be limited"
    ARGO_AVAILABLE=false
else
    ARGO_AVAILABLE=true
fi

# Function to get cluster info
get_cluster_info() {
    print_header "🌐 Cluster Information"
    
    if kubectl cluster-info &> /dev/null; then
        CLUSTER_NAME=$(kubectl config current-context 2>/dev/null || echo "unknown")
        print_metric "Cluster Context: $CLUSTER_NAME"
        
        KUBECTL_VERSION=$(kubectl version --client --short 2>/dev/null | cut -d' ' -f3)
        print_metric "kubectl Version: $KUBECTL_VERSION"
        
        if [ "$ARGO_AVAILABLE" = true ]; then
            ARGO_VERSION=$(argo version --short 2>/dev/null | head -n1)
            print_metric "Argo CLI Version: $ARGO_VERSION"
        fi
    else
        print_error "Cannot connect to Kubernetes cluster"
        return 1
    fi
    echo ""
}

# Function to check Argo Workflows installation
check_argo_installation() {
    print_header "🔧 Argo Workflows Installation Status"
    
    if kubectl get namespace argo &> /dev/null; then
        print_success "Argo Workflows namespace exists"
        
        # Check Argo Workflows pods
        if kubectl get pods -n argo &> /dev/null; then
            PODS_READY=$(kubectl get pods -n argo --no-headers 2>/dev/null | grep -c "Running" || echo "0")
            PODS_TOTAL=$(kubectl get pods -n argo --no-headers 2>/dev/null | wc -l || echo "0")
            PODS_FAILED=$(kubectl get pods -n argo --no-headers 2>/dev/null | grep -c "Failed\|Error" || echo "0")
            
            print_metric "Pods Status: $PODS_READY/$PODS_TOTAL Running, $PODS_FAILED Failed"
            
            if [ "$PODS_FAILED" -gt 0 ]; then
                print_warning "Some Argo Workflows pods are in failed state"
                kubectl get pods -n argo | grep -E "(Failed|Error)" || true
            fi
        else
            print_warning "Could not check Argo Workflows pods"
        fi
        
        # Check Argo Workflows services
        if kubectl get services -n argo &> /dev/null; then
            SERVICES=$(kubectl get services -n argo --no-headers 2>/dev/null | wc -l || echo "0")
            print_metric "Services: $SERVICES running"
        fi
    else
        print_error "Argo Workflows namespace not found"
        print_status "Argo Workflows may not be installed"
    fi
    echo ""
}

# Function to monitor workflows
monitor_workflows() {
    print_header "🚀 Workflow Status"
    
    if [ "$ARGO_AVAILABLE" = true ]; then
        # Get workflow statistics
        TOTAL_WORKFLOWS=$(argo list --all-namespaces --no-headers 2>/dev/null | wc -l || echo "0")
        RUNNING_WORKFLOWS=$(argo list --all-namespaces --no-headers 2>/dev/null | grep -c "Running" || echo "0")
        COMPLETED_WORKFLOWS=$(argo list --all-namespaces --no-headers 2>/dev/null | grep -c "Succeeded" || echo "0")
        FAILED_WORKFLOWS=$(argo list --all-namespaces --no-headers 2>/dev/null | grep -c "Failed" || echo "0")
        
        print_metric "Total Workflows: $TOTAL_WORKFLOWS"
        print_metric "Running: $RUNNING_WORKFLOWS"
        print_metric "Completed: $COMPLETED_WORKFLOWS"
        print_metric "Failed: $FAILED_WORKFLOWS"
        
        if [ "$TOTAL_WORKFLOWS" -gt 0 ]; then
            echo ""
            print_status "Recent Workflows:"
            argo list --all-namespaces --limit 5 2>/dev/null || print_warning "Could not list workflows"
        fi
        
        # Check workflow templates
        TEMPLATES=$(argo template list --all-namespaces --no-headers 2>/dev/null | wc -l || echo "0")
        print_metric "Workflow Templates: $TEMPLATES"
        
        # Check cron workflows
        CRON_WORKFLOWS=$(argo cron list --all-namespaces --no-headers 2>/dev/null | wc -l || echo "0")
        print_metric "Cron Workflows: $CRON_WORKFLOWS"
    else
        print_warning "Argo CLI not available - using kubectl"
        
        # Use kubectl to get workflow information
        TOTAL_WORKFLOWS=$(kubectl get workflows --all-namespaces --no-headers 2>/dev/null | wc -l || echo "0")
        RUNNING_WORKFLOWS=$(kubectl get workflows --all-namespaces --no-headers 2>/dev/null | grep -c "Running" || echo "0")
        COMPLETED_WORKFLOWS=$(kubectl get workflows --all-namespaces --no-headers 2>/dev/null | grep -c "Succeeded" || echo "0")
        FAILED_WORKFLOWS=$(kubectl get workflows --all-namespaces --no-headers 2>/dev/null | grep -c "Failed" || echo "0")
        
        print_metric "Total Workflows: $TOTAL_WORKFLOWS"
        print_metric "Running: $RUNNING_WORKFLOWS"
        print_metric "Completed: $COMPLETED_WORKFLOWS"
        print_metric "Failed: $FAILED_WORKFLOWS"
    fi
    echo ""
}

# Function to check resource usage
check_resource_usage() {
    print_header "📈 Resource Usage"
    
    # Check if metrics-server is available
    if kubectl top nodes &> /dev/null 2>&1; then
        print_status "Node Resource Usage:"
        kubectl top nodes --no-headers 2>/dev/null | head -3 || print_warning "Could not get node metrics"
        
        echo ""
        print_status "Pod Resource Usage (Argo namespace):"
        if kubectl get namespace argo &> /dev/null; then
            kubectl top pods -n argo --no-headers 2>/dev/null | head -5 || print_warning "Could not get pod metrics"
        else
            print_warning "Argo namespace not found"
        fi
    else
        print_warning "Metrics server not available - resource usage not available"
    fi
    echo ""
}

# Function to check events
check_events() {
    print_header "📋 Recent Events"
    
    if [ "$ARGO_AVAILABLE" = true ]; then
        # Get recent workflow events
        print_status "Recent Workflow Events:"
        argo get @latest --events 2>/dev/null | head -10 || print_warning "No recent workflow events"
    else
        # Use kubectl to get events
        print_status "Recent Cluster Events:"
        kubectl get events --all-namespaces --sort-by='.lastTimestamp' 2>/dev/null | tail -10 || print_warning "Could not get events"
    fi
    echo ""
}

# Function to check test namespace
check_test_namespace() {
    print_header "🧪 Test Environment"
    
    if kubectl get namespace argo-test &> /dev/null; then
        print_success "Test namespace 'argo-test' exists"
        
        # Check resources in test namespace
        PODS=$(kubectl get pods -n argo-test --no-headers 2>/dev/null | wc -l || echo "0")
        WORKFLOWS=$(kubectl get workflows -n argo-test --no-headers 2>/dev/null | wc -l || echo "0")
        TEMPLATES=$(kubectl get workflowtemplates -n argo-test --no-headers 2>/dev/null | wc -l || echo "0")
        
        print_metric "Test Pods: $PODS"
        print_metric "Test Workflows: $WORKFLOWS"
        print_metric "Test Templates: $TEMPLATES"
        
        if [ "$WORKFLOWS" -gt 0 ]; then
            echo ""
            print_status "Test Workflows:"
            kubectl get workflows -n argo-test 2>/dev/null || true
        fi
    else
        print_warning "Test namespace 'argo-test' not found"
        print_status "Run setup.sh to create test environment"
    fi
    echo ""
}

# Function to show quick actions
show_quick_actions() {
    print_header "⚡ Quick Actions"
    
    echo "1. List all workflows:"
    print_metric "   argo list --all-namespaces"
    echo ""
    
    echo "2. Watch latest workflow:"
    print_metric "   argo watch @latest"
    echo ""
    
    echo "3. Submit test workflow:"
    print_metric "   argo submit basic-workflows/hello-world.yaml -n argo-test"
    echo ""
    
    echo "4. Get workflow logs:"
    print_metric "   argo logs @latest"
    echo ""
    
    echo "5. Check Argo server status:"
    print_metric "   kubectl get pods -n argo"
    echo ""
    
    echo "6. Port forward to Argo UI:"
    print_metric "   kubectl port-forward svc/argo-server -n argo 2746:2746"
    echo ""
}

# Main monitoring function
main() {
    get_cluster_info
    check_argo_installation
    monitor_workflows
    check_resource_usage
    check_events
    check_test_namespace
    show_quick_actions
    
    print_header "📊 Monitoring Complete"
    print_status "Run this script periodically to monitor your Argo Workflows environment"
    print_status "For detailed logs, use: argo logs <workflow-name>"
    print_status "For real-time monitoring, use: argo watch @latest"
}

# Run main function
main
