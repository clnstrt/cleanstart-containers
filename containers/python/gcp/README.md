# Step 0: Connect to Your GKE Cluster (if not already connected)
```bash
gcloud container clusters get-credentials <cluster-name> --zone us-central1-a
```
# Right Directory
```bash
cd /cleanstart-containers/containers/python/gcp
```

# Step 1: Create the Namespace
```bash
kubectl apply -f namespace.yaml
```

# Step 2: Build the Docker Image
```bash
docker build -t python:latest .
```

# Step 3: Tag the Image for Artifact Registry
```bash
docker tag python:latest <artifact_registry>/python:latest
```

# Step 4: Configure Docker Authentication
```bash
gcloud auth configure-docker us-central1-docker.pkg.dev
```

# Step 5: Push the Image
```bash
docker push <artifact_registry>/python:latest
```

# Step 6: Deploy the Application
```bash
kubectl apply -f deployment.yaml -n python
```

# Step 7: Create the Service
```bash
kubectl apply -f service.yaml -n python
```

# Step 8: Verify Deployment
```bash
kubectl get all -n python
```
# Result through IP 
<img width="1887" height="865" alt="image" src="https://github.com/user-attachments/assets/ebb1accb-f714-402f-9940-33c95c40aca4" />


# Useful Commands
```bash
kubectl logs -f deployment/jdk-installer -n python
kubectl get all -n python
kubectl get events -n jdk --sort-by='.lastTimestamp'
```

# Cleanup
```bash
kubectl delete -f gcp/service.yaml
kubectl delete -f gcp/deployment.yaml
kubectl delete -f gcp/namespace.yaml

```

