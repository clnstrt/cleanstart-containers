### Quick Start to deploy a Go Web App on CleanStart on GKE Cluster

## Prerequisites

You should have a GKE cluster and kubectl installed and configured.

## Steps

### 1. Create a namespace

```bash
 kubectl apply -f namespace.yaml
```

```bash
 kubectl get ns
 ```

### 2. Create a deployment

```bash
kubectl apply -f deployment.yaml -n go-app
```

### 3. Create a service
```bash
kubectl apply -f service.yaml -n go-app
```

### 4. Check the status of the deployment

```bash
 kubectl get all
```

### 4. Check the status of the deployment

```bash
 kubectl get all -n go-app
```

#### 5. Check the logs of the deployment
```bash
 kubectl logs -f go-app-569fc678c-nvjsd -n go-app
 ```

 ### 6.
 Access the service using the external IP
 ```bash
 http://34.60.244.95/
 ```
