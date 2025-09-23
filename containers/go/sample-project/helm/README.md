# Go Web App Helm Chart

This Helm chart deploys the CleanStart Go application on a Kubernetes cluster.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- CleanStart Go container image

## Installing the Chart

To install the chart with the release name `my-go-web-app`:

```bash
helm install my-go-web-app ./go-web-app
```

The command deploys the Go application on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-go-web-app` deployment:

```bash
helm uninstall my-go-web-app
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)   | `""`  |

### Image parameters

| Name                | Description                                                                 | Value                   |
| ------------------- | --------------------------------------------------------------------------- | ----------------------- |
| `image.repository`  | Go image repository                                                         | `cleanstart/go`         |
| `image.tag`         | Go image tag (immutable tags are recommended)                              | `""`                     |
| `image.pullPolicy`  | Go image pull policy                                                         | `Always`                |
```

## 🔧 Configuration

### Key Configuration Options

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | CleanStart Go image repository | `cleanstart/go` |
| `image.tag` | Image tag | `latest` |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | Service port | `8080` |
| `persistence.enabled` | Enable persistent storage | `true` |
| `persistence.size` | PVC size | `1Gi` |
| `autoscaling.enabled` | Enable HPA | `false` |
| `ingress.enabled` | Enable ingress | `false` |

### CleanStart Specific Settings

```yaml
cleanstart:
  enabled: true
  imageVerified: true
  securityScan: true
  publisher: "CleanStart"
```

## 📊 Values Examples

### Basic Deployment
```yaml
image:
  repository: cleanstart/go
  tag: latest

service:
  type: ClusterIP
  port: 8080

persistence:
  enabled: true
  size: 1Gi
```

### Production Deployment
```yaml
image:
  repository: cleanstart/go
  tag: latest
  pullPolicy: Always

service:
  type: LoadBalancer
  port: 8080

ingress:
  enabled: true
  className: nginx
  hosts:
    - host: go-app.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: go-app-tls
      hosts:
        - go-app.example.com

autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 80

resources:
  limits:
    cpu: 1000m
    memory: 1Gi
  requests:
    cpu: 500m
    memory: 512Mi

persistence:
  enabled: true
  size: 10Gi
  storageClass: fast-ssd
```

### Development Deployment
```yaml
image:
  repository: cleanstart/go
  tag: latest

service:
  type: NodePort
  port: 8080

ingress:
  enabled: true
  hosts:
    - host: go-app.local
      paths:
        - path: /
          pathType: Prefix

resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 250m
    memory: 256Mi

persistence:
  enabled: true
  size: 1Gi
```

## 🧪 Testing

### Test CleanStart Image
```bash
# Test CleanStart Go image
docker run --rm cleanstart/go:latest go version

# Test application locally
docker run --rm -p 8080:8080 cleanstart/go:latest
```

### Test Helm Chart
```bash
# Lint the chart
helm lint ./helm/go-web-app

# Dry run installation
helm install go-web-app ./helm/go-web-app --dry-run --debug

# Test upgrade
helm upgrade go-web-app ./helm/go-web-app --dry-run --debug
```

### Test Deployment
```bash
# Check deployment status
kubectl get pods -l app.kubernetes.io/name=go-web-app

# Check service
kubectl get svc go-web-app

# Check logs
kubectl logs -l app.kubernetes.io/name=go-web-app

# Test health endpoint
kubectl exec -it deployment/go-web-app -- wget -qO- http://localhost:8080/
```

## 🔍 Monitoring

### Health Checks
```bash
# Check pod health
kubectl describe pod -l app.kubernetes.io/name=go-web-app

# Test health endpoint
curl http://localhost:8080/
```

### Prometheus Integration
```yaml
serviceMonitor:
  enabled: true
  interval: 30s
  path: /metrics
  labels:
    prometheus: kube-prometheus
```

## 🔒 Security

### Network Policies
```yaml
networkPolicy:
  enabled: true
  ingress:
    - from:
        - namespaceSelector:
            matchLabels:
              name: ingress-nginx
      ports:
        - protocol: TCP
          port: 8080
```

### Security Context
```yaml
securityContext:
  capabilities:
    drop:
    - ALL
  readOnlyRootFilesystem: false
  runAsNonRoot: true
  runAsUser: 1000
```

## 📈 Scaling

### Horizontal Pod Autoscaler
```yaml
autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 80
  targetMemoryUtilizationPercentage: 80
```

### Manual Scaling
```bash
# Scale deployment
kubectl scale deployment go-web-app --replicas=5

# Check HPA status
kubectl get hpa
```

## 🔄 Backup and Recovery

### Database Backup
```bash
# Create backup
kubectl exec deployment/go-web-app -- cp /app/data/users.db /tmp/backup.db
kubectl cp go-web-app-pod:/tmp/backup.db ./backup.db
```

### Volume Backup
```bash
# Backup persistent volume
kubectl exec deployment/go-web-app -- tar czf /tmp/data-backup.tar.gz /app/data
kubectl cp go-web-app-pod:/tmp/data-backup.tar.gz ./data-backup.tar.gz
```

## 🐛 Troubleshooting

### Common Issues

**1. Pod Not Starting**
```bash
# Check pod status
kubectl describe pod -l app.kubernetes.io/name=go-web-app

# Check logs
kubectl logs -l app.kubernetes.io/name=go-web-app
```

**2. Service Not Accessible**
```bash
# Check service endpoints
kubectl get endpoints go-web-app

# Test service connectivity
kubectl exec -it deployment/go-web-app -- wget -qO- http://localhost:8080/
```

**3. Persistent Volume Issues**
```bash
# Check PVC status
kubectl get pvc

# Check PV status
kubectl get pv
```

### Debug Commands
```bash
# Get detailed pod information
kubectl get pods -o yaml -l app.kubernetes.io/name=go-web-app

# Check events
kubectl get events --sort-by=.metadata.creationTimestamp

# Describe resources
kubectl describe deployment go-web-app
```

## 📚 Application Features

### Web Interface
- **Homepage**: List all users (`/`)
- **Add User**: Create new user (`/add`)
- **Edit User**: Update user information (`/edit/:id`)
- **Delete User**: Remove user (`/delete/:id`)

### REST API
- **GET /api/users**: Get all users
- **POST /api/users**: Create new user

### Database
- **SQLite**: Embedded database
- **Persistent Storage**: Data survives pod restarts
- **Sample Data**: Pre-populated with demo users

## 🚀 Production Deployment

### Recommended Production Settings
1. **Use specific image tag**: `tag: "1.0.0"` instead of `latest`
2. **Enable ingress**: Configure proper ingress with TLS
3. **Set resource limits**: Configure CPU and memory limits
4. **Enable autoscaling**: Configure HPA for automatic scaling
5. **Enable monitoring**: Configure ServiceMonitor for Prometheus
6. **Use secrets**: Store sensitive data in Kubernetes secrets
7. **Enable network policies**: Restrict network access

### Production Values Example
```yaml
image:
  repository: cleanstart/go
  tag: "1.0.0"
  pullPolicy: Always

ingress:
  enabled: true
  className: nginx
  hosts:
    - host: go-app.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: go-app-tls
      hosts:
        - go-app.example.com

autoscaling:
  enabled: true
  minReplicas: 3
  maxReplicas: 20
  targetCPUUtilizationPercentage: 70

resources:
  limits:
    cpu: 1000m
    memory: 1Gi
  requests:
    cpu: 500m
    memory: 512Mi

persistence:
  enabled: true
  size: 20Gi
  storageClass: fast-ssd

serviceMonitor:
  enabled: true
  interval: 30s
  path: /metrics

networkPolicy:
  enabled: true
```

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🤝 Contributing

We welcome contributions to improve the Go Web App Helm chart:

1. **Report Issues**: Found a bug? Report it in the issues section
2. **Suggest Features**: Have ideas for improvements? Open a feature request
3. **Submit PRs**: Fixed a bug or added a feature? Submit a pull request
4. **Improve Docs**: Help improve documentation and examples

## 🆘 Support

### Getting Help
- **Documentation**: Check this README and Helm chart documentation
- **Issues**: Report bugs and request features in the issues section
- **CleanStart**: Visit [CleanStart.com](https://cleanstart.com/) for image support
- **Community**: Join discussions in the project community

### Contact Information
- **CleanStart Support**: [CleanStart.com](https://cleanstart.com/)
- **Go Documentation**: [Go.dev](https://go.dev/doc/)
- **Helm Documentation**: [Helm.sh](https://helm.sh/docs/)

---

**🎉 Ready to deploy Go Web App with CleanStart? Start with the quick start guide above!**
