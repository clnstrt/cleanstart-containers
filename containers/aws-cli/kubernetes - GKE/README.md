# AWS CLI on Kubernetes

This basic project shows how to run the CleanStart `aws-cli` container in GKE using a Kubernetes `Namespace`, `Secret` for credentials, and a one-off `Job` to execute AWS CLI commands.

## Prerequisites
- Google Cloud CLI configured and authenticated
- `kubectl` configured for your GKE cluster
- AWS access keys (or use Workload Identity in production)

## Files
- `namespace.yaml`: Creates the `aws-cli-app` namespace
- `secret.yaml`: Stores AWS credentials as a Kubernetes secret
- `job.yaml`: Runs the `cleanstart/aws-cli` image with a sample command

## Steps

### 0) Connect to your GKE cluster
```bash
gcloud container clusters get-credentials <cluster-name> --zone <zone>
```

### 1) Create namespace
```bash
kubectl apply -f namespace.yaml
```

### 2) Create AWS credentials secret
Edit `secret.yaml` and set values (or use `kubectl create secret`). Then apply:
```bash
kubectl apply -f secret.yaml -n aws-cli-app
```

### 3) Run the AWS CLI Job
The provided `job.yaml` runs `aws --version` by default. Apply it:
```bash
kubectl apply -f job.yaml -n aws-cli-app
```

Check Job and logs:
```bash
kubectl get jobs -n aws-cli-app
POD=$(kubectl get pods -n aws-cli-app -l job-name=aws-cli-job -o jsonpath='{.items[0].metadata.name}')
kubectl logs -n aws-cli-app $POD
```

### 4) Run a custom command
Override the command at apply time:
```bash
kubectl create job aws-cli-list-s3 -n aws-cli-app \
  --image=cleanstart/aws-cli:latest \
  -- aws s3 ls
```

Or patch the `args` in `job.yaml`, for example to list S3 buckets:
```yaml
args: ["s3", "ls"]
```

## Notes
- Image: `cleanstart/aws-cli:latest`
- The image is minimal and executes `aws` directly; no shell is provided
- Consider GKE Workload Identity for production instead of static keys
- Set `AWS_REGION` via env as needed

## Cleanup
```bash
kubectl delete -f job.yaml -n aws-cli-app || true
kubectl delete -f secret.yaml -n aws-cli-app || true
kubectl delete -f namespace.yaml || true
```
