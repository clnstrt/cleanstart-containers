# 🚀 Go Web App - Kubernetes Deployment

This directory contains a complete Kubernetes deployment for the Go web application. It includes all necessary manifests, scripts, and documentation to deploy a production-ready Go web app on Kubernetes.

## 📁 Project Structure

```
kubernetes/
├── go-deployment.yaml      # Main application deployment
├── go-service.yaml         # Service definitions (ClusterIP & NodePort)
├── go-configmap.yaml       # Application configuration
├── go-secrets.yaml         # Secret management
├── go-pvc.yaml            # Persistent volume claims
├── go-ingress.yaml        # Ingress configuration
├── go-hpa.yaml           # Horizontal Pod Autoscaler
├── go-networkpolicy.yaml # Network security policies
├── deploy.sh             # Deployment script
├── undeploy.sh           # Cleanup script
├── status.sh             # Status monitoring script
└── README.md             # This file
```

## 🎯 What This Deployment Includes

### Core Components
- **Deployment**: 3 replicas of the Go web application
- **Services**: ClusterIP and NodePort services for internal and external access
- **ConfigMap**: Application configuration management
- **Secrets**: Secure storage for sensitive data
- **PVC**: Persistent storage for database files
- **Ingress**: External access with load balancing
- **HPA**: Automatic scaling based on CPU and memory usage
- **NetworkPolicy**: Security policies for network traffic

### Features
- ✅ **High Availability**: 3 replicas with health checks
- ✅ **Auto-scaling**: HPA scales from 2 to 10 pods based on resource usage
- ✅ **Persistent Storage**: Database data survives pod restarts
- ✅ **Security**: Network policies and non-root containers
- ✅ **Monitoring**: Health checks and resource limits
- ✅ **Load Balancing**: Ingress controller with multiple access methods
- ✅ **Configuration Management**: ConfigMaps and Secrets

## 🛠️ Prerequisites

### Required Tools
1. **kubectl** - Kubernetes command-line tool
2. **Docker** - Container runtime
3. **Kubernetes Cluster** - Local (minikube/kind) or cloud (GKE/EKS/AKS)

### Installation Commands

#### Install kubectl
```bash
# Linux/macOS
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Windows (PowerShell)
winget install Kubernetes.kubectl

# macOS (Homebrew)
brew install kubectl
```

#### Install Docker
```bash
# Follow official Docker installation guide
# https://docs.docker.com/get-docker/
```

#### Set up Kubernetes Cluster

**Option 1: Minikube (Local Development)**
```bash
# Install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Start cluster
minikube start
```

**Option 2: Kind (Local Development)**
```bash
# Install kind
go install sigs.k8s.io/kind@v0.20.0

# Create cluster
kind create cluster
```

**Option 3: Cloud Provider**
- Google GKE
- Amazon EKS
- Microsoft AKS
- DigitalOcean Kubernetes

## 🚀 Quick Start

### 1. Clone and Navigate
```bash
cd containers/go/sample-project/kubernetes
```

### 2. Make Scripts Executable
```bash
chmod +x *.sh
```

### 3. Deploy the Application
```bash
./deploy.sh
```

### 4. Check Status
```bash
./status.sh
```

### 5. Access the Application

**Option A: Port Forward (Recommended for testing)**
```bash
kubectl port-forward service/go-web-service 8080:80
# Access: http://localhost:8080
```

**Option B: NodePort (If using minikube)**
```bash
# Get node IP
kubectl get nodes -o wide

# Access via: http://<NODE_IP>:30080
```

**Option C: Ingress (If ingress controller is installed)**
```bash
# Add to /etc/hosts
echo "<INGRESS_IP> go-web.local" | sudo tee -a /etc/hosts

# Access: http://go-web.local
```

## 📊 Monitoring and Management

### Check Application Status
```bash
./status.sh
```

### View Logs
```bash
# All pods
kubectl logs -l app=go-web-app

# Specific pod
kubectl logs <pod-name>

# Follow logs
kubectl logs -l app=go-web-app -f
```

### Scale Application
```bash
# Scale to 5 replicas
kubectl scale deployment go-web-app --replicas=5

# Check scaling
kubectl get pods -l app=go-web-app
```

### Update Application
```bash
# Update image
kubectl set image deployment/go-web-app go-web-app=go-web-app:v2.0.0

# Check rollout status
kubectl rollout status deployment/go-web-app
```

## 🔧 Configuration

### Environment Variables
The application uses the following environment variables (configured in ConfigMap):

| Variable | Description | Default |
|----------|-------------|---------|
| `PORT` | Server port | `8080` |
| `DATABASE_PATH` | Database file path | `/app/data/users.db` |
| `LOG_LEVEL` | Logging level | `info` |

### Resource Limits
- **CPU Request**: 50m
- **CPU Limit**: 100m
- **Memory Request**: 64Mi
- **Memory Limit**: 128Mi

### Scaling Configuration
- **Min Replicas**: 2
- **Max Replicas**: 10
- **CPU Target**: 70%
- **Memory Target**: 80%

## 🔒 Security Features

### Network Policies
- Restricts ingress traffic to only necessary sources
- Allows egress to DNS and internal services
- Blocks unnecessary network access

### Pod Security
- Non-root user execution
- Read-only root filesystem (where applicable)
- Security contexts configured

### Secrets Management
- Sensitive data stored in Kubernetes Secrets
- Base64 encoded values
- Separate from application code

## 📈 Production Considerations

### High Availability
- Multiple replicas across nodes
- Anti-affinity rules (can be added)
- Persistent storage for data

### Monitoring
- Health checks configured
- Resource monitoring via HPA
- Log aggregation (consider ELK stack)

### Backup
- Database files stored in persistent volumes
- Regular backup of PVC data
- Configuration backup via Git

### Security
- Network policies enabled
- RBAC configuration (can be added)
- Image security scanning

## 🧪 Testing

### Health Check
```bash
# Check if application is healthy
kubectl get pods -l app=go-web-app
kubectl describe pod <pod-name>
```

### Load Testing
```bash
# Install hey (load testing tool)
go install github.com/rakyll/hey@latest

# Run load test
hey -n 1000 -c 10 http://localhost:8080
```

### Database Testing
```bash
# Port forward to access database
kubectl port-forward service/go-web-service 8080:80

# Test API endpoints
curl http://localhost:8080/api/users
```

## 🐛 Troubleshooting

### Common Issues

**1. Pods not starting**
```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

**2. Service not accessible**
```bash
kubectl get services
kubectl describe service go-web-service
```

**3. Ingress not working**
```bash
kubectl get ingress
kubectl describe ingress go-web-ingress
```

**4. PVC not mounting**
```bash
kubectl get pvc
kubectl describe pvc go-web-pvc
```

### Debug Commands
```bash
# Get all resources
kubectl get all -l app=go-web-app

# Describe resources
kubectl describe deployment go-web-app
kubectl describe service go-web-service

# Check events
kubectl get events --sort-by=.metadata.creationTimestamp
```

## 🧹 Cleanup

### Remove Application
```bash
./undeploy.sh
```

### Manual Cleanup
```bash
# Delete all resources
kubectl delete -f .

# Delete namespace
kubectl delete namespace go-web-app
```

## 📚 Additional Resources

### Kubernetes Documentation
- [Kubernetes Official Docs](https://kubernetes.io/docs/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Kubernetes Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)

### Go Web Development
- [Gin Web Framework](https://gin-gonic.com/)
- [Go Official Docs](https://golang.org/doc/)
- [Go Best Practices](https://golang.org/doc/effective_go.html)

### Container Security
- [Kubernetes Security Best Practices](https://kubernetes.io/docs/concepts/security/)
- [Container Security Guide](https://kubernetes.io/docs/concepts/containers/images/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../../../LICENSE) file for details.

---

**Happy Deploying! 🚀**

*For questions or issues, please open an issue in the repository.*
