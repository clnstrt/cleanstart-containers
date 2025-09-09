# Basic MinIO Tenant Deployment

This example demonstrates how to deploy a basic MinIO tenant using the MinIO Operator in Kubernetes.

## 🎯 What You'll Learn

- Deploy MinIO operator in Kubernetes
- Create a simple MinIO tenant
- Access MinIO console and API
- Basic tenant management operations

## 📋 Prerequisites

- Kubernetes cluster (minikube, kind, or cloud provider)
- kubectl configured to access your cluster
- Ports 9000 and 9001 available

## 🚀 Quick Start

### 1. Deploy MinIO Operator

```bash
# Apply the MinIO operator
kubectl apply -f minio-operator.yaml

# Wait for operator to be ready
kubectl wait --for=condition=available --timeout=300s deployment/minio-operator -n minio-operator

# Check operator status
kubectl get pods -n minio-operator
```

### 2. Deploy MinIO Tenant

```bash
# Apply the MinIO tenant
kubectl apply -f minio-tenant.yaml

# Wait for tenant to be ready
kubectl wait --for=condition=available --timeout=300s deployment/minio -n minio-tenant

# Check tenant status
kubectl get tenants
kubectl get pods -n minio-tenant
```

### 3. Access MinIO Services

```bash
# Port forward MinIO API
kubectl port-forward svc/minio 9000:9000 -n minio-tenant &

# Port forward MinIO Console
kubectl port-forward svc/minio-console 9001:9001 -n minio-tenant &

# Access MinIO Console
open http://localhost:9001
```

### 4. Test MinIO Operations

```bash
# Test MinIO API health
curl http://localhost:9000/minio/health/live

# Test MinIO API ready
curl http://localhost:9000/minio/health/ready

# Test MinIO console
curl http://localhost:9001
```

## 📁 Files Overview

- `minio-operator.yaml` - MinIO operator deployment
- `minio-tenant.yaml` - Basic MinIO tenant configuration
- `test-tenant.sh` - Test script for tenant operations
- `README.md` - This documentation

## 🔧 Configuration Details

### MinIO Operator
- **Namespace**: `minio-operator`
- **Replicas**: 1
- **Image**: `minio/operator:latest`
- **Resources**: 100m CPU, 128Mi memory

### MinIO Tenant
- **Namespace**: `minio-tenant`
- **Nodes**: 4 (2 per zone)
- **Storage**: 10Gi per node
- **Credentials**: `minioadmin` / `minioadmin123`

## 🧪 Testing

### Run the Test Script

```bash
# Make script executable
chmod +x test-tenant.sh

# Run tests
./test-tenant.sh
```

### Manual Testing

```bash
# Check tenant status
kubectl get tenants -o wide

# Check tenant pods
kubectl get pods -n minio-tenant -o wide

# Check tenant services
kubectl get svc -n minio-tenant

# Check tenant events
kubectl get events -n minio-tenant
```

## 🔍 Monitoring

### Check Tenant Health

```bash
# Check tenant status
kubectl describe tenant minio-tenant

# Check tenant logs
kubectl logs -l app=minio -n minio-tenant

# Check operator logs
kubectl logs -l app=minio-operator -n minio-operator
```

### Access MinIO Console

1. Port forward the console service:
   ```bash
   kubectl port-forward svc/minio-console 9001:9001 -n minio-tenant
   ```

2. Open browser to `http://localhost:9001`

3. Login with credentials:
   - Username: `minioadmin`
   - Password: `minioadmin123`

## 🛠️ Troubleshooting

### Common Issues

**Operator won't start**
```bash
# Check operator logs
kubectl logs -n minio-operator deployment/minio-operator

# Check operator configuration
kubectl get configmap -n minio-operator

# Check operator permissions
kubectl auth can-i create tenants --as=system:serviceaccount:minio-operator:minio-operator
```

**Tenant creation fails**
```bash
# Check tenant status
kubectl describe tenant minio-tenant

# Check tenant events
kubectl get events --field-selector involvedObject.name=minio-tenant

# Check resource availability
kubectl top nodes
kubectl top pods -n minio-tenant
```

**Console access issues**
```bash
# Check console service
kubectl get svc minio-console -n minio-tenant

# Check console pod status
kubectl get pods -l app=minio-console -n minio-tenant

# Check console logs
kubectl logs -l app=minio-console -n minio-tenant
```

## 🧹 Cleanup

### Remove Tenant

```bash
# Delete MinIO tenant
kubectl delete -f minio-tenant.yaml

# Wait for tenant to be deleted
kubectl wait --for=delete tenant/minio-tenant --timeout=300s
```

### Remove Operator

```bash
# Delete MinIO operator
kubectl delete -f minio-operator.yaml

# Wait for operator to be deleted
kubectl wait --for=delete deployment/minio-operator -n minio-operator --timeout=300s
```

### Clean Up Namespaces

```bash
# Delete namespaces
kubectl delete namespace minio-tenant
kubectl delete namespace minio-operator
```

## 📚 Next Steps

After completing this basic example:

1. **Try Multi-Tenant Setup** - Deploy multiple tenants
2. **Explore Production Setup** - Enterprise-grade configuration
3. **Set Up Monitoring** - Prometheus and Grafana integration
4. **Learn Advanced Features** - Scaling, backup, and security

## 🔗 Related Examples

- [Multi-Tenant Setup](../multi-tenant/) - Multiple tenants in one cluster
- [Production Setup](../production-setup/) - Enterprise-grade configuration
- [Monitoring Setup](../monitoring/) - Comprehensive monitoring

---

**Happy MinIO Tenant Management! 🏢**
