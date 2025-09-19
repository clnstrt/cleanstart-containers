**🚀 Nginx Sample Project on Kubernetes**

This project deploys a sample nginx app on Kubernetes using the image cleanstart/nginx:latest.
It includes:

✅ Deployment with 2 replicas

✅ Service (ClusterIP) for access

✅ Horizontal Pod Autoscaler (HPA)

✅ Ingress for routing

✅ ConfigMap with a custom index.html

**📂 Project Structure**
```bash
deployment.yaml   # Kubernetes manifests (Deployment, Service, HPA, Ingress, ConfigMap)
README.md         # This guide
```

**⚡ Prerequisites**

Kubernetes cluster (minikube / kind / k3s / any cloud)

kubectl installed and configured


**🚀 Deploy the Application**

Apply the manifests:

```bash
kubectl apply -f deployment.yaml
```

This creates:

nginx-sample namespace

nginx-deployment (2 pods)

nginx-service (ClusterIP service on port 80)

nginx-hpa (auto-scale between 2–5 pods)

nginx-ingress (Ingress resource for external access)

nginx-html (ConfigMap with index.html)

🔍 Verify Deployment
1. Check all resources
```bash
kubectl get all -n nginx-sample
```

Expected Output:

2 running pods

ClusterIP service

HPA configured

2. Watch pod status
```bash
kubectl get pods -n nginx-sample -w
```

3. Check logs
```bash
kubectl logs -n nginx-sample <pod-name>
```

🌐 Access the App
Option 1: Port Forward

```bash
kubectl port-forward svc/nginx-service -n nginx-sample 8080:80
```

Now open **http://localhost:8080**

Note: The cleanstart/nginx:latest image does not include a default index.html file. As a result, the Nginx welcome page is not displayed. However, the Nginx server itself is running as expected.


To delete everything:

```bash
kubectl delete -f deployment.yaml
```

Or delete namespace:

```bash
kubectl delete namespace nginx-sample
```

✅ Expected Output

Deletes all the services