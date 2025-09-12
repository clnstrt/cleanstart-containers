#!/bin/bash

# Velero Cleanup Script for Sample Application
# This script removes the sample application and related resources

set -e

# Configuration
NAMESPACE="sample-app"
CLEANUP_BACKUPS=false
CLEANUP_RESTORES=false
CLEANUP_ALL=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log "Checking prerequisites..."
    
    # Check if kubectl is available
    if ! command -v kubectl &> /dev/null; then
        error "kubectl is not installed or not in PATH"
        exit 1
    fi
    
    # Check if velero is available
    if ! command -v velero &> /dev/null; then
        error "velero CLI is not installed or not in PATH"
        exit 1
    fi
    
    success "Prerequisites check passed"
}

# Show current resources
show_current_resources() {
    log "Current resources in namespace: $NAMESPACE"
    
    if kubectl get namespace $NAMESPACE &> /dev/null; then
        echo "Namespace exists. Current resources:"
        kubectl get all -n $NAMESPACE 2>/dev/null || echo "No resources found"
        
        echo ""
        echo "Persistent Volume Claims:"
        kubectl get pvc -n $NAMESPACE 2>/dev/null || echo "No PVCs found"
        
        echo ""
        echo "ConfigMaps:"
        kubectl get configmaps -n $NAMESPACE 2>/dev/null || echo "No ConfigMaps found"
        
        echo ""
        echo "Secrets:"
        kubectl get secrets -n $NAMESPACE 2>/dev/null || echo "No Secrets found"
    else
        log "Namespace $NAMESPACE does not exist"
    fi
}

# Cleanup namespace resources
cleanup_namespace() {
    if kubectl get namespace $NAMESPACE &> /dev/null; then
        log "Cleaning up namespace: $NAMESPACE"
        
        # Delete all resources in the namespace
        kubectl delete all --all -n $NAMESPACE --ignore-not-found=true
        
        # Delete PVCs
        kubectl delete pvc --all -n $NAMESPACE --ignore-not-found=true
        
        # Delete ConfigMaps
        kubectl delete configmap --all -n $NAMESPACE --ignore-not-found=true
        
        # Delete Secrets
        kubectl delete secret --all -n $NAMESPACE --ignore-not-found=true
        
        # Delete Ingress
        kubectl delete ingress --all -n $NAMESPACE --ignore-not-found=true
        
        # Delete the namespace itself
        kubectl delete namespace $NAMESPACE --ignore-not-found=true
        
        success "Namespace $NAMESPACE cleaned up successfully"
    else
        log "Namespace $NAMESPACE does not exist - nothing to clean up"
    fi
}

# Cleanup Velero backups
cleanup_backups() {
    if [ "$CLEANUP_BACKUPS" = true ] || [ "$CLEANUP_ALL" = true ]; then
        log "Cleaning up Velero backups for namespace: $NAMESPACE"
        
        # Get backups for the namespace
        BACKUPS=$(velero backup get --output json | jq -r ".items[] | select(.Spec.IncludedNamespaces[] == \"$NAMESPACE\") | .Metadata.Name" 2>/dev/null || echo "")
        
        if [ -n "$BACKUPS" ]; then
            echo "Found backups to delete:"
            echo "$BACKUPS"
            
            read -p "Do you want to delete these backups? This action cannot be undone. (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                for backup in $BACKUPS; do
                    log "Deleting backup: $backup"
                    velero backup delete $backup --confirm
                done
                success "All backups deleted successfully"
            else
                log "Backup deletion cancelled by user"
            fi
        else
            log "No backups found for namespace: $NAMESPACE"
        fi
    fi
}

# Cleanup Velero restores
cleanup_restores() {
    if [ "$CLEANUP_RESTORES" = true ] || [ "$CLEANUP_ALL" = true ]; then
        log "Cleaning up Velero restores for namespace: $NAMESPACE"
        
        # Get restores for the namespace
        RESTORES=$(velero restore get --output json | jq -r ".items[] | select(.Spec.IncludedNamespaces[] == \"$NAMESPACE\") | .Metadata.Name" 2>/dev/null || echo "")
        
        if [ -n "$RESTORES" ]; then
            echo "Found restores to delete:"
            echo "$RESTORES"
            
            read -p "Do you want to delete these restores? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                for restore in $RESTORES; do
                    log "Deleting restore: $restore"
                    velero restore delete $restore --confirm
                done
                success "All restores deleted successfully"
            else
                log "Restore deletion cancelled by user"
            fi
        else
            log "No restores found for namespace: $NAMESPACE"
        fi
    fi
}

# Verify cleanup
verify_cleanup() {
    log "Verifying cleanup..."
    
    # Check if namespace still exists
    if kubectl get namespace $NAMESPACE &> /dev/null; then
        warning "Namespace $NAMESPACE still exists"
        return 1
    else
        success "Namespace $NAMESPACE successfully removed"
    fi
    
    # Check if any resources remain
    REMAINING_RESOURCES=$(kubectl get all --all-namespaces -l app=sample-app 2>/dev/null | wc -l || echo "0")
    
    if [ "$REMAINING_RESOURCES" -gt 0 ]; then
        warning "Some resources with app=sample-app label still exist:"
        kubectl get all --all-namespaces -l app=sample-app
    else
        success "All sample-app resources successfully removed"
    fi
}

# Show cleanup summary
show_summary() {
    log "Cleanup Summary:"
    echo "Namespace cleaned: $NAMESPACE"
    echo "Backups cleaned: $([ "$CLEANUP_BACKUPS" = true ] && echo "Yes" || echo "No")"
    echo "Restores cleaned: $([ "$CLEANUP_RESTORES" = true ] && echo "Yes" || echo "No")"
    echo "Full cleanup: $([ "$CLEANUP_ALL" = true ] && echo "Yes" || echo "No")"
}

# Main execution
main() {
    echo "=========================================="
    echo "Velero Cleanup Script for Sample Application"
    echo "=========================================="
    echo ""
    
    check_prerequisites
    show_current_resources
    
    echo ""
    read -p "Do you want to proceed with cleanup? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "Cleanup cancelled by user"
        exit 0
    fi
    
    cleanup_namespace
    cleanup_backups
    cleanup_restores
    verify_cleanup
    show_summary
    
    echo ""
    success "Cleanup process completed successfully!"
    echo ""
    echo "To redeploy the sample application:"
    echo "kubectl apply -f manifests/sample-app.yaml"
}

# Handle script arguments
case "${1:-}" in
    --help|-h)
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --help, -h        Show this help message"
        echo "  --backups         Also cleanup Velero backups"
        echo "  --restores        Also cleanup Velero restores"
        echo "  --all             Cleanup everything (namespace, backups, restores)"
        echo ""
        echo "Examples:"
        echo "  $0                    # Cleanup namespace only"
        echo "  $0 --backups          # Cleanup namespace and backups"
        echo "  $0 --restores         # Cleanup namespace and restores"
        echo "  $0 --all              # Full cleanup of everything"
        exit 0
        ;;
    --backups)
        CLEANUP_BACKUPS=true
        main
        ;;
    --restores)
        CLEANUP_RESTORES=true
        main
        ;;
    --all)
        CLEANUP_ALL=true
        main
        ;;
    "")
        # No arguments, run namespace cleanup only
        main
        ;;
    *)
        error "Unknown option: $1"
        echo "Use --help for usage information"
        exit 1
        ;;
esac
