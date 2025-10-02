# Curl GKE Quick Start Guide

This guide provides step-by-step instructions to deploy and test the curl application on your GKE cluster.

## Prerequisites Checklist

Before starting, ensure you have:
- ✅ Google Cloud CLI (`gcloud`) installed
- ✅ `kubectl` installed
- ✅ Active GKE cluster
- ✅ Proper permissions to create resources

## Method 1: Automated Deployment (Recommended)

### Step 1: Make the script executable
```bash
chmod +x deploy.sh
```

### Step 2: Run the deployment script
```bash
./deploy.sh
```

The script will automatically:
- Create the namespace
- Deploy the application
- Create the service
- Wait for the pod to be ready
- Test curl functionality

---

## Method 2: Manual Deployment (Step-by-Step)

### Step 0: Connect to Your GKE Cluster

First, authenticate and connect to your GKE cluster:

```bash
# Login to Google Cloud (if not already authenticated)
gcloud auth login

# Set your project
gcloud config set project YOUR_PROJECT_ID

# Get cluster credentials (replace with your actual cluster name and zone)
gcloud container clusters get-credentials YOUR_CLUSTER_NAME --zone YOUR_ZONE

# Verify connection
kubectl cluster-info
kubectl get nodes
```

**Example:**
```bash
gcloud container clusters get-credentials my-cluster --zone us-central1-a
```

### Step 1: Navigate to the GCP Directory

```bash
cd containers/curl/gcp
```

### Step 2: Verify Files Exist

```bash
ls -la
```

You should see:
- `namespace.yaml`
- `deployment.yaml`
- `service.yaml`
- `README.md`
- `deploy.sh`

### Step 3: Create the Namespace

```bash
kubectl apply -f namespace.yaml
```

**Expected Output:**
```
namespace/curl-app created
```

**Verify:**
```bash
kubectl get namespaces | grep curl-app
```

### Step 4: Deploy the Curl Application

```bash
kubectl apply -f deployment.yaml -n curl-app
```

**Expected Output:**
```
deployment.apps/curl-app created
```

**Verify:**
```bash
kubectl get deployment -n curl-app
```

### Step 5: Create the Service

```bash
kubectl apply -f service.yaml -n curl-app
```

**Expected Output:**
```
service/curl-app-service created
```

**Verify:**
```bash
kubectl get service -n curl-app
```

### Step 6: Wait for Pod to be Ready

```bash
kubectl get pods -n curl-app -w
```

Press `Ctrl+C` once you see the pod status as `Running` and `READY` shows `1/1`.

**Expected Output:**
```
NAME                        READY   STATUS    RESTARTS   AGE
curl-app-xxxxxxxxxx-xxxxx   1/1     Running   0          30s
```

**Alternative - Wait automatically:**
```bash
kubectl wait --for=condition=ready pod -l app=curl-app -n curl-app --timeout=120s
```

### Step 7: Get All Resources

```bash
kubectl get all -n curl-app
```

**Expected Output:**
```
NAME                            READY   STATUS    RESTARTS   AGE
pod/curl-app-xxxxxxxxxx-xxxxx   1/1     Running   0          1m

NAME                       TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
service/curl-app-service   ClusterIP   10.XX.XX.XX    <none>        8080/TCP   1m

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/curl-app   1/1     1            1           1m

NAME                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/curl-app-xxxxxxxxxx   1         1         1       1m
```

---

## Testing the Deployment

### Get the Pod Name

```bash
POD_NAME=$(kubectl get pods -n curl-app -l app=curl-app -o jsonpath='{.items[0].metadata.name}')
echo "Pod Name: $POD_NAME"
```

### Test 1: Simple GET Request

```bash
kubectl exec -it $POD_NAME -n curl-app -- curl -s https://httpbin.org/get
```

**Expected Output:** JSON response with your request details

### Test 2: Check Curl Version

```bash
kubectl exec -it $POD_NAME -n curl-app -- curl --version
```

### Test 3: POST Request with JSON Data

```bash
kubectl exec -it $POD_NAME -n curl-app -- curl -s -X POST https://httpbin.org/post \
  -H "Content-Type: application/json" \
  -d '{"environment": "gke", "test": "successful"}'
```

### Test 4: Check Headers

```bash
kubectl exec -it $POD_NAME -n curl-app -- curl -s https://httpbin.org/headers
```

### Test 5: Get IP Address

```bash
kubectl exec -it $POD_NAME -n curl-app -- curl -s https://httpbin.org/ip
```

### Test 6: SSL Certificate Check

```bash
kubectl exec -it $POD_NAME -n curl-app -- curl -I https://google.com
```

### Test 7: Interactive Shell

```bash
kubectl exec -it $POD_NAME -n curl-app -- /bin/sh
```

Once inside the pod:
```bash
# Check curl version
curl --version

# Make requests
curl -s https://httpbin.org/get
curl -s https://api.github.com

# Exit the pod
exit
```

---

## Verification Checklist

After deployment, verify these items:

- [ ] Namespace `curl-app` exists
- [ ] Deployment `curl-app` is created with 1/1 replicas ready
- [ ] Pod is in `Running` state (not CrashLoopBackOff)
- [ ] Service `curl-app-service` is created
- [ ] Can execute curl commands in the pod
- [ ] Can make external HTTPS requests

---

## Common Use Cases

### 1. Test Internal Kubernetes Service

```bash
kubectl exec -it $POD_NAME -n curl-app -- curl -s http://kubernetes.default.svc.cluster.local
```

### 2. Test Another Service in Your Cluster

```bash
# Replace with your actual service name and namespace
kubectl exec -it $POD_NAME -n curl-app -- curl -s http://my-service.my-namespace.svc.cluster.local
```

### 3. Check Service Health

```bash
kubectl exec -it $POD_NAME -n curl-app -- curl -s -o /dev/null -w "%{http_code}\n" https://httpbin.org/status/200
```

### 4. Download a File

```bash
kubectl exec -it $POD_NAME -n curl-app -- curl -O https://httpbin.org/json
```

### 5. Multiple Requests (Simple Load Test)

```bash
kubectl exec -it $POD_NAME -n curl-app -- sh -c 'for i in 1 2 3 4 5; do echo "Request $i:"; curl -s https://httpbin.org/get | head -5; echo ""; done'
```

---

## Troubleshooting

### Issue 1: Pod in CrashLoopBackOff

**Check pod status:**
```bash
kubectl describe pod -l app=curl-app -n curl-app
kubectl logs -l app=curl-app -n curl-app
```

**Solution:** The deployment uses `sleep infinity` which should prevent this. If it still happens:
- Verify image is accessible: `docker pull cleanstart/curl:latest`
- Check for image pull errors in pod description

### Issue 2: Cannot Pull Image

**Error:** `ImagePullBackOff` or `ErrImagePull`

**Solution:**
```bash
# Verify internet connectivity from cluster
kubectl run test-connection --image=busybox --rm -it --restart=Never -- ping -c 3 8.8.8.8

# Check if image exists
docker pull cleanstart/curl:latest
```

### Issue 3: Pod Name Not Found

**Error:** No resources found

**Solution:**
```bash
# List all pods in namespace
kubectl get pods -n curl-app

# Check if deployment exists
kubectl get deployment -n curl-app

# Check events
kubectl get events -n curl-app --sort-by='.lastTimestamp'
```

### Issue 4: Command Execution Fails

**Error:** `OCI runtime exec failed`

**Solution:**
```bash
# Verify pod is running
kubectl get pods -n curl-app

# Check pod logs
kubectl logs -l app=curl-app -n curl-app

# Describe pod for details
kubectl describe pod -l app=curl-app -n curl-app
```

---

## Monitoring and Logs

### View Real-time Logs

```bash
kubectl logs -f $POD_NAME -n curl-app
```

### View Pod Events

```bash
kubectl describe pod $POD_NAME -n curl-app
```

### Check Resource Usage

```bash
kubectl top pod $POD_NAME -n curl-app
```

### Get All Events in Namespace

```bash
kubectl get events -n curl-app --sort-by='.lastTimestamp'
```

---

## Scaling

### Scale Up

```bash
kubectl scale deployment curl-app --replicas=3 -n curl-app
```

### Scale Down

```bash
kubectl scale deployment curl-app --replicas=1 -n curl-app
```

### Verify Scaling

```bash
kubectl get pods -n curl-app
```

---

## Cleanup

### Option 1: Delete Individual Resources

```bash
kubectl delete service curl-app-service -n curl-app
kubectl delete deployment curl-app -n curl-app
kubectl delete namespace curl-app
```

### Option 2: Delete Everything at Once (Recommended)

```bash
kubectl delete namespace curl-app
```

### Verify Cleanup

```bash
kubectl get all -n curl-app
```

**Expected Output:** `No resources found in curl-app namespace.` or `Error from server (NotFound): namespaces "curl-app" not found`

---

## Quick Reference Commands

```bash
# Get pod name
POD_NAME=$(kubectl get pods -n curl-app -l app=curl-app -o jsonpath='{.items[0].metadata.name}')

# Execute curl command
kubectl exec -it $POD_NAME -n curl-app -- curl -s https://httpbin.org/get

# Get interactive shell
kubectl exec -it $POD_NAME -n curl-app -- /bin/sh

# View logs
kubectl logs -f $POD_NAME -n curl-app

# Check status
kubectl get all -n curl-app

# Delete everything
kubectl delete namespace curl-app
```

---

## Summary

You now have a working curl container running in your GKE cluster! This container can be used for:
- ✅ Testing internal and external API endpoints
- ✅ Debugging network connectivity
- ✅ Verifying SSL certificates
- ✅ Service health checks
- ✅ Simple load testing
- ✅ Data downloads and uploads

For more advanced usage examples, see the main [README.md](README.md).

---

## Next Steps

1. Try testing your internal services
2. Set up automated health checks using CronJobs
3. Integrate with monitoring tools
4. Create custom scripts for your specific use cases

For questions or issues, refer to the troubleshooting section or the main README.md file.

