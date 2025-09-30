# Step 0: Connect to Your GKE Cluster (if not already connected)
```bash
gcloud container clusters get-credentials community-images --zone us-central1-a
```
# Right Directory
```bash
cd /cleanstart-containers/containers/jre/gcp
```

# Step 1: Create the Namespace
```bash
kubectl apply -f namespace.yaml
```

# Step 2: Build the Docker Image
```bash
docker build -t jre-app:latest .
```

# Step 3: Tag the Image for Artifact Registry
```bash
docker tag jre-app:latest us-central1-docker.pkg.dev/consumption-442810/testing-community-images/jre-app:latest
```

# Step 4: Configure Docker Authentication
```bash
gcloud auth configure-docker us-central1-docker.pkg.dev
```

# Step 5: Push the Image
```bash
docker push us-central1-docker.pkg.dev/consumption-442810/testing-community-images/jre-app:latest
```

# Step 6: Deploy the Application
```bash
kubectl apply -f deployment.yaml -n jre-app
```

# Step 7: Create the Service
```bash
kubectl apply -f service.yaml -n jre-app
```

# Step 8: Verify Deployment
```bash
kubectl get all -n jre-app
```

# Useful Commands
```bash
kubectl logs -f deployment/jre-installer -n jre-app
kubectl get all -n jre-app
kubectl get events -n jre --sort-by='.lastTimestamp'
```

# Cleanup
```bash
kubectl delete -f gcp/service.yaml
kubectl delete -f gcp/deployment.yaml
kubectl delete -f gcp/namespace.yaml
```