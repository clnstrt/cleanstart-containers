# MinIO Kubernetes Deployment

This directory contains Kubernetes deployment files for MinIO object storage server using the CleanStart MinIO container image.

## Files

- `namespace.yaml` - Creates the `minio-app` namespace
- `deployment.yaml` - Deploys MinIO server with proper configuration
- `service.yaml` - Exposes MinIO API and Console via LoadBalancer

## Quick Start

### Prerequisites

- GKE cluster with kubectl configured
- Access to pull `cleanstart/minio:latest` image

### Deployment

1. **Create namespace and deploy MinIO:**
```bash
   kubectl apply -f namespace.yaml
   kubectl apply -f deployment.yaml
   kubectl apply -f service.yaml
   ```

2. **Check deployment status:**
 ```bash
   kubectl get pods -n minio-app
   kubectl get svc -n minio-app
   ```

3. **Get external IP:**
 ```bash
   kubectl get svc minio-app-service -n minio-app
   ```

### Access MinIO

Once deployed, you can access MinIO through:

- **MinIO Web Console**: `http://<EXTERNAL-IP>:9090`
  - Username: `minioadmin`
  - Password: `minioadmin`

- **MinIO API**: `http://<EXTERNAL-IP>:9000`
  - Access Key: `minioadmin`
  - Secret Key: `minioadmin`

### Configuration

The deployment includes:

- **Health Checks**: Liveness and readiness probes
- **Resource Limits**: Memory and CPU constraints
- **Environment Variables**: Default admin credentials
- **Storage**: Uses emptyDir for temporary storage (not persistent)

### Production Considerations

For production use, consider:

1. **Persistent Storage**: Replace `emptyDir` with PersistentVolume
2. **Security**: Use Kubernetes secrets for credentials
3. **High Availability**: Deploy multiple replicas
4. **TLS**: Configure SSL/TLS certificates
5. **Monitoring**: Add monitoring and logging

### Cleanup

To remove the deployment:

```bash
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
kubectl delete -f namespace.yaml
```

## Testing

You can test the deployment by:

1. Accessing the web console to create buckets
2. Using MinIO client (mc) to interact with the API
3. Uploading and downloading files through the console

## Troubleshooting

- Check pod logs: `kubectl logs -n minio-app deployment/minio-app`
- Verify service endpoints: `kubectl get endpoints -n minio-app`
- Check resource usage: `kubectl top pods -n minio-app`
