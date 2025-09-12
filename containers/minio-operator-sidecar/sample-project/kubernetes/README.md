# 🚀 MinIO Operator Sidecar - Kubernetes Deployment

Deploy MinIO Operator Sidecar on Kubernetes using CleanStart container images.

## Quick Start

### Prerequisites
- Kubernetes cluster (minikube, kind, or cloud provider)
- kubectl configured to access your cluster

### Deploy MinIO Operator
```bash
# 1. Create namespace
kubectl create namespace minio-operator

# 2. Deploy RBAC
kubectl apply -f minio-operator-rbac.yaml

# 3. Deploy Operator
kubectl apply -f minio-operator-deployment.yaml

# 4. Deploy Tenant Secret
kubectl apply -f minio-tenant-secret.yaml

# 5. Deploy Tenant
kubectl apply -f minio-tenant.yaml

# 6. Deploy Services
kubectl apply -f minio-tenant-service.yaml
```

### Access MinIO
```bash
# Port forward MinIO API
kubectl port-forward svc/minio-tenant 9000:9000 -n minio-operator

# Port forward MinIO Console
kubectl port-forward svc/minio-tenant-console 9001:9001 -n minio-operator

# Access MinIO Console
open http://localhost:9001
# Default credentials: minioadmin / minioadmin123
```

### Check Status
```bash
# Check operator status
kubectl get pods -n minio-operator

# Check tenant status
kubectl get tenants -n minio-operator
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [MinIO Official Documentation](https://docs.min.io/)
- [MinIO Operator Documentation](https://docs.min.io/docs/minio-operator-quickstart-guide.html)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
