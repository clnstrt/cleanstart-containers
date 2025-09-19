# CleanStart Nginx Test Deployment

This deployment provides a comprehensive testing environment for the CleanStart Nginx image on Kubernetes. It includes multiple test endpoints, interactive web interface, and various testing scenarios to validate the functionality of the CleanStart Nginx container.

## Overview

The test deployment includes:

- **Namespace**: `nginx-test` for isolated testing environment
- **Deployment**: 2 replicas of CleanStart Nginx with comprehensive configuration
- **ConfigMaps**: Nginx configuration and HTML content for testing
- **Services**: Both ClusterIP and NodePort services for different access methods
- **Health Checks**: Liveness, readiness, and startup probes
- **Test Endpoints**: Multiple endpoints for testing various functionalities

## Prerequisites

- Kubernetes cluster (minikube, kind, EKS, GKE, AKS, etc.)
- `kubectl` installed and configured
- Access to CleanStart Nginx image (`cleanstart/nginx:latest`)

## Quick Start

### 1. Deploy the Test Environment

```bash
# Deploy all resources
kubectl apply -f test-deployment.yaml

# Verify deployment
kubectl get all -n nginx-test
```

### 2. Check Deployment Status

```bash
# Check pods status
kubectl get pods -n nginx-test

# Check services
kubectl get services -n nginx-test

# Check configmaps
kubectl get configmaps -n nginx-test
```

Expected output:
```
NAME                                     READY   STATUS    RESTARTS   AGE
nginx-test-deployment-xxxxx-yyyyy        1/1     Running   0          1m
nginx-test-deployment-xxxxx-zzzzz        1/1     Running   0          1m

NAME                           TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
nginx-test-service             ClusterIP   10.96.xxx.xxx   <none>        80/TCP         1m
nginx-test-service-nodeport    NodePort    10.96.yyy.yyy   <none>        80:30080/TCP   1m
```

## Testing Methods

### Method 1: Port Forward (Recommended for Local Testing)

```bash
# Port forward to access the application
kubectl port-forward -n nginx-test svc/nginx-test-service 8080:80

# Access the application
# Open browser: http://localhost:8080
```

### Method 2: NodePort (For External Access)

```bash
# Get the node IP (for minikube)
minikube ip

# Access via NodePort
# http://<NODE-IP>:30080
```

### Method 3: LoadBalancer (Cloud Providers)

```bash
# Create a LoadBalancer service
kubectl expose deployment nginx-test-deployment -n nginx-test --type=LoadBalancer --port=80 --name=nginx-test-lb

# Get external IP
kubectl get services -n nginx-test nginx-test-lb
```

## Test Endpoints

The deployment includes several test endpoints to validate CleanStart Nginx functionality:

### 1. Health Check
```bash
curl http://localhost:8080/health
# Expected: "healthy"
```

### 2. Status Information
```bash
curl http://localhost:8080/status
# Expected: JSON with status, timestamp, and nginx version
```

### 3. HTTP Method Testing
```bash
# Test GET
curl -X GET http://localhost:8080/test

# Test POST
curl -X POST http://localhost:8080/test

# Test PUT
curl -X PUT http://localhost:8080/test

# Test DELETE
curl -X DELETE http://localhost:8080/test
```

### 4. Static File Serving
```bash
# Test HTML file
curl http://localhost:8080/index.html

# Test 404 error page
curl http://localhost:8080/nonexistent
```

## Interactive Testing

The web interface at `http://localhost:8080` provides:

- **Interactive Test Buttons**: Click to test different HTTP methods
- **Endpoint Testing**: Click on endpoint links to test functionality
- **Real-time Results**: See responses directly in the browser
- **Feature Validation**: Visual confirmation of CleanStart Nginx capabilities

## Advanced Testing

### 1. Load Testing

```bash
# Install hey (load testing tool)
go install github.com/rakyll/hey@latest

# Run load test
hey -n 1000 -c 10 http://localhost:8080/health
```

### 2. Security Headers Testing

```bash
# Check security headers
curl -I http://localhost:8080/

# Expected headers:
# X-Frame-Options: SAMEORIGIN
# X-Content-Type-Options: nosniff
# X-XSS-Protection: 1; mode=block
# Referrer-Policy: strict-origin-when-cross-origin
```

### 3. Compression Testing

```bash
# Test gzip compression
curl -H "Accept-Encoding: gzip" -v http://localhost:8080/status
```

### 4. Log Analysis

```bash
# View nginx logs
kubectl logs -n nginx-test deployment/nginx-test-deployment

# Follow logs in real-time
kubectl logs -f -n nginx-test deployment/nginx-test-deployment
```

## Monitoring and Observability

### 1. Pod Status Monitoring

```bash
# Watch pod status
kubectl get pods -n nginx-test -w

# Describe pod for detailed information
kubectl describe pod -n nginx-test -l app=nginx-test
```

### 2. Resource Usage

```bash
# Check resource usage
kubectl top pods -n nginx-test

# Check node resource usage
kubectl top nodes
```

### 3. Service Endpoints

```bash
# Check service endpoints
kubectl get endpoints -n nginx-test

# Describe service
kubectl describe service -n nginx-test nginx-test-service
```

## Troubleshooting

### Common Issues

1. **Pod not starting**:
   ```bash
   kubectl describe pod -n nginx-test -l app=nginx-test
   kubectl logs -n nginx-test deployment/nginx-test-deployment
   ```

2. **Service not accessible**:
   ```bash
   kubectl get services -n nginx-test
   kubectl get endpoints -n nginx-test
   ```

3. **ConfigMap issues**:
   ```bash
   kubectl get configmaps -n nginx-test
   kubectl describe configmap -n nginx-test nginx-config
   ```

### Debug Commands

```bash
# Check all resources
kubectl get all -n nginx-test

# Check events
kubectl get events -n nginx-test --sort-by='.lastTimestamp'

# Check resource quotas
kubectl describe namespace nginx-test
```

## Performance Testing

### 1. Basic Performance Test

```bash
# Test response time
time curl http://localhost:8080/health

# Test with multiple requests
for i in {1..10}; do curl -w "%{time_total}\n" -o /dev/null -s http://localhost:8080/health; done
```

### 2. Concurrent Testing

```bash
# Test concurrent requests
for i in {1..5}; do curl http://localhost:8080/status & done; wait
```

## Cleanup

To remove all test resources:

```bash
# Delete the entire namespace (removes all resources)
kubectl delete namespace nginx-test

# Or delete individual resources
kubectl delete -f test-deployment.yaml
```

## Test Scenarios

### Scenario 1: Basic Functionality
1. Deploy the test environment
2. Access the web interface
3. Test all interactive buttons
4. Verify health endpoint
5. Check status endpoint

### Scenario 2: HTTP Methods
1. Test GET, POST, PUT, DELETE methods
2. Verify proper responses for each method
3. Test error handling for unsupported methods

### Scenario 3: Error Handling
1. Access non-existent pages (404)
2. Test error page rendering
3. Verify proper error responses

### Scenario 4: Performance
1. Run load tests
2. Monitor resource usage
3. Test under concurrent load
4. Verify response times

### Scenario 5: Security
1. Check security headers
2. Test access to hidden files
3. Verify proper error responses
4. Test input validation

## Expected Results

- ✅ All pods should be in `Running` state
- ✅ Health checks should pass
- ✅ Web interface should load correctly
- ✅ All test endpoints should respond appropriately
- ✅ Security headers should be present
- ✅ Error pages should render correctly
- ✅ Performance should be within acceptable limits

## Contributing

To contribute to this test deployment:

1. Fork the repository
2. Create a feature branch
3. Add new test scenarios
4. Update documentation
5. Submit a pull request

## License

This test deployment is open source and available under the [MIT License](LICENSE).
