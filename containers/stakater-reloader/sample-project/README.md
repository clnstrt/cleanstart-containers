# 🚀 Stakater Reloader Sample Projects

This directory contains sample projects demonstrating Stakater Reloader capabilities for automatic Kubernetes resource reloading when ConfigMaps or Secrets change.

## 📁 Sample Projects

### 1. Basic Reloading (`basic-reloading/`)
- **ConfigMap Reloading**: Automatic pod restarts on ConfigMap changes
- **Secret Reloading**: Automatic pod restarts on Secret changes
- **Annotation-based**: Using annotations for reloading control

### 2. Advanced Features (`advanced-features/`)
- **Selective Reloading**: Reloading specific containers only
- **Namespace Filtering**: Reloading resources in specific namespaces
- **Resource Filtering**: Reloading specific resource types

### 3. Web Applications (`web-applications/`)
- **Python Flask App**: Web application with automatic config reloading
- **Node.js Express App**: REST API with automatic secret reloading
- **PHP Application**: PHP application with ConfigMap reloading

### 4. Production Setup (`production-setup/`)
- **High Availability**: Reloader deployment with HA
- **Monitoring**: Reloader metrics and monitoring
- **Security**: RBAC and security configurations

## 🚀 Quick Start

### Prerequisites
- Kubernetes cluster (1.19+)
- kubectl configured
- Helm (optional, for installation)

### Installing Reloader

1. **Install via Helm** (Recommended):
```bash
helm repo add stakater https://stakater.github.io/stakater-charts
helm repo update
helm install reloader stakater/reloader
```

2. **Install via kubectl**:
```bash
kubectl apply -f https://raw.githubusercontent.com/stakater/Reloader/master/deployments/kubernetes/reloader.yaml
```

3. **Verify Installation**:
```bash
kubectl get pods -n reloader
kubectl get deployments -n reloader
```

### Basic Usage

1. **Create a ConfigMap**:
```bash
kubectl apply -f basic-reloading/configmap-example.yaml
```

2. **Create a Deployment with Reloader Annotation**:
```bash
kubectl apply -f basic-reloading/deployment-example.yaml
```

3. **Update the ConfigMap**:
```bash
kubectl patch configmap my-config --patch '{"data":{"key":"new-value"}}'
```

4. **Watch Pod Restart**:
```bash
kubectl get pods -w
```

## 📚 Reloader Examples

### Basic ConfigMap Reloading
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-config
  namespace: default
data:
  config.yaml: |
    database:
      host: localhost
      port: 5432
    logging:
      level: info
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  namespace: default
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
      annotations:
        reloader.stakater.com/auto: "true"
    spec:
      containers:
      - name: my-app
        image: nginx:latest
        volumeMounts:
        - name: config-volume
          mountPath: /etc/config
      volumes:
      - name: config-volume
        configMap:
          name: my-config
```

### Secret Reloading
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
  namespace: default
type: Opaque
data:
  password: cGFzc3dvcmQxMjM=  # password123
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  namespace: default
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
      annotations:
        reloader.stakater.com/search: "my-secret"
    spec:
      containers:
      - name: my-app
        image: nginx:latest
        env:
        - name: PASSWORD
          valueFrom:
            secretKeyRef:
              name: my-secret
              key: password
```

### Selective Container Reloading
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: multi-container-app
  namespace: default
spec:
  replicas: 3
  selector:
    matchLabels:
      app: multi-container-app
  template:
    metadata:
      labels:
        app: multi-container-app
      annotations:
        reloader.stakater.com/search: "my-config"
        configmap.reloader.stakater.com/reload: "my-config"
    spec:
      containers:
      - name: app-container
        image: nginx:latest
        volumeMounts:
        - name: config-volume
          mountPath: /etc/config
      - name: sidecar-container
        image: busybox:latest
        command: ["sleep", "3600"]
      volumes:
      - name: config-volume
        configMap:
          name: my-config
```

## 🧪 Testing Reloader

### Test ConfigMap Reloading
```bash
# Create test deployment
kubectl apply -f basic-reloading/deployment-example.yaml

# Get initial pod names
kubectl get pods -l app=my-app

# Update ConfigMap
kubectl patch configmap my-config --patch '{"data":{"key":"updated-value"}}'

# Watch for pod restarts
kubectl get pods -l app=my-app -w
```

### Test Secret Reloading
```bash
# Create test secret
kubectl apply -f basic-reloading/secret-example.yaml

# Update secret
kubectl patch secret my-secret --patch '{"data":{"password":"'$(echo -n "newpassword" | base64)'"}}'

# Watch for pod restarts
kubectl get pods -l app=my-app -w
```

### Verify Reloader Logs
```bash
# Check Reloader logs
kubectl logs -n reloader deployment/reloader

# Check specific pod logs
kubectl logs -n reloader -l app=reloader
```

## 🔧 Configuration

### Reloader Configuration
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: reloader-config
  namespace: reloader
data:
  config.yaml: |
    logLevel: info
    watchGlobally: true
    ignoreSecrets: false
    ignoreConfigMaps: false
    resourcesToIgnore:
      - namespace: kube-system
      - namespace: kube-public
```

### Environment Variables
```bash
export RELOADER_LOG_LEVEL=info
export RELOADER_WATCH_NAMESPACE=""
export RELOADER_IGNORE_SECRETS=false
export RELOADER_IGNORE_CONFIGMAPS=false
```

## 📊 Monitoring

### Reloader Metrics
```bash
# Check Reloader metrics endpoint
kubectl port-forward -n reloader svc/reloader 8080:8080
curl http://localhost:8080/metrics
```

### Reload Events
```bash
# Check for reload events
kubectl get events --field-selector reason=Reloader

# Check specific namespace events
kubectl get events -n default --field-selector reason=Reloader
```

### Pod Restart Monitoring
```bash
# Monitor pod restarts
kubectl get pods -o wide --watch

# Check restart counts
kubectl get pods -o custom-columns=NAME:.metadata.name,RESTARTS:.status.containerStatuses[0].restartCount
```

## 🛠️ Troubleshooting

### Common Issues
1. **Pods Not Restarting**: Check annotations and ConfigMap/Secret references
2. **Reloader Not Running**: Verify Reloader deployment and RBAC permissions
3. **Permission Errors**: Check RBAC configuration and service account

### Debug Commands
```bash
# Check Reloader status
kubectl get pods -n reloader
kubectl describe pod -n reloader -l app=reloader

# Check RBAC permissions
kubectl get clusterrole reloader-role
kubectl get clusterrolebinding reloader-role-binding

# Check Reloader logs
kubectl logs -n reloader -l app=reloader --tail=100
```

### Validation
```bash
# Validate annotations
kubectl get deployments -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.metadata.annotations}{"\n"}{end}'

# Check ConfigMap/Secret references
kubectl describe deployment my-app
```

## 📚 Resources

- [Stakater Reloader Documentation](https://github.com/stakater/Reloader)
- [Kubernetes ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)
- [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
- [CleanStart Website](https://www.cleanstart.com/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Adding new Reloader examples
- Improving documentation
- Reporting issues
- Suggesting new features

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
