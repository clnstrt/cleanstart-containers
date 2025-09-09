# 🚀 MinIO Operator Sidecar Kubernetes Samples

This directory contains comprehensive Kubernetes sample projects for MinIO Operator Sidecar deployment. These examples demonstrate various Kubernetes concepts including operators, tenants, sidecar patterns, persistent volumes, secrets, monitoring, and more.

## 📁 Project Structure

```
kubernetes/
├── minio-operator-deployment.yaml        # MinIO Operator deployment
├── minio-operator-rbac.yaml              # RBAC configuration
├── minio-tenant.yaml                     # MinIO Tenant configuration
├── minio-tenant-secret.yaml              # Tenant secrets
├── minio-tenant-service.yaml             # Tenant services
├── minio-tenant-ingress.yaml             # Ingress configuration
├── minio-sidecar-pattern.yaml            # Sidecar pattern example
├── minio-sidecar-config.yaml             # Sidecar configuration
├── minio-sidecar-pvc.yaml                # Persistent volume claims
├── minio-monitoring.yaml                 # Monitoring configuration
├── docker-compose.yml                    # Full local testing setup
├── docker-compose-simple.yml             # Simple local testing
├── scripts/
│   └── deploy.sh                         # Deployment automation script
└── README.md                             # This file
```

## 🎯 What You'll Learn

By working through these examples, you'll understand:

- **MinIO Operator** - How to deploy and manage MinIO using Kubernetes operators
- **MinIO Tenants** - Multi-tenant MinIO cluster management
- **Sidecar Patterns** - Running MinIO as a sidecar container
- **Persistent Volumes** - Data persistence across pod restarts
- **RBAC** - Role-based access control for operators
- **Secrets Management** - Secure credential management
- **Monitoring** - Prometheus and Grafana integration
- **Networking** - Services, ingress, and load balancing
- **Resource Management** - CPU and memory limits
- **Local Development** - Docker Compose for testing

## 🚀 Quick Start

### Prerequisites

- Kubernetes cluster (local or cloud)
- `kubectl` configured to access your cluster
- Docker (for local testing)
- MinIO client (`mc`) for testing

### Option 1: Using the Deployment Script (Recommended)

```bash
# Make the script executable (Linux/Mac)
chmod +x scripts/deploy.sh

# Deploy MinIO Operator and Tenant
./scripts/deploy.sh deploy

# Deploy with all features (sidecar, monitoring, ingress)
./scripts/deploy.sh deploy minio-operator minio-tenant true true true

# Deploy operator only
./scripts/deploy.sh operator

# Deploy tenant only
./scripts/deploy.sh tenant minio-operator my-tenant

# Check deployment status
./scripts/deploy.sh status

# Connect to MinIO
./scripts/deploy.sh connect

# Port forward services
./scripts/deploy.sh port-forward

# Clean up when done
./scripts/deploy.sh cleanup
```

### Option 2: Manual Deployment

```bash
# 1. Create namespace
kubectl create namespace minio-operator

# 2. Deploy RBAC
kubectl apply -f minio-operator-rbac.yaml

# 3. Deploy Operator
kubectl apply -f minio-operator-deployment.yaml

# 4. Deploy Tenant Secret
kubectl apply -f minio-tenant-secret.yaml

# 5. Deploy PVCs
kubectl apply -f minio-sidecar-pvc.yaml

# 6. Deploy Tenant
kubectl apply -f minio-tenant.yaml

# 7. Deploy Services
kubectl apply -f minio-tenant-service.yaml

# 8. Check status
kubectl get pods -n minio-operator
kubectl get tenants -n minio-operator
```

### Option 3: Local Testing with Docker Compose

```bash
# Simple deployment
docker-compose -f docker-compose-simple.yml up -d

# Full deployment with monitoring
docker-compose up -d

# Check service status
docker-compose ps

# View logs
docker-compose logs -f minio-operator
docker-compose logs -f minio-tenant

# Stop and cleanup
docker-compose down -v
```

## 📋 Sample Configurations

### 1. MinIO Operator (`minio-operator-deployment.yaml`)

The MinIO Operator deployment includes:
- Single replica operator
- Health checks and monitoring
- Resource limits
- Environment configuration
- Service account integration

### 2. RBAC Configuration (`minio-operator-rbac.yaml`)

Comprehensive RBAC setup:
- Service account for the operator
- ClusterRole with necessary permissions
- ClusterRoleBinding for operator access
- Service for operator metrics

### 3. MinIO Tenant (`minio-tenant.yaml`)

Production-ready tenant configuration:
- 8-node MinIO cluster (2 pools of 4 nodes each)
- Persistent storage with 10GB per node
- Console, KES, Prometheus, and Logger components
- Health checks and resource limits
- Secret-based authentication

### 4. Sidecar Pattern (`minio-sidecar-pattern.yaml`)

Application with MinIO sidecar:
- Main application container (nginx example)
- MinIO sidecar container
- Shared storage and configuration
- Automatic bucket creation
- Health monitoring

### 5. Monitoring (`minio-monitoring.yaml`)

Comprehensive monitoring setup:
- ServiceMonitor for Prometheus
- Custom alerting rules
- MinIO-specific metrics
- Resource usage monitoring

### 6. Networking (`minio-tenant-service.yaml`, `minio-tenant-ingress.yaml`)

Network configuration:
- ClusterIP services for internal access
- Ingress for external access
- Load balancing and SSL termination
- Multiple host routing

## 🔧 Configuration Details

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `MINIO_ROOT_USER` | MinIO root username | `minioadmin` |
| `MINIO_ROOT_PASSWORD` | MinIO root password | `minioadmin123` |
| `MINIO_PROMETHEUS_AUTH_TYPE` | Prometheus auth type | `public` |
| `MINIO_PROMETHEUS_URL` | Prometheus endpoint | `http://prometheus:9090` |

### Resource Limits

| Component | CPU Request | CPU Limit | Memory Request | Memory Limit |
|-----------|-------------|-----------|----------------|--------------|
| MinIO Operator | 250m | 500m | 256Mi | 512Mi |
| MinIO Tenant | 250m | 500m | 256Mi | 512Mi |
| MinIO Console | 100m | 200m | 128Mi | 256Mi |
| MinIO KES | 50m | 100m | 64Mi | 128Mi |
| MinIO Prometheus | 100m | 200m | 128Mi | 256Mi |
| MinIO Logger | 50m | 100m | 64Mi | 128Mi |

### Health Checks

- **Liveness Probe**: Checks if MinIO is accepting requests
- **Readiness Probe**: Verifies MinIO readiness
- **Initial Delay**: 30 seconds (liveness), 5 seconds (readiness)
- **Period**: 10 seconds (liveness), 5 seconds (readiness)

## 🗄️ MinIO Features

### Object Storage
- S3-compatible API
- Multi-tenant support
- Bucket management
- Object lifecycle policies

### Security
- Secret-based authentication
- RBAC integration
- Network policies
- Encryption at rest and in transit

### Monitoring
- Prometheus metrics
- Health check endpoints
- Resource usage monitoring
- Custom alerting rules

### High Availability
- Multi-node clusters
- Data replication
- Automatic failover
- Load balancing

## 🔍 Monitoring and Troubleshooting

### Check Operator Status
```bash
kubectl get pods -n minio-operator -l app=minio-operator
kubectl logs -n minio-operator deployment/minio-operator
kubectl describe pod -n minio-operator -l app=minio-operator
```

### Check Tenant Status
```bash
kubectl get tenants -n minio-operator
kubectl get pods -n minio-operator -l app=minio
kubectl describe tenant minio-tenant -n minio-operator
```

### Check Services
```bash
kubectl get services -n minio-operator -l app=minio
kubectl get ingress -n minio-operator
```

### Connect to MinIO
```bash
# Port forward MinIO API
kubectl port-forward svc/minio-tenant 9000:9000 -n minio-operator

# Port forward MinIO Console
kubectl port-forward svc/minio-tenant-console 9001:9001 -n minio-operator

# Access MinIO Console
open http://localhost:9001
# Default credentials: minioadmin / minioadmin123
```

### Test MinIO API
```bash
# Test MinIO health
curl http://localhost:9000/minio/health/live

# Test with MinIO client
mc alias set myminio http://localhost:9000 minioadmin minioadmin123
mc ls myminio
```

### Common Issues

1. **Operator not starting**: Check RBAC permissions and resource limits
2. **Tenant creation fails**: Verify PVC availability and storage class
3. **Console access issues**: Check service and ingress configuration
4. **Sidecar not working**: Verify shared volumes and configuration

## 🚀 Advanced Features

### Multi-Tenant Setup
```bash
# Deploy multiple tenants
kubectl apply -f tenant-1.yaml
kubectl apply -f tenant-2.yaml
kubectl apply -f tenant-3.yaml
```

### Custom Sidecar Patterns
```bash
# Deploy custom sidecar applications
kubectl apply -f custom-sidecar-app.yaml
kubectl apply -f batch-processing-sidecar.yaml
```

### Monitoring Integration
```bash
# Deploy Prometheus and Grafana
kubectl apply -f prometheus-deployment.yaml
kubectl apply -f grafana-deployment.yaml
```

### Backup and Recovery
```bash
# Create backup job
kubectl create job backup-minio --from=cronjob/minio-backup

# Restore from backup
kubectl create job restore-minio --from=cronjob/minio-restore
```

## 🔄 CI/CD Integration

### GitHub Actions Example
```yaml
name: Deploy MinIO Operator
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Deploy MinIO Operator
      run: |
        kubectl apply -f minio-operator-rbac.yaml
        kubectl apply -f minio-operator-deployment.yaml
        kubectl rollout status deployment/minio-operator
    - name: Deploy MinIO Tenant
      run: |
        kubectl apply -f minio-tenant-secret.yaml
        kubectl apply -f minio-tenant.yaml
        kubectl wait --for=condition=ready tenant/minio-tenant
```

## 📚 Learning Resources

- [MinIO Operator Documentation](https://docs.min.io/docs/minio-operator-quickstart-guide.html)
- [MinIO Kubernetes Documentation](https://docs.min.io/docs/deploy-minio-on-kubernetes.html)
- [Kubernetes Operators Guide](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/)
- [MinIO Sidecar Patterns](https://docs.min.io/docs/minio-sidecar-patterns.html)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../../../LICENSE) file for details.

## 🆘 Support

If you encounter any issues:

1. Check the troubleshooting section above
2. Review MinIO and Kubernetes logs
3. Verify your cluster configuration
4. Open an issue on GitHub

---

**Happy MinIO Operator Learning! 🚀**

*These samples are designed to help you learn MinIO Operator concepts while working with Kubernetes. Start with the basic examples and gradually work your way up to the advanced configurations.*
