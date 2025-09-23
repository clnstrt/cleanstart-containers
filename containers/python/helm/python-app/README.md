# CleanStart Python Container - Community Deployment Guide

Deploy a secure, enterprise-grade Python container that demonstrates advanced security practices and performance monitoring.

## Features

- ✅ Security-hardened runtime environment
- ✅ Non-root user execution (UID 1001)
- ✅ Comprehensive health checks and monitoring
- ✅ Multi-architecture support (AMD64/ARM64)
- ✅ Performance optimized with benchmarking
- ✅ Production-ready Kubernetes deployment

## Quick Start

### Prerequisites
- Kubernetes cluster (v1.19+)
- Helm 3.0+
- kubectl configured

### Deploy with Helm

```bash
# Add the repository (if using a Helm repo)
helm repo add cleanstart https://your-helm-repo.com
helm repo update

# Install the application
helm install my-cleanstart-app ./helm/python-app

# Or with custom values
helm install my-cleanstart-app ./helm/python-app \
  --set image.tag=latest \
  --set replicaCount=3 \
  --set resources.requests.cpu=100m \
  --set resources.requests.memory=128Mi
```

### Access the Application

```bash
# Get service information
kubectl get svc

# Port forward to access locally
kubectl port-forward svc/my-cleanstart-demo-python-app 8080:5000

# Test the endpoints
curl http://localhost:8080/health    # Health check
curl http://localhost:8080/metrics   # Performance metrics
curl http://localhost:8080/info      # System information
curl http://localhost:8080/bench     # CPU benchmark
```

## Application Endpoints

| Endpoint | Description | Purpose |
|----------|-------------|---------|
| `/` | Welcome message | Basic connectivity test |
| `/health` | Health check | Kubernetes liveness/readiness |
| `/metrics` | Performance metrics | Monitoring and observability |
| `/info` | System information | Runtime environment details |
| `/bench` | CPU benchmark | Performance validation |
| `/stress` | Load testing | Stress testing capabilities |

## Configuration Options

### values.yaml Key Parameters

```yaml
# Replica configuration
replicaCount: 2

# Image settings
image:
  repository: your-registry/cleanstart-python
  tag: "latest"
  pullPolicy: IfNotPresent

# Service configuration
service:
  type: ClusterIP
  port: 5000

# Resource limits
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 512Mi

# Security context
securityContext:
  runAsNonRoot: true
  runAsUser: 1001
  allowPrivilegeEscalation: false
  capabilities:
    drop:
      - ALL
```

## Testing Framework

### Local Testing
```bash
# Test container locally
docker run -p 5000:5000 your-registry/cleanstart-python:latest

# Verify endpoints
curl http://localhost:5000/health
curl http://localhost:5000/metrics
```

### Kubernetes Testing
```bash
# Deploy test instance
helm install test-instance ./helm/python-app --set nameOverride=test

# Run comprehensive tests
kubectl run test-pod --image=curlimages/curl:latest --rm -it --restart=Never -- \
  sh -c "
    curl -f http://test-python-app:5000/health &&
    curl -f http://test-python-app:5000/metrics &&
    curl -f http://test-python-app:5000/info &&
    echo 'All tests passed!'
  "

# Cleanup test
helm uninstall test-instance
```

## Deployment Scenarios

### Development Environment
```bash
helm install dev-python ./helm/python-app \
  --set replicaCount=1 \
  --set resources.requests.cpu=50m \
  --set resources.requests.memory=64Mi \
  --set image.tag=dev
```

### Production Environment
```bash
helm install prod-python ./helm/python-app \
  --set replicaCount=5 \
  --set resources.requests.cpu=200m \
  --set resources.requests.memory=256Mi \
  --set resources.limits.cpu=1000m \
  --set resources.limits.memory=1Gi \
  --set autoscaling.enabled=true \
  --set autoscaling.maxReplicas=10
```

### High Availability Setup
```bash
helm install ha-python ./helm/python-app \
  --set replicaCount=3 \
  --set podDisruptionBudget.enabled=true \
  --set podDisruptionBudget.minAvailable=2 \
  --set affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].weight=100
```

## Monitoring and Observability

### Health Checks
The application includes comprehensive health checks:
- **Liveness**: `/health` endpoint
- **Readiness**: `/health` endpoint with dependency validation
- **Startup**: Configurable delay for application initialization

### Metrics Collection
```bash
# View application metrics
curl http://your-service:5000/metrics

# System information
curl http://your-service:5000/info | jq '.'
```

### Performance Benchmarking
```bash
# Run CPU benchmark
curl http://your-service:5000/bench

# Load testing endpoint
curl -X POST http://your-service:5000/stress \
  -H "Content-Type: application/json" \
  -d '{"duration": 30, "intensity": "medium"}'
```

## Scaling Operations

### Horizontal Scaling
```bash
# Manual scaling
kubectl scale deployment my-cleanstart-demo-python-app --replicas=5

# Auto-scaling with Helm
helm upgrade my-cleanstart-app ./helm/python-app \
  --set autoscaling.enabled=true \
  --set autoscaling.minReplicas=2 \
  --set autoscaling.maxReplicas=10 \
  --set autoscaling.targetCPUUtilizationPercentage=70
```

### Vertical Scaling
```bash
helm upgrade my-cleanstart-app ./helm/python-app \
  --set resources.requests.memory=512Mi \
  --set resources.requests.cpu=500m \
  --set resources.limits.memory=2Gi \
  --set resources.limits.cpu=2000m
```

## Troubleshooting

### Check Pod Status
```bash
kubectl get pods -l app.kubernetes.io/name=python-app
kubectl describe pod <pod-name>
```

### View Application Logs
```bash
kubectl logs -l app.kubernetes.io/name=python-app -f
```

### Test Connectivity
```bash
kubectl exec -it <pod-name> -- python3 -c "
import urllib.request
response = urllib.request.urlopen('http://localhost:5000/health')
print(response.read().decode())
"
```

### Common Issues

**Pod Stuck in Pending**: Check resource availability
```bash
kubectl describe node
kubectl top nodes
```

**CrashLoopBackOff**: Check application logs
```bash
kubectl logs <pod-name> --previous
```

**Service Unreachable**: Verify service and endpoints
```bash
kubectl get endpoints
kubectl get svc
```

## Cleanup

### Remove Application
```bash
helm uninstall my-cleanstart-app
```

### Verify Cleanup
```bash
kubectl get all -l app.kubernetes.io/name=python-app
```
