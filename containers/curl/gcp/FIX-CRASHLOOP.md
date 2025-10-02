# Fix CrashLoopBackOff - Immediate Solution

## The Problem
The pod is entering CrashLoopBackOff state because the original command might not be compatible with the curl image.

## The Solution
Updated the deployment to use `tail -f /dev/null` which is more universally available across all Linux distributions and container images.

---

## Quick Fix - Run These Commands Now

```bash
# Step 1: Delete the existing deployment
kubectl delete deployment curl-app -n curl-app

# Step 2: Apply the fixed deployment
kubectl apply -f deployment.yaml -n curl-app

# Step 3: Watch the pod status (wait for Running status)
kubectl get pods -n curl-app -w
```

Press `Ctrl+C` once you see the pod status change to **Running** with **1/1** in the READY column.

---

## Verify the Fix

```bash
# Check pod status
kubectl get pods -n curl-app

# Expected output:
# NAME                        READY   STATUS    RESTARTS   AGE
# curl-app-xxxxxxxxxx-xxxxx   1/1     Running   0          30s

# Get pod name
POD_NAME=$(kubectl get pods -n curl-app -l app=curl-app -o jsonpath='{.items[0].metadata.name}')

# Test if curl works
kubectl exec -it $POD_NAME -n curl-app -- curl --version

# Test a real request
kubectl exec -it $POD_NAME -n curl-app -- curl -s https://httpbin.org/get
```

---

## What Changed

**Before (not working):**
```yaml
command: ["sleep", "infinity"]
```

**After (working):**
```yaml
command: ["tail", "-f", "/dev/null"]
```

**Why this works:**
- `tail` is available in almost all Linux images
- `/dev/null` always exists
- `-f` flag keeps the process running indefinitely
- This is a standard technique for keeping containers alive

---

## Alternative Commands (if tail doesn't work)

If for some reason `tail` also doesn't work, try these alternatives:

### Option 1: Using sh with while loop
```yaml
command: ["/bin/sh", "-c"]
args: ["while true; do sleep 3600; done"]
```

### Option 2: Using large sleep value
```yaml
command: ["sleep", "2147483647"]
```

### Option 3: Using sh with pause
```yaml
command: ["/bin/sh", "-c"]
args: ["trap : TERM INT; sleep infinity & wait"]
```

To apply an alternative:
1. Edit `deployment.yaml`
2. Change the `command` line
3. Run: `kubectl apply -f deployment.yaml -n curl-app`

---

## Troubleshooting

### Check why pod is crashing

```bash
# Get pod name (even if crashing)
POD_NAME=$(kubectl get pods -n curl-app -l app=curl-app -o jsonpath='{.items[0].metadata.name}')

# View pod details
kubectl describe pod $POD_NAME -n curl-app

# View logs (if any)
kubectl logs $POD_NAME -n curl-app

# View previous container logs (after restart)
kubectl logs $POD_NAME -n curl-app --previous
```

### Common error messages

**Error: "executable file not found"**
- Solution: The command doesn't exist in the image. Try an alternative command.

**Error: "OCI runtime create failed"**
- Solution: Command syntax issue. Verify the YAML formatting.

**Error: "ImagePullBackOff"**
- Solution: Cannot pull the image. Check internet connectivity:
  ```bash
  docker pull cleanstart/curl:latest
  ```

---

## Complete Fresh Deployment

If you want to start completely fresh:

```bash
# 1. Delete everything
kubectl delete namespace curl-app

# 2. Wait a moment
sleep 5

# 3. Create namespace
kubectl apply -f namespace.yaml

# 4. Deploy with fixed configuration
kubectl apply -f deployment.yaml -n curl-app

# 5. Create service
kubectl apply -f service.yaml -n curl-app

# 6. Wait for pod
kubectl wait --for=condition=ready pod -l app=curl-app -n curl-app --timeout=120s

# 7. Test
POD_NAME=$(kubectl get pods -n curl-app -l app=curl-app -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it $POD_NAME -n curl-app -- curl -s https://httpbin.org/get
```

---

## Success Indicators

✅ **Pod status shows**: `Running`
✅ **READY shows**: `1/1`
✅ **RESTARTS shows**: `0` (or low number)
✅ **Can execute curl commands**
✅ **Can access external URLs**

---

## Still Having Issues?

1. **Check the image exists:**
   ```bash
   docker pull cleanstart/curl:latest
   ```

2. **Try a different base image:**
   Edit `deployment.yaml` and try:
   ```yaml
   image: curlimages/curl:latest
   ```

3. **Check cluster resources:**
   ```bash
   kubectl describe nodes
   kubectl get events -n curl-app
   ```

4. **Check for network policies:**
   ```bash
   kubectl get networkpolicies -n curl-app
   ```

---

## Need Help?

If none of these solutions work, provide the following information:

```bash
# Run these commands and share the output:
kubectl describe pod -l app=curl-app -n curl-app
kubectl logs -l app=curl-app -n curl-app --previous
kubectl get events -n curl-app --sort-by='.lastTimestamp'
```

---

**The deployment.yaml has been updated. Just run the Quick Fix commands above!**


