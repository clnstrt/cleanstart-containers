# Step 0: Connect to Your GKE Cluster (if not already connected)
```bash
gcloud container clusters get-credentials <cluster-name> --zone us-central1-a
```
# Right Directory
```bash
cd /cleanstart-containers/containers/jdk/gcp
```

# Step 1: Create the Namespace
```bash
kubectl apply -f namespace.yaml
```

# Step 2: Build the Docker Image
```bash
docker build -t jdk-app:latest .
```

# Step 3: Tag the Image for Artifact Registry
```bash
docker tag jdk-app:latest <your_artifact_registry>/jdk-app:latest
```

# Step 4: Configure Docker Authentication
```bash
gcloud auth configure-docker us-central1-docker.pkg.dev
```

# Step 5: Push the Image
```bash
docker push <artifact_registry>/jdk-app:latest
```

# Step 6: Deploy the Application
```bash
kubectl apply -f deployment.yaml -n jdk-app
```

# Step 7: Create the Service
```bash
kubectl apply -f service.yaml -n jdk-app
```

# Step 8: Verify Deployment
```bash
kubectl get all -n jdk-app
```
# Result 
Access through IP 
<img width="870" height="286" alt="image" src="https://github.com/user-attachments/assets/ace4d797-b12b-49ee-ac62-89d0911c7812" />


# Useful Commands
```bash
kubectl logs -f deployment/jdk-installer -n jdk-app
kubectl get all -n jdk-app
kubectl get events -n jdk --sort-by='.lastTimestamp'
```

# Cleanup
```bash
kubectl delete -f gcp/service.yaml
kubectl delete -f gcp/deployment.yaml
kubectl delete -f gcp/namespace.yaml

```

