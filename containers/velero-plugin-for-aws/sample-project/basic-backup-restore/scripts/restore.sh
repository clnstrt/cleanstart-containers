#!/bin/bash

# Velero Restore Script for Sample Application
# This script demonstrates basic restore operations

set -e

# Configuration
NAMESPACE="sample-app"
RESTORE_NAME="sample-app-restore-$(date +%Y%m%d-%H%M%S)"
BACKUP_NAME=""

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
    
    # Check if Velero is installed in the cluster
    if ! kubectl get namespace velero &> /dev/null; then
        error "Velero namespace not found. Please install Velero first."
        exit 1
    fi
    
    success "Prerequisites check passed"
}

# List available backups
list_backups() {
    log "Available backups:"
    velero backup get
}

# Select backup to restore from
select_backup() {
    if [ -z "$BACKUP_NAME" ]; then
        log "No backup specified. Please select from available backups:"
        list_backups
        
        echo ""
        read -p "Enter backup name to restore from: " BACKUP_NAME
        
        if [ -z "$BACKUP_NAME" ]; then
            error "No backup name provided"
            exit 1
        fi
    fi
    
    # Verify backup exists
    if ! velero backup describe $BACKUP_NAME &> /dev/null; then
        error "Backup '$BACKUP_NAME' not found"
        exit 1
    fi
    
    # Check backup status
    BACKUP_STATUS=$(velero backup describe $BACKUP_NAME --output json | jq -r '.Status.Phase' 2>/dev/null || echo "UNKNOWN")
    
    if [ "$BACKUP_STATUS" != "Completed" ]; then
        error "Backup '$BACKUP_NAME' is not completed (Status: $BACKUP_STATUS)"
        exit 1
    fi
    
    success "Selected backup: $BACKUP_NAME (Status: $BACKUP_STATUS)"
}

# Check for existing resources
check_existing_resources() {
    log "Checking for existing resources in namespace: $NAMESPACE"
    
    if kubectl get namespace $NAMESPACE &> /dev/null; then
        warning "Namespace $NAMESPACE already exists"
        
        # Check what resources exist
        RESOURCES=$(kubectl get all -n $NAMESPACE 2>/dev/null | wc -l || echo "0")
        
        if [ "$RESOURCES" -gt 0 ]; then
            warning "Namespace contains existing resources"
            kubectl get all -n $NAMESPACE
            
            read -p "Do you want to continue with restore? This may cause conflicts. (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                log "Restore cancelled by user"
                exit 0
            fi
        fi
    else
        log "Namespace $NAMESPACE does not exist - will be created during restore"
    fi
}

# Create restore
create_restore() {
    log "Creating restore: $RESTORE_NAME"
    log "Restoring from backup: $BACKUP_NAME"
    log "Target namespace: $NAMESPACE"
    
    # Create restore with detailed options
    velero restore create $RESTORE_NAME \
        --from-backup=$BACKUP_NAME \
        --namespace-mappings $NAMESPACE:$NAMESPACE \
        --description="Restore of $NAMESPACE from backup $BACKUP_NAME" \
        --annotations restore-type=automated,environment=development,created-by=script \
        --wait
    
    if [ $? -eq 0 ]; then
        success "Restore created successfully: $RESTORE_NAME"
    else
        error "Failed to create restore"
        exit 1
    fi
}

# Verify restore
verify_restore() {
    log "Verifying restore: $RESTORE_NAME"
    
    # Wait a moment for restore to complete
    sleep 5
    
    # Get restore status
    RESTORE_STATUS=$(velero restore describe $RESTORE_NAME --output json | jq -r '.Status.Phase' 2>/dev/null || echo "UNKNOWN")
    
    if [ "$RESTORE_STATUS" = "Completed" ]; then
        success "Restore completed successfully"
    elif [ "$RESTORE_STATUS" = "Failed" ]; then
        error "Restore failed"
        velero restore logs $RESTORE_NAME
        exit 1
    else
        warning "Restore status: $RESTORE_STATUS"
    fi
    
    # Show restore details
    log "Restore details:"
    velero restore describe $RESTORE_NAME
}

# Verify restored resources
verify_resources() {
    log "Verifying restored resources in namespace: $NAMESPACE"
    
    # Wait for resources to be ready
    sleep 10
    
    # Check namespace
    if kubectl get namespace $NAMESPACE &> /dev/null; then
        success "Namespace $NAMESPACE exists"
    else
        error "Namespace $NAMESPACE not found after restore"
        return 1
    fi
    
    # Check resources
    log "Checking restored resources:"
    kubectl get all -n $NAMESPACE
    
    # Check specific resource types
    log "Checking deployments:"
    kubectl get deployments -n $NAMESPACE
    
    log "Checking services:"
    kubectl get services -n $NAMESPACE
    
    log "Checking persistent volume claims:"
    kubectl get pvc -n $NAMESPACE
    
    # Check pod status
    log "Checking pod status:"
    kubectl get pods -n $NAMESPACE
    
    # Wait for pods to be ready
    log "Waiting for pods to be ready..."
    kubectl wait --for=condition=ready pod -l app=sample-app -n $NAMESPACE --timeout=300s
    
    success "Resource verification completed"
}

# Show restore statistics
show_statistics() {
    log "Restore statistics:"
    
    # Count total restores
    TOTAL_RESTORES=$(velero restore get --output json | jq '.items | length' 2>/dev/null || echo "0")
    
    # Count completed restores
    COMPLETED_RESTORES=$(velero restore get --output json | jq '.items[] | select(.Status.Phase == "Completed") | .Metadata.Name' 2>/dev/null | wc -l)
    
    # Count failed restores
    FAILED_RESTORES=$(velero restore get --output json | jq '.items[] | select(.Status.Phase == "Failed") | .Metadata.Name' 2>/dev/null | wc -l)
    
    echo "Total restores: $TOTAL_RESTORES"
    echo "Completed: $COMPLETED_RESTORES"
    echo "Failed: $FAILED_RESTORES"
}

# Main execution
main() {
    echo "=========================================="
    echo "Velero Restore Script for Sample Application"
    echo "=========================================="
    echo ""
    
    check_prerequisites
    select_backup
    check_existing_resources
    create_restore
    verify_restore
    verify_resources
    show_statistics
    
    echo ""
    success "Restore process completed successfully!"
    echo "Restore name: $RESTORE_NAME"
    echo "Source backup: $BACKUP_NAME"
    echo "Target namespace: $NAMESPACE"
    echo ""
    echo "To verify the restored application:"
    echo "kubectl get all -n $NAMESPACE"
    echo "kubectl port-forward svc/sample-app-service 8080:80 -n $NAMESPACE"
}

# Handle script arguments
case "${1:-}" in
    --help|-h)
        echo "Usage: $0 [OPTIONS] [BACKUP_NAME]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --verify-only  Only verify existing restores"
        echo "  --list-only    Only list existing backups"
        echo ""
        echo "Arguments:"
        echo "  BACKUP_NAME    Name of backup to restore from"
        echo ""
        echo "Examples:"
        echo "  $0                                    # Interactive backup selection"
        echo "  $0 my-backup-name                     # Restore from specific backup"
        echo "  $0 --verify-only                      # Verify existing restores"
        echo "  $0 --list-only                        # List available backups"
        exit 0
        ;;
    --verify-only)
        log "Verification mode only"
        check_prerequisites
        show_statistics
        exit 0
        ;;
    --list-only)
        log "List mode only"
        check_prerequisites
        list_backups
        exit 0
        ;;
    "")
        # No arguments, run full restore
        main
        ;;
    *)
        # Assume first argument is backup name
        BACKUP_NAME="$1"
        main
        ;;
esac
