# Step 0: Connect to Your GKE Cluster (if not already connected)
```bash
gcloud container clusters get-credentials <cluster-name> --zone us-central1-b
```
# Right Directory
```bash
cd /cleanstart-containers/containers/argocd-extension-installer/gcp
```

# Step 1: Create the Namespace
```bash
kubectl apply -f namespace.yaml
```

# Step 2: Build the Docker Image
```bash
docker build -t argocd-extensions-app:latest .
```

# Step 3: Tag the Image for Artifact Registry
```bash
docker tag argocd-extensions-app:latest <your_artifact_registry>/argocd-extensions-app:latest
```

# Step 4: Configure Docker Authentication
```bash
gcloud auth configure-docker  <your_artifact_registry>/us-central1-docker.pkg.dev
```

# Step 5: Push the Image
```bash
docker push argocd-extensions-app:latest
```

# Step 6: Deploy the Application
```bash
kubectl apply -f deployment.yaml -n argocd-extension
```

# Step 7: Create the Service
```bash
kubectl apply -f service.yaml -n argocd-extension
```

# Step 8: Verify Deployment
```bash
kubectl get all -n argocd-extension
```

# Result 
Through IP you will access the application dashboard
<img width="767" height="797" alt="image" src="https://github.com/user-attachments/assets/c46b3b17-30bd-46cc-aaae-6f244ed15982" />


# Useful Commands
```bash
kubectl logs -f deployment/argocd-extension-installer -n argocd-extension
kubectl get all -n argocd-extension
kubectl get events -n argocd-extension --sort-by='.lastTimestamp'
```

# Cleanup
```bash
kubectl delete -f gcp/service.yaml
kubectl delete -f gcp/deployment.yaml
kubectl delete -f gcp/namespace.yaml

```

