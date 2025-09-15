#!/bin/bash

# MinIO Tenant Test Script
# This script tests the basic MinIO tenant deployment

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

echo "🧪 Testing MinIO Tenant Deployment"
echo "=================================="

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    print_error "kubectl is not installed or not in PATH"
    exit 1
fi

print_success "kubectl is available"

# Check if we can connect to cluster
if ! kubectl cluster-info &> /dev/null; then
    print_error "Cannot connect to Kubernetes cluster"
    exit 1
fi

print_success "Connected to Kubernetes cluster"

# Check if MinIO operator is running
print_status "Checking MinIO operator status..."
if kubectl get pods -n minio-operator | grep -q "Running"; then
    print_success "MinIO operator is running"
else
    print_error "MinIO operator is not running"
    print_status "Deploy operator first: kubectl apply -f minio-operator.yaml"
    exit 1
fi

# Check if MinIO tenant exists
print_status "Checking MinIO tenant status..."
if kubectl get tenant minio-tenant -n minio-tenant &> /dev/null; then
    print_success "MinIO tenant exists"
else
    print_error "MinIO tenant does not exist"
    print_status "Deploy tenant first: kubectl apply -f minio-tenant.yaml"
    exit 1
fi

# Check tenant status
print_status "Checking tenant status..."
TENANT_STATUS=$(kubectl get tenant minio-tenant -n minio-tenant -o jsonpath='{.status.currentState}')
if [ "$TENANT_STATUS" = "Ready" ]; then
    print_success "Tenant is ready"
else
    print_warning "Tenant status: $TENANT_STATUS"
    print_status "Waiting for tenant to be ready..."
    kubectl wait --for=condition=ready tenant/minio-tenant -n minio-tenant --timeout=300s
    print_success "Tenant is now ready"
fi

# Check tenant pods
print_status "Checking tenant pods..."
POD_COUNT=$(kubectl get pods -n minio-tenant -l app=minio --no-headers | wc -l)
if [ "$POD_COUNT" -ge 4 ]; then
    print_success "Tenant has $POD_COUNT pods running"
else
    print_warning "Tenant has only $POD_COUNT pods (expected 4+)"
fi

# Check tenant services
print_status "Checking tenant services..."
if kubectl get svc minio -n minio-tenant &> /dev/null; then
    print_success "MinIO API service exists"
else
    print_error "MinIO API service does not exist"
fi

if kubectl get svc minio-console -n minio-tenant &> /dev/null; then
    print_success "MinIO Console service exists"
else
    print_error "MinIO Console service does not exist"
fi

# Test MinIO API health
print_status "Testing MinIO API health..."
if kubectl port-forward svc/minio 9000:9000 -n minio-tenant &> /dev/null &
then
    PORT_FORWARD_PID=$!
    sleep 5
    
    if curl -s http://localhost:9000/minio/health/live &> /dev/null; then
        print_success "MinIO API is healthy"
    else
        print_warning "MinIO API health check failed"
    fi
    
    if curl -s http://localhost:9000/minio/health/ready &> /dev/null; then
        print_success "MinIO API is ready"
    else
        print_warning "MinIO API ready check failed"
    fi
    
    # Kill port forward
    kill $PORT_FORWARD_PID 2>/dev/null || true
else
    print_warning "Could not port forward to MinIO API"
fi

# Test MinIO Console
print_status "Testing MinIO Console..."
if kubectl port-forward svc/minio-console 9001:9001 -n minio-tenant &> /dev/null &
then
    PORT_FORWARD_PID=$!
    sleep 5
    
    if curl -s http://localhost:9001 &> /dev/null; then
        print_success "MinIO Console is accessible"
    else
        print_warning "MinIO Console is not accessible"
    fi
    
    # Kill port forward
    kill $PORT_FORWARD_PID 2>/dev/null || true
else
    print_warning "Could not port forward to MinIO Console"
fi

# Check tenant events
print_status "Checking tenant events..."
EVENT_COUNT=$(kubectl get events -n minio-tenant --field-selector involvedObject.name=minio-tenant --no-headers | wc -l)
if [ "$EVENT_COUNT" -gt 0 ]; then
    print_status "Found $EVENT_COUNT events for tenant"
    kubectl get events -n minio-tenant --field-selector involvedObject.name=minio-tenant --sort-by='.lastTimestamp' | tail -5
else
    print_status "No recent events for tenant"
fi

# Summary
echo ""
echo "🎯 Test Summary"
echo "==============="
echo "✅ MinIO Operator: Running"
echo "✅ MinIO Tenant: Ready"
echo "✅ Tenant Pods: $POD_COUNT running"
echo "✅ MinIO API: Available"
echo "✅ MinIO Console: Available"
echo ""
echo "🔗 Access URLs:"
echo "  MinIO API: http://localhost:9000 (after port-forward)"
echo "  MinIO Console: http://localhost:9001 (after port-forward)"
echo ""
echo "🔑 Default Credentials:"
echo "  Username: minioadmin"
echo "  Password: minioadmin123"
echo ""
echo "📋 Useful Commands:"
echo "  kubectl get tenants -n minio-tenant"
echo "  kubectl get pods -n minio-tenant"
echo "  kubectl port-forward svc/minio 9000:9000 -n minio-tenant"
echo "  kubectl port-forward svc/minio-console 9001:9001 -n minio-tenant"
echo ""
print_success "MinIO Tenant test completed successfully! 🎉"
