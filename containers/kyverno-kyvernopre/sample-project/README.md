# Kyverno-Kyvernopre Sample Project

This sample project demonstrates how to properly run and test the Kyverno-Kyvernopre container with the correct environment variables and configurations.

## 🚀 Quick Start - Working Steps

### Step 1: Pull the Image
```bash
docker pull cleanstart/kyverno-kyvernopre:latest
```

### Step 2: Test Container (Recommended)
```bash
docker run --rm --name kyverno-test \
  -e KYVERNO_NAMESPACE=kyverno \
  -e KYVERNO_SERVICEACCOUNT_NAME=kyverno \
  -e KYVERNO_DEPLOYMENT=kyverno \
  -e KYVERNO_POD_NAME=kyverno-pre \
  -e INIT_CONFIG='{"config":{}}' \
  -e METRICS_CONFIG='{"enabled":false}' \
  cleanstart/kyverno-kyvernopre:latest --help
```

### Step 3: Run Production Container
```bash
docker run -d --name kyverno-prod \
  -e KYVERNO_NAMESPACE=kyverno \
  -e KYVERNO_SERVICEACCOUNT_NAME=kyverno \
  -e KYVERNO_DEPLOYMENT=kyverno \
  -e KYVERNO_POD_NAME=kyverno-pre \
  -e INIT_CONFIG='{"config":{}}' \
  -e METRICS_CONFIG='{"enabled":false}' \
  cleanstart/kyverno-kyvernopre:latest
```

### Step 4: Check Container Status
```bash
docker logs kyverno-prod
```

### Step 5: Clean Up
```bash
docker stop kyverno-prod
docker rm kyverno-prod
```

## 🔧 Required Environment Variables

The container requires these 6 environment variables to start properly:

| Variable | Value | Description |
|----------|-------|-------------|
| `KYVERNO_NAMESPACE` | kyverno | Namespace where Kyverno is installed |
| `KYVERNO_SERVICEACCOUNT_NAME` | kyverno | Service account name for Kyverno |
| `KYVERNO_DEPLOYMENT` | kyverno | Deployment name for Kyverno |
| `KYVERNO_POD_NAME` | kyverno-pre | Pod name for Kyverno pre-hook |
| `INIT_CONFIG` | `{"config":{}}` | Initial configuration (JSON object) |
| `METRICS_CONFIG` | `{"enabled":false}` | Metrics configuration (JSON object) |

## 📁 Files in This Project

- `README.md` - This documentation with working steps
- `Dockerfile` - Sample Dockerfile showing how to extend the base image
- `test-config.yaml` - Sample Kyverno policy configuration

## 🎯 What This Container Does

The Kyverno-Kyvernopre container is a Kubernetes admission controller that:
- Validates Kubernetes resources before they're created
- Supports various configuration options for logging, rate limiting, and metrics
- Requires a Kubernetes cluster connection for full operation
- Can be tested using the `--help` flag to show available options

## 💡 Tips

- Use `--help` command for testing (no Kubernetes cluster required)
- The container runs as an admission controller in Kubernetes
- All environment variables are required for proper startup
- Use `--rm` flag for testing to automatically clean up containers