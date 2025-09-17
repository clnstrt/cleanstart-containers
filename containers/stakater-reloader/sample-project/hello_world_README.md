# 🚀 Stakater Reloader Hello World

Welcome to the Stakater Reloader Hello World example! This simple example demonstrates how to get started with Stakater Reloader for automatic Kubernetes resource reloading.

## 📋 What is Stakater Reloader?

Stakater Reloader is a Kubernetes controller that automatically restarts pods when ConfigMaps or Secrets change. It provides:

- **Automatic Reloading**: Restart pods when configs change
- **ConfigMap Support**: Monitor ConfigMap changes
- **Secret Support**: Monitor Secret changes
- **Annotation-based**: Simple annotation-based configuration
- **Zero Downtime**: Rolling updates for seamless reloads

## 🚀 Quick Start

### Prerequisites

- Kubernetes cluster (v1.14+)
- kubectl configured
- Stakater Reloader installed

### Running the Hello World

1. **Apply the hello world resources:**
   ```bash
   kubectl apply -f hello_world.yaml
   ```

2. **Check deployment status:**
   ```bash
   kubectl get pods -l app=hello-world-app
   ```

3. **Test automatic reloading:**
   ```bash
   # Update the ConfigMap
   kubectl patch configmap hello-world-config --patch '{
     "data": {
       "app.properties": "app.name=Updated Hello World App\napp.version=2.0.0\napp.message=Hello from Updated Stakater Reloader!"
     }
   }'
   
   # Watch pods restart automatically
   kubectl get pods -l app=hello-world-app -w
   ```

## 📊 What the Hello World Does

The `hello_world.yaml` file demonstrates:

1. **ConfigMap Creation**: Creates a ConfigMap with application configuration
2. **Deployment Setup**: Creates a deployment with Reloader annotations
3. **Service Creation**: Exposes the application via service
4. **Test Script**: Includes a script to test automatic reloading
5. **Annotation Usage**: Shows how to configure Reloader annotations

## 🔧 Configuration

### ConfigMap with Reloader Annotation
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: hello-world-config
  annotations:
    # This annotation tells Reloader to restart pods when this ConfigMap changes
    reloader.stakater.com/auto: "true"
data:
  app.properties: |
    app.name=Hello World App
    app.version=1.0.0
    app.message=Hello from Stakater Reloader!
```

### Deployment with Reloader Annotation
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world-app
spec:
  template:
    metadata:
      annotations:
        # This annotation tells Reloader to restart pods when ConfigMap changes
        configmap.reloader.stakater.com/reload: "hello-world-config"
    spec:
      containers:
      - name: hello-world
        image: nginx:latest
        volumeMounts:
        - name: config-volume
          mountPath: /etc/config
      volumes:
      - name: config-volume
        configMap:
          name: hello-world-config
```

## 🎯 Reloader Annotations

### ConfigMap Annotations
- `reloader.stakater.com/auto: "true"` - Enable automatic reloading

### Pod Annotations
- `configmap.reloader.stakater.com/reload: "configmap-name"` - Reload on ConfigMap changes
- `secret.reloader.stakater.com/reload: "secret-name"` - Reload on Secret changes

## 🔍 Testing Automatic Reloading

### Method 1: Update ConfigMap
```bash
kubectl patch configmap hello-world-config --patch '{
  "data": {
    "app.properties": "app.name=Updated App\napp.version=2.0.0"
  }
}'
```

### Method 2: Use Test Script
```bash
# Make script executable
chmod +x test-reload.sh

# Run test script
./test-reload.sh
```

### Method 3: Watch Pod Changes
```bash
# Watch pods in real-time
kubectl get pods -l app=hello-world-app -w
```

## 🛠️ Key Features Demonstrated

- **ConfigMap Monitoring**: Automatic detection of ConfigMap changes
- **Pod Restart**: Automatic pod restart on configuration changes
- **Rolling Updates**: Seamless rolling updates
- **Annotation Configuration**: Simple annotation-based setup
- **Volume Mounting**: ConfigMap mounted as volume

## 📚 Next Steps

1. **Explore Basic Examples**: Check out `basic-examples/` for more examples
2. **Web Integration**: See `web-integration/` for advanced use cases
3. **Production Setup**: Learn about production configurations
4. **Monitoring**: Set up monitoring for Reloader

## 🔧 Configuration Options

### Reloader Installation
```bash
# Install via Helm
helm repo add stakater https://stakater.github.io/stakater-charts
helm repo update
helm install stakater/reloader

# Or via kubectl
kubectl apply -f https://raw.githubusercontent.com/stakater/Reloader/master/deployments/kubernetes/reloader.yaml
```

### Advanced Annotations
```yaml
# Multiple ConfigMaps
configmap.reloader.stakater.com/reload: "config1,config2"

# Multiple Secrets
secret.reloader.stakater.com/reload: "secret1,secret2"

# Custom reload strategy
reloader.stakater.com/reload: "configmap-name"
```

## 🆘 Troubleshooting

### Common Issues

1. **Pods Not Restarting**: Check Reloader installation
2. **Annotation Not Working**: Verify annotation syntax
3. **Permission Denied**: Check RBAC permissions

### Debug Commands

```bash
# Check Reloader installation
kubectl get pods -n reloader

# View Reloader logs
kubectl logs -n reloader -l app=reloader

# Check ConfigMap changes
kubectl get configmap hello-world-config -o yaml

# Monitor pod events
kubectl get events --field-selector involvedObject.name=hello-world-app
```

## 📖 Learn More

- [Stakater Reloader Documentation](https://github.com/stakater/Reloader)
- [Reloader Examples](https://github.com/stakater/Reloader/tree/master/examples)
- [Kubernetes ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)

## 🎯 Use Cases

Stakater Reloader is perfect for:

- **Configuration Management**: Automatic config updates
- **Secret Rotation**: Automatic secret updates
- **Zero Downtime**: Seamless application updates
- **DevOps Automation**: Reduce manual intervention
- **CI/CD Integration**: Automatic deployments
- **Microservices**: Service configuration updates

---

**Happy Automatic Reloading with Stakater Reloader!** 🔄
