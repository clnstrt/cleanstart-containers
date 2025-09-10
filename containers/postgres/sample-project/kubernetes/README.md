# 🚀 PostgreSQL Kubernetes Samples

This directory contains comprehensive Kubernetes sample projects for PostgreSQL database deployment. These examples demonstrate various Kubernetes concepts including deployments, services, persistent volumes, secrets, configmaps, and more.

## 📁 Project Structure

```
kubernetes/
├── postgres-deployment.yaml              # Basic PostgreSQL deployment
├── postgres-deployment-with-secrets.yaml # PostgreSQL with secrets
├── postgres-pvc.yaml                     # Persistent Volume Claim
├── postgres-service.yaml                 # PostgreSQL service
├── postgres-configmap.yaml               # Configuration management
├── postgres-secret.yaml                  # Secret management
├── postgres-hpa.yaml                     # Horizontal Pod Autoscaler
├── postgres-ingress.yaml                 # Ingress configuration
├── docker-compose.yml                    # Local testing with Docker Compose
├── docker-compose-simple.yml             # Simple local testing
├── init-scripts/
│   └── init.sql                          # Database initialization script
├── scripts/
│   └── deploy.sh                         # Deployment automation script
└── README.md                             # This file
```

## 🎯 What You'll Learn

By working through these examples, you'll understand:

- **Kubernetes Deployments** - How to deploy PostgreSQL as a stateful application
- **Persistent Volumes** - Data persistence across pod restarts
- **Services** - Internal networking and service discovery
- **Secrets** - Secure credential management
- **ConfigMaps** - Configuration management
- **Health Checks** - Liveness and readiness probes
- **Resource Management** - CPU and memory limits
- **Auto-scaling** - Horizontal Pod Autoscaler
- **Ingress** - External access to services
- **Local Development** - Docker Compose for testing

## 🚀 Quick Start

### Prerequisites

- Kubernetes cluster (local or cloud)
- `kubectl` configured to access your cluster
- Docker (for local testing)

### Option 1: Using the Deployment Script (Recommended)

```bash
# Make the script executable (Linux/Mac)
chmod +x scripts/deploy.sh

# Deploy PostgreSQL to default namespace
./scripts/deploy.sh deploy

# Deploy with secrets and advanced features
./scripts/deploy.sh deploy postgres-db true hpa ingress

# Check deployment status
./scripts/deploy.sh status

# Connect to PostgreSQL
./scripts/deploy.sh connect

# Clean up when done
./scripts/deploy.sh cleanup
```

### Option 2: Manual Deployment

```bash
# 1. Create PersistentVolumeClaim
kubectl apply -f postgres-pvc.yaml

# 2. Create ConfigMap
kubectl apply -f postgres-configmap.yaml

# 3. Create Secret
kubectl apply -f postgres-secret.yaml

# 4. Create Service
kubectl apply -f postgres-service.yaml

# 5. Create Deployment
kubectl apply -f postgres-deployment.yaml

# 6. Check status
kubectl get pods -l app=postgres
kubectl get services -l app=postgres
```

### Option 3: Local Testing with Docker Compose

```bash
# Simple deployment
docker-compose -f docker-compose-simple.yml up -d

# Full deployment with pgAdmin
docker-compose up -d

# Check logs
docker-compose logs postgres

# Connect to database
docker exec -it postgres-k8s-demo psql -U postgres -d helloworld

# Stop and cleanup
docker-compose down -v
```

## 📋 Sample Configurations

### 1. Basic Deployment (`postgres-deployment.yaml`)

A simple PostgreSQL deployment with:
- Single replica
- Persistent storage
- Health checks
- Resource limits
- Environment variables

### 2. Secure Deployment (`postgres-deployment-with-secrets.yaml`)

Enhanced deployment with:
- Secret-based credentials
- ConfigMap integration
- Advanced PostgreSQL configuration
- Security best practices

### 3. Persistent Volume Claim (`postgres-pvc.yaml`)

Storage configuration:
- 10GB storage request
- ReadWriteOnce access mode
- Standard storage class

### 4. Service (`postgres-service.yaml`)

Network configuration:
- ClusterIP service type
- Port 5432 exposure
- Internal service discovery

### 5. ConfigMap (`postgres-configmap.yaml`)

Configuration management:
- Database settings
- PostgreSQL configuration
- Environment variables

### 6. Secret (`postgres-secret.yaml`)

Secure credential storage:
- Base64 encoded passwords
- Username and database name
- Opaque secret type

### 7. Horizontal Pod Autoscaler (`postgres-hpa.yaml`)

Auto-scaling configuration:
- CPU and memory-based scaling
- 1-3 replica range
- Custom scaling policies

### 8. Ingress (`postgres-ingress.yaml`)

External access configuration:
- NGINX ingress controller
- Host-based routing
- Optional TLS support

## 🔧 Configuration Details

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `POSTGRES_DB` | Database name | `helloworld` |
| `POSTGRES_USER` | Database user | `postgres` |
| `POSTGRES_PASSWORD` | Database password | `password` |
| `PGDATA` | Data directory | `/var/lib/postgresql/data/pgdata` |

### Resource Limits

| Resource | Request | Limit |
|----------|---------|-------|
| CPU | 250m | 500m |
| Memory | 256Mi | 512Mi |

### Health Checks

- **Liveness Probe**: Checks if PostgreSQL is accepting connections
- **Readiness Probe**: Verifies database readiness
- **Initial Delay**: 30 seconds (liveness), 5 seconds (readiness)
- **Period**: 10 seconds (liveness), 5 seconds (readiness)

## 🗄️ Database Schema

The initialization script creates:

### Users Table
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Posts Table
```sql
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 🔍 Monitoring and Troubleshooting

### Check Pod Status
```bash
kubectl get pods -l app=postgres
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Check Services
```bash
kubectl get services -l app=postgres
kubectl describe service postgres-service
```

### Check Persistent Volumes
```bash
kubectl get pvc -l app=postgres
kubectl describe pvc postgres-pvc
```

### Connect to Database
```bash
# Get pod name
POD_NAME=$(kubectl get pods -l app=postgres -o jsonpath='{.items[0].metadata.name}')

# Connect to PostgreSQL
kubectl exec -it $POD_NAME -- psql -U postgres -d helloworld
```

### Common Issues

1. **Pod not starting**: Check resource limits and PVC availability
2. **Connection refused**: Verify service and pod status
3. **Data not persisting**: Check PVC status and storage class
4. **Health check failures**: Review PostgreSQL logs and configuration

## 🚀 Advanced Features

### Auto-scaling
The HPA configuration automatically scales PostgreSQL based on:
- CPU utilization (70% threshold)
- Memory utilization (80% threshold)
- Custom scaling policies

### Security
- Secrets for credential management
- Non-root container execution
- Network policies (can be added)
- RBAC configurations (can be added)

### Monitoring
- Health check endpoints
- Resource usage monitoring
- Log aggregation ready
- Prometheus metrics compatible

## 🔄 CI/CD Integration

### GitHub Actions Example
```yaml
name: Deploy PostgreSQL
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Deploy to Kubernetes
      run: |
        kubectl apply -f postgres-deployment.yaml
        kubectl apply -f postgres-service.yaml
        kubectl rollout status deployment/postgres-deployment
```

## 📚 Learning Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Kubernetes Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
- [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
- [Kubernetes ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)

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
2. Review Kubernetes and PostgreSQL logs
3. Verify your cluster configuration
4. Open an issue on GitHub

---

**Happy Kubernetes Learning! 🚀**

*These samples are designed to help you learn Kubernetes concepts while working with PostgreSQL. Start with the basic examples and gradually work your way up to the advanced configurations.*
