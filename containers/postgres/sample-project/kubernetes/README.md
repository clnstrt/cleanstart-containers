# 🚀 PostgreSQL - Kubernetes Deployment

Deploy PostgreSQL database on Kubernetes using CleanStart container images.

## Quick Start

### Prerequisites
- Kubernetes cluster (minikube, kind, or cloud provider)
- kubectl configured to access your cluster

### Deploy PostgreSQL
```bash
# 1. Deploy the database
kubectl apply -f postgres-deployment.yaml

# 2. Deploy services
kubectl apply -f postgres-service.yaml

# 3. Deploy persistent volume
kubectl apply -f postgres-pvc.yaml

# 4. Deploy secrets
kubectl apply -f postgres-secret.yaml
```

### Access the Database
```bash
# Port forward to access the database
kubectl port-forward svc/postgres-service 5432:5432

# Connect to database
psql -h localhost -p 5432 -U postgres -d postgres
```

### Check Status
```bash
# Check deployment status
kubectl get pods -l app=postgres

# Check services
kubectl get services -l app=postgres
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [PostgreSQL Official Documentation](https://www.postgresql.org/docs/)
- [Kubernetes Official Documentation](https://kubernetes.io/docs/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).