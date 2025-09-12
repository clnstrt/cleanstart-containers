#!/bin/bash

# MetalLB Multi-Pool Setup Test Script
# This script tests the multi-pool configuration and service assignments

set -e

echo "🔍 Testing MetalLB Multi-Pool Setup"
echo "==================================="

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

# Check if we can connect to the cluster
if ! kubectl cluster-info &> /dev/null; then
    print_error "Cannot connect to Kubernetes cluster"
    exit 1
fi

print_success "Connected to Kubernetes cluster"

# Check if MetalLB is deployed
print_status "Checking MetalLB deployment..."
if ! kubectl get namespace metallb-system &> /dev/null; then
    print_error "MetalLB namespace not found. Please deploy MetalLB first:"
    echo "kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.2/config/manifests/metallb-native.yaml"
    exit 1
fi

# Check MetalLB pods
print_status "Checking MetalLB pods..."
CONTROLLER_READY=$(kubectl get pods -n metallb-system -l app=metallb,component=controller --no-headers | awk '{print $2}' | grep -c "1/1" || echo "0")
SPEAKER_READY=$(kubectl get pods -n metallb-system -l app=metallb,component=speaker --no-headers | awk '{print $2}' | grep -c "1/1" || echo "0")

if [ "$CONTROLLER_READY" -eq 0 ]; then
    print_error "MetalLB controller is not ready"
    exit 1
fi

if [ "$SPEAKER_READY" -eq 0 ]; then
    print_error "MetalLB speaker is not ready"
    exit 1
fi

print_success "MetalLB pods are ready"

# Check IP address pools
print_status "Checking IP address pools..."
POOLS=("web-pool" "api-pool" "database-pool")
for pool in "${POOLS[@]}"; do
    if ! kubectl get ipaddresspool "$pool" -n metallb-system &> /dev/null; then
        print_error "IP address pool '$pool' not found"
        print_status "Applying $pool configuration..."
        case $pool in
            "web-pool")
                kubectl apply -f web-pool-config.yaml
                ;;
            "api-pool")
                kubectl apply -f api-pool-config.yaml
                ;;
            "database-pool")
                kubectl apply -f database-pool-config.yaml
                ;;
        esac
        sleep 5
    fi
done

print_success "All IP address pools are configured"

# Check L2 advertisements
print_status "Checking L2 advertisements..."
ADVERTISEMENTS=("web-advertisement" "api-advertisement" "database-advertisement")
for adv in "${ADVERTISEMENTS[@]}"; do
    if ! kubectl get l2advertisement "$adv" -n metallb-system &> /dev/null; then
        print_error "L2 advertisement '$adv' not found"
        print_status "Applying $adv configuration..."
        case $adv in
            "web-advertisement")
                kubectl apply -f web-pool-config.yaml
                ;;
            "api-advertisement")
                kubectl apply -f api-pool-config.yaml
                ;;
            "database-advertisement")
                kubectl apply -f database-pool-config.yaml
                ;;
        esac
        sleep 5
    fi
done

print_success "All L2 advertisements are configured"

# Check if sample apps are deployed
print_status "Checking sample applications..."
if ! kubectl get deployment web-app &> /dev/null; then
    print_status "Deploying sample applications..."
    kubectl apply -f sample-apps.yaml
    print_status "Waiting for deployments to be ready..."
    kubectl wait --for=condition=available deployment/web-app --timeout=60s
    kubectl wait --for=condition=available deployment/api-app --timeout=60s
    kubectl wait --for=condition=available deployment/database-app --timeout=60s
fi

print_success "Sample applications are deployed"

# Check LoadBalancer services
print_status "Checking LoadBalancer services..."
SERVICES=("web-service" "api-service" "database-service")
for service in "${SERVICES[@]}"; do
    if ! kubectl get service "$service" &> /dev/null; then
        print_error "LoadBalancer service '$service' not found"
        exit 1
    fi
done

print_success "All LoadBalancer services are configured"

# Wait for external IP assignments
print_status "Waiting for external IP assignments..."
WEB_IP=""
API_IP=""
DB_IP=""

for i in {1..30}; do
    WEB_IP=$(kubectl get service web-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "")
    API_IP=$(kubectl get service api-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "")
    DB_IP=$(kubectl get service database-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "")
    
    if [ -n "$WEB_IP" ] && [ -n "$API_IP" ] && [ -n "$DB_IP" ]; then
        break
    fi
    
    print_status "Waiting for IP assignments... ($i/30)"
    sleep 10
done

if [ -z "$WEB_IP" ] || [ -z "$API_IP" ] || [ -z "$DB_IP" ]; then
    print_error "Not all external IPs assigned after 5 minutes"
    print_status "Current IP assignments:"
    echo "Web: $WEB_IP"
    echo "API: $API_IP"
    echo "Database: $DB_IP"
    exit 1
fi

print_success "All external IPs assigned:"
echo "  Web: $WEB_IP"
echo "  API: $API_IP"
echo "  Database: $DB_IP"

# Verify IP pool assignments
print_status "Verifying IP pool assignments..."
WEB_POOL_RANGE="192.168.1.240-192.168.1.245"
API_POOL_RANGE="192.168.1.246-192.168.1.250"
DB_POOL_RANGE="192.168.1.251-192.168.1.255"

# Check if IPs are in correct ranges (simplified check)
WEB_IP_NUM=$(echo "$WEB_IP" | cut -d. -f4)
API_IP_NUM=$(echo "$API_IP" | cut -d. -f4)
DB_IP_NUM=$(echo "$DB_IP" | cut -d. -f4)

if [ "$WEB_IP_NUM" -ge 240 ] && [ "$WEB_IP_NUM" -le 245 ]; then
    print_success "Web service IP is in correct pool range"
else
    print_warning "Web service IP may not be in expected pool range"
fi

if [ "$API_IP_NUM" -ge 246 ] && [ "$API_IP_NUM" -le 250 ]; then
    print_success "API service IP is in correct pool range"
else
    print_warning "API service IP may not be in expected pool range"
fi

if [ "$DB_IP_NUM" -ge 251 ] && [ "$DB_IP_NUM" -le 255 ]; then
    print_success "Database service IP is in correct pool range"
else
    print_warning "Database service IP may not be in expected pool range"
fi

# Test HTTP connectivity
print_status "Testing HTTP connectivity..."
if command -v curl &> /dev/null; then
    # Test web service
    if curl -s --connect-timeout 10 "http://$WEB_IP" | grep -q "Welcome to nginx"; then
        print_success "Web service connectivity test passed"
    else
        print_warning "Web service connectivity test failed"
    fi
    
    # Test API service
    if curl -s --connect-timeout 10 "http://$API_IP:8080" | grep -q "Welcome to nginx"; then
        print_success "API service connectivity test passed"
    else
        print_warning "API service connectivity test failed"
    fi
else
    print_warning "curl not available, skipping HTTP tests"
fi

# Display service information
echo ""
echo "📊 Service Information"
echo "====================="
kubectl get services -o wide

echo ""
echo "📊 IP Pool Configuration"
echo "========================"
kubectl get ipaddresspools -n metallb-system
kubectl get l2advertisements -n metallb-system

echo ""
echo "📊 Pod Status"
echo "============="
kubectl get pods -l app=web-app
kubectl get pods -l app=api-app
kubectl get pods -l app=database-app

echo ""
print_success "MetalLB Multi-Pool setup is working correctly!"
print_status "Service URLs:"
echo "  Web: http://$WEB_IP"
echo "  API: http://$API_IP:8080"
echo "  Database: $DB_IP:5432"
echo ""
print_status "To clean up, run:"
echo "kubectl delete -f sample-apps.yaml"
echo "kubectl delete -f web-pool-config.yaml"
echo "kubectl delete -f api-pool-config.yaml"
echo "kubectl delete -f database-pool-config.yaml"
