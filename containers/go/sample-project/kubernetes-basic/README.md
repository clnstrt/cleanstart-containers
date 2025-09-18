# 🚀 CleanStart Go Kubernetes Sample

A simple Kubernetes deployment demonstrating a Go-based HTTP server using the CleanStart Go container image with netcat for HTTP responses.

## 📋 Prerequisites

- **kubectl** configured and connected to a Kubernetes cluster
- **Namespace** `go-sample` exists
- **ConfigMap** `go-sample-config` exists

## 🚀 Quick Deployment

### Step 1: Create Prerequisites
```bash
# Create namespace
kubectl create namespace go-sample

# Create configmap
kubectl create configmap go-sample-config \
  --from-literal=APP_VERSION=1.0.0 \
  --from-literal=PORT=8080 \
  --from-literal=ENVIRONMENT=production \
  -n go-sample
```

### Step 2: Deploy Application
```bash
# Deploy the application
kubectl apply -f deployment.yaml
```

### Step 3: Verify Deployment
```bash
# Check deployment status
kubectl get deployment -n go-sample

# Check pods
kubectl get pods -n go-sample

# Test the application
kubectl exec -n go-sample <pod-name> -- curl -s http://localhost:8080
```

### Step 4: Access Application
```bash
# Port forward to access locally
kubectl port-forward svc/go-sample-service 8080:80 -n go-sample

# Visit http://localhost:8080 in your browser
```

## 🧹 Cleanup
```bash
# Remove deployment
kubectl delete -f deployment.yaml

# Or remove everything
kubectl delete namespace go-sample
```

## 📝 Application Details

**What it does:**
- Runs a simple HTTP server using netcat
- Serves dynamic responses with pod name, version, and timestamp
- Responds to health checks on the root path `/`

**Response format:**
```
Hello from CleanStart Go! Pod: go-sample-deployment-xxx, Version: 1.0.0, Time: 2025-01-18 15:30:45
```

**Health checks:**
- Liveness probe: `GET /` on port 8080
- Readiness probe: `GET /` on port 8080

## 🔧 Alternative Deployment Options

### Using Kustomize
```bash
# Deploy everything with kustomize
kubectl apply -k .
```

### Using Individual Files
```bash
# Deploy all resources individually
kubectl apply -f namespace.yaml
kubectl apply -f configmap.yaml
kubectl apply -f deployment.yaml
```

## 🎯 Key Points

- **deployment.yaml** contains only the Deployment resource
- Requires **namespace** and **configmap** to exist first
- No Service defined in deployment.yaml - access via port-forwarding
- Uses netcat for simple HTTP responses
- Health checks use root path `/`