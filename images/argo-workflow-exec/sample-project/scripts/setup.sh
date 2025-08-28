#!/bin/bash

# Argo Workflows Sample Project Setup Script
# This script sets up the testing environment for Argo Workflows

set -e

echo "🚀 Setting up Argo Workflows testing environment..."

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
print_status "Checking kubectl installation..."
if ! command -v kubectl &> /dev/null; then
    print_error "kubectl is not installed or not in PATH"
    print_status "Please install kubectl: https://kubernetes.io/docs/tasks/tools/"
    exit 1
fi
print_success "kubectl is available"

# Check kubectl version
KUBECTL_VERSION=$(kubectl version --client --short 2>/dev/null | cut -d' ' -f3)
print_status "kubectl version: $KUBECTL_VERSION"

# Check if argo CLI is available
print_status "Checking Argo CLI installation..."
if ! command -v argo &> /dev/null; then
    print_warning "Argo CLI is not installed"
    print_status "Installing Argo CLI..."
    
    # Download and install Argo CLI
    ARGO_VERSION="v3.4.8"
    curl -sLO https://github.com/argoproj/argo-workflows/releases/download/${ARGO_VERSION}/argo-linux-amd64
    chmod +x argo-linux-amd64
    sudo mv argo-linux-amd64 /usr/local/bin/argo
    
    print_success "Argo CLI installed successfully"
else
    ARGO_VERSION=$(argo version --short 2>/dev/null | head -n1)
    print_success "Argo CLI is available: $ARGO_VERSION"
fi

# Check cluster connectivity
print_status "Checking Kubernetes cluster connectivity..."
if ! kubectl cluster-info &> /dev/null; then
    print_error "Cannot connect to Kubernetes cluster"
    print_status "Please ensure your kubeconfig is properly configured"
    exit 1
fi
print_success "Connected to Kubernetes cluster"

# Get cluster info
CLUSTER_NAME=$(kubectl config current-context 2>/dev/null || echo "unknown")
print_status "Current cluster context: $CLUSTER_NAME"

# Check if Argo Workflows is installed
print_status "Checking Argo Workflows installation..."
if ! kubectl get namespace argo &> /dev/null; then
    print_warning "Argo Workflows namespace not found"
    print_status "Installing Argo Workflows..."
    
    # Install Argo Workflows
    kubectl create namespace argo
    kubectl apply -n argo -f https://github.com/argoproj/argo-workflows/releases/download/v3.4.8/install.yaml
    
    print_success "Argo Workflows installed successfully"
else
    print_success "Argo Workflows namespace exists"
fi

# Check Argo Workflows pods
print_status "Checking Argo Workflows pods..."
if kubectl get pods -n argo &> /dev/null; then
    PODS_READY=$(kubectl get pods -n argo --no-headers | grep -c "Running" || echo "0")
    PODS_TOTAL=$(kubectl get pods -n argo --no-headers | wc -l || echo "0")
    print_status "Argo Workflows pods: $PODS_READY/$PODS_TOTAL running"
else
    print_warning "Could not check Argo Workflows pods"
fi

# Create test namespace
print_status "Creating test namespace..."
kubectl create namespace argo-test --dry-run=client -o yaml | kubectl apply -f -
print_success "Test namespace 'argo-test' ready"

# Set up RBAC for testing
print_status "Setting up RBAC for testing..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: argo-test-sa
  namespace: argo-test
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: argo-test-role
  namespace: argo-test
rules:
- apiGroups: [""]
  resources: ["pods", "pods/log"]
  verbs: ["get", "list", "watch", "create", "delete"]
- apiGroups: ["argoproj.io"]
  resources: ["workflows", "workflowtemplates"]
  verbs: ["get", "list", "watch", "create", "update", "delete"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: argo-test-rolebinding
  namespace: argo-test
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: argo-test-role
subjects:
- kind: ServiceAccount
  name: argo-test-sa
  namespace: argo-test
EOF
print_success "RBAC configured for testing"

# Create sample workflow template
print_status "Creating sample workflow template..."
cat <<EOF | kubectl apply -f -
apiVersion: argoproj.io/v1alpha1
kind: WorkflowTemplate
metadata:
  name: sample-template
  namespace: argo-test
spec:
  entrypoint: hello
  templates:
  - name: hello
    container:
      image: docker/whalesay
      command: [cowsay]
      args: ["Hello from template!"]
EOF
print_success "Sample workflow template created"

# Test workflow submission
print_status "Testing workflow submission..."
if argo submit --from workflowtemplate/sample-template -n argo-test --generate-name test- &> /dev/null; then
    print_success "Workflow submission test passed"
else
    print_warning "Workflow submission test failed (this might be expected if Argo server is not ready)"
fi

# Display setup summary
echo ""
print_success "Setup completed successfully!"
echo ""
echo "📋 Setup Summary:"
echo "  • kubectl: $KUBECTL_VERSION"
echo "  • Argo CLI: $ARGO_VERSION"
echo "  • Cluster: $CLUSTER_NAME"
echo "  • Test namespace: argo-test"
echo "  • RBAC: Configured"
echo "  • Sample template: Created"
echo ""
echo "🚀 Next steps:"
echo "  1. Test basic workflow: argo submit basic-workflows/hello-world.yaml -n argo-test"
echo "  2. Monitor workflows: argo watch @latest -n argo-test"
echo "  3. List workflows: argo list -n argo-test"
echo ""
echo "📚 Documentation:"
echo "  • Argo Workflows: https://argoproj.github.io/argo-workflows/"
echo "  • Sample projects: ./sample-project/"
echo ""
