# 🚀 Tigera Operator Container

A CleanStart container image for Tigera Operator, providing Calico networking and security management for Kubernetes clusters.

## 📋 Overview

Tigera Operator is the official operator for managing Calico networking, security, and observability in Kubernetes clusters. This container provides a complete environment for deploying and managing Calico with Tigera Operator.

## 🏗️ What's Included

- **Tigera Operator**: Latest version for Calico management
- **kubectl**: Kubernetes CLI tool
- **Configuration Templates**: Pre-configured Calico setups
- **Security Tools**: Network policies and security configurations
- **Monitoring**: Observability and monitoring configurations

## 🚀 Quick Start

### Using Docker

```bash
# Run the container
docker run -it --rm cleanstart/tigera-operator:latest

# Apply Tigera Operator
kubectl apply -f /tmp/tigera-operator.yaml

# Apply Calico configuration
kubectl apply -f /app/calico-config.yaml
```

### Using Docker Compose

```bash
# Navigate to sample project
cd sample-project/basic-setup

# Start the environment
docker-compose up -d
```

## 📁 Sample Projects

This container includes comprehensive sample projects:

### 1. **Basic Setup** (`sample-project/basic-setup/`)
- Minimal Calico installation
- Basic network policies
- Simple configuration examples

### 2. **Advanced Networking** (`sample-project/advanced-networking/`)
- Complex network topologies
- Multi-cluster configurations
- Advanced routing examples

### 3. **Security Policies** (`sample-project/security-policies/`)
- Network security policies
- Pod security policies
- Compliance configurations

### 4. **Monitoring & Observability** (`sample-project/monitoring/`)
- Calico monitoring setup
- Metrics collection
- Alerting configurations

## 🔧 Configuration

### Environment Variables

- `TIGERA_OPERATOR_VERSION`: Tigera Operator version (default: v1.35.0)
- `CALICO_VERSION`: Calico version (default: v3.26.4)
- `KUBECTL_VERSION`: kubectl version (default: v1.28.0)

### Configuration Files

- `operator-config.yaml`: Tigera Operator configuration
- `calico-config.yaml`: Calico installation configuration

## 🛡️ Security Features

- **Non-root user**: Runs as `operator` user for security
- **Minimal base image**: Alpine Linux for reduced attack surface
- **Certificate management**: Built-in CA certificate handling
- **Network policies**: Pre-configured security policies

## 📊 Monitoring

The container includes monitoring capabilities:

- **Metrics collection**: Prometheus-compatible metrics
- **Health checks**: Built-in health monitoring
- **Logging**: Structured logging for observability

## 🔗 Integration

### With Prometheus

```yaml
# Prometheus scrape config
- job_name: 'calico'
  static_configs:
    - targets: ['calico-node:9091']
```

### With Grafana

```bash
# Import Calico dashboard
kubectl apply -f sample-project/monitoring/grafana-dashboard.yaml
```

## 📚 Learning Path

1. **Start with Basic Setup**: Learn fundamental Calico concepts
2. **Explore Network Policies**: Understand security configurations
3. **Advanced Networking**: Master complex topologies
4. **Monitoring**: Implement observability
5. **Production Setup**: Deploy in production environments

## 🆘 Troubleshooting

### Common Issues

1. **Operator not starting**: Check RBAC permissions
2. **Network policies not working**: Verify Calico installation
3. **Metrics not available**: Check Prometheus configuration

### Debug Commands

```bash
# Check operator status
kubectl get pods -n tigera-operator

# View Calico logs
kubectl logs -n calico-system -l k8s-app=calico-node

# Check network policies
kubectl get networkpolicies --all-namespaces
```

## 📖 Documentation

- [Tigera Operator Documentation](https://docs.tigera.io/calico/latest/operations/install)
- [Calico Documentation](https://docs.tigera.io/calico/latest/about)
- [Network Policies Guide](https://docs.tigera.io/calico/latest/security/calico-network-policy)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](../../CONTRIBUTING.md) for details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../../LICENSE) file for details.

---

**CleanStart Containers** - Making containerization simple and secure! 🐳
