# 🚀 Prometheus - Kubernetes Deployment

Deploy Prometheus monitoring on Kubernetes using CleanStart container images.

## Quick Start

### Prerequisites
- Kubernetes cluster (minikube, kind, or cloud provider)
- kubectl configured to access your cluster

### Deploy Prometheus
```bash
# 1. Deploy Prometheus
kubectl apply -f prometheus-deployment.yaml

# 2. Deploy services
kubectl apply -f prometheus-service.yaml

# 3. Deploy configuration
kubectl apply -f prometheus-configmap.yaml

# 4. Deploy persistent volume
kubectl apply -f prometheus-pvc.yaml
```

### Access Prometheus
```bash
# Port forward to access Prometheus
kubectl port-forward svc/prometheus-service 9090:9090

# Access: http://localhost:9090
```

### Check Status
```bash
# Check deployment status
kubectl get pods -l app=prometheus

# Check services
kubectl get services -l app=prometheus
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [Prometheus Official Documentation](https://prometheus.io/docs/)
- [Kubernetes Official Documentation](https://kubernetes.io/docs/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).