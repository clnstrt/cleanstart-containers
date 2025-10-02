# Kyverno-Kyvernopre Simple Kubernetes Deployment

Simple deployment for testing the Kyverno-Kyvernopre container on GKE.

## 🚀 Quick Deploy

```bash
# Deploy everything
kubectl apply -f namespace.yaml
kubectl apply -f serviceaccount.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

## ✅ Check Status

```bash
# Check if running
kubectl get pods -n kyverno

# Check logs
kubectl logs -n kyverno deployment/kyverno
```

## 🧹 Cleanup

```bash
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
kubectl delete -f serviceaccount.yaml
kubectl delete -f namespace.yaml
```

## 📁 Files

- `namespace.yaml` - Creates kyverno namespace
- `serviceaccount.yaml` - Service account
- `deployment.yaml` - Main deployment with working environment variables
- `service.yaml` - Service to expose the container