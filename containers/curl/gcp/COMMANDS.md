# Curl GKE Deployment - Copy & Paste Commands

## 🚨 Fix CrashLoopBackOff (Run this first if pod is crashing)

```bash
# Delete and recreate with fixed deployment
kubectl delete deployment curl-app -n curl-app
kubectl apply -f deployment.yaml -n curl-app
kubectl get pods -n curl-app -w
# Press Ctrl+C when status is Running
```

---

## Complete Deployment (Copy all commands below)

```bash
# Step 1: Navigate to directory
cd containers/curl/gcp

# Step 2: Create namespace
kubectl apply -f namespace.yaml

# Step 3: Deploy application
kubectl apply -f deployment.yaml -n curl-app

# Step 4: Create service
kubectl apply -f service.yaml -n curl-app

# Step 5: Wait for pod to be ready
kubectl wait --for=condition=ready pod -l app=curl-app -n curl-app --timeout=120s

# Step 6: Verify deployment
kubectl get all -n curl-app

# Step 7: Get pod name
POD_NAME=$(kubectl get pods -n curl-app -l app=curl-app -o jsonpath='{.items[0].metadata.name}')
echo "Pod Name: $POD_NAME"

# Step 8: Test curl
kubectl exec -it $POD_NAME -n curl-app -- curl -s https://httpbin.org/get
```

---

## Testing Commands

```bash
# Set pod name variable (run this first)
POD_NAME=$(kubectl get pods -n curl-app -l app=curl-app -o jsonpath='{.items[0].metadata.name}')

# Test 1: Simple GET request
kubectl exec -it $POD_NAME -n curl-app -- curl -s https://httpbin.org/get

# Test 2: POST request with JSON
kubectl exec -it $POD_NAME -n curl-app -- curl -s -X POST https://httpbin.org/post -H "Content-Type: application/json" -d '{"test":"data"}'

# Test 3: Check headers
kubectl exec -it $POD_NAME -n curl-app -- curl -s https://httpbin.org/headers

# Test 4: Get your IP
kubectl exec -it $POD_NAME -n curl-app -- curl -s https://httpbin.org/ip

# Test 5: Interactive shell
kubectl exec -it $POD_NAME -n curl-app -- /bin/sh
```

---

## Monitoring Commands

```bash
# View all resources
kubectl get all -n curl-app

# View pod details
kubectl describe pod -l app=curl-app -n curl-app

# View logs
kubectl logs -l app=curl-app -n curl-app -f

# Check resource usage
kubectl top pod -n curl-app

# View events
kubectl get events -n curl-app --sort-by='.lastTimestamp'
```

---

## Cleanup

```bash
# Delete everything
kubectl delete namespace curl-app

# Verify deletion
kubectl get namespaces | grep curl-app
```

---

## Troubleshooting

```bash
# If pod is in CrashLoopBackOff
kubectl describe pod -l app=curl-app -n curl-app
kubectl logs -l app=curl-app -n curl-app

# Check if deployment exists
kubectl get deployment -n curl-app

# Restart deployment
kubectl rollout restart deployment curl-app -n curl-app

# Force delete and recreate
kubectl delete deployment curl-app -n curl-app
kubectl apply -f deployment.yaml -n curl-app
```

---

## Quick Reference

| Command | Description |
|---------|-------------|
| `kubectl get pods -n curl-app` | List pods |
| `kubectl get all -n curl-app` | List all resources |
| `kubectl logs -f <pod-name> -n curl-app` | View logs |
| `kubectl exec -it <pod-name> -n curl-app -- /bin/sh` | Get shell |
| `kubectl delete namespace curl-app` | Delete everything |

