# CleanStart Nginx - Complete Production Deployment

A comprehensive, production-ready Kubernetes deployment for CleanStart Nginx web server. This single-file deployment includes all necessary components for a robust, scalable, and secure web server setup.

## 🚀 Overview

This deployment provides a complete Nginx solution on Kubernetes with:

- **Production-ready configuration** with security headers, compression, and performance optimizations
- **Multiple service types** (ClusterIP, NodePort, LoadBalancer) for different access patterns
- **Horizontal Pod Autoscaling** for automatic scaling based on CPU and memory usage
- **Pod Disruption Budget** for high availability during updates
- **Network Policies** for enhanced security
- **Comprehensive monitoring** with Prometheus metrics and health checks
- **Interactive web interface** for testing and validation

## 📋 Prerequisites

- Kubernetes cluster (v1.19+)
- `kubectl` configured and connected to your cluster
- Access to CleanStart Nginx image (`cleanstart/nginx:latest`)
- Sufficient cluster resources (minimum 2 nodes recommended for HPA)

## 🏗️ Architecture

### Components Included

| Component | Type | Purpose |
|-----------|------|---------|
| **Namespace** | `nginx-production` | Isolated environment for all resources |
| **ConfigMaps** | `nginx-config`, `nginx-html-content` | Configuration and static content |
| **Deployment** | `nginx-app` | Main application with 3 replicas |
| **Services** | `nginx-service`, `nginx-service-nodeport`, `nginx-service-loadbalancer` | Different access methods |
| **ServiceAccount** | `nginx-app-sa` | Security context for pods |
| **HPA** | `nginx-hpa` | Automatic scaling (2-10 replicas) |
| **PDB** | `nginx-pdb` | High availability during updates |
| **NetworkPolicy** | `nginx-network-policy` | Network security rules |

### Resource Requirements

- **CPU**: 100m request, 200m limit per pod
- **Memory**: 128Mi request, 256Mi limit per pod
- **Storage**: EmptyDir volumes for logs and cache
- **Network**: Port 80 for HTTP traffic

## 🚀 Quick Start

### 1. Deploy Everything

```bash
# Deploy all components with a single command
kubectl apply -f complete-deployment.yaml

# Verify deployment
kubectl get all -n nginx-production
```

### 2. Check Deployment Status

```bash
# Check pods
kubectl get pods -n nginx-production

# Check services
kubectl get services -n nginx-production

# Check HPA status
kubectl get hpa -n nginx-production

# Check PDB
kubectl get pdb -n nginx-production
```

Expected output:
```
NAME                           READY   STATUS    RESTARTS   AGE
nginx-app-xxxxx-yyyyy         1/1     Running   0          1m
nginx-app-xxxxx-zzzzz         1/1     Running   0          1m
nginx-app-xxxxx-aaaaa         1/1     Running   0          1m

NAME                           TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
nginx-service                  ClusterIP      10.96.xxx.xxx   <none>        80/TCP         1m
nginx-service-loadbalancer    LoadBalancer   10.96.yyy.yyy   <pending>     80:xxxxx/TCP   1m
nginx-service-nodeport        NodePort       10.96.zzz.zzz   <none>        80:30080/TCP   1m

NAME               REFERENCE         TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
nginx-hpa          Deployment/nginx-app   0%/70%   2         10        3          1m

NAME             MIN AVAILABLE   MAX UNAVAILABLE   ALLOWED DISRUPTIONS   AGE
nginx-pdb        1               N/A               2                     1m
```

## 🌐 Access Methods

### Method 1: Port Forward (Development/Testing)

```bash
# Port forward to access the application
kubectl port-forward -n nginx-production svc/nginx-service 8080:80

# Access: http://localhost:8080
```

### Method 2: NodePort (External Access)

```bash
# Get node IP (for minikube)
minikube ip

# Access via NodePort
# http://<NODE-IP>:30080
```

### Method 3: LoadBalancer (Cloud Providers)

```bash
# Get external IP
kubectl get services -n nginx-production nginx-service-loadbalancer

# Access via LoadBalancer IP
# http://<EXTERNAL-IP>
```

### Method 4: Ingress (Production)

```bash
# Create ingress (example with nginx-ingress)
kubectl create ingress nginx-ingress -n nginx-production \
  --rule="nginx.example.com/*=nginx-service:80" \
  --class=nginx
```

## 🔍 Testing & Validation

### Available Endpoints

| Endpoint | Method | Purpose | Response |
|----------|--------|---------|----------|
| `/` | GET | Main application | Interactive web interface |
| `/health` | GET | Health check | `healthy` |
| `/status` | GET | Status information | JSON with status, timestamp, version |
| `/metrics` | GET | Prometheus metrics | Metrics in Prometheus format |
| `/api/*` | ANY | API proxy | Proxied to backend service |

### Quick Tests

```bash
# Health check
curl http://localhost:8080/health

# Status information
curl http://localhost:8080/status

# Metrics
curl http://localhost:8080/metrics

# Security headers
curl -I http://localhost:8080/
```

### Interactive Testing

The web interface at `http://localhost:8080` provides:

- **Clickable endpoint testing**
- **Security headers validation**
- **Real-time response display**
- **Feature validation dashboard**

## 📊 Monitoring & Observability

### Health Checks

- **Liveness Probe**: `/health` endpoint every 10 seconds
- **Readiness Probe**: `/health` endpoint every 5 seconds
- **Startup Probe**: `/health` endpoint with 30 failure threshold

### Metrics

- **Prometheus Metrics**: Available at `/metrics`
- **Custom Metrics**: Status endpoint with timestamp and version
- **Resource Metrics**: CPU and memory usage for HPA

### Logging

```bash
# View application logs
kubectl logs -n nginx-production deployment/nginx-app

# Follow logs in real-time
kubectl logs -f -n nginx-production deployment/nginx-app

# View logs from specific pod
kubectl logs -n nginx-production <pod-name>
```

## 🔧 Configuration Management

### Nginx Configuration

The Nginx configuration includes:

- **Performance optimizations**: sendfile, tcp_nopush, keepalive
- **Security headers**: X-Frame-Options, CSP, XSS protection
- **Compression**: Gzip for text-based content
- **Rate limiting**: API and login rate limits
- **Proxy configuration**: Backend service integration
- **Caching**: Static file caching with appropriate headers

### Environment Variables

- `NGINX_ENVSUBST_TEMPLATE_DIR`: Template directory
- `NGINX_ENVSUBST_TEMPLATE_SUFFIX`: Template file suffix
- `NGINX_ENTRYPOINT_QUIET_LOGS`: Quiet startup logs

### Volume Mounts

- **Configuration**: `/etc/nginx/nginx.conf` (read-only)
- **Static Content**: `/usr/share/nginx/html` (read-only)
- **Logs**: `/var/log/nginx` (writable)
- **Cache**: `/var/cache/nginx` (writable)
- **Temporary**: `/tmp` (writable)

## 🚀 Scaling & Performance

### Horizontal Pod Autoscaler

- **Min Replicas**: 2
- **Max Replicas**: 10
- **CPU Target**: 70% utilization
- **Memory Target**: 80% utilization
- **Scale Down**: 10% every 60 seconds (5-minute stabilization)
- **Scale Up**: 50% every 60 seconds (1-minute stabilization)

### Pod Disruption Budget

- **Min Available**: 1 pod
- **Ensures**: At least 1 pod remains available during updates

### Anti-Affinity

- **Pod Anti-Affinity**: Prefers pods on different nodes
- **Topology Key**: `kubernetes.io/hostname`

## 🔒 Security Features

### Network Security

- **Network Policies**: Restrict ingress/egress traffic
- **Service Account**: Non-root user execution
- **Security Context**: Run as user 1001, group 1001

### Application Security

- **Security Headers**: Comprehensive security header implementation
- **Access Control**: Hidden file protection, backup file blocking
- **Rate Limiting**: API and login rate limiting
- **Content Security Policy**: Strict CSP implementation

### Security Headers Included

- `X-Frame-Options: SAMEORIGIN`
- `X-Content-Type-Options: nosniff`
- `X-XSS-Protection: 1; mode=block`
- `Referrer-Policy: strict-origin-when-cross-origin`
- `Content-Security-Policy: default-src 'self'...`

## 🛠️ Troubleshooting

### Common Issues

1. **Pods not starting**:
   ```bash
   kubectl describe pod -n nginx-production -l app=nginx-app
   kubectl logs -n nginx-production deployment/nginx-app
   ```

2. **Services not accessible**:
   ```bash
   kubectl get services -n nginx-production
   kubectl get endpoints -n nginx-production
   ```

3. **HPA not scaling**:
   ```bash
   kubectl describe hpa -n nginx-production nginx-hpa
   kubectl top pods -n nginx-production
   ```

4. **Network policy blocking traffic**:
   ```bash
   kubectl describe networkpolicy -n nginx-production nginx-network-policy
   ```

### Debug Commands

```bash
# Check all resources
kubectl get all -n nginx-production

# Check events
kubectl get events -n nginx-production --sort-by='.lastTimestamp'

# Check resource usage
kubectl top pods -n nginx-production
kubectl top nodes

# Check configuration
kubectl describe configmap -n nginx-production nginx-config
kubectl describe configmap -n nginx-production nginx-html-content
```

## 📈 Performance Testing

### Load Testing

```bash
# Install hey (load testing tool)
go install github.com/rakyll/hey@latest

# Basic load test
hey -n 1000 -c 10 http://localhost:8080/health

# Stress test
hey -n 10000 -c 50 http://localhost:8080/status
```

### Monitoring During Load

```bash
# Watch HPA scaling
kubectl get hpa -n nginx-production -w

# Monitor pod status
kubectl get pods -n nginx-production -w

# Check resource usage
kubectl top pods -n nginx-production
```

## 🔄 Updates & Maintenance

### Rolling Updates

```bash
# Update image
kubectl set image deployment/nginx-app nginx-app=cleanstart/nginx:latest -n nginx-production

# Check rollout status
kubectl rollout status deployment/nginx-app -n nginx-production

# Rollback if needed
kubectl rollout undo deployment/nginx-app -n nginx-production
```

### Configuration Updates

```bash
# Update ConfigMap
kubectl apply -f complete-deployment.yaml

# Restart deployment to pick up changes
kubectl rollout restart deployment/nginx-app -n nginx-production
```

## 🧹 Cleanup

### Remove All Resources

```bash
# Delete the entire namespace (removes all resources)
kubectl delete namespace nginx-production

# Or delete individual resources
kubectl delete -f complete-deployment.yaml
```

### Partial Cleanup

```bash
# Delete specific components
kubectl delete deployment nginx-app -n nginx-production
kubectl delete service nginx-service -n nginx-production
kubectl delete configmap nginx-config -n nginx-production
```

## 📚 Advanced Usage

### Custom Configuration

1. **Modify ConfigMap**: Edit the `nginx.conf` section in the deployment file
2. **Update HTML Content**: Modify the `index.html` section
3. **Apply Changes**: Run `kubectl apply -f complete-deployment.yaml`
4. **Restart Deployment**: `kubectl rollout restart deployment/nginx-app -n nginx-production`

### Integration with Backend Services

The configuration includes upstream configuration for backend services:

```nginx
upstream backend {
    least_conn;
    server backend-service:5000 max_fails=3 fail_timeout=30s;
    keepalive 32;
}
```

### SSL/TLS Configuration

To add SSL/TLS support:

1. Create TLS secrets with certificates
2. Update the server block to include SSL configuration
3. Add SSL redirect rules

### Ingress Integration

Example Ingress configuration:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-ingress
  namespace: nginx-production
spec:
  rules:
  - host: nginx.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nginx-service
            port:
              number: 80
```

## 🤝 Contributing

Contributions are welcome! Please feel free to:

- Report bugs and issues
- Suggest new features
- Submit pull requests
- Improve documentation
- Add new test scenarios

## 📄 License

This deployment is open source and available under the [MIT License](LICENSE).

## 🔗 Resources

- [CleanStart Official Website](https://cleanstart.com/)
- [Nginx Official Documentation](https://nginx.org/en/docs/)
- [Kubernetes Official Documentation](https://kubernetes.io/docs/)
- [Prometheus Monitoring](https://prometheus.io/docs/)
- [Kubernetes HPA Documentation](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)

**Reference:**

CleanStart Community Images: https://hub.docker.com/u/cleanstart 

Get more from CleanStart images from https://github.com/clnstrt/cleanstart-containers/tree/main/containers⁠, 

  -  how-to-Run sample projects using dockerfile 
  -  how-to-Deploy via Kubernete YAML 
  -  how-to-Migrate from public images to CleanStart images

---

# Vulnerability Disclaimer

CleanStart offers Docker images that include third-party open-source libraries and packages maintained by independent contributors. While CleanStart maintains these images and applies industry-standard security practices, it cannot guarantee the security or integrity of upstream components beyond its control.

Users acknowledge and agree that open-source software may contain undiscovered vulnerabilities or introduce new risks through updates. CleanStart shall not be liable for security issues originating from third-party libraries, including but not limited to zero-day exploits, supply chain attacks, or contributor-introduced risks.

Security remains a shared responsibility: CleanStart provides updated images and guidance where possible, while users are responsible for evaluating deployments and implementing appropriate controls.