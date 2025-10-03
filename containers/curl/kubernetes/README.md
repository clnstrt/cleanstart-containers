# Curl Container - Kubernetes Testing

Simple Kubernetes testing for the `cleanstart/curl` container.

## Deploy

```bash
# Create namespace
kubectl create namespace curl-testing

# Run job
kubectl apply -f job.yaml

# Check results
kubectl get jobs -n curl-testing
kubectl logs job/curl-test-job -n curl-testing
```

## Test

```bash
# Test curl version
kubectl run curl-test --image=cleanstart/curl:latest --rm -it --restart=Never -n curl-testing -- curl --version

# Test HTTP request
kubectl run curl-test --image=cleanstart/curl:latest --rm -it --restart=Never -n curl-testing -- curl -s https://httpbin.org/get

# Test POST request
kubectl run curl-test --image=cleanstart/curl:latest --rm -it --restart=Never -n curl-testing -- curl -s -X POST https://httpbin.org/post \
  -H "Content-Type: application/json" \
  -d '{"test": "data from GKE"}'
```

## Cleanup

```bash
kubectl delete -f job.yaml
kubectl delete namespace curl-testing
```
