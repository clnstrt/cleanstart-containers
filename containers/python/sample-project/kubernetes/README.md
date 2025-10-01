# Flask User Management App - Kubernetes Deployment

This directory contains the production-ready Kubernetes deployment for the Flask User Management application, refactored following senior developer best practices.

## 🏗️ Architecture Overview

The application has been refactored to follow proper separation of concerns:

- **Application Code**: Separated into individual files (`app.py`, `requirements.txt`)
- **Configuration**: Managed through ConfigMaps and environment variables
- **Storage**: Persistent volumes for database persistence
- **Security**: Non-root user execution and proper security contexts
- **Monitoring**: Health checks and Prometheus annotations

## 📁 File Structure

```
kubernetes/
├── k8s-deployment.yaml      # Main deployment, service, and namespace
├── configmap.yaml           # Application configuration
├── app-configmap.yaml       # Application code as ConfigMap
├── persistent-volume.yaml   # Persistent storage for database
├── deploy.sh               # Deployment script
└── README.md               # This file
```

## 🚀 Deployment

### Prerequisites

- Kubernetes cluster (minikube, kind, or cloud provider)
- kubectl configured to connect to your cluster

### Quick Deploy

```bash
# Make the deployment script executable (Linux/macOS)
chmod +x deploy.sh

# Run the deployment
./deploy.sh
```

### Manual Deploy

```bash
# Apply the main deployment file (includes everything needed)
kubectl apply -f k8s-deployment.yaml

# Wait for deployment to be ready
kubectl wait --for=condition=available --timeout=300s deployment/flask-user-app -n flask-app
```

## 🔧 Configuration

### Environment Variables

The application can be configured through the ConfigMap:

- `DATABASE_PATH`: Path to SQLite database file
- `DEBUG`: Enable/disable debug mode
- `HOST`: Application host
- `PORT`: Application port
- `LOG_LEVEL`: Logging level

### Scaling

```bash
# Scale to 3 replicas
kubectl scale -n flask-app deployment/flask-user-app --replicas=3
```

## 📊 Monitoring & Health Checks

### Health Endpoint

The application exposes a health check endpoint at `/health` that returns:

```json
{
  "status": "healthy",
  "database": "/app/data/users.db"
}
```

### Prometheus Integration

The deployment includes Prometheus annotations for metrics scraping:

- Scrape: `true`
- Port: `5000`
- Path: `/health`

## 🔒 Security Features

- **Non-root execution**: Runs as user ID 1000
- **Read-only root filesystem**: Enabled where possible
- **Capability dropping**: All capabilities dropped
- **No privilege escalation**: Disabled
- **Resource limits**: CPU and memory limits enforced

## 💾 Data Persistence

- Database stored in persistent volume (`/app/data/users.db`)
- 1GB storage allocation
- Retain policy for data preservation

## 🌐 Accessing the Application

### Port Forward

```bash
kubectl port-forward -n flask-app service/flask-app-service 8080:80
```

Then open http://localhost:8080 in your browser.

### Service Details

```bash
kubectl get services -n flask-app
```

## 📝 Logs & Debugging

### View Logs

```bash
# Application logs
kubectl logs -n flask-app deployment/flask-user-app

# Follow logs in real-time
kubectl logs -n flask-app deployment/flask-user-app -f
```

### Debug Pod

```bash
# Get pod status
kubectl get pods -n flask-app

# Describe pod for detailed information
kubectl describe pod -n flask-app <pod-name>

# Execute shell in pod
kubectl exec -it -n flask-app <pod-name> -- /bin/bash
```

## 🧹 Cleanup

```bash
# Delete all resources
kubectl delete namespace flask-app

# Or delete individual resources
kubectl delete -f k8s-deployment.yaml
kubectl delete -f persistent-volume.yaml
kubectl delete -f app-configmap.yaml
kubectl delete -f configmap.yaml
```

## 🔄 Updates & Rollouts

### Rolling Update

The deployment uses a rolling update strategy:

- Max unavailable: 1 pod
- Max surge: 1 pod

### Update Application

1. Update the ConfigMap with new application code
2. Restart the deployment to pick up changes:

```bash
kubectl rollout restart -n flask-app deployment/flask-user-app
```

## 📈 Production Considerations

For production deployment, consider:

1. **Image Security**: Use specific image tags instead of `latest-dev`
2. **Resource Monitoring**: Implement proper monitoring and alerting
3. **Backup Strategy**: Regular database backups
4. **Network Policies**: Implement network segmentation
5. **Ingress**: Use Ingress controller for external access
6. **TLS**: Enable HTTPS with proper certificates
7. **Secrets**: Use Kubernetes Secrets for sensitive data

## 🆚 Comparison with Original

### What Was Improved

1. **Simplified Deployment**: Single file deployment with working configuration
2. **Health Checks**: Dedicated health endpoint for monitoring
3. **Resource Management**: Proper CPU and memory limits
4. **Load Balancing**: Multiple replicas for high availability
5. **Maintainability**: Clean, working deployment structure
6. **Production Readiness**: Proper resource limits and health checks

### What Stayed the Same

- **Application Logic**: Identical Flask application functionality
- **User Interface**: Same HTML/CSS/JavaScript
- **Database Schema**: Same SQLite structure
- **API Endpoints**: Same routes and behavior
- **User Experience**: Identical functionality

## 🎯 **Quick Start Guide**

1. **Deploy the application**:
   ```bash
   kubectl apply -f k8s-deployment.yaml
   ```

2. **Wait for pods to be ready**:
   ```bash
   kubectl get pods -n flask-app
   ```

3. **Access the application**:
   ```bash
   kubectl port-forward -n flask-app service/flask-app-service 8080:80
   ```
   Then open http://localhost:8080 in your browser

4. **Test the application**:
   - Add users using the form
   - Edit existing users
   - Delete users
   - Verify data persistence across pod restarts
