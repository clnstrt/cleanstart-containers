# Step 0: Connect to Your GKE Cluster (if not already connected) Make sure you have Gcloud installed and kubectl configured and connected to your cluster
```bash
gcloud container clusters get-credentials community-images --zone us-central1-a
```
# Right Directory
```bash
cd /cleanstart-containers/containers/metallb-controller/gcp
```

# Step 1: Create the Namespace
```bash
kubectl apply -f namespace.yaml
```

# Step 2: Build the Docker Image
```bash
docker build -t metallb-controller-app:latest .
```

# Step 3: Tag the Image for Artifact Registry
```bash
docker tag metallb-controller-app:latest us-central1-docker.pkg.dev/consumption-442810/testing-community-images/metallb-controller-app:latest
```

# Step 4: Configure Docker Authentication
```bash
gcloud auth configure-docker us-central1-docker.pkg.dev
```

# Step 5: Push the Image
```bash
docker push us-central1-docker.pkg.dev/consumption-442810/testing-community-images/metallb-controller-app:latest
```

# Step 6: Deploy the Application
```bash
kubectl apply -f deployment.yaml -n metallb-controller-app
```

# Step 7: Create the Service
```bash
kubectl apply -f service.yaml -n metallb-controller-app
```

# Step 8: Verify Deployment
```bash
kubectl get all -n metallb-controller-app
```

# Useful Commands
```bash
kubectl logs -f deployment/metallb-controller-installer -n metallb-controller-app
kubectl get all -n metallb-controller-app
kubectl get events -n metallb-controller --sort-by='.lastTimestamp'
```

# Cleanup
```bash
kubectl delete -f gcp/service.yaml
kubectl delete -f gcp/deployment.yaml
kubectl delete -f gcp/namespace.yaml
```