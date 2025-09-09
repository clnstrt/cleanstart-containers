# Production MinIO Operator Setup

This example demonstrates how to deploy a production-ready MinIO operator with enterprise-grade security, high availability, and monitoring.

## 🎯 What You'll Learn

- Deploy production-ready MinIO operator
- Configure high availability and disaster recovery
- Implement security hardening and compliance
- Set up comprehensive monitoring and alerting

## 📋 Prerequisites

- Kubernetes cluster with at least 3 nodes
- kubectl configured to access your cluster
- Helm installed (for monitoring)
- Ports 9000-9003 available

## 🚀 Quick Start

### 1. Deploy Production MinIO Operator

```bash
# Apply the production operator
kubectl apply -f minio-operator-prod.yaml

# Wait for operator to be ready
kubectl wait --for=condition=available --timeout=300s deployment/minio-operator -n minio-operator
```

### 2. Deploy Production Tenant

```bash
# Apply the production tenant
kubectl apply -f tenant-production.yaml

# Wait for tenant to be ready
kubectl wait --for=condition=ready tenant/minio-production -n minio-production --timeout=600s
```

### 3. Deploy Security Policies

```bash
# Apply RBAC and security policies
kubectl apply -f rbac.yaml
kubectl apply -f security-policies.yaml
kubectl apply -f network-policies.yaml
```

### 4. Deploy Monitoring

```bash
# Deploy Prometheus and Grafana
kubectl apply -f monitoring.yaml

# Wait for monitoring to be ready
kubectl wait --for=condition=available --timeout=300s deployment/prometheus -n monitoring
kubectl wait --for=condition=available --timeout=300s deployment/grafana -n monitoring
```

### 5. Deploy Backup Configuration

```bash
# Apply backup configuration
kubectl apply -f backup.yaml

# Wait for backup to be ready
kubectl wait --for=condition=available --timeout=300s deployment/backup-operator -n backup
```

### 6. Access Production Services

```bash
# Port forward production tenant
kubectl port-forward svc/minio 9000:9000 -n minio-production &
kubectl port-forward svc/minio-console 9001:9001 -n minio-production &

# Port forward monitoring
kubectl port-forward svc/prometheus 9090:9090 -n monitoring &
kubectl port-forward svc/grafana 3000:3000 -n monitoring &

# Access services
open http://localhost:9001  # MinIO Console
open http://localhost:3000  # Grafana (admin/admin)
open http://localhost:9090  # Prometheus
```

## 📁 Files Overview

- `minio-operator-prod.yaml` - Production MinIO operator
- `tenant-production.yaml` - Production tenant configuration
- `rbac.yaml` - RBAC and security policies
- `security-policies.yaml` - Security hardening policies
- `network-policies.yaml` - Network isolation policies
- `monitoring.yaml` - Prometheus and Grafana setup
- `backup.yaml` - Backup and disaster recovery
- `test-production.sh` - Test script for production setup
- `README.md` - This documentation

## 🔧 Configuration Details

### Production Operator
- **Namespace**: `minio-operator`
- **Replicas**: 2 (high availability)
- **Resources**: 500m CPU, 512Mi memory
- **Security**: Non-root user, security contexts
- **Monitoring**: Prometheus metrics enabled

### Production Tenant
- **Namespace**: `minio-production`
- **Nodes**: 8 (4 zones, 2 nodes per zone)
- **Storage**: 100Gi per node (800Gi total)
- **Replication**: 4+2 erasure coding
- **Resources**: 1 CPU, 2Gi memory per pod
- **Security**: TLS encryption, RBAC, network policies

### Security Features
- **RBAC**: Role-based access control
- **Network Policies**: Tenant isolation
- **Pod Security**: Non-root users, security contexts
- **TLS**: Encryption in transit
- **Secrets**: Secure credential management

### Monitoring
- **Prometheus**: Metrics collection
- **Grafana**: Dashboards and visualization
- **AlertManager**: Alerting and notifications
- **MinIO Exporter**: MinIO-specific metrics

### Backup
- **Automated Backup**: Daily backups
- **Disaster Recovery**: Cross-region replication
- **Retention**: 30-day retention policy
- **Encryption**: Backup encryption

## 🧪 Testing

### Run the Test Script

```bash
# Make script executable
chmod +x test-production.sh

# Run tests
./test-production.sh
```

### Manual Testing

```bash
# Check operator status
kubectl get pods -n minio-operator

# Check tenant status
kubectl get tenants -n minio-production

# Check security policies
kubectl get networkpolicies --all-namespaces
kubectl get rbac --all-namespaces

# Check monitoring
kubectl get pods -n monitoring

# Check backup
kubectl get pods -n backup
```

## 🔍 Monitoring

### Access Monitoring Dashboards

1. **Grafana Dashboard**:
   ```bash
   kubectl port-forward svc/grafana 3000:3000 -n monitoring
   # Open http://localhost:3000
   # Username: admin, Password: admin
   ```

2. **Prometheus**:
   ```bash
   kubectl port-forward svc/prometheus 9090:9090 -n monitoring
   # Open http://localhost:9090
   ```

3. **MinIO Console**:
   ```bash
   kubectl port-forward svc/minio-console 9001:9001 -n minio-production
   # Open http://localhost:9001
   # Username: prodadmin, Password: prodadmin123
   ```

### Key Metrics to Monitor

- **Tenant Health**: Pod status, readiness, liveness
- **Storage Usage**: Disk usage, available space
- **Performance**: Request latency, throughput
- **Security**: Failed authentication attempts
- **Backup**: Backup success/failure rates

## 🛠️ Troubleshooting

### Common Issues

**Operator high availability issues**
```bash
# Check operator pods
kubectl get pods -n minio-operator

# Check operator logs
kubectl logs -l app=minio-operator -n minio-operator

# Check operator events
kubectl get events -n minio-operator
```

**Tenant scaling issues**
```bash
# Check tenant status
kubectl describe tenant minio-production -n minio-production

# Check tenant pods
kubectl get pods -n minio-production -o wide

# Check resource usage
kubectl top pods -n minio-production
```

**Security policy issues**
```bash
# Check network policies
kubectl get networkpolicies --all-namespaces

# Check RBAC
kubectl get clusterroles | grep minio
kubectl get clusterrolebindings | grep minio

# Test connectivity
kubectl run test-pod --image=busybox -it --rm -- sh
```

**Monitoring issues**
```bash
# Check monitoring pods
kubectl get pods -n monitoring

# Check monitoring logs
kubectl logs -l app=prometheus -n monitoring
kubectl logs -l app=grafana -n monitoring

# Check monitoring services
kubectl get svc -n monitoring
```

## 🧹 Cleanup

### Remove Production Setup

```bash
# Delete production tenant
kubectl delete -f tenant-production.yaml

# Delete security policies
kubectl delete -f rbac.yaml
kubectl delete -f security-policies.yaml
kubectl delete -f network-policies.yaml

# Delete monitoring
kubectl delete -f monitoring.yaml

# Delete backup
kubectl delete -f backup.yaml

# Delete operator
kubectl delete -f minio-operator-prod.yaml
```

### Clean Up Namespaces

```bash
# Delete namespaces
kubectl delete namespace minio-production
kubectl delete namespace minio-operator
kubectl delete namespace monitoring
kubectl delete namespace backup
```

## 📚 Next Steps

After completing this production setup:

1. **Set Up Monitoring** - Comprehensive monitoring and alerting
2. **Implement Backup** - Automated backup and disaster recovery
3. **Add Security** - Advanced security configurations
4. **Scale Operations** - Multi-cluster and multi-region setup

## 🔗 Related Examples

- [Basic Tenant Setup](../basic-tenant/) - Single tenant deployment
- [Multi-Tenant Setup](../multi-tenant/) - Multiple tenants in one cluster
- [Monitoring Setup](../monitoring/) - Comprehensive monitoring

---

**Happy Production Management! 🏭**
