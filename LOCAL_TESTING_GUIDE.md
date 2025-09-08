# 🚀 Local Testing Guide for Kubernetes Sample Projects

This guide helps you test the Kubernetes sample projects locally using Docker Compose or a local Kubernetes cluster.

## 📋 Prerequisites

### Option 1: Docker Compose (Recommended for Quick Testing)
- Docker Desktop installed and running
- Docker Compose v2.0+

### Option 2: Local Kubernetes Cluster
- **minikube**: `minikube start`
- **kind**: `kind create cluster`
- **Docker Desktop**: Enable Kubernetes in settings
- kubectl configured to access your cluster

## 🐍 Testing Python Sample Project

### Method 1: Docker Compose (Simplest)

```bash
# Navigate to Python sample
cd images/python/sample-project/kubernetes

# Start services
docker-compose -f docker-compose-simple.yml up -d

# Check status
docker-compose -f docker-compose-simple.yml ps

# Test endpoints
curl http://localhost:5000/health  # Direct Python app
curl http://localhost:8080/health  # Through Nginx proxy
curl http://localhost:8080/        # Dashboard

# Stop services
docker-compose -f docker-compose-simple.yml down
```

### Method 2: Local Kubernetes Cluster

```bash
# Build local image
cd images/python
docker build -t python-k8s-app:latest .

# Load into minikube (if using minikube)
minikube image load python-k8s-app:latest

# Deploy to Kubernetes
cd sample-project/kubernetes
kubectl apply -f python-deployment-local.yaml
kubectl apply -f python-service.yaml
kubectl apply -f python-configmap.yaml
kubectl apply -f python-secret.yaml

# Check deployment
kubectl get pods -l app=python-app
kubectl get services

# Access application
kubectl port-forward svc/python-service 5000:5000
# Open http://localhost:5000

# Clean up
kubectl delete -f python-deployment-local.yaml
kubectl delete -f python-service.yaml
kubectl delete -f python-configmap.yaml
kubectl delete -f python-secret.yaml
```

## 🌐 Testing Nginx Sample Project

### Method 1: Docker Compose (Simplest)

```bash
# Navigate to Nginx sample
cd images/nginx/sample-project/kubernetes

# Start services
docker-compose -f docker-compose-simple.yml up -d

# Check status
docker-compose -f docker-compose-simple.yml ps

# Test endpoints
curl http://localhost:8080/health  # Main Nginx app
curl http://localhost:8081/health  # Load balancer
curl http://localhost:8081/backend-status  # Load balancer status

# Stop services
docker-compose -f docker-compose-simple.yml down
```

### Method 2: Local Kubernetes Cluster

```bash
# Build local image
cd images/nginx
docker build -t nginx-k8s-app:latest .

# Load into minikube (if using minikube)
minikube image load nginx-k8s-app:latest

# Deploy to Kubernetes
cd sample-project/kubernetes
kubectl apply -f nginx-deployment-local.yaml
kubectl apply -f nginx-service.yaml
kubectl apply -f nginx-configmap.yaml

# Check deployment
kubectl get pods -l app=nginx-app
kubectl get services

# Access application
kubectl port-forward svc/nginx-service 8080:80
# Open http://localhost:8080

# Clean up
kubectl delete -f nginx-deployment-local.yaml
kubectl delete -f nginx-service.yaml
kubectl delete -f nginx-configmap.yaml
```

## 🧪 Testing Advanced Features

### Load Balancer Testing
```bash
# Start Nginx load balancer
cd images/nginx/sample-project/kubernetes
docker-compose -f docker-compose-simple.yml up -d

# Test load balancing
for i in {1..10}; do
  echo "Request $i:"
  curl -s http://localhost:8081/ | grep -o "Backend ID: [^<]*" || echo "No backend ID found"
done
```

### Reverse Proxy Testing
```bash
# Start Python + Nginx proxy
cd images/python/sample-project/kubernetes
docker-compose -f docker-compose-simple.yml up -d

# Test different endpoints
curl http://localhost:8080/backend/health  # Direct backend
curl http://localhost:8080/api/health      # Through proxy
curl http://localhost:8080/                # Dashboard
```

## 🔧 Troubleshooting

### Common Issues

**1. Docker not running**
```bash
# Start Docker Desktop
# Or on Linux: sudo systemctl start docker
```

**2. Port already in use**
```bash
# Check what's using the port
netstat -tulpn | grep :5000
netstat -tulpn | grep :8080

# Kill the process or use different ports
```

**3. Images not found**
```bash
# Pull images first
docker pull cleanstart/python:latest
docker pull cleanstart/nginx:latest

# Or build locally
docker build -t cleanstart/python:latest images/python/
docker build -t cleanstart/nginx:latest images/nginx/
```

**4. Kubernetes cluster not accessible**
```bash
# Check cluster status
kubectl cluster-info

# Start minikube
minikube start

# Or create kind cluster
kind create cluster
```

**5. Health checks failing**
```bash
# Check container logs
docker-compose logs python-app
docker-compose logs nginx-proxy

# Check if services are ready
docker-compose ps
```

### Debug Commands

```bash
# Docker Compose debugging
docker-compose logs -f [service-name]
docker-compose exec [service-name] /bin/bash
docker-compose ps

# Kubernetes debugging
kubectl get pods -l app=python-app
kubectl describe pod [pod-name]
kubectl logs [pod-name]
kubectl exec -it [pod-name] -- /bin/bash
```

## 📊 Expected Results

### Python Sample
- **Health Check**: `curl http://localhost:5000/health` → `{"status": "healthy"}`
- **Dashboard**: `http://localhost:8080` → Interactive dashboard
- **Metrics**: `curl http://localhost:5000/metrics` → Prometheus metrics

### Nginx Sample
- **Health Check**: `curl http://localhost:8080/health` → `healthy`
- **Load Balancer**: `http://localhost:8081/backend-status` → Load balancer status
- **Load Distribution**: Multiple requests show different backend IDs

## 🎯 Success Criteria

✅ **All services start successfully**
✅ **Health checks pass**
✅ **Endpoints are accessible**
✅ **Load balancing works (for Nginx sample)**
✅ **Reverse proxy works (for Python sample)**
✅ **No error logs in containers**

## 🚀 Next Steps

After successful local testing:

1. **Deploy to Cloud**: Use the full Kubernetes manifests
2. **Add Monitoring**: Deploy Prometheus and Grafana
3. **Implement CI/CD**: Set up automated deployments
4. **Scale Testing**: Test with higher loads
5. **Security Testing**: Validate security policies

## 📚 Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [minikube Documentation](https://minikube.sigs.k8s.io/docs/)
- [kind Documentation](https://kind.sigs.k8s.io/)

---

**Happy Testing! 🎉**

This guide ensures your Kubernetes sample projects work perfectly for local testing and development.
