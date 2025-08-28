#!/bin/bash

# Argo Workflows Sample Project Cleanup Script
# This script cleans up the testing environment for Argo Workflows

set -e

echo "🧹 Cleaning up Argo Workflows testing environment..."

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
if ! command -v kubectl &> /dev/null; then
    print_error "kubectl is not installed or not in PATH"
    exit 1
fi

# Check if argo CLI is available
if ! command -v argo &> /dev/null; then
    print_warning "Argo CLI is not installed"
else
    print_status "Argo CLI found"
fi

# Function to safely delete resources
safe_delete() {
    local resource_type=$1
    local namespace=$2
    local name=$3
    
    if kubectl get $resource_type $name -n $namespace &> /dev/null; then
        print_status "Deleting $resource_type $name in namespace $namespace"
        kubectl delete $resource_type $name -n $namespace --ignore-not-found=true
        print_success "Deleted $resource_type $name"
    else
        print_status "$resource_type $name not found in namespace $namespace"
    fi
}

# Function to safely delete all resources of a type
safe_delete_all() {
    local resource_type=$1
    local namespace=$2
    
    print_status "Deleting all $resource_type in namespace $namespace"
    kubectl delete $resource_type --all -n $namespace --ignore-not-found=true
    print_success "Deleted all $resource_type in namespace $namespace"
}

# Clean up workflows
print_status "Cleaning up workflows..."
if command -v argo &> /dev/null; then
    # Delete all workflows in argo-test namespace
    if kubectl get namespace argo-test &> /dev/null; then
        print_status "Deleting all workflows in argo-test namespace"
        argo delete --all -n argo-test --ignore-not-found=true || true
        print_success "Deleted all workflows in argo-test namespace"
    fi
    
    # Delete all workflows in default namespace
    print_status "Deleting all workflows in default namespace"
    argo delete --all --ignore-not-found=true || true
    print_success "Deleted all workflows in default namespace"
    
    # Delete workflow templates
    print_status "Deleting workflow templates..."
    argo template delete --all --ignore-not-found=true || true
    print_success "Deleted all workflow templates"
    
    # Delete cron workflows
    print_status "Deleting cron workflows..."
    argo cron delete --all --ignore-not-found=true || true
    print_success "Deleted all cron workflows"
else
    print_warning "Argo CLI not available, using kubectl to delete workflows"
    if kubectl get namespace argo-test &> /dev/null; then
        kubectl delete workflows --all -n argo-test --ignore-not-found=true || true
        kubectl delete workflowtemplates --all -n argo-test --ignore-not-found=true || true
        kubectl delete cronworkflows --all -n argo-test --ignore-not-found=true || true
    fi
    kubectl delete workflows --all --ignore-not-found=true || true
    kubectl delete workflowtemplates --all --ignore-not-found=true || true
    kubectl delete cronworkflows --all --ignore-not-found=true || true
fi

# Clean up test namespace resources
if kubectl get namespace argo-test &> /dev/null; then
    print_status "Cleaning up argo-test namespace resources..."
    
    # Delete service accounts
    safe_delete_all "serviceaccount" "argo-test"
    
    # Delete roles and role bindings
    safe_delete_all "role" "argo-test"
    safe_delete_all "rolebinding" "argo-test"
    
    # Delete any remaining pods
    safe_delete_all "pod" "argo-test"
    
    # Delete any remaining configmaps
    safe_delete_all "configmap" "argo-test"
    
    # Delete any remaining secrets
    safe_delete_all "secret" "argo-test"
    
    print_success "Cleaned up argo-test namespace resources"
fi

# Clean up default namespace resources (if any from testing)
print_status "Cleaning up default namespace resources..."
safe_delete_all "pod" "default"
safe_delete_all "configmap" "default"
safe_delete_all "secret" "default"

# Optionally delete the test namespace
read -p "Do you want to delete the argo-test namespace? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if kubectl get namespace argo-test &> /dev/null; then
        print_status "Deleting argo-test namespace..."
        kubectl delete namespace argo-test --ignore-not-found=true
        print_success "Deleted argo-test namespace"
    else
        print_status "argo-test namespace not found"
    fi
else
    print_status "Keeping argo-test namespace"
fi

# Clean up any temporary files
print_status "Cleaning up temporary files..."
if [ -d "/tmp" ]; then
    find /tmp -name "*argo*" -type f -delete 2>/dev/null || true
    find /tmp -name "*workflow*" -type f -delete 2>/dev/null || true
    print_success "Cleaned up temporary files"
fi

# Display cleanup summary
echo ""
print_success "Cleanup completed successfully!"
echo ""
echo "📋 Cleanup Summary:"
echo "  • Workflows: Deleted"
echo "  • Workflow Templates: Deleted"
echo "  • Cron Workflows: Deleted"
echo "  • Test Resources: Cleaned"
echo "  • Temporary Files: Removed"
echo ""
echo "🔍 Verification:"
echo "  • Check workflows: argo list --all-namespaces"
echo "  • Check namespaces: kubectl get namespaces | grep argo"
echo "  • Check pods: kubectl get pods --all-namespaces | grep argo"
echo ""
