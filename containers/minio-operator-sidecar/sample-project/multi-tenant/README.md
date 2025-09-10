# Multi-Tenant MinIO Cluster Setup

This example demonstrates how to deploy multiple MinIO tenants in a single Kubernetes cluster with proper isolation and resource management.

## 🎯 What You'll Learn

- Deploy multiple MinIO tenants in one cluster
- Configure tenant isolation and security
- Manage shared resources across tenants
- Implement network policies for tenant separation

## 📋 Prerequisites

- Kubernetes cluster (minikube, kind, or cloud provider)
- kubectl configured to access your cluster
- MinIO operator deployed
- Ports 9000-9003 available

## 🚀 Quick Start

### 1. Deploy MinIO Operator (if not already deployed)

```bash
# Apply the MinIO operator
kubectl apply -f minio-operator.yaml

# Wait for operator to be ready
kubectl wait --for=condition=available --timeout=300s deployment/minio-operator -n minio-operator
```

### 2. Deploy Development Tenant

```bash
# Apply the development tenant
kubectl apply -f tenant-dev.yaml

# Wait for tenant to be ready
kubectl wait --for=condition=ready tenant/minio-dev -n minio-dev --timeout=300s
```

### 3. Deploy Production Tenant

```bash
# Apply the production tenant
kubectl apply -f tenant-prod.yaml

# Wait for tenant to be ready
kubectl wait --for=condition=ready tenant/minio-prod -n minio-prod --timeout=300s
```

### 4. Deploy Network Policies

```bash
# Apply network policies for tenant isolation
kubectl apply -f network-policies.yaml
```

### 5. Access Tenants

```bash
# Port forward development tenant
kubectl port-forward svc/minio 9000:9000 -n minio-dev &
kubectl port-forward svc/minio-console 9001:9001 -n minio-dev &

# Port forward production tenant
kubectl port-forward svc/minio 9002:9000 -n minio-prod &
kubectl port-forward svc/minio-console 9003:9001 -n minio-prod &

# Access consoles
open http://localhost:9001  # Development
open http://localhost:9003  # Production
```

## 📁 Files Overview

- `minio-operator.yaml` - MinIO operator deployment
- `tenant-dev.yaml` - Development tenant configuration
- `tenant-prod.yaml` - Production tenant configuration
- `network-policies.yaml` - Network isolation policies
- `test-multi-tenant.sh` - Test script for multi-tenant setup
- `README.md` - This documentation

## 🔧 Configuration Details

### Development Tenant
- **Namespace**: `minio-dev`
- **Nodes**: 2 (single zone)
- **Storage**: 5Gi per node
- **Credentials**: `devadmin` / `devadmin123`
- **Resources**: Lower CPU/memory limits

### Production Tenant
- **Namespace**: `minio-prod`
- **Nodes**: 4 (2 zones)
- **Storage**: 20Gi per node
- **Credentials**: `prodadmin` / `prodadmin123`
- **Resources**: Higher CPU/memory limits

### Network Policies
- **Tenant Isolation**: Prevent cross-tenant communication
- **API Access**: Allow external access to APIs
- **Console Access**: Allow external access to consoles
- **Internal Communication**: Allow tenant internal communication

## 🧪 Testing

### Run the Test Script

```bash
# Make script executable
chmod +x test-multi-tenant.sh

# Run tests
./test-multi-tenant.sh
```

### Manual Testing

```bash
# Check all tenants
kubectl get tenants --all-namespaces

# Check tenant pods
kubectl get pods -n minio-dev
kubectl get pods -n minio-prod

# Check tenant services
kubectl get svc -n minio-dev
kubectl get svc -n minio-prod

# Check network policies
kubectl get networkpolicies --all-namespaces
```

## 🔍 Monitoring

### Check Tenant Health

```bash
# Check development tenant
kubectl describe tenant minio-dev -n minio-dev

# Check production tenant
kubectl describe tenant minio-prod -n minio-prod

# Check tenant logs
kubectl logs -l app=minio -n minio-dev
kubectl logs -l app=minio -n minio-prod
```

### Access Tenant Consoles

1. **Development Console**:
   ```bash
   kubectl port-forward svc/minio-console 9001:9001 -n minio-dev
   # Open http://localhost:9001
   # Username: devadmin, Password: devadmin123
   ```

2. **Production Console**:
   ```bash
   kubectl port-forward svc/minio-console 9003:9001 -n minio-prod
   # Open http://localhost:9003
   # Username: prodadmin, Password: prodadmin123
   ```

## 🛠️ Troubleshooting

### Common Issues

**Tenant creation fails**
```bash
# Check tenant status
kubectl describe tenant minio-dev -n minio-dev

# Check tenant events
kubectl get events -n minio-dev --field-selector involvedObject.name=minio-dev

# Check resource availability
kubectl top nodes
kubectl describe nodes
```

**Network policies blocking access**
```bash
# Check network policies
kubectl get networkpolicies --all-namespaces

# Check policy details
kubectl describe networkpolicy tenant-isolation -n minio-dev

# Test connectivity
kubectl run test-pod --image=busybox -it --rm -- sh
```

**Resource conflicts**
```bash
# Check resource usage
kubectl top pods --all-namespaces

# Check resource limits
kubectl describe pods -n minio-dev
kubectl describe pods -n minio-prod

# Check node resources
kubectl describe nodes
```

## 🧹 Cleanup

### Remove Tenants

```bash
# Delete development tenant
kubectl delete -f tenant-dev.yaml

# Delete production tenant
kubectl delete -f tenant-prod.yaml

# Delete network policies
kubectl delete -f network-policies.yaml
```

### Remove Operator

```bash
# Delete MinIO operator
kubectl delete -f minio-operator.yaml
```

### Clean Up Namespaces

```bash
# Delete namespaces
kubectl delete namespace minio-dev
kubectl delete namespace minio-prod
kubectl delete namespace minio-operator
```

## 📚 Next Steps

After completing this multi-tenant example:

1. **Try Production Setup** - Enterprise-grade configuration
2. **Set Up Monitoring** - Prometheus and Grafana integration
3. **Implement Backup** - Automated backup strategies
4. **Add Security** - Advanced security configurations

## 🔗 Related Examples

- [Basic Tenant Setup](../basic-tenant/) - Single tenant deployment
- [Production Setup](../production-setup/) - Enterprise-grade configuration
- [Monitoring Setup](../monitoring/) - Comprehensive monitoring

---

**Happy Multi-Tenant Management! 🏢🏢**
