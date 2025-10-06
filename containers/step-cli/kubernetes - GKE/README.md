# 🔐 Step CLI - Kubernetes Deployment

Simple Kubernetes deployment for the CleanStart Step CLI container, demonstrating PKI and certificate management capabilities.

## 📁 Files

- `namespace.yaml` - Creates the step-cli-sample namespace
- `deployment.yaml` - Deploys a persistent Step CLI pod
- `job.yaml` - Runs a one-time Step CLI demo job
- `configmap.yaml` - Provides configuration files and scripts
- `README.md` - This documentation

## 🚀 Quick Deploy

### Option 1: Run Demo Job (Recommended for Testing)
```bash
# Apply namespace first
kubectl apply -f namespace.yaml

# Run the demo job
kubectl apply -f job.yaml

# Check job status
kubectl get jobs -n step-cli-sample

# View job logs
kubectl logs -n step-cli-sample -l app=step-cli-demo
```

### Option 2: Deploy Persistent Pod
```bash
# Apply all resources
kubectl apply -f namespace.yaml
kubectl apply -f configmap.yaml
kubectl apply -f deployment.yaml

# Check deployment status
kubectl get pods -n step-cli-sample
kubectl get deployments -n step-cli-sample
```

## 🧪 Testing

### Test the Demo Job
```bash
# Run the demo job and check results
kubectl apply -f job.yaml
kubectl logs -n step-cli-sample -l app=step-cli-demo

# Expected output:
# - Step CLI version information
# - Help commands for CA, certificate, and crypto operations
# - OIDC test (may show as unavailable - this is expected)
```

### Test Persistent Deployment
```bash
# Get pod name
POD_NAME=$(kubectl get pods -n step-cli-sample -l app=step-cli -o jsonpath='{.items[0].metadata.name}')

# Execute Step CLI commands
kubectl exec -n step-cli-sample $POD_NAME -- ./step version
kubectl exec -n step-cli-sample $POD_NAME -- ./step --help
kubectl exec -n step-cli-sample $POD_NAME -- ./step ca --help
kubectl exec -n step-cli-sample $POD_NAME -- ./step certificate --help
kubectl exec -n step-cli-sample $POD_NAME -- ./step crypto --help
```

### Interactive Session
```bash
# Start interactive session
kubectl exec -it -n step-cli-sample $POD_NAME -- sh

# Inside the container, run Step CLI commands:
# ./step version
# ./step --help
# ./step ca --help
```

## 📋 Expected Results

When working correctly, you should see:

```
Smallstep CLI/0.24.4 (linux/amd64)
Release Date: 2024-XX-XX XX:XX UTC

NAME
  step -- plumbing for distributed systems

USAGE
  step command [arguments]

COMMANDS
  certificate  manage certificates and other credentials
  ca           run a certificate authority (CA)
  crypto       cryptographic utilities
  ssh          SSH certificate management
```

**Note**: OIDC commands may not be available in this build, which is expected behavior.

## 🔧 Configuration

The ConfigMap provides:
- Sample Step CLI configuration
- Certificate request templates
- Helper scripts for common operations

Access configuration files:
```bash
# View ConfigMap
kubectl get configmap -n step-cli-sample step-cli-config -o yaml

# Mount ConfigMap in pod (add to deployment.yaml)
volumeMounts:
- name: config-volume
  mountPath: /etc/step/config
volumes:
- name: config-volume
  configMap:
    name: step-cli-config
```

## 🧹 Cleanup

```bash
# Delete all resources
kubectl delete -f .

# Or delete individually
kubectl delete job step-cli-demo -n step-cli-sample
kubectl delete deployment step-cli-deployment -n step-cli-sample
kubectl delete configmap step-cli-config -n step-cli-sample
kubectl delete namespace step-cli-sample
```

## 📚 Use Cases

This Kubernetes deployment is perfect for:

- **Certificate Management**: Issue and manage TLS certificates
- **PKI Operations**: Set up and manage certificate authorities
- **Crypto Utilities**: Generate keys, sign certificates
- **CI/CD Integration**: Automated certificate provisioning
- **Development Testing**: Test Step CLI functionality in Kubernetes

## 🔍 Troubleshooting

### Common Issues

**Pod not starting**
```bash
kubectl describe pod -n step-cli-sample -l app=step-cli
kubectl logs -n step-cli-sample -l app=step-cli
```

**Job failing**
```bash
kubectl describe job -n step-cli-sample step-cli-demo
kubectl logs -n step-cli-sample -l app=step-cli-demo
```

**Image pull issues**
```bash
# Ensure image exists
docker pull cleanstart/step-cli:latest-dev

# Check image availability
kubectl get events -n step-cli-sample
```

