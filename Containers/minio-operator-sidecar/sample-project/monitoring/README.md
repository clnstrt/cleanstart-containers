# MinIO Monitoring and Observability Setup

This example demonstrates how to set up comprehensive monitoring and observability for MinIO clusters using Prometheus, Grafana, and MinIO-specific metrics.

## 🎯 What You'll Learn

- Deploy Prometheus for metrics collection
- Configure Grafana dashboards for MinIO
- Set up MinIO metrics exporter
- Implement alerting and notifications
- Monitor MinIO cluster health and performance

## 📋 Prerequisites

- Kubernetes cluster with MinIO operator deployed
- MinIO tenant running
- Helm installed (for easy deployment)
- Ports 9090, 3000, 9091 available

## 🚀 Quick Start

### 1. Deploy Prometheus

```bash
# Create monitoring namespace
kubectl create namespace monitoring

# Deploy Prometheus
kubectl apply -f prometheus.yaml

# Wait for Prometheus to be ready
kubectl wait --for=condition=available --timeout=300s deployment/prometheus -n monitoring
```

### 2. Deploy MinIO Exporter

```bash
# Deploy MinIO metrics exporter
kubectl apply -f minio-exporter.yaml

# Wait for exporter to be ready
kubectl wait --for=condition=available --timeout=300s deployment/minio-exporter -n monitoring
```

### 3. Deploy Grafana

```bash
# Deploy Grafana
kubectl apply -f grafana.yaml

# Wait for Grafana to be ready
kubectl wait --for=condition=available --timeout=300s deployment/grafana -n monitoring
```

### 4. Deploy AlertManager

```bash
# Deploy AlertManager
kubectl apply -f alertmanager.yaml

# Wait for AlertManager to be ready
kubectl wait --for=condition=available --timeout=300s deployment/alertmanager -n monitoring
```

### 5. Access Monitoring Services

```bash
# Port forward Prometheus
kubectl port-forward svc/prometheus 9090:9090 -n monitoring &

# Port forward Grafana
kubectl port-forward svc/grafana 3000:3000 -n monitoring &

# Port forward MinIO Exporter
kubectl port-forward svc/minio-exporter 9091:9091 -n monitoring &

# Access services
open http://localhost:9090  # Prometheus
open http://localhost:3000  # Grafana (admin/admin)
open http://localhost:9091  # MinIO Exporter
```

## 📁 Files Overview

- `prometheus.yaml` - Prometheus deployment and configuration
- `minio-exporter.yaml` - MinIO metrics exporter
- `grafana.yaml` - Grafana deployment and dashboards
- `alertmanager.yaml` - AlertManager configuration
- `dashboards/` - Grafana dashboard configurations
- `alerts/` - Prometheus alert rules
- `test-monitoring.sh` - Test script for monitoring setup
- `README.md` - This documentation

## 🔧 Configuration Details

### Prometheus
- **Namespace**: `monitoring`
- **Storage**: 50Gi persistent volume
- **Retention**: 30 days
- **Scrape Interval**: 15s
- **Targets**: MinIO operator, MinIO tenants, MinIO exporter

### MinIO Exporter
- **Namespace**: `monitoring`
- **Port**: 9091
- **Metrics**: MinIO-specific metrics
- **Authentication**: MinIO credentials
- **Targets**: All MinIO tenants

### Grafana
- **Namespace**: `monitoring`
- **Port**: 3000
- **Credentials**: admin/admin
- **Dashboards**: MinIO cluster, tenant, and performance dashboards
- **Data Source**: Prometheus

### AlertManager
- **Namespace**: `monitoring`
- **Port**: 9093
- **Channels**: Email, Slack, webhook
- **Rules**: MinIO-specific alert rules

## 🧪 Testing

### Run the Test Script

```bash
# Make script executable
chmod +x test-monitoring.sh

# Run tests
./test-monitoring.sh
```

### Manual Testing

```bash
# Check monitoring pods
kubectl get pods -n monitoring

# Check monitoring services
kubectl get svc -n monitoring

# Check Prometheus targets
kubectl port-forward svc/prometheus 9090:9090 -n monitoring
# Open http://localhost:9090/targets

# Check MinIO metrics
kubectl port-forward svc/minio-exporter 9091:9091 -n monitoring
# Open http://localhost:9091/metrics
```

## 📊 Monitoring Dashboards

### MinIO Cluster Dashboard
- **Overview**: Cluster health, node status, storage usage
- **Performance**: Request latency, throughput, error rates
- **Storage**: Disk usage, available space, replication status
- **Security**: Authentication attempts, access patterns

### MinIO Tenant Dashboard
- **Tenant Health**: Pod status, readiness, liveness
- **Resource Usage**: CPU, memory, storage per tenant
- **Performance**: API response times, request rates
- **Errors**: Error rates, failed requests

### MinIO Performance Dashboard
- **Throughput**: Requests per second, data transfer rates
- **Latency**: P50, P95, P99 response times
- **Errors**: Error rates by endpoint, error types
- **Capacity**: Storage usage, available space

## 🚨 Alerting Rules

### Critical Alerts
- **Tenant Down**: MinIO tenant pods not running
- **High Error Rate**: Error rate > 5%
- **Storage Full**: Disk usage > 90%
- **High Latency**: P95 latency > 1s

### Warning Alerts
- **High CPU Usage**: CPU usage > 80%
- **High Memory Usage**: Memory usage > 80%
- **Replication Lag**: Replication lag > 1 hour
- **Backup Failure**: Backup job failed

### Info Alerts
- **Tenant Created**: New tenant created
- **Tenant Deleted**: Tenant deleted
- **Scaling Event**: Tenant scaled up/down
- **Configuration Change**: Tenant configuration updated

## 🔍 Monitoring Best Practices

### Key Metrics to Monitor

1. **Availability Metrics**
   - Pod status and readiness
   - Service availability
   - API endpoint health

2. **Performance Metrics**
   - Request latency (P50, P95, P99)
   - Throughput (requests/second)
   - Error rates

3. **Resource Metrics**
   - CPU usage
   - Memory usage
   - Storage usage
   - Network I/O

4. **Business Metrics**
   - Number of tenants
   - Storage capacity
   - User activity
   - Data growth

### Dashboard Organization

1. **Overview Dashboards**
   - High-level cluster status
   - Key performance indicators
   - Recent alerts and events

2. **Detailed Dashboards**
   - Per-tenant metrics
   - Performance analysis
   - Resource utilization

3. **Operational Dashboards**
   - Troubleshooting information
   - Log analysis
   - Configuration details

## 🛠️ Troubleshooting

### Common Issues

**Prometheus not collecting metrics**
```bash
# Check Prometheus configuration
kubectl get configmap prometheus-config -n monitoring -o yaml

# Check Prometheus logs
kubectl logs -l app=prometheus -n monitoring

# Check Prometheus targets
kubectl port-forward svc/prometheus 9090:9090 -n monitoring
# Open http://localhost:9090/targets
```

**Grafana not loading dashboards**
```bash
# Check Grafana logs
kubectl logs -l app=grafana -n monitoring

# Check Grafana configuration
kubectl get configmap grafana-config -n monitoring -o yaml

# Check data source connection
kubectl port-forward svc/grafana 3000:3000 -n monitoring
# Open http://localhost:3000/datasources
```

**MinIO Exporter not working**
```bash
# Check exporter logs
kubectl logs -l app=minio-exporter -n monitoring

# Check exporter configuration
kubectl get configmap minio-exporter-config -n monitoring -o yaml

# Test exporter metrics
kubectl port-forward svc/minio-exporter 9091:9091 -n monitoring
# Open http://localhost:9091/metrics
```

**Alerts not firing**
```bash
# Check AlertManager configuration
kubectl get configmap alertmanager-config -n monitoring -o yaml

# Check AlertManager logs
kubectl logs -l app=alertmanager -n monitoring

# Check alert rules
kubectl get configmap prometheus-rules -n monitoring -o yaml
```

## 🧹 Cleanup

### Remove Monitoring Setup

```bash
# Delete monitoring components
kubectl delete -f prometheus.yaml
kubectl delete -f minio-exporter.yaml
kubectl delete -f grafana.yaml
kubectl delete -f alertmanager.yaml

# Delete monitoring namespace
kubectl delete namespace monitoring
```

## 📚 Next Steps

After completing this monitoring setup:

1. **Customize Dashboards** - Create custom dashboards for your needs
2. **Set Up Alerting** - Configure email/Slack notifications
3. **Implement Logging** - Add centralized logging with ELK stack
4. **Add Tracing** - Implement distributed tracing

## 🔗 Related Examples

- [Basic Tenant Setup](../basic-tenant/) - Single tenant deployment
- [Multi-Tenant Setup](../multi-tenant/) - Multiple tenants in one cluster
- [Production Setup](../production-setup/) - Enterprise-grade configuration

---

**Happy Monitoring! 📊**
