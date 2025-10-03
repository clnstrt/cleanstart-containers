# cAdvisor GCP Deployment

This project deploys **cAdvisor** (Container Advisor) on Google Kubernetes Engine (GKE) using the CleanStart cAdvisor image. cAdvisor provides container users with resource usage and performance characteristics of running containers.

## Overview

cAdvisor is a running daemon that collects, aggregates, processes, and exports information about running containers. It provides:
- Real-time container resource monitoring and metrics collection
- Native Prometheus metrics endpoint integration
- Historical performance data analysis and storage
- Enterprise-grade security with RBAC support

## Prerequisites

- Google Cloud CLI installed and configured
- kubectl configured to connect to your GKE cluster
- Docker installed (for building images if needed)
- GKE cluster with appropriate permissions

## Deployment Instructions

### Step 0: Connect to Your GKE Cluster

```bash
gcloud container clusters get-credentials <cluster-name> --zone <zone-name>
```

### Step 1: Navigate to the GCP Directory

```bash
cd containers/cAdvisor/gcp
```

### Step 2: Create the Namespace

```bash
kubectl apply -f namespace.yaml
```

### Step 3: Deploy cAdvisor Application

```bash
kubectl apply -f deployment.yaml -n cadvisor-app
```

### Step 4: Create the Service

```bash
kubectl apply -f service.yaml -n cadvisor-app
```

### Step 5: Verify Deployment

```bash
kubectl get all -n cadvisor-app
```

## Accessing cAdvisor

### Get the External IP

```bash
kubectl get service cadvisor-app-service -n cadvisor-app
```

### Port Forward to Access cAdvisor

Since we're using ClusterIP service, use port forwarding:

```bash
kubectl port-forward service/cadvisor-app-service 8080:8080 -n cadvisor-app
```

Then access at: `http://localhost:8080`

### Access Prometheus Metrics

cAdvisor exposes Prometheus metrics at:
```
http://localhost:8080/metrics
```

## Configuration Details

### Simplified Deployment

This deployment uses a minimal configuration to avoid crash loop backoff:
- Basic container configuration without complex security contexts
- No volume mounts (cAdvisor will work with limited visibility)
- Simple ClusterIP service for internal access
- Port forwarding for external access

### Container Arguments

- `--port=8080`: Exposes cAdvisor on port 8080
- `--housekeeping_interval=10s`: Sets data collection interval

## Useful Commands

### Check Pod Status

```bash
kubectl get pods -n cadvisor-app
```

### View Logs

```bash
kubectl logs -f deployment/cadvisor-app -n cadvisor-app
```

### Check Events

```bash
kubectl get events -n cadvisor-app --sort-by='.lastTimestamp'
```

### Port Forward (Alternative Access)

```bash
kubectl port-forward service/cadvisor-app-service 8080:8080 -n cadvisor-app
```

Then access at: `http://localhost:8080`

### Scale Deployment

```bash
kubectl scale deployment cadvisor-app --replicas=2 -n cadvisor-app
```

## Monitoring and Metrics

### Prometheus Integration

cAdvisor automatically exposes metrics in Prometheus format. You can scrape these metrics using:

```yaml
- job_name: 'cadvisor'
  static_configs:
  - targets: ['<EXTERNAL-IP>:8080']
  scrape_interval: 30s
```

### Key Metrics

- `container_cpu_usage_seconds_total`
- `container_memory_usage_bytes`
- `container_network_receive_bytes_total`
- `container_network_transmit_bytes_total`

## Troubleshooting

### Common Issues

1. **Pod Not Starting**: Check if the node has sufficient permissions for host filesystem access
2. **No Metrics**: Verify that volume mounts are correctly configured
3. **Access Issues**: Ensure the LoadBalancer service has an external IP assigned

### Debug Commands

```bash
# Describe the pod for detailed information
kubectl describe pod -l app=cadvisor-app -n cadvisor-app

# Check service endpoints
kubectl get endpoints -n cadvisor-app

# View detailed service information
kubectl describe service cadvisor-app-service -n cadvisor-app
```

## Cleanup

To remove the cAdvisor deployment:

```bash
kubectl delete -f service.yaml -n cadvisor-app
kubectl delete -f deployment.yaml -n cadvisor-app
kubectl delete -f namespace.yaml
```

## Architecture Notes

- **Image**: `cleanstart/cadvisor:latest`
- **Port**: 8080 (exposed via LoadBalancer)
- **Network**: Host network for container monitoring
- **Storage**: No persistent storage required (in-memory metrics)

## Security Considerations

- The deployment uses `hostNetwork: true` for container monitoring
- Runs with minimal privileges (non-root user)
- All security contexts are hardened for production use
- Read-only filesystem prevents malicious modifications

## Performance Optimization

- Resource limits prevent excessive resource consumption
- Health checks ensure service availability
- Single replica deployment for monitoring efficiency
- Optimized for GKE cluster environments

---

For more information about CleanStart containers, visit: https://www.cleanstart.com
