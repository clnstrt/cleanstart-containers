# 🚀 Go Web App - Kubernetes Deployment

Deploy Go web application on Kubernetes using CleanStart container images.

## Quick Start

### Prerequisites
- Kubernetes cluster (minikube, kind, or cloud provider)
- kubectl configured to access your cluster

### Deploy Go Web App
```bash
# 1. Deploy the application
kubectl apply -f go-deployment.yaml

# 2. Deploy services
kubectl apply -f go-service.yaml

# 3. Deploy configuration
kubectl apply -f go-configmap.yaml

# 4. Deploy secrets
kubectl apply -f go-secrets.yaml

# 5. Deploy persistent volume
kubectl apply -f go-pvc.yaml
```

### Access the Application
```bash
# Port forward to access the app
kubectl port-forward service/go-web-service 8080:80

# Access: http://localhost:8080
```

### Check Status
```bash
# Check deployment status
kubectl get pods -l app=go-web-app

# Check services
kubectl get services -l app=go-web-app
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [Go Official Documentation](https://golang.org/doc/)
- [Kubernetes Official Documentation](https://kubernetes.io/docs/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
