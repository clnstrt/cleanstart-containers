# Execute Prometheus Monitoring on CleanStart Container - Prometheus

A comprehensive monitoring and alerting solution for applications and infrastructure built with **Prometheus**, **Docker**, and **CleanStart**.

## Objective

The objective of this project is to utilize CleanStart Container Image - Prometheus and build a complete monitoring and alerting system that provides metrics collection, querying, and visualization capabilities for applications and infrastructure.

## Summary

This project demonstrates how to combine Prometheus, Docker, and CleanStart to create a robust monitoring system. It offers both metrics collection and alerting capabilities—supporting various monitoring configurations—packaged in a containerized environment for easy deployment and scalability.

## Quick Start - Run Locally

### Prerequisites
Pull CleanStart Prometheus image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/prometheus:latest
```

### Step 1: Navigate to Prometheus Directory
```bash
cd containers/prometheus/sample-project
```

### Step 2: Run Prometheus with Default Configuration
```bash
# Run Prometheus with default configuration
docker run --rm -p 9090:9090 cleanstart/prometheus:latest

# Access at http://localhost:9090
```

### Step 3: Run Prometheus with Custom Configuration
```bash
# Run Prometheus with custom configuration
docker run --rm -p 9090:9090 -v $(pwd)/prometheus.yml:/etc/prometheus/prometheus.yml \
  cleanstart/prometheus:latest

# Access at http://localhost:9090
```

### Step 4: Run Prometheus with Data Persistence
```bash
# Run Prometheus with data persistence
docker run --rm -p 9090:9090 -v prometheus_data:/prometheus \
  cleanstart/prometheus:latest

# Access at http://localhost:9090
```

### Prometheus Output
You should see output like this:
```
prometheus, version 2.45.0 (branch: HEAD, revision: 2c375d6d0d4312c08295a6d3c1c7b7b8c8c8c8c8)
build user:       root@prometheus
build date:       20240115-10:30:45
go version:       go1.21.0
platform:         linux/amd64
level=info ts=2024-01-15T10:30:45.123Z caller=main.go:456 msg="Starting Prometheus Server" mode=server
level=info ts=2024-01-15T10:30:45.124Z caller=main.go:457 msg="Build context" go_version=go1.21.0
level=info ts=2024-01-15T10:30:45.125Z caller=main.go:458 msg="Loading configuration file" filename=/etc/prometheus/prometheus.yml
level=info ts=2024-01-15T10:30:45.126Z caller=main.go:459 msg="Completed loading of configuration file" filename=/etc/prometheus/prometheus.yml
level=info ts=2024-01-15T10:30:45.127Z caller=main.go:460 msg="Server is ready to receive web requests."
```

### Application Access
Once started, you can access the application at: **http://localhost:9090**

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

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [Prometheus Official Documentation](https://prometheus.io/docs/)
- [Prometheus Configuration Guide](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
