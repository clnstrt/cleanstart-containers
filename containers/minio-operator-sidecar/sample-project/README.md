# MinIO Operator Sidecar Sample Projects

This directory contains practical examples demonstrating how to use the MinIO Operator Sidecar for MinIO tenant management and cluster operations in Kubernetes environments.

## 🎯 What You'll Learn

- **Basic Tenant Management**: Deploy and manage single MinIO tenants
- **Multi-Tenant Setup**: Configure multiple MinIO tenants in a single cluster
- **Production Configuration**: Enterprise-grade MinIO operator setup
- **Monitoring Integration**: Prometheus and Grafana monitoring setup
- **Security Best Practices**: RBAC, network policies, and security configurations

## 📁 Project Structure

```
sample-project/
├── basic-tenant/              # 🏢 Basic MinIO tenant deployment
├── multi-tenant/              # 🏢 Multi-tenant MinIO cluster setup
├── production-setup/          # 🏭 Production-ready MinIO operator
├── monitoring/                # 📊 Monitoring and observability
├── README.md                  # 📖 This comprehensive guide
├── setup.sh                   # 🐧 Linux/macOS setup script
├── setup.bat                  # 🪟 Windows setup script
└── docker-compose.yml         # 🐳 Docker Compose for easy testing
```

## 🚀 Quick Start

### Prerequisites

- Kubernetes cluster (minikube, kind, or cloud provider)
- kubectl configured to access your cluster
- Docker and Docker Compose installed
- Basic understanding of Kubernetes concepts
- Ports 9000, 9001, 9090, 3000 available (depending on example)

### Choose Your Learning Path

| Level | Example | Description | Time to Complete |
|-------|---------|-------------|------------------|
| **🟢 Beginner** | `basic-tenant/` | Basic MinIO tenant deployment | 20-30 minutes |
| **🟡 Intermediate** | `multi-tenant/` | Multi-tenant cluster setup | 30-45 minutes |
| **🔴 Advanced** | `production-setup/` | Production-ready operator configuration | 45-60 minutes |
| **📊 Monitoring** | `monitoring/` | Monitoring and observability setup | 30-45 minutes |

### Run Any Example

```bash
# Navigate to the example directory
cd basic-tenant

# Deploy the MinIO operator
kubectl apply -f minio-operator.yaml

# Deploy the MinIO tenant
kubectl apply -f minio-tenant.yaml

# Check the status
kubectl get tenants
kubectl get pods -n minio-operator

# Access MinIO console
kubectl port-forward svc/minio-console 9001:9001
```

## 📊 Example Overview

### 1. 🏢 Basic Tenant (`basic-tenant/`)

**Purpose**: Learn fundamental MinIO tenant deployment and management.

**Components**:
- **MinIO Operator**: Kubernetes operator for MinIO management
- **MinIO Tenant**: Single MinIO tenant with 4 nodes
- **MinIO Console**: Web-based management interface
- **Service Configuration**: LoadBalancer and NodePort services

**Access Points**:
- MinIO API: `http://localhost:9000`
- MinIO Console: `http://localhost:9001`
- Default credentials: `minioadmin` / `minioadmin123`

**Learning Objectives**:
- Deploy MinIO operator in Kubernetes
- Create and manage MinIO tenants
- Access MinIO console and API
- Basic tenant configuration

**Time to Complete**: 20-30 minutes

### 2. 🏢 Multi-Tenant (`multi-tenant/`)

**Purpose**: Master multi-tenant MinIO cluster setup and management.

**Components**:
- **MinIO Operator**: Multi-tenant capable operator
- **Tenant 1**: Development environment tenant
- **Tenant 2**: Production environment tenant
- **Shared Storage**: Common storage backend
- **Network Policies**: Tenant isolation

**Access Points**:
- Tenant 1 API: `http://localhost:9000`
- Tenant 1 Console: `http://localhost:9001`
- Tenant 2 API: `http://localhost:9002`
- Tenant 2 Console: `http://localhost:9003`

**Learning Objectives**:
- Multi-tenant MinIO deployment
- Tenant isolation and security
- Resource management across tenants
- Network policy configuration

**Time to Complete**: 30-45 minutes

### 3. 🏭 Production Setup (`production-setup/`)

**Purpose**: Implement enterprise-grade MinIO operator with security and high availability.

**Components**:
- **Production Operator**: High-availability operator setup
- **Production Tenant**: Multi-zone tenant with replication
- **Security Hardening**: RBAC, network policies, and encryption
- **Backup Configuration**: Automated backup and disaster recovery
- **Resource Management**: CPU and memory limits

**Access Points**:
- Production API: `https://localhost:9000`
- Production Console: `https://localhost:9001`
- Admin Interface: `https://localhost:9002`
- Backup Interface: `https://localhost:9003`

**Learning Objectives**:
- Production MinIO architecture
- Security hardening and compliance
- High availability and disaster recovery
- Resource management and scaling

**Time to Complete**: 45-60 minutes

### 4. 📊 Monitoring (`monitoring/`)

**Purpose**: Set up comprehensive monitoring and observability for MinIO clusters.

**Components**:
- **Prometheus**: Metrics collection and storage
- **Grafana**: Monitoring dashboards and visualization
- **MinIO Exporter**: MinIO-specific metrics exporter
- **Alert Manager**: Alerting and notification system
- **Custom Dashboards**: MinIO-specific monitoring dashboards

**Access Points**:
- Prometheus: `http://localhost:9090`
- Grafana: `http://localhost:3000` (admin/admin)
- MinIO Exporter: `http://localhost:9091`
- Alert Manager: `http://localhost:9093`

**Learning Objectives**:
- MinIO monitoring setup
- Prometheus metrics collection
- Grafana dashboard configuration
- Alerting and notification setup

**Time to Complete**: 30-45 minutes

## 🔧 Setup Scripts

### Linux/macOS Setup

```bash
# Make script executable
chmod +x setup.sh

# Run interactive setup script
./setup.sh
```

### Windows Setup

```cmd
# Run interactive setup script
setup.bat
```

### Docker Compose Setup

```bash
# Start all services with Docker Compose
docker-compose up -d

# Check service status
docker-compose ps

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## 📈 MinIO Operator Best Practices

### Key Operations to Master

| Operation | Description | Best Practice | Example Command |
|-----------|-------------|---------------|-----------------|
| **Tenant Creation** | Create new MinIO tenants | Use proper resource limits and security | `kubectl apply -f minio-tenant.yaml` |
| **Tenant Scaling** | Scale MinIO tenant nodes | Use horizontal pod autoscaler | `kubectl scale tenant my-tenant --replicas=8` |
| **Tenant Backup** | Backup tenant data | Implement automated backup strategy | `kubectl create job backup-job --from=cronjob/backup` |
| **Tenant Monitoring** | Monitor tenant health | Use Prometheus and Grafana | `kubectl get tenants -o wide` |
| **Tenant Security** | Secure tenant access | Implement RBAC and network policies | `kubectl apply -f rbac.yaml` |

### Security Considerations

```yaml
# Example RBAC configuration
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: minio-tenant-admin
rules:
- apiGroups: ["minio.min.io"]
  resources: ["tenants"]
  verbs: ["get", "list", "create", "update", "patch", "delete"]
```

## 🎓 Learning Path

### 🟢 Beginner Level (20-30 minutes)
1. **Start with Basic Tenant**
   - Deploy MinIO operator
   - Create a simple MinIO tenant
   - Access MinIO console
   - Test basic operations

2. **Practice Tenant Management**
   - Scale tenant nodes
   - Update tenant configuration
   - Monitor tenant health
   - Backup tenant data

### 🟡 Intermediate Level (30-45 minutes)
1. **Move to Multi-Tenant Setup**
   - Deploy multiple tenants
   - Configure tenant isolation
   - Implement network policies
   - Manage shared resources

2. **Tenant Lifecycle Management**
   - Tenant provisioning automation
   - Tenant decommissioning
   - Resource allocation
   - Cost optimization

### 🔴 Advanced Level (45-60 minutes)
1. **Production Setup**
   - Implement high availability
   - Configure security hardening
   - Set up disaster recovery
   - Implement compliance

2. **Advanced Operations**
   - Custom operator development
   - Advanced monitoring setup
   - Performance optimization
   - Security auditing

### 📊 Expert Level (60+ minutes)
1. **Monitoring and Observability**
   - Comprehensive monitoring setup
   - Custom dashboard creation
   - Alerting configuration
   - Performance analysis

2. **Custom Solutions**
   - Custom operator development
   - Integration with other systems
   - Advanced automation
   - Enterprise features

## 🔍 Testing and Validation

### Health Checks

```bash
# Check MinIO operator status
kubectl get pods -n minio-operator

# Check MinIO tenant status
kubectl get tenants

# Check MinIO instance status
kubectl get minioinstances

# Check MinIO console access
kubectl port-forward svc/minio-console 9001:9001
```

### Tenant Testing

```bash
# Test MinIO API access
curl http://localhost:9000/minio/health/live

# Test MinIO console access
curl http://localhost:9001

# Test tenant scaling
kubectl scale tenant my-tenant --replicas=4

# Test tenant backup
kubectl create job backup-test --from=cronjob/backup
```

### Operator Testing

```bash
# Test operator logs
kubectl logs -n minio-operator deployment/minio-operator

# Test operator metrics
kubectl port-forward svc/minio-operator 4222:4222

# Test operator health
kubectl get pods -n minio-operator -o wide
```

## 🛡️ Security Considerations

### Network Security
- Use network policies for tenant isolation
- Implement TLS encryption for all communications
- Use proper ingress controllers
- Regular security audits and updates

### Access Control
- Implement RBAC for operator access
- Use service accounts with minimal permissions
- Regular access review and rotation
- Monitor access patterns and anomalies

### Data Security
- Enable encryption at rest
- Use secure key management
- Implement data retention policies
- Regular backup and recovery testing

## 🔧 Troubleshooting

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
kubectl describe tenant my-tenant

# Check tenant events
kubectl get events --field-selector involvedObject.name=my-tenant

# Check resource availability
kubectl top nodes
kubectl top pods -n minio-operator
```

**Console access issues**
```bash
# Check console service
kubectl get svc minio-console

# Check console pod status
kubectl get pods -l app=minio-console

# Check console logs
kubectl logs -l app=minio-console
```

### Debug Commands

```bash
# Check operator configuration
kubectl get configmap -n minio-operator

# Check operator RBAC
kubectl get clusterrole minio-operator

# Check tenant resources
kubectl get all -l app=minio

# Check operator metrics
kubectl port-forward svc/minio-operator 4222:4222
```

## 📚 Additional Resources

### Documentation
- [MinIO Operator Documentation](https://docs.min.io/docs/minio-operator-quickstart-guide.html)
- [MinIO Kubernetes Documentation](https://docs.min.io/docs/deploy-minio-on-kubernetes.html)
- [Kubernetes Operators Guide](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/)

### Community
- [MinIO Community](https://github.com/minio/minio)
- [MinIO Operator GitHub](https://github.com/minio/operator)
- [MinIO Documentation](https://docs.min.io/)

### Tools and Extensions
- [MinIO Client (mc)](https://docs.min.io/docs/minio-client-quickstart-guide.html)
- [MinIO Console](https://github.com/minio/console)
- [MinIO Exporter](https://github.com/minio/minio/blob/master/docs/metrics/prometheus/README.md)

## 🤝 Contributing

We welcome contributions to improve these examples:

1. **Add new tenant management scenarios**
2. **Improve documentation**
3. **Create additional examples**
4. **Fix bugs and issues**
5. **Add new integration examples**
6. **Improve security configurations**

### How to Contribute

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📞 Support

If you encounter issues or need help:

1. **Check the troubleshooting section above**
2. **Review the individual example READMEs**
3. **Check the logs for specific error messages**
4. **Open an issue on GitHub with detailed information**

---

**Happy MinIO Tenant Management! 🏢**