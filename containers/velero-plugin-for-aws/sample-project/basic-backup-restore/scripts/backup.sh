#!/bin/bash

# Velero Backup Script for Sample Application
# This script demonstrates basic backup operations

set -e

# Configuration
NAMESPACE="sample-app"
BACKUP_NAME="sample-app-backup-$(date +%Y%m%d-%H%M%S)"
BACKUP_DESCRIPTION="Automated backup of sample application"

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
    
    # Check if namespace exists
    if ! kubectl get namespace $NAMESPACE &> /dev/null; then
        error "Namespace $NAMESPACE does not exist"
        exit 1
    fi
    
    # Check if Velero is installed in the cluster
    if ! kubectl get namespace velero &> /dev/null; then
        error "Velero namespace not found. Please install Velero first."
        exit 1
    fi
    
    success "Prerequisites check passed"
}

# Create backup
create_backup() {
    log "Creating backup: $BACKUP_NAME"
    
    # Create backup with detailed options
    velero backup create $BACKUP_NAME \
        --include-namespaces=$NAMESPACE \
        --description="$BACKUP_DESCRIPTION" \
        --annotations backup-type=automated,environment=development,created-by=script \
        --wait
    
    if [ $? -eq 0 ]; then
        success "Backup created successfully: $BACKUP_NAME"
    else
        error "Failed to create backup"
        exit 1
    fi
}

# Verify backup
verify_backup() {
    log "Verifying backup: $BACKUP_NAME"
    
    # Wait a moment for backup to complete
    sleep 5
    
    # Get backup status
    BACKUP_STATUS=$(velero backup describe $BACKUP_NAME --output json | jq -r '.Status.Phase' 2>/dev/null || echo "UNKNOWN")
    
    if [ "$BACKUP_STATUS" = "Completed" ]; then
        success "Backup completed successfully"
    elif [ "$BACKUP_STATUS" = "Failed" ]; then
        error "Backup failed"
        velero backup logs $BACKUP_NAME
        exit 1
    else
        warning "Backup status: $BACKUP_STATUS"
    fi
    
    # Show backup details
    log "Backup details:"
    velero backup describe $BACKUP_NAME
}

# List all backups
list_backups() {
    log "Listing all backups:"
    velero backup get
}

# Show backup statistics
show_statistics() {
    log "Backup statistics:"
    
    # Count total backups
    TOTAL_BACKUPS=$(velero backup get --output json | jq '.items | length' 2>/dev/null || echo "0")
    
    # Count completed backups
    COMPLETED_BACKUPS=$(velero backup get --output json | jq '.items[] | select(.Status.Phase == "Completed") | .Metadata.Name' 2>/dev/null | wc -l)
    
    # Count failed backups
    FAILED_BACKUPS=$(velero backup get --output json | jq '.items[] | select(.Status.Phase == "Failed") | .Metadata.Name' 2>/dev/null | wc -l)
    
    echo "Total backups: $TOTAL_BACKUPS"
    echo "Completed: $COMPLETED_BACKUPS"
    echo "Failed: $FAILED_BACKUPS"
}

# Main execution
main() {
    echo "=========================================="
    echo "Velero Backup Script for Sample Application"
    echo "=========================================="
    echo ""
    
    check_prerequisites
    create_backup
    verify_backup
    list_backups
    show_statistics
    
    echo ""
    success "Backup process completed successfully!"
    echo "Backup name: $BACKUP_NAME"
    echo "Namespace: $NAMESPACE"
    echo ""
    echo "To restore from this backup, use:"
    echo "velero restore create my-restore --from-backup=$BACKUP_NAME"
}

# Handle script arguments
case "${1:-}" in
    --help|-h)
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --verify-only  Only verify existing backups"
        echo "  --list-only    Only list existing backups"
        echo ""
        echo "Examples:"
        echo "  $0                    # Create new backup"
        echo "  $0 --verify-only      # Verify existing backups"
        echo "  $0 --list-only        # List all backups"
        exit 0
        ;;
    --verify-only)
        log "Verification mode only"
        check_prerequisites
        list_backups
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
        # No arguments, run full backup
        main
        ;;
    *)
        error "Unknown option: $1"
        echo "Use --help for usage information"
        exit 1
        ;;
esac
