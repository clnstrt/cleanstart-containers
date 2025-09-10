# 🔍 Prometheus Sample Projects

This directory contains sample projects for testing the `cleanstart/prometheus` Docker image that you already pulled from Docker Hub. These examples demonstrate Prometheus monitoring configurations for metrics collection, alerting, and visualization.

## 🚀 Quick Start

### Prerequisites
- Docker installed and running
- Port 9090 available (optional)

### Setup
```bash
# Navigate to this directory
cd containers/prometheus/sample-project

# Test the image (you already pulled cleanstart/prometheus:latest from Docker Hub)
docker run --rm cleanstart/prometheus:latest prometheus --version
```

### Run Examples

#### Basic Prometheus Monitoring
```bash
# Run Prometheus with default configuration
docker run --rm -p 9090:9090 -v $(pwd)/prometheus.yml:/etc/prometheus/prometheus.yml \
  cleanstart/prometheus:latest

# Access at http://localhost:9090
```

#### Kubernetes Monitoring
```bash
# Navigate to kubernetes samples
cd kubernetes

# Deploy Prometheus to Kubernetes
kubectl apply -f prometheus-deployment.yaml
kubectl apply -f prometheus-service.yaml
kubectl apply -f prometheus-configmap.yaml

# Access via port-forward
kubectl port-forward svc/prometheus-service 9090:9090
```

#### Using Docker Compose
```bash
# Start Prometheus with monitoring
docker-compose up -d

# Access Prometheus UI
open http://localhost:9090
```

## 📁 Project Structure

```
sample-project/
├── README.md                    # This file
├── prometheus.yml              # Prometheus configuration
├── kubernetes/                 # Kubernetes deployment examples
│   ├── prometheus-deployment.yaml
│   ├── prometheus-service.yaml
│   ├── prometheus-configmap.yaml
│   └── README.md
└── docker-compose.yml          # Docker Compose setup
```

## 🎯 Features

- Metrics collection and storage
- Alerting rules and notifications
- Service discovery
- Grafana integration
- Kubernetes monitoring
- Custom metrics endpoints

## 📊 Output

Prometheus provides:
- Time-series metrics data
- Alert notifications
- Query results (PromQL)
- Service health status
- Performance monitoring

## 🔒 Security

- Non-root user execution
- Secure Prometheus configurations
- RBAC permissions
- Network security

## 🤝 Contributing

To add new Prometheus configurations:
1. Create configuration in appropriate directory
2. Add documentation
3. Test with Prometheus
