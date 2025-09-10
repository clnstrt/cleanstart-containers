#!/bin/bash

# MinIO Operator Sidecar Sample Project Setup Script for Linux/macOS
# This script sets up the MinIO Operator Sidecar sample project environment

set -e

echo "🚀 Setting up MinIO Operator Sidecar Sample Project"
echo "=================================================="

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

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

print_success "Docker is installed"

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    print_error "kubectl is not installed. Please install kubectl first."
    exit 1
fi

print_success "kubectl is installed"

# Check if we can connect to cluster
if ! kubectl cluster-info &> /dev/null; then
    print_error "Cannot connect to Kubernetes cluster"
    print_status "Please ensure your cluster is running and kubectl is configured"
    exit 1
fi

print_success "Connected to Kubernetes cluster"

# Check if MinIO operator image is available
print_status "Checking MinIO operator image availability..."
if docker pull minio/operator:latest &> /dev/null; then
    print_success "MinIO operator image is available"
else
    print_warning "Failed to pull MinIO operator image"
fi

# Create necessary directories
print_status "Creating directories..."
mkdir -p basic-tenant
mkdir -p multi-tenant
mkdir -p production-setup
mkdir -p monitoring
mkdir -p config
mkdir -p manifests
mkdir -p scripts

print_success "Directories created"

# Create basic configuration files
print_status "Creating configuration files..."

# Create basic tenant configuration
cat > basic-tenant/minio-operator.yaml << 'EOF'
apiVersion: v1
kind: Namespace
metadata:
  name: minio-operator
  labels:
    name: minio-operator
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: minio-operator
  namespace: minio-operator
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: minio-operator
rules:
- apiGroups: [""]
  resources: ["pods", "services", "endpoints", "persistentvolumeclaims", "events", "configmaps", "secrets"]
  verbs: ["*"]
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["list", "get", "watch"]
- apiGroups: ["apps"]
  resources: ["deployments", "daemonsets", "replicasets", "statefulsets"]
  verbs: ["*"]
- apiGroups: ["minio.min.io"]
  resources: ["*"]
  verbs: ["*"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: minio-operator
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: minio-operator
subjects:
- kind: ServiceAccount
  name: minio-operator
  namespace: minio-operator
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: minio-operator
  namespace: minio-operator
  labels:
    app: minio-operator
spec:
  replicas: 1
  selector:
    matchLabels:
      app: minio-operator
  template:
    metadata:
      labels:
        app: minio-operator
    spec:
      serviceAccountName: minio-operator
      containers:
      - name: minio-operator
        image: minio/operator:latest
        command:
        - operator
        - --watch-namespace=""
        - --log-level=info
        ports:
        - containerPort: 4222
          name: http
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 500m
            memory: 512Mi
        env:
        - name: WATCH_NAMESPACE
          value: ""
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: OPERATOR_NAME
          value: "minio-operator"
        livenessProbe:
          httpGet:
            path: /healthz
            port: 4222
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /readyz
            port: 4222
          initialDelaySeconds: 5
          periodSeconds: 5
EOF

# Create basic tenant configuration
cat > basic-tenant/minio-tenant.yaml << 'EOF'
apiVersion: v1
kind: Namespace
metadata:
  name: minio-tenant
  labels:
    name: minio-tenant
---
apiVersion: v1
kind: Secret
metadata:
  name: minio-tenant-secret
  namespace: minio-tenant
type: Opaque
data:
  # minioadmin / minioadmin123
  accesskey: bWluaW9hZG1pbg==
  secretkey: bWluaW9hZG1pbg==
---
apiVersion: minio.min.io/v2
kind: Tenant
metadata:
  name: minio-tenant
  namespace: minio-tenant
  labels:
    app: minio
spec:
  image: minio/minio:latest
  imagePullPolicy: IfNotPresent
  podTemplate:
    metadata: {}
    spec:
      containers:
      - name: minio
        image: minio/minio:latest
        command:
        - /bin/bash
        - -c
        - minio server --console-address ":9001" http://minio-{0...3}.minio-tenant-hl.minio-tenant.svc.cluster.local/data
        env:
        - name: MINIO_ROOT_USER
          valueFrom:
            secretKeyRef:
              name: minio-tenant-secret
              key: accesskey
        - name: MINIO_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: minio-tenant-secret
              key: secretkey
        ports:
        - containerPort: 9000
          name: api
        - containerPort: 9001
          name: console
        livenessProbe:
          httpGet:
            path: /minio/health/live
            port: 9000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /minio/health/ready
            port: 9000
          initialDelaySeconds: 5
          periodSeconds: 5
        resources:
          requests:
            cpu: 100m
            memory: 256Mi
          limits:
            cpu: 500m
            memory: 1Gi
        volumeMounts:
        - name: data
          mountPath: /data
  pools:
  - servers: 4
    volumesPerServer: 1
    volumeClaimTemplate:
      metadata:
        name: data
      spec:
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
            storage: 10Gi
        storageClassName: standard
  credentials:
    secret:
      name: minio-tenant-secret
  requestAutoCert: false
  s3:
    bucketDNS: false
  console:
    image: minio/console:latest
    imagePullPolicy: IfNotPresent
    replicas: 1
    resources:
      requests:
        cpu: 100m
        memory: 128Mi
      limits:
        cpu: 200m
        memory: 256Mi
  serviceMetadata:
    minioService:
      type: LoadBalancer
      ports:
        api: 9000
        console: 9001
    consoleService:
      type: LoadBalancer
      ports:
        console: 9001
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    runAsGroup: 1000
    fsGroup: 1000
EOF

print_success "Configuration files created"

# Make scripts executable
print_status "Making scripts executable..."
chmod +x basic-tenant/test-tenant.sh 2>/dev/null || true
chmod +x multi-tenant/test-multi-tenant.sh 2>/dev/null || true
chmod +x production-setup/test-production.sh 2>/dev/null || true
chmod +x monitoring/test-monitoring.sh 2>/dev/null || true

print_success "Scripts made executable"

# Create a simple test script
cat > test-setup.sh << 'EOF'
#!/bin/bash

echo "🧪 Testing MinIO Operator Sidecar Sample Project Setup"
echo "====================================================="

# Test Kubernetes connectivity
echo "Testing Kubernetes connectivity..."
if kubectl cluster-info &> /dev/null; then
    echo "✅ Kubernetes cluster is accessible"
else
    echo "❌ Kubernetes cluster is not accessible"
    exit 1
fi

# Test MinIO operator deployment
echo "Testing MinIO operator deployment..."
if kubectl get pods -n minio-operator | grep -q "Running"; then
    echo "✅ MinIO operator is running"
else
    echo "❌ MinIO operator is not running"
    echo "Run: kubectl apply -f basic-tenant/minio-operator.yaml"
fi

# Test MinIO tenant deployment
echo "Testing MinIO tenant deployment..."
if kubectl get tenant minio-tenant -n minio-tenant &> /dev/null; then
    echo "✅ MinIO tenant exists"
else
    echo "❌ MinIO tenant does not exist"
    echo "Run: kubectl apply -f basic-tenant/minio-tenant.yaml"
fi

# Test MinIO API access
echo "Testing MinIO API access..."
if kubectl port-forward svc/minio 9000:9000 -n minio-tenant &> /dev/null &
then
    PORT_FORWARD_PID=$!
    sleep 5
    
    if curl -s http://localhost:9000/minio/health/live &> /dev/null; then
        echo "✅ MinIO API is accessible"
    else
        echo "❌ MinIO API is not accessible"
    fi
    
    kill $PORT_FORWARD_PID 2>/dev/null || true
else
    echo "❌ Could not port forward to MinIO API"
fi

# Test MinIO Console access
echo "Testing MinIO Console access..."
if kubectl port-forward svc/minio-console 9001:9001 -n minio-tenant &> /dev/null &
then
    PORT_FORWARD_PID=$!
    sleep 5
    
    if curl -s http://localhost:9001 &> /dev/null; then
        echo "✅ MinIO Console is accessible"
    else
        echo "❌ MinIO Console is not accessible"
    fi
    
    kill $PORT_FORWARD_PID 2>/dev/null || true
else
    echo "❌ Could not port forward to MinIO Console"
fi

echo ""
echo "🎯 Access URLs:"
echo "  MinIO API: http://localhost:9000 (after port-forward)"
echo "  MinIO Console: http://localhost:9001 (after port-forward)"
echo "  Default credentials: minioadmin / minioadmin123"
echo ""
echo "📚 Sample Projects:"
echo "  Basic Tenant: ./basic-tenant/"
echo "  Multi-Tenant: ./multi-tenant/"
echo "  Production Setup: ./production-setup/"
echo "  Monitoring: ./monitoring/"
echo ""
echo "🎉 Setup test completed!"
EOF

chmod +x test-setup.sh

print_success "Test script created"

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "📋 Next Steps:"
echo "1. Deploy MinIO operator: kubectl apply -f basic-tenant/minio-operator.yaml"
echo "2. Deploy MinIO tenant: kubectl apply -f basic-tenant/minio-tenant.yaml"
echo "3. Test the setup: ./test-setup.sh"
echo "4. Explore the sample projects in the subdirectories"
echo ""
echo "🔗 Access URLs (after deployment):"
echo "  MinIO API: http://localhost:9000 (after port-forward)"
echo "  MinIO Console: http://localhost:9001 (after port-forward)"
echo "  Default credentials: minioadmin / minioadmin123"
echo ""
echo "📚 Sample Projects:"
echo "  Basic Tenant: ./basic-tenant/"
echo "  Multi-Tenant: ./multi-tenant/"
echo "  Production Setup: ./production-setup/"
echo "  Monitoring: ./monitoring/"
echo ""
print_success "Happy MinIO Tenant Management! 🏢"
