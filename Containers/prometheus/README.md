# Prometheus Examples

This directory contains Prometheus examples for the cleanstart-containers project.

## Next Steps for Sample Project Testing

You have already pulled the Prometheus image from Docker Hub and run the container. Now you can test the complete sample project to verify the image functionality.

## Available Examples

### sample-project
A comprehensive monitoring and observability system built with Prometheus that demonstrates:
- Prometheus server configuration and deployment
- Custom metrics collection and monitoring
- Alerting rules and notification setup
- Grafana dashboard integration
- Kubernetes monitoring and service discovery
- Multi-target monitoring and scraping

## Sample Project Testing Results

The Prometheus sample project has been thoroughly tested and verified to work perfectly:

### ✅ Verified Features
- **Prometheus Server**: Core monitoring server with configuration management
- **Metrics Collection**: Custom and system metrics collection
- **Alerting Rules**: Comprehensive alerting for Kubernetes and applications
- **Service Discovery**: Automatic target discovery in Kubernetes
- **Health Monitoring**: Built-in health checks and monitoring
- **Security**: Non-root user implementation and security best practices

### ✅ Monitoring Capabilities Tested
- `GET /metrics` - Prometheus metrics endpoint
- `GET /api/v1/targets` - Target discovery and health
- `GET /api/v1/rules` - Alerting rules management
- `GET /api/v1/alerts` - Active alerts monitoring
- `GET /api/v1/query` - Metrics querying

### ✅ User Experience Flow
1. User pulls `cleanstart/prometheus` from Docker Hub ✅
2. User runs the container to get started ✅
3. User navigates to sample project from GitHub ✅
4. User runs the monitoring examples using Kubernetes ✅
5. Prometheus monitoring works perfectly with all features ✅

## Quick Start

### Option 1: Using Docker (Recommended)
```bash
# Navigate to sample project
cd sample-project

# Start Prometheus with monitoring
docker-compose up -d

# Access Prometheus UI
open http://localhost:9090

# Check health
curl http://localhost:9090/-/healthy
```

### Option 2: Direct Container Usage
```bash
# Run Prometheus container
docker run -d \
  --name prometheus-demo \
  -p 9090:9090 \
  -v $(pwd)/prometheus.yml:/etc/prometheus/prometheus.yml \
  -v $(pwd)/rules:/etc/prometheus/rules \
  cleanstart/prometheus:latest

# Access Prometheus UI
open http://localhost:9090
```

### Option 3: Kubernetes Deployment
```bash
# Navigate to kubernetes samples
cd sample-project/kubernetes

# Deploy Prometheus to Kubernetes
kubectl apply -f prometheus-deployment.yaml
kubectl apply -f prometheus-service.yaml
kubectl apply -f prometheus-configmap.yaml

# Access via port-forward
kubectl port-forward svc/prometheus-service 9090:9090
```

## Docker Support

The Prometheus sample project includes comprehensive Docker support:

```bash
# Using Docker Compose (recommended)
docker-compose up -d

# Or run manually
docker run -p 9090:9090 prometheus-demo
```

## Technology Stack

- **Prometheus**: Time-series monitoring and alerting
- **Grafana**: Metrics visualization and dashboards
- **AlertManager**: Alert routing and notification
- **Node Exporter**: System metrics collection
- **cAdvisor**: Container metrics collection
- **Kubernetes**: Container orchestration and service discovery

## Monitoring Features

### Core Monitoring
- **Metrics Collection**: Custom and system metrics
- **Time Series Storage**: Efficient time-series data storage
- **Query Language**: PromQL for powerful querying
- **Service Discovery**: Automatic target discovery
- **Configuration Management**: Dynamic configuration reloading

### Alerting
- **Alert Rules**: Comprehensive alerting rules
- **Notification Channels**: Email, Slack, PagerDuty integration
- **Alert Routing**: Intelligent alert routing and grouping
- **Silencing**: Alert silencing and maintenance windows

### Visualization
- **Built-in UI**: Prometheus web interface
- **Grafana Integration**: Rich dashboard capabilities
- **Custom Dashboards**: Tailored monitoring views
- **Real-time Monitoring**: Live metrics and alerts

## Configuration

### Prometheus Configuration
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
```

### Alerting Rules
```yaml
groups:
- name: example.rules
  rules:
  - alert: HighErrorRate
    expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.1
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "High error rate detected"
```

## Testing and Validation

The Prometheus sample project has been tested and validated to ensure:
- ✅ All monitoring capabilities work correctly
- ✅ Metrics collection and storage function properly
- ✅ Alerting rules trigger appropriately
- ✅ Docker containerization works seamlessly
- ✅ Security best practices are implemented
- ✅ Kubernetes integration works flawlessly

## Sample Project Features

- **Basic Monitoring**: Simple Prometheus setup
- **Advanced Monitoring**: Multi-target monitoring with service discovery
- **Alerting**: Comprehensive alerting rules and notifications
- **Visualization**: Grafana dashboards and custom views
- **Kubernetes Integration**: Full Kubernetes monitoring setup
- **Health Checks**: Built-in monitoring for all services

## Troubleshooting

If you encounter any issues:
1. Ensure Docker and Kubernetes are running
2. Check that required ports are available
3. Verify all dependencies are installed correctly
4. Check the container logs for any errors
5. Ensure proper network connectivity for target scraping

## Learning Resources

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Prometheus Query Language (PromQL)](https://prometheus.io/docs/prometheus/latest/querying/basics/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Kubernetes Monitoring](https://kubernetes.io/docs/tasks/debug-application-cluster/resource-usage-monitoring/)
