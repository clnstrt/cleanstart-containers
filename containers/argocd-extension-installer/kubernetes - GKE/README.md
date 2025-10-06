# Step 0: Connect to Your GKE Cluster (if not already connected)
## About this folder
This folder contains Kubernetes manifests and instructions to deploy the Argo CD Extension Installer on Google Kubernetes Engine (GKE).

## What this README covers
This README explains how to build, push, and run the CleanStart container image on GKE using the resources in this folder. Follow the steps below to connect to your cluster, build and publish the image, and deploy it to GKE.

---
 
Prerequisites:
- Ensure you have the Google Cloud SDK installed and you are authenticated.
- Set your active project and region/zone.

```bash
# Authenticate and select your project
gcloud auth login
gcloud config set project <PROJECT_ID>

# Optional: set defaults for region/zone
gcloud config set compute/region <REGION>
gcloud config set compute/zone <ZONE>

# Get credentials for your GKE cluster
gcloud container clusters get-credentials <CLUSTER_NAME> --zone <ZONE>
```
# Right Directory
```bash
cd /cleanstart-containers/containers/argocd-extension-installer/gcp
```

# Step 1: Create the Namespace
```bash
kubectl apply -f namespace.yaml
```
Notes:
- This creates the `argocd-extension` namespace used by the deployment and service.
- You can verify with: `kubectl get ns argocd-extension`.

# Step 2: Build the Docker Image
```bash
docker build -t argocd-extensions-app:latest .
```

# Step 3: Tag the Image for Artifact Registry
```bash
# Example Artifact Registry path:
# <REGION>-docker.pkg.dev/<PROJECT_ID>/<REPO_NAME>/argocd-extensions-app:<TAG>

export REGION=<REGION>
export PROJECT_ID=<PROJECT_ID>
export REPO_NAME=<REPO_NAME>
export TAG=latest

# (One-time) Create the Artifact Registry repo if it doesn't exist
gcloud artifacts repositories create "$REPO_NAME" \
  --repository-format=docker \
  --location="$REGION" \
  --description="Argo CD extensions images"

docker tag argocd-extensions-app:latest \ 
  "$REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/argocd-extensions-app:$TAG"
```

# Step 4: Configure Docker Authentication
```bash
# Configure auth for the Artifact Registry host for your region
gcloud auth configure-docker "$REGION-docker.pkg.dev"
```

# Step 5: Push the Image
```bash
# Push the fully qualified, tagged image
docker push "$REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/argocd-extensions-app:$TAG"
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
Tips:
- Pods should be in `Running` state; if not, check logs and events below.
- Describe resources for troubleshooting: `kubectl describe pod <POD> -n argocd-extension`.


# Useful Commands
```bash
kubectl logs -f deployment/argocd-extension-installer -n argocd-extension
kubectl get all -n argocd-extension
kubectl get events -n argocd-extension --sort-by='.lastTimestamp'

# Port-forward locally if no LoadBalancer is available
kubectl port-forward svc/argocd-extension-installer 8080:80 -n argocd-extension
```

# Cleanup
```bash
# If you ran commands from this folder, paths can be relative
kubectl delete -f service.yaml -n argocd-extension
kubectl delete -f deployment.yaml -n argocd-extension
kubectl delete -f namespace.yaml

```

