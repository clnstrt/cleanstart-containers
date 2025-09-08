# Python Kubernetes Sample Project

This directory contains comprehensive Kubernetes examples for deploying Python applications using the `cleanstart/python` image.

## 🚀 Quick Start

### Prerequisites
- Kubernetes cluster (minikube, kind, or cloud provider)
- kubectl configured to access your cluster
- Docker (for building images if needed)

### Option 1: Using Pre-built Image from Docker Hub
```bash
# Deploy the Python application
kubectl apply -f python-deployment.yaml

# Check deployment status
kubectl get pods -l app=python-app

# Access the application
kubectl port-forward svc/python-service 5000:5000
# Open http://localhost:5000
```

### Option 2: Build and Deploy Locally
```bash
# Build the image
docker build -t python-k8s-app:latest .

# Load into minikube (if using minikube)
minikube image load python-k8s-app:latest

# Deploy with local image
kubectl apply -f python-deployment-local.yaml
```

## 📁 Project Structure

```
kubernetes/
├── README.md                    # This file
├── python-deployment.yaml      # Basic deployment with pre-built image
├── python-deployment-local.yaml # Deployment with local image
├── python-service.yaml         # Service configuration
├── python-configmap.yaml       # Configuration management
├── python-secret.yaml          # Secret management
├── python-ingress.yaml         # Ingress configuration
├── python-hpa.yaml            # Horizontal Pod Autoscaler
├── python-pdb.yaml            # Pod Disruption Budget
├── python-monitoring.yaml     # Monitoring and metrics
├── python-network-policy.yaml # Network security policies
├── python-rbac.yaml           # Role-based access control
├── python-pvc.yaml            # Persistent volume claims
├── python-job.yaml            # Batch job example
├── python-cronjob.yaml        # Scheduled job example
├── multi-tier/                # Multi-tier application
│   ├── frontend.yaml
│   ├── backend.yaml
│   └── database.yaml
├── production/                # Production-ready configurations
│   ├── python-prod.yaml
│   ├── monitoring-stack.yaml
│   └── backup-job.yaml
└── scripts/                   # Deployment scripts
    ├── deploy.sh
    ├── undeploy.sh
    └── health-check.sh
```

## 🎯 Available Examples

### 1. Basic Deployment
- **File**: `python-deployment.yaml`
- **Features**: Simple deployment with service
- **Use Case**: Getting started with Python on K8s

### 2. Production Deployment
- **File**: `python-prod.yaml`
- **Features**: High availability, resource limits, health checks
- **Use Case**: Production workloads

### 3. Multi-Tier Application
- **Directory**: `multi-tier/`
- **Features**: Frontend, backend, and database components
- **Use Case**: Full-stack applications

### 4. Batch Processing
- **Files**: `python-job.yaml`, `python-cronjob.yaml`
- **Features**: One-time and scheduled jobs
- **Use Case**: Data processing, ETL pipelines

### 5. Monitoring & Observability
- **File**: `python-monitoring.yaml`
- **Features**: Prometheus metrics, Grafana dashboards
- **Use Case**: Application monitoring

## 🛠️ Configuration Options

### Environment Variables
```yaml
env:
- name: FLASK_ENV
  value: "production"
- name: DATABASE_URL
  valueFrom:
    secretKeyRef:
      name: python-secrets
      key: database-url
```

### Resource Limits
```yaml
resources:
  requests:
    memory: "256Mi"
    cpu: "250m"
  limits:
    memory: "512Mi"
    cpu: "500m"
```

### Health Checks
```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 5000
  initialDelaySeconds: 30
  periodSeconds: 10
readinessProbe:
  httpGet:
    path: /ready
    port: 5000
  initialDelaySeconds: 5
  periodSeconds: 5
```

## 🔧 Advanced Features

### Horizontal Pod Autoscaling
```bash
# Deploy HPA
kubectl apply -f python-hpa.yaml

# Check HPA status
kubectl get hpa python-hpa
```

### Network Policies
```bash
# Deploy network policies
kubectl apply -f python-network-policy.yaml

# Verify policies
kubectl get networkpolicies
```

### Persistent Storage
```bash
# Deploy PVC
kubectl apply -f python-pvc.yaml

# Check PVC status
kubectl get pvc
```

## 🚀 Deployment Commands

### Deploy All Components
```bash
# Deploy basic setup
kubectl apply -f python-deployment.yaml
kubectl apply -f python-service.yaml
kubectl apply -f python-configmap.yaml

# Deploy advanced features
kubectl apply -f python-hpa.yaml
kubectl apply -f python-ingress.yaml
kubectl apply -f python-monitoring.yaml
```

### Deploy Production Setup
```bash
# Deploy production configuration
kubectl apply -f production/python-prod.yaml
kubectl apply -f production/monitoring-stack.yaml
```

### Deploy Multi-Tier Application
```bash
# Deploy all tiers
kubectl apply -f multi-tier/
```

## 🧪 Testing & Verification

### Health Checks
```bash
# Check pod status
kubectl get pods -l app=python-app

# Check service endpoints
kubectl get endpoints python-service

# Test application health
kubectl port-forward svc/python-service 5000:5000
curl http://localhost:5000/health
```

### Load Testing
```bash
# Scale up for load testing
kubectl scale deployment python-app --replicas=5

# Monitor resource usage
kubectl top pods -l app=python-app
```

### Logs and Debugging
```bash
# View application logs
kubectl logs -l app=python-app

# Debug pod issues
kubectl describe pod <pod-name>

# Execute commands in pod
kubectl exec -it <pod-name> -- /bin/bash
```

## 🔍 Monitoring & Observability

### Metrics Collection
- **Prometheus**: Application metrics
- **Grafana**: Visualization dashboards
- **Jaeger**: Distributed tracing

### Log Aggregation
- **Fluentd**: Log collection
- **Elasticsearch**: Log storage
- **Kibana**: Log analysis

### Health Monitoring
- **Liveness Probes**: Container health
- **Readiness Probes**: Service readiness
- **Startup Probes**: Application startup

## 🛡️ Security Features

### Network Security
- **Network Policies**: Traffic isolation
- **Service Mesh**: Advanced networking
- **TLS/SSL**: Encrypted communication

### Access Control
- **RBAC**: Role-based permissions
- **Service Accounts**: Pod identity
- **Secrets**: Secure configuration

### Container Security
- **Non-root User**: Security best practices
- **Image Scanning**: Vulnerability detection
- **Pod Security Standards**: Security policies

## 📊 Performance Optimization

### Resource Management
- **Resource Requests**: Guaranteed resources
- **Resource Limits**: Maximum resource usage
- **Quality of Service**: Pod priority classes

### Scaling Strategies
- **Horizontal Scaling**: Add more pods
- **Vertical Scaling**: Increase pod resources
- **Cluster Autoscaling**: Dynamic node scaling

### Caching & Storage
- **Persistent Volumes**: Data persistence
- **ConfigMaps**: Configuration management
- **Secrets**: Sensitive data storage

## 🔧 Troubleshooting

### Common Issues

**Pod Not Starting**
```bash
# Check pod events
kubectl describe pod <pod-name>

# Check container logs
kubectl logs <pod-name>
```

**Service Not Accessible**
```bash
# Check service endpoints
kubectl get endpoints <service-name>

# Test service connectivity
kubectl run test-pod --image=busybox --rm -it -- wget -O- <service-name>
```

**Resource Issues**
```bash
# Check resource usage
kubectl top pods
kubectl top nodes

# Check resource quotas
kubectl describe quota
```

### Debug Commands
```bash
# Get all resources
kubectl get all -l app=python-app

# Describe resources
kubectl describe deployment python-app
kubectl describe service python-service

# Check events
kubectl get events --sort-by=.metadata.creationTimestamp
```

## 🎓 Learning Path

### Beginner Level
1. **Basic Deployment** - Deploy simple Python app
2. **Service Configuration** - Expose application
3. **Configuration Management** - Use ConfigMaps

### Intermediate Level
1. **Health Checks** - Implement probes
2. **Resource Management** - Set limits and requests
3. **Scaling** - Configure HPA

### Advanced Level
1. **Multi-Tier Architecture** - Complex applications
2. **Security Policies** - Network and RBAC
3. **Monitoring Stack** - Full observability

## 🚀 Production Considerations

### High Availability
- **Multi-replica deployments**
- **Pod anti-affinity rules**
- **Multi-zone deployments**

### Disaster Recovery
- **Backup strategies**
- **Cross-region replication**
- **Recovery procedures**

### Performance
- **Resource optimization**
- **Caching strategies**
- **Load balancing**

## 📚 Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Python on Kubernetes Best Practices](https://kubernetes.io/docs/concepts/containers/images/)
- [Flask Deployment Guide](https://flask.palletsprojects.com/en/2.0.x/deploying/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../../../LICENSE) file for details.

---

**Happy Deploying! 🎉**
