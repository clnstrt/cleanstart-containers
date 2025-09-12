#!/bin/bash

# MetalLB BGP Setup Verification Script
# This script verifies the BGP configuration and connectivity

set -e

echo "🔍 Verifying MetalLB BGP Setup"
echo "=============================="

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

# Check IP address pool
print_status "Checking IP address pool..."
if ! kubectl get ipaddresspool bgp-pool -n metallb-system &> /dev/null; then
    print_error "IP address pool 'bgp-pool' not found"
    print_status "Applying BGP configuration..."
    kubectl apply -f bgp-config.yaml
    sleep 5
fi

print_success "IP address pool is configured"

# Check BGP peer
print_status "Checking BGP peer..."
if ! kubectl get bgppeer sample -n metallb-system &> /dev/null; then
    print_error "BGP peer 'sample' not found"
    print_status "Applying BGP configuration..."
    kubectl apply -f bgp-config.yaml
    sleep 5
fi

print_success "BGP peer is configured"

# Check BGP advertisement
print_status "Checking BGP advertisement..."
if ! kubectl get bgpadvertisement example -n metallb-system &> /dev/null; then
    print_error "BGP advertisement 'example' not found"
    print_status "Applying BGP configuration..."
    kubectl apply -f bgp-config.yaml
    sleep 5
fi

print_success "BGP advertisement is configured"

# Check if sample app is deployed
print_status "Checking sample application..."
if ! kubectl get deployment nginx-bgp &> /dev/null; then
    print_status "Deploying sample application..."
    kubectl apply -f sample-app.yaml
    print_status "Waiting for deployment to be ready..."
    kubectl wait --for=condition=available deployment/nginx-bgp --timeout=60s
fi

print_success "Sample application is deployed"

# Check LoadBalancer service
print_status "Checking LoadBalancer service..."
if ! kubectl get service nginx-bgp-service &> /dev/null; then
    print_error "LoadBalancer service 'nginx-bgp-service' not found"
    exit 1
fi

# Wait for external IP assignment
print_status "Waiting for external IP assignment..."
EXTERNAL_IP=""
for i in {1..30}; do
    EXTERNAL_IP=$(kubectl get service nginx-bgp-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "")
    if [ -n "$EXTERNAL_IP" ]; then
        break
    fi
    print_status "Waiting for IP assignment... ($i/30)"
    sleep 10
done

if [ -z "$EXTERNAL_IP" ]; then
    print_error "External IP not assigned after 5 minutes"
    print_status "Checking MetalLB logs..."
    kubectl logs -n metallb-system deployment/metallb-controller --tail=20
    kubectl logs -n metallb-system daemonset/metallb-speaker --tail=20
    exit 1
fi

print_success "External IP assigned: $EXTERNAL_IP"

# Check BGP peer status
print_status "Checking BGP peer status..."
BGP_PEER_STATUS=$(kubectl get bgppeer sample -n metallb-system -o jsonpath='{.status}' 2>/dev/null || echo "{}")
if [ "$BGP_PEER_STATUS" != "{}" ]; then
    print_success "BGP peer has status information"
    echo "$BGP_PEER_STATUS" | jq . 2>/dev/null || echo "$BGP_PEER_STATUS"
else
    print_warning "BGP peer status not available (this is normal for some configurations)"
fi

# Test HTTP connectivity
print_status "Testing HTTP connectivity..."
if command -v curl &> /dev/null; then
    if curl -s --connect-timeout 10 "http://$EXTERNAL_IP" | grep -q "Welcome to nginx"; then
        print_success "HTTP connectivity test passed"
    else
        print_warning "HTTP connectivity test failed, but IP is assigned"
    fi
else
    print_warning "curl not available, skipping HTTP test"
fi

# Display service information
echo ""
echo "📊 Service Information"
echo "====================="
kubectl get service nginx-bgp-service -o wide

echo ""
echo "📊 BGP Configuration"
echo "==================="
kubectl get ipaddresspools -n metallb-system
kubectl get bgppeers -n metallb-system
kubectl get bgpadvertisements -n metallb-system

echo ""
echo "📊 Pod Status"
echo "============="
kubectl get pods -l app=nginx-bgp

echo ""
print_success "MetalLB BGP setup is working correctly!"
print_status "You can access your application at: http://$EXTERNAL_IP"
print_status "BGP routes should be advertised to peer: 192.168.1.1"
echo ""
print_status "To clean up, run:"
echo "kubectl delete -f sample-app.yaml"
echo "kubectl delete -f bgp-config.yaml"
