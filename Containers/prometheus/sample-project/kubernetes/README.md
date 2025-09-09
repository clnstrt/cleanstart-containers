# 🚀 Prometheus Kubernetes Samples

This directory contains comprehensive Kubernetes sample projects for Prometheus monitoring deployment. These examples demonstrate various Kubernetes concepts including deployments, services, persistent volumes, configmaps, RBAC, monitoring, alerting, and more.

## 📁 Project Structure

```
kubernetes/
├── prometheus-deployment.yaml              # Prometheus deployment
├── prometheus-service.yaml                 # Prometheus service
├── prometheus-configmap.yaml               # Prometheus configuration
├── prometheus-rules.yaml                   # Alerting rules
├── prometheus-pvc.yaml                     # Persistent Volume Claim
├── prometheus-rbac.yaml                    # RBAC configuration
├── prometheus-ingress.yaml                 # Ingress configuration
├── node-exporter.yaml                      # Node Exporter deployment
├── grafana-deployment.yaml                 # Grafana deployment
├── docker-compose.yml                      # Full local testing setup
├── docker-compose-simple.yml               # Simple local testing
├── scripts/
│   └── deploy.sh                           # Deployment automation script
└── README.md                               # This file
```

## 🎯 What You'll Learn

By working through these examples, you'll understand:

- **Prometheus Deployment** - How to deploy Prometheus as a monitoring solution
- **Node Exporter** - Host metrics collection and monitoring
- **Grafana Integration** - Visualization and dashboard management
- **Persistent Volumes** - Data persistence across pod restarts
- **RBAC** - Role-based access control for monitoring
- **ConfigMaps** - Configuration management for Prometheus
- **Alerting Rules** - Custom alerting and notification setup
- **Service Discovery** - Automatic target discovery and scraping
- **Resource Management** - CPU and memory limits for monitoring
- **Ingress** - External access to monitoring dashboards
- **Local Development** - Docker Compose for testing

## 🚀 Quick Start

### Prerequisites

- Kubernetes cluster (local or cloud)
- `kubectl` configured to access your cluster
- Docker (for local testing)
- Prometheus client tools (optional)

### Option 1: Using the Deployment Script (Recommended)

```bash
# Make the script executable
chmod +x scripts/deploy.sh

# Deploy all components
./scripts/deploy.sh

# Check deployment status
kubectl get pods -l app=prometheus
kubectl get pods -l app=node-exporter
kubectl get pods -l app=grafana
```

### Option 2: Manual Deployment

```bash
# Deploy Prometheus
kubectl apply -f prometheus-deployment.yaml
kubectl apply -f prometheus-service.yaml
kubectl apply -f prometheus-configmap.yaml
kubectl apply -f prometheus-rbac.yaml
kubectl apply -f prometheus-pvc.yaml

# Deploy Node Exporter
kubectl apply -f node-exporter.yaml

# Deploy Grafana
kubectl apply -f grafana-deployment.yaml

# Deploy Ingress (optional)
kubectl apply -f prometheus-ingress.yaml
```

## 🐳 Local Testing with Docker Compose

### Simple Setup (Recommended for Testing)

```bash
# Start all services
docker-compose -f docker-compose-simple.yml up -d

# Check service status
docker-compose -f docker-compose-simple.yml ps

# View logs
docker-compose -f docker-compose-simple.yml logs prometheus
docker-compose -f docker-compose-simple.yml logs node-exporter

# Stop services
docker-compose -f docker-compose-simple.yml down
```

### Full Setup (Production-like)

```bash
# Start all services with persistent volumes
docker-compose -f docker-compose.yml up -d

# Check service status
docker-compose -f docker-compose.yml ps

# View logs
docker-compose -f docker-compose.yml logs

# Stop services
docker-compose -f docker-compose.yml down
```

## 🔧 Configuration

### Prometheus Configuration

The Prometheus configuration is managed through ConfigMaps:

```yaml
# prometheus-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
    scrape_configs:
      - job_name: 'prometheus'
        static_configs:
          - targets: ['localhost:9090']
      - job_name: 'node-exporter'
        static_configs:
          - targets: ['node-exporter:9100']
```

### Alerting Rules

Custom alerting rules are defined in `prometheus-rules.yaml`:

- **High CPU Usage** - Alert when CPU usage exceeds 80%
- **High Memory Usage** - Alert when memory usage exceeds 90%
- **Disk Space Low** - Alert when disk space is below 10%
- **Service Down** - Alert when services are unreachable

## 📊 Monitoring Features

### Prometheus Features

- **Metrics Collection** - Scrapes metrics from various targets
- **Query Language** - PromQL for advanced queries
- **Alerting** - Rule-based alerting system
- **Service Discovery** - Automatic target discovery
- **Data Retention** - Configurable data retention policies

### Node Exporter Features

- **System Metrics** - CPU, memory, disk, network
- **Hardware Metrics** - Temperature, fan speed, power
- **Process Metrics** - Running processes and resource usage
- **Custom Metrics** - Application-specific metrics

### Grafana Features

- **Dashboards** - Pre-built and custom dashboards
- **Data Sources** - Multiple data source support
- **Alerting** - Visual alerting and notifications
- **User Management** - Role-based access control

## 🌐 Access Points

### Local Development

- **Prometheus UI**: http://localhost:9090
- **Node Exporter**: http://localhost:9100
- **Grafana**: http://localhost:3000 (admin/admin)

### Kubernetes Cluster

- **Prometheus Service**: `prometheus-service:9090`
- **Node Exporter Service**: `node-exporter-service:9100`
- **Grafana Service**: `grafana-service:3000`

### Ingress (if enabled)

- **Prometheus**: `http://prometheus.yourdomain.com`
- **Grafana**: `http://grafana.yourdomain.com`

## 🔍 Verification

### Check Prometheus Status

```bash
# Check if Prometheus is running
kubectl get pods -l app=prometheus

# Check Prometheus logs
kubectl logs -l app=prometheus

# Test Prometheus API
curl http://localhost:9090/-/healthy
```

### Check Node Exporter Status

```bash
# Check if Node Exporter is running
kubectl get pods -l app=node-exporter

# Check Node Exporter logs
kubectl logs -l app=node-exporter

# Test Node Exporter metrics
curl http://localhost:9100/metrics
```

### Check Grafana Status

```bash
# Check if Grafana is running
kubectl get pods -l app=grafana

# Check Grafana logs
kubectl logs -l app=grafana

# Test Grafana API
curl http://localhost:3000/api/health
```

## 📈 Sample Queries

### Basic Queries

```promql
# CPU usage percentage
100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory usage percentage
100 - ((node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100)

# Disk usage percentage
100 - ((node_filesystem_avail_bytes / node_filesystem_size_bytes) * 100)

# Network traffic
rate(node_network_receive_bytes_total[5m])
rate(node_network_transmit_bytes_total[5m])
```

### Advanced Queries

```promql
# Top 5 processes by CPU usage
topk(5, rate(process_cpu_seconds_total[5m]))

# Memory usage by process
topk(10, process_resident_memory_bytes)

# Disk I/O rate
rate(node_disk_read_bytes_total[5m])
rate(node_disk_written_bytes_total[5m])
```

## 🚨 Troubleshooting

### Common Issues

1. **Prometheus not starting**
   - Check logs: `kubectl logs -l app=prometheus`
   - Verify ConfigMap: `kubectl describe configmap prometheus-config`
   - Check RBAC: `kubectl get clusterrole prometheus`

2. **Node Exporter not collecting metrics**
   - Check logs: `kubectl logs -l app=node-exporter`
   - Verify service: `kubectl get svc node-exporter-service`
   - Check Prometheus targets: http://localhost:9090/targets

3. **Grafana not accessible**
   - Check logs: `kubectl logs -l app=grafana`
   - Verify service: `kubectl get svc grafana-service`
   - Check ingress: `kubectl get ingress`

### Debug Commands

```bash
# Check all resources
kubectl get all -l app=prometheus
kubectl get all -l app=node-exporter
kubectl get all -l app=grafana

# Check persistent volumes
kubectl get pv,pvc

# Check RBAC
kubectl get clusterrole,clusterrolebinding | grep prometheus

# Check ConfigMaps
kubectl get configmaps
kubectl describe configmap prometheus-config
```

## 🔧 Customization

### Adding Custom Metrics

1. **Create a custom exporter**
2. **Add to Prometheus configuration**
3. **Update service discovery**
4. **Create Grafana dashboards**

### Scaling Prometheus

1. **Increase resource limits**
2. **Configure horizontal pod autoscaler**
3. **Set up Prometheus federation**
4. **Implement data retention policies**

### Security Hardening

1. **Enable TLS/SSL**
2. **Configure authentication**
3. **Set up network policies**
4. **Implement RBAC**

## 📚 Additional Resources

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Node Exporter Documentation](https://github.com/prometheus/node_exporter)
- [Grafana Documentation](https://grafana.com/docs/)
- [Kubernetes Monitoring Guide](https://kubernetes.io/docs/tasks/debug-application-cluster/resource-usage-monitoring/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../../../LICENSE) file for details.

---

**Happy Monitoring! 🎉**

For questions or support, please open an issue in the repository.