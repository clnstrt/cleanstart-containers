# MinIO Operator Sidecar - Kubernetes Deployment

Simple Kubernetes deployment for testing the MinIO Operator Sidecar container on GKE.

## Important Note

The MinIO Operator Sidecar is **not a web application**. It's a CLI tool/background service that runs once and completes its task. It doesn't serve web pages or have a browser interface.

## Files

- `namespace.yaml` - Creates the namespace
- `deployment.yaml` - Deploys the container (keeps it running for testing)
- `service.yaml` - Exposes the service via LoadBalancer

## Deploy

```bash
kubectl apply -f namespace.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

## Check Status

```bash
# Check if pod is running
kubectl get pods -n minio-operator-sidecar

# Check service (will have external IP but no web interface)
kubectl get service -n minio-operator-sidecar

# Check what the operator is doing
kubectl logs -n minio-operator-sidecar -l app=minio-operator-sidecar
```

## What the Operator Does

The operator sidecar:
1. Runs the `/minio-operator-sidecar` binary
2. Completes its initialization/configuration task
3. Exits (this is expected behavior)
4. Container stays alive for testing purposes

## Testing the Operator

```bash
# Follow the logs to see what it's doing
kubectl logs -n minio-operator-sidecar -l app=minio-operator-sidecar --follow

# Check pod details
kubectl describe pod -n minio-operator-sidecar
```

## Cleanup

```bash
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
kubectl delete -f namespace.yaml
```