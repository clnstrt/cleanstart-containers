# 🚀 Nginx - Kubernetes Deployment

Deploy Nginx web server on Kubernetes using CleanStart container images.

## Quick Start

### Prerequisites
- Kubernetes cluster (minikube, kind, or cloud provider)
- kubectl configured to access your cluster

### Deploy Nginx
```bash
# 1. Deploy the application
kubectl apply -f nginx-deployment.yaml

# 2. Deploy services
kubectl apply -f nginx-service.yaml

# 3. Deploy configuration
kubectl apply -f nginx-configmap.yaml
```

### Access the Application
```bash
# Port forward to access the app
kubectl port-forward svc/nginx-service 8080:80

# Access: http://localhost:8080
```

### Check Status
```bash
# Check deployment status
kubectl get pods -l app=nginx-app

# Check services
kubectl get services -l app=nginx-app
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [Nginx Official Documentation](https://nginx.org/en/docs/)
- [Kubernetes Official Documentation](https://kubernetes.io/docs/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).