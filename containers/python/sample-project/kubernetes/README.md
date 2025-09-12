# 🚀 Python - Kubernetes Deployment

Deploy Python web application on Kubernetes using CleanStart container images.

## Quick Start

### Prerequisites
- Kubernetes cluster (minikube, kind, or cloud provider)
- kubectl configured to access your cluster

### Deploy Python App
```bash
# 1. Deploy the application
kubectl apply -f python-deployment.yaml

# 2. Deploy services
kubectl apply -f python-service.yaml

# 3. Deploy configuration
kubectl apply -f python-configmap.yaml
```

### Access the Application
```bash
# Port forward to access the app
kubectl port-forward svc/python-service 5000:5000

# Access: http://localhost:5000
```

### Check Status
```bash
# Check deployment status
kubectl get pods -l app=python-app

# Check services
kubectl get services -l app=python-app
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [Python Official Documentation](https://docs.python.org/)
- [Kubernetes Official Documentation](https://kubernetes.io/docs/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).