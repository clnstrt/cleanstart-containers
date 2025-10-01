# Step 0: Connect to Your GKE Cluster (if not already connected)
```bash
gcloud container clusters get-credentials community-images --zone us-central1-a
```
# Right Directory
```bash
cd /cleanstart-containers/containers/cortex/gcp
```

# Step 1: Create the Namespace
```bash
kubectl apply -f namespace.yaml
```

# Step 2: Build the Docker Image
```bash
docker build -t cortex:latest .
```

# Step 3: Tag the Image for Artifact Registry
```bash
docker tag cortex-app:latest <your_artifact_registry>/cortex-app:latest
```

# Step 4: Configure Docker Authentication
```bash
gcloud auth configure-docker us-central1-docker.pkg.dev
```

# Step 5: Push the Image
```bash
docker push <your_artifact_registry>/cortex-app:latest
```

# Step 6: Deploy the Application
```bash
kubectl apply -f deployment.yaml -n cortex
```

# Step 7: Create the Service
```bash
kubectl apply -f service.yaml -n cortex
```

# Step 8: Verify Deployment
```bash
kubectl get all -n cortex
```
# Result will be logs of json
<img width="1029" height="845" alt="image" src="https://github.com/user-attachments/assets/59a1fcd4-61cc-4db6-b86f-9327f47354df" />


# Useful Commands
```bash
kubectl logs -f deployment/cortex -n cortex
kubectl get all -n cortex
kubectl get events -n cortex --sort-by='.lastTimestamp'
```

# Cleanup
```bash
kubectl delete -f gcp/service.yaml
kubectl delete -f gcp/deployment.yaml
kubectl delete -f gcp/namespace.yaml

```

