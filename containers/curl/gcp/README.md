# Curl GCP Deployment

This project deploys **curl** on Google Kubernetes Engine (GKE) using the CleanStart curl image. The curl container serves as a utility pod for making HTTP/HTTPS requests, API testing, and web scraping within your Kubernetes cluster.

## Overview

curl is a command-line tool for transferring data with URLs. This deployment provides:
- HTTP/HTTPS request capabilities (GET, POST, PUT, DELETE)
- File download and upload operations
- SSL/TLS certificate testing and verification
- API testing and automation within the cluster
- Web scraping and data extraction
- JSON processing with jq integration

## Prerequisites

- Google Cloud CLI installed and configured
- kubectl configured to connect to your GKE cluster
- GKE cluster with appropriate permissions
- Basic knowledge of Kubernetes and curl commands

## Deployment Instructions

### Step 0: Connect to Your GKE Cluster

```bash
gcloud container clusters get-credentials <cluster-name> --zone <zone-name>
```

Replace `<cluster-name>` and `<zone-name>` with your actual cluster name and zone.

### Step 1: Navigate to the GCP Directory

```bash
cd containers/curl/gcp
```

### Step 2: Create the Namespace

```bash
kubectl apply -f namespace.yaml
```

### Step 3: Deploy Curl Application

```bash
kubectl apply -f deployment.yaml -n curl-app
```

### Step 4: Create the Service (Optional)

```bash
kubectl apply -f service.yaml -n curl-app
```

Note: The service is optional since curl is primarily used as a utility container.

### Step 5: Verify Deployment

```bash
kubectl get all -n curl-app
```

Expected output:
```
NAME                            READY   STATUS    RESTARTS   AGE
pod/curl-app-xxxxxxxxxx-xxxxx   1/1     Running   0          10s

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/curl-app   1/1     1            1           10s
```

## Using the Curl Container

### Method 1: Execute Commands Directly

Execute curl commands directly in the running pod:

```bash
# Get the pod name
POD_NAME=$(kubectl get pods -n curl-app -l app=curl-app -o jsonpath='{.items[0].metadata.name}')

# Make a simple GET request
kubectl exec -it $POD_NAME -n curl-app -- curl -s https://httpbin.org/get

# Make a POST request with JSON data
kubectl exec -it $POD_NAME -n curl-app -- curl -s -X POST https://httpbin.org/post \
  -H "Content-Type: application/json" \
  -d '{"test": "data", "from": "gke"}'

# Check SSL certificate
kubectl exec -it $POD_NAME -n curl-app -- curl -s -I https://google.com

# Test internal Kubernetes services
kubectl exec -it $POD_NAME -n curl-app -- curl -s http://kubernetes.default.svc.cluster.local
```

### Method 2: Interactive Shell

Enter the pod for interactive curl usage:

```bash
kubectl exec -it $POD_NAME -n curl-app -- /bin/sh
```

Once inside the pod, you can run curl commands:

```bash
# Check curl version
curl --version

# Make requests
curl -s https://httpbin.org/get
curl -s https://httpbin.org/headers
curl -s https://httpbin.org/ip

# Download files
curl -O https://httpbin.org/json

# Test API endpoints
curl -s https://api.github.com/repos/kubernetes/kubernetes | head -20

# Exit the pod
exit
```

## Use Cases

### 1. API Testing

Test REST APIs within your cluster:

```bash
kubectl exec -it $POD_NAME -n curl-app -- curl -s -X GET \
  http://my-api-service.default.svc.cluster.local/api/health
```

### 2. Service Health Checks

Verify internal service connectivity:

```bash
kubectl exec -it $POD_NAME -n curl-app -- curl -s -o /dev/null -w "%{http_code}" \
  http://my-service.my-namespace.svc.cluster.local
```

### 3. External API Integration

Test external API connectivity from within the cluster:

```bash
kubectl exec -it $POD_NAME -n curl-app -- curl -s https://api.example.com/v1/data
```

### 4. SSL/TLS Verification

Check SSL certificates of your services:

```bash
kubectl exec -it $POD_NAME -n curl-app -- curl -vI https://my-secure-service.example.com
```

### 5. Load Testing (Simple)

Run simple load tests:

```bash
kubectl exec -it $POD_NAME -n curl-app -- sh -c '
  for i in $(seq 1 10); do
    echo "Request $i:"
    time curl -s https://httpbin.org/delay/1 > /dev/null
  done
'
```

### 6. JSON Data Processing

Process API responses with jq (if available):

```bash
kubectl exec -it $POD_NAME -n curl-app -- sh -c \
  'curl -s https://httpbin.org/json | grep slideshow'
```

## Configuration Details

### Deployment Specifications

- **Image**: `cleanstart/curl:latest`
- **Replicas**: 1 (can be scaled if needed)
- **Resources**:
  - Memory Request: 64Mi
  - Memory Limit: 128Mi
  - CPU Request: 100m
  - CPU Limit: 200m
- **Command**: `tail -f /dev/null` to keep the container alive

### Container Behavior

The container runs `tail -f /dev/null` to stay active, allowing you to exec into it and run curl commands as needed. This approach is ideal for:
- Ad-hoc debugging and testing
- Service connectivity validation
- API endpoint verification
- Network troubleshooting

## Useful Commands

### Check Pod Status

```bash
kubectl get pods -n curl-app
kubectl describe pod $POD_NAME -n curl-app
```

### View Pod Logs

```bash
kubectl logs -f $POD_NAME -n curl-app
```

### Check Resource Usage

```bash
kubectl top pod $POD_NAME -n curl-app
```

### Scale Deployment

```bash
kubectl scale deployment curl-app --replicas=2 -n curl-app
```

### Update Image

```bash
kubectl set image deployment/curl-app curl-app=cleanstart/curl:latest-dev -n curl-app
```

## Troubleshooting

### Common Issues

1. **CrashLoopBackOff State**
   
   If the pod enters CrashLoopBackOff, check:
   ```bash
   kubectl describe pod $POD_NAME -n curl-app
   kubectl logs $POD_NAME -n curl-app
   ```
   
   **Solution**: The deployment now uses `tail -f /dev/null` command which is more reliable and universally available. If you still see issues:
   - Verify the image is accessible: `docker pull cleanstart/curl:latest`
   - Check if there are image pull errors in the pod description
   - Ensure the cluster has internet access to pull the image

2. **Pod Not Starting**
   ```bash
   kubectl describe pod $POD_NAME -n curl-app
   kubectl logs $POD_NAME -n curl-app
   ```

3. **Connection Timeouts**
   - Verify network policies allow outbound traffic
   - Check if DNS resolution is working: `kubectl exec -it $POD_NAME -n curl-app -- nslookup google.com`

4. **Command Not Found**
   - Ensure you're using the correct image tag
   - Verify the image contains curl: `kubectl exec -it $POD_NAME -n curl-app -- which curl`

### Debug Commands

```bash
# Check pod events
kubectl get events -n curl-app --sort-by='.lastTimestamp'

# Verify pod is running
kubectl get pods -n curl-app -o wide

# Check network connectivity
kubectl exec -it $POD_NAME -n curl-app -- ping -c 3 8.8.8.8

# Test DNS resolution
kubectl exec -it $POD_NAME -n curl-app -- nslookup kubernetes.default.svc.cluster.local
```

## Cleanup

To remove the curl deployment:

```bash
kubectl delete -f service.yaml -n curl-app
kubectl delete -f deployment.yaml -n curl-app
kubectl delete -f namespace.yaml
```

Or delete everything at once:

```bash
kubectl delete namespace curl-app
```

## Advanced Usage

### Creating a Job for One-Time Tasks

If you need to run a one-time curl command, create a Job instead:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: curl-job
  namespace: curl-app
spec:
  template:
    spec:
      containers:
      - name: curl
        image: cleanstart/curl:latest
        command: ["curl", "-s", "https://httpbin.org/get"]
      restartPolicy: Never
  backoffLimit: 4
```

Apply with:
```bash
kubectl apply -f curl-job.yaml
```

### Creating a CronJob for Scheduled Tasks

For scheduled API calls or health checks:

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: curl-cronjob
  namespace: curl-app
spec:
  schedule: "*/5 * * * *"  # Every 5 minutes
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: curl
            image: cleanstart/curl:latest
            command: ["curl", "-s", "https://httpbin.org/get"]
          restartPolicy: OnFailure
```

## Security Considerations

- The deployment uses minimal resource limits to prevent resource exhaustion
- No privileged access is required
- Network policies can be applied to restrict egress traffic
- Consider using a service mesh for enhanced security and observability

## Architecture Notes

- **Purpose**: Utility container for HTTP/HTTPS operations
- **Network**: Uses cluster networking (ClusterIP)
- **Storage**: No persistent storage required
- **Scalability**: Can be scaled horizontally if needed

## Performance Tips

- For high-volume testing, consider scaling the deployment
- Use connection reuse for multiple requests to the same host
- Monitor resource usage and adjust limits as needed

---

For more information about CleanStart containers, visit: https://www.cleanstart.com

