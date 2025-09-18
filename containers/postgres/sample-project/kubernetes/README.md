🚀 PostgreSQL on Kubernetes with Cleanstart Lightweight Image

A comprehensive Kubernetes deployment solution for PostgreSQL using the cleanstart/postgres:latest image. This repository provides production-ready manifests and examples for deploying PostgreSQL in Kubernetes environments.

## Overview

Deployment with persistent storage

- **Deployment**: PostgreSQL pod with persistent storage
- **Service**: ClusterIP service for internal cluster access
- **Secret**: Secure password management using Kubernetes secrets
- **PersistentVolumeClaim**: Data persistence across pod restarts
- **Namespace**: Isolated environment for PostgreSQL resources

## Prerequisites

Before deploying this solution, ensure you have:

- A running Kubernetes cluster (minikube, kind, EKS, GKE, AKS, etc.)
- `kubectl` installed and configured to communicate with your cluster
- Access to Docker Hub or your container registry
- Sufficient cluster resources for PostgreSQL deployment

## Quick Start

### 1. Deploy PostgreSQL Resources

Apply the Kubernetes manifests to create all necessary resources:

Docker/Container registry access

🛠️ 1. Apply Kubernetes Manifests
kubectl apply -f deployment.yaml

This command creates the following resources in the `postgres-sample` namespace:

- **Namespace**: `postgres-sample`
- **Secret**: `postgres-secret` with base64-encoded password
- **PersistentVolumeClaim**: `postgres-pvc` for data persistence
- **Deployment**: `postgres-deployment` running cleanstart/postgres:latest
- **Service**: `postgres-service` (ClusterIP type)

### 2. Verify Deployment Status

Check that the PostgreSQL pod is running successfully:

```bash
kubectl get pods -n postgres-sample
```


You should see the Postgres pod in Running state:

NAME                                   READY   STATUS    RESTARTS   AGE
postgres-deployment-xxxxxx-yyyyy       1/1     Running   0          1m

💻 3. Connect with a PostgreSQL Client

Launch a temporary PostgreSQL client pod to connect to your database:

```bash
kubectl run -it --rm pg-client \
  --image=postgres:17 \
  -n postgres-sample \
  --restart=Never \
  --env="PGPASSWORD=postgres_pass" -- \
  psql -h postgres-service -U postgres
```

📝 4. Run CRUD Operations

Once connected to the PostgreSQL shell, you can perform basic CRUD operations:

-- Create a database
CREATE DATABASE sampledb;
\c sampledb;

-- Create a sample table
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(50),
    salary NUMERIC
);

-- Insert data
INSERT INTO employees (name, role, salary) VALUES
  ('Alice', 'Engineer', 75000),
  ('Bob', 'Manager', 90000),
  ('Charlie', 'Intern', 30000);

-- Read data
SELECT * FROM employees;

-- Update data
UPDATE employees SET salary = 80000 WHERE name = 'Alice';

-- Delete data
DELETE FROM employees WHERE name = 'Charlie';

-- Verify changes
SELECT * FROM employees;

-- Exit
\q

## Troubleshooting

### Common Issues

1. **Pod not starting**: Check resource limits and storage availability
2. **Connection refused**: Verify service and pod status
3. **Authentication failed**: Confirm password in secret matches environment variable

### Useful Commands

```bash
# Check pod logs
kubectl logs -n postgres-sample deployment/postgres-deployment

# Describe pod for detailed information
kubectl describe pod -n postgres-sample -l app=postgres

# Check service endpoints
kubectl get endpoints -n postgres-sample postgres-service
```

✅ Cleanup

To remove all resources created by this deployment:

```bash
kubectl delete -f deployment.yaml
```

This will remove the namespace and all associated resources, including persistent volumes (if not retained).

## Contributing

Contributions are welcome! Please feel free to submit issues and enhancement requests.


