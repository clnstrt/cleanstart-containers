# Nginx Kubernetes Sample Project

This directory contains comprehensive Kubernetes examples for deploying Nginx applications using the `cleanstart/nginx` image.

## 🚀 Quick Start

### Prerequisites
- Kubernetes cluster (minikube, kind, or cloud provider)
- kubectl configured to access your cluster
- Docker (for building images if needed)

### Option 1: Using Pre-built Image from Docker Hub
```bash
# Deploy the Nginx application
kubectl apply -f nginx-deployment.yaml

# Check deployment status
kubectl get pods -l app=nginx-app

# Access the application
kubectl port-forward svc/nginx-service 8080:80
# Open http://localhost:8080
```

### Option 2: Build and Deploy Locally
```bash
# Build the image
docker build -t nginx-k8s-app:latest .

# Load into minikube (if using minikube)
minikube image load nginx-k8s-app:latest

# Deploy with local image
kubectl apply -f nginx-deployment-local.yaml
```

## 📁 Project Structure

```
kubernetes/
├── README.md                    # This file
├── nginx-deployment.yaml       # Basic deployment with pre-built image
├── nginx-deployment-local.yaml # Deployment with local image
├── nginx-service.yaml          # Service configuration
├── nginx-configmap.yaml        # Nginx configuration
├── nginx-secret.yaml           # Secret management
├── nginx-ingress.yaml          # Ingress configuration
├── nginx-hpa.yaml             # Horizontal Pod Autoscaler
├── nginx-pdb.yaml             # Pod Disruption Budget
├── nginx-monitoring.yaml      # Monitoring and metrics
├── nginx-network-policy.yaml  # Network security policies
├── nginx-rbac.yaml            # Role-based access control
├── nginx-pvc.yaml             # Persistent volume claims
├── reverse-proxy/             # Reverse proxy examples
│   ├── nginx-reverse-proxy.yaml
│   ├── backend-service.yaml
│   └── nginx-config.yaml
├── load-balancer/             # Load balancer examples
│   ├── nginx-lb.yaml
│   ├── backend-deployments.yaml
│   └── nginx-lb-config.yaml
├── static-site/               # Static site hosting
│   ├── nginx-static.yaml
│   ├── content-configmap.yaml
│   └── nginx-static-config.yaml
├── production/                # Production-ready configurations
│   ├── nginx-prod.yaml
│   ├── monitoring-stack.yaml
│   └── backup-job.yaml
└── scripts/                   # Deployment scripts
    ├── deploy.sh
    ├── undeploy.sh
    └── health-check.sh
```

## 🎯 Available Examples

### 1. Basic Web Server
- **File**: `nginx-deployment.yaml`
- **Features**: Simple Nginx web server
- **Use Case**: Static content hosting

### 2. Reverse Proxy
- **Directory**: `reverse-proxy/`
- **Features**: Proxying requests to backend services
- **Use Case**: API gateway, microservices

### 3. Load Balancer
- **Directory**: `load-balancer/`
- **Features**: Distributing traffic across multiple backends
- **Use Case**: High availability, traffic distribution

### 4. Static Site Hosting
- **Directory**: `static-site/`
- **Features**: Serving static websites with custom content
- **Use Case**: Frontend applications, documentation sites

### 5. Production Setup
- **Directory**: `production/`
- **Features**: High availability, monitoring, security
- **Use Case**: Production workloads

## 🛠️ Configuration Options

### Nginx Configuration
```nginx
server {
    listen 80;
    server_name _;
    
    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri $uri/ =404;
    }
    
    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }
}
```

### Resource Limits
```yaml
resources:
  requests:
    memory: "128Mi"
    cpu: "100m"
  limits:
    memory: "256Mi"
    cpu: "200m"
```

### Health Checks
```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 80
  initialDelaySeconds: 10
  periodSeconds: 10
readinessProbe:
  httpGet:
    path: /health
    port: 80
  initialDelaySeconds: 5
  periodSeconds: 5
```

## 🔧 Advanced Features

### Reverse Proxy Configuration
```bash
# Deploy reverse proxy setup
kubectl apply -f reverse-proxy/

# Check services
kubectl get services
```

### Load Balancer Setup
```bash
# Deploy load balancer
kubectl apply -f load-balancer/

# Scale backend services
kubectl scale deployment backend-1 --replicas=3
```

### Static Site with Custom Content
```bash
# Deploy static site
kubectl apply -f static-site/

# Update content
kubectl apply -f content-configmap.yaml
```

## 🚀 Deployment Commands

### Deploy Basic Setup
```bash
# Deploy basic Nginx
kubectl apply -f nginx-deployment.yaml
kubectl apply -f nginx-service.yaml
kubectl apply -f nginx-configmap.yaml

# Deploy advanced features
kubectl apply -f nginx-hpa.yaml
kubectl apply -f nginx-ingress.yaml
kubectl apply -f nginx-monitoring.yaml
```

### Deploy Production Setup
```bash
# Deploy production configuration
kubectl apply -f production/nginx-prod.yaml
kubectl apply -f production/monitoring-stack.yaml
```

### Deploy Specific Use Cases
```bash
# Reverse proxy
kubectl apply -f reverse-proxy/

# Load balancer
kubectl apply -f load-balancer/

# Static site
kubectl apply -f static-site/
```

## 🧪 Testing & Verification

### Health Checks
```bash
# Check pod status
kubectl get pods -l app=nginx-app

# Check service endpoints
kubectl get endpoints nginx-service

# Test application health
kubectl port-forward svc/nginx-service 8080:80
curl http://localhost:8080/health
```

### Load Testing
```bash
# Scale up for load testing
kubectl scale deployment nginx-app --replicas=5

# Monitor resource usage
kubectl top pods -l app=nginx-app
```

### Configuration Testing
```bash
# Test Nginx configuration
kubectl exec -it <pod-name> -- nginx -t

# Reload Nginx configuration
kubectl exec -it <pod-name> -- nginx -s reload
```

## 🔍 Monitoring & Observability

### Metrics Collection
- **Nginx Exporter**: Prometheus metrics
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

**Configuration Issues**
```bash
# Test Nginx configuration
kubectl exec -it <pod-name> -- nginx -t

# Check configuration files
kubectl exec -it <pod-name> -- cat /etc/nginx/nginx.conf
```

### Debug Commands
```bash
# Get all resources
kubectl get all -l app=nginx-app

# Describe resources
kubectl describe deployment nginx-app
kubectl describe service nginx-service

# Check events
kubectl get events --sort-by=.metadata.creationTimestamp
```

## 🎓 Learning Path

### Beginner Level
1. **Basic Deployment** - Deploy simple Nginx server
2. **Service Configuration** - Expose application
3. **Configuration Management** - Use ConfigMaps

### Intermediate Level
1. **Health Checks** - Implement probes
2. **Resource Management** - Set limits and requests
3. **Scaling** - Configure HPA

### Advanced Level
1. **Reverse Proxy** - Complex routing
2. **Load Balancing** - Traffic distribution
3. **Security Policies** - Network and RBAC

## 🚀 Production Considerations

### High Availability
- **Multi-replica deployments**
- **Pod anti-affinity rules**
- **Multi-zone deployments**

### Performance
- **Resource optimization**
- **Caching strategies**
- **Load balancing**

### Security
- **TLS termination**
- **Rate limiting**
- **Security headers**

## 📚 Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Nginx on Kubernetes Best Practices](https://kubernetes.io/docs/concepts/containers/images/)
- [Nginx Configuration Guide](https://nginx.org/en/docs/)
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
