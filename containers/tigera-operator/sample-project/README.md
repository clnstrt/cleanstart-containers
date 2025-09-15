# 🚀 Tigera Operator Sample Projects

This directory contains comprehensive sample projects demonstrating Tigera Operator and Calico networking capabilities.

## 📁 Project Structure

```
sample-project/
├── basic-setup/           # Basic Calico installation and configuration
├── advanced-networking/    # Complex networking scenarios
├── security-policies/      # Network security policies
├── monitoring/            # Observability and monitoring
└── README.md             # This file
```

## 🚀 Quick Start

### 1. Basic Setup
Start with the basic setup to get Calico running:

```bash
cd basic-setup
kubectl apply -f tigera-operator.yaml
kubectl apply -f calico-installation.yaml
```

### 2. Security Policies
Implement network security:

```bash
cd security-policies
kubectl apply -f network-policies/
```

### 3. Advanced Networking
Configure complex networking:

```bash
cd advanced-networking
kubectl apply -f multi-cluster/
```

### 4. Monitoring
Set up observability:

```bash
cd monitoring
kubectl apply -f prometheus-config.yaml
kubectl apply -f grafana-dashboard.yaml
```

## 📋 Sample Projects Overview

### 🔧 Basic Setup
- **Tigera Operator Installation**: Complete operator setup
- **Calico Installation**: Basic Calico networking
- **Simple Network Policies**: Basic security rules
- **Health Checks**: Operator and Calico health monitoring

### 🌐 Advanced Networking
- **Multi-Cluster Setup**: Cross-cluster networking
- **BGP Configuration**: Advanced routing
- **IP Pool Management**: Custom IP allocation
- **Service Mesh Integration**: Istio and Calico integration

### 🛡️ Security Policies
- **Network Policies**: Comprehensive security rules
- **Global Network Policies**: Cluster-wide security
- **Pod Security Policies**: Pod-level security
- **Compliance Policies**: Regulatory compliance examples

### 📊 Monitoring
- **Prometheus Integration**: Metrics collection
- **Grafana Dashboards**: Visualization
- **Alerting Rules**: Proactive monitoring
- **Log Aggregation**: Centralized logging

## 🛠️ Prerequisites

- Kubernetes cluster (v1.21+)
- kubectl configured
- Tigera Operator installed
- Calico networking enabled

## 📖 Learning Path

1. **Start with Basic Setup**: Understand fundamental concepts
2. **Explore Security Policies**: Learn security best practices
3. **Advanced Networking**: Master complex scenarios
4. **Implement Monitoring**: Add observability
5. **Production Deployment**: Scale to production

## 🔍 Testing

Each sample project includes test scenarios:

```bash
# Test basic setup
cd basic-setup
./test-setup.sh

# Test security policies
cd security-policies
./test-policies.sh

# Test monitoring
cd monitoring
./test-monitoring.sh
```

## 📚 Documentation

- [Tigera Operator Docs](https://docs.tigera.io/calico/latest/operations/install)
- [Calico Documentation](https://docs.tigera.io/calico/latest/about)
- [Network Policies Guide](https://docs.tigera.io/calico/latest/security/calico-network-policy)

## 🤝 Contributing

Contributions are welcome! Please see our [Contributing Guide](../../../CONTRIBUTING.md).

---

**Happy Networking with Calico!** 🐳
