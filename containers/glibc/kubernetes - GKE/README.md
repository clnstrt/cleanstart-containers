# Step 0: Connect to Your GKE Cluster (if not already connected)
```bash
gcloud container clusters get-credentials <cluster-name> --zone us-central1-a
```
# Right Directory
```bash
cd /cleanstart-containers/containers/glibc/gcp
```

# Step 1: Create the Namespace
```bash
kubectl apply -f namespace.yaml (Naming convention is <container-name>-app)
```

# Step 2: Build the Docker Image
```bash
docker build -t glibc-app:latest .
```

# Step 3: Tag the Image for Artifact Registry
```bash
docker tag glibc-app:latest <artifact_registry>/glibc-app:latest
```

# Step 4: Configure Docker Authentication
```bash
gcloud auth configure-docker us-central1-docker.pkg.dev
```

# Step 5: Push the Image
```bash
docker push <artifact_registry>/glibc-app:latest
```

# Step 6: Deploy the Application
```bash
kubectl apply -f deployment.yaml -n glibc-app
```

# Step 7: Create the Service
```bash
kubectl apply -f service.yaml -n glibc-app
```

# Step 8: Verify Deployment
```bash
kubectl get all -n glibc-app
```

# Useful Commands
```bash
kubectl logs -f deployment/glibc -n glibc
kubectl get all -n glibc
kubectl get events -n glibc --sort-by='.lastTimestamp'
```

# Cleanup
```bash
kubectl delete -f gcp/service.yaml
kubectl delete -f gcp/deployment.yaml
kubectl delete -f gcp/namespace.yaml

```
