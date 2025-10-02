#!/bin/bash

# Curl GKE Deployment Script
# This script deploys the curl application to your GKE cluster

set -e  # Exit on any error

echo "======================================"
echo "Curl GKE Deployment Script"
echo "======================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Create namespace
echo -e "${BLUE}Step 1: Creating namespace 'curl-app'...${NC}"
kubectl apply -f namespace.yaml
echo -e "${GREEN}✓ Namespace created${NC}"
echo ""

# Wait a moment
sleep 2

# Step 2: Deploy the application
echo -e "${BLUE}Step 2: Deploying curl application...${NC}"
kubectl apply -f deployment.yaml -n curl-app
echo -e "${GREEN}✓ Deployment created${NC}"
echo ""

# Step 3: Create service (optional)
echo -e "${BLUE}Step 3: Creating service...${NC}"
kubectl apply -f service.yaml -n curl-app
echo -e "${GREEN}✓ Service created${NC}"
echo ""

# Step 4: Wait for pod to be ready
echo -e "${BLUE}Step 4: Waiting for pod to be ready...${NC}"
kubectl wait --for=condition=ready pod -l app=curl-app -n curl-app --timeout=120s
echo -e "${GREEN}✓ Pod is ready${NC}"
echo ""

# Step 5: Display deployment status
echo -e "${BLUE}Step 5: Deployment Status${NC}"
echo "======================================"
kubectl get all -n curl-app
echo ""

# Step 6: Get pod name and test
echo -e "${BLUE}Step 6: Testing curl functionality...${NC}"
POD_NAME=$(kubectl get pods -n curl-app -l app=curl-app -o jsonpath='{.items[0].metadata.name}')
echo "Pod Name: $POD_NAME"
echo ""

echo "Testing curl with httpbin.org/get..."
kubectl exec -it $POD_NAME -n curl-app -- curl -s https://httpbin.org/get
echo ""
echo ""

echo -e "${GREEN}======================================"
echo "✓ Deployment Successful!"
echo "======================================"${NC}
echo ""
echo "To use the curl container:"
echo "  POD_NAME=\$(kubectl get pods -n curl-app -l app=curl-app -o jsonpath='{.items[0].metadata.name}')"
echo "  kubectl exec -it \$POD_NAME -n curl-app -- curl -s https://httpbin.org/get"
echo ""
echo "To get an interactive shell:"
echo "  kubectl exec -it \$POD_NAME -n curl-app -- /bin/sh"
echo ""
echo "To cleanup:"
echo "  kubectl delete namespace curl-app"
echo ""

