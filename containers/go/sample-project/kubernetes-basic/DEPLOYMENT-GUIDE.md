# 🚀 Simple Deployment Guide

This guide explains how to deploy the Go sample application using the simplified `deployment.yaml` approach.

## 📋 Prerequisites

Before deploying, ensure you have:
- **kubectl** configured and connected to a Kubernetes cluster
- **Namespace** `go-sample` exists
- **ConfigMap** `go-sample-config` exists

## 🎯 Quick Deployment

### Option 1: Standalone Deployment (Simplest)

```bash
# 1. Create namespace first
kubectl create namespace go-sample

# 2. Create configmap
kubectl create configmap go-sample-config \
  --from-literal=APP_VERSION=1.0.0 \
  --from-literal=PORT=8080 \
  --from-literal=ENVIRONMENT=production \
  -n go-sample

# 3. Deploy the application
kubectl apply -f deployment.yaml
```

### Option 2: Using Individual Files

```bash
# Deploy all resources individually
kubectl apply -f namespace.yaml
kubectl apply -f configmap.yaml
kubectl apply -f deployment.yaml
```

### Option 3: Using Kustomize

```bash
# Deploy everything with kustomize
kubectl apply -k .
```

## 🔍 Verification

```bash
# Check deployment status
kubectl get deployment -n go-sample

# Check pods
kubectl get pods -n go-sample

# Test the application
kubectl exec -n go-sample <pod-name> -- curl -s http://localhost:8080
```

## 🌐 Access the Application

```bash
# Port forward to access locally
kubectl port-forward deployment/go-sample-deployment 8080:8080 -n go-sample

# Visit http://localhost:8080 in your browser
```

## 🧹 Cleanup

```bash
# Remove deployment only
kubectl delete -f deployment.yaml

# Or remove everything
kubectl delete namespace go-sample
```

## 📝 Notes

- The `deployment.yaml` contains only the Deployment resource
- It references external ConfigMap (`go-sample-config`) and Namespace (`go-sample`)
- No Service is defined in the deployment.yaml - access is via port-forwarding
- The application uses netcat to serve simple HTTP responses
- Health checks use the root path `/` for both liveness and readiness probes
