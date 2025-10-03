# 🚀 Argo-Workflow-Exec Kubernetes Deployment

Simple Kubernetes deployment for testing CleanStart Argo Workflow Exec container.

## 📁 Files

- `namespace.yaml` - Creates a dedicated namespace for testing
- `deployment.yaml` - Deployment with persistent pod for testing
- `job.yaml` - One-time job for testing (recommended)

## 🚀 Quick Start

### Prerequisites
- GKE cluster with kubectl configured
- Sufficient permissions to create namespaces and deployments

### Option 1: Deploy as Job (Recommended)
```bash
# Apply all resources
kubectl apply -f namespace.yaml
kubectl apply -f job.yaml

# Watch the job
kubectl get jobs -n argo-workflow-exec-test -w

# Check job logs
kubectl logs -n argo-workflow-exec-test job/argo-workflow-exec-test-job -f
```

### Clean up Job
```bash
kubectl delete job argo-workflow-exec-test-job -n argo-workflow-exec-test
```

### Option 2: Deploy as Deployment
```bash
# Apply all resources
kubectl apply -f namespace.yaml
kubectl apply -f deployment.yaml

# Check deployment status
kubectl get deployments -n argo-workflow-exec-test

# Get pod logs
kubectl logs -n argo-workflow-exec-test deployment/argo-workflow-exec-test -f
```

## 🧪 Testing Commands

### Check Job Status
```bash
kubectl get jobs -n argo-workflow-exec-test
```

### View Job Logs
```bash
kubectl logs -n argo-workflow-exec-test job/argo-workflow-exec-test-job
```

### Check Pod Status
```bash
kubectl get pods -n argo-workflow-exec-test
```

### Describe Resources
```bash
kubectl describe job argo-workflow-exec-test-job -n argo-workflow-exec-test
kubectl describe deployment argo-workflow-exec-test -n argo-workflow-exec-test
```

### Clean up Deployment
```bash
kubectl delete deployment argo-workflow-exec-test -n argo-workflow-exec-test
```

### Clean up Namespace (removes everything)
```bash
kubectl delete namespace argo-workflow-exec-test
```

## 📋 Expected Output

The container will run the same test script as the sample-project and should output:

```bash
🚀 Testing argoexec...
Script is running...
Current user: clnstrt
Current directory: /
PATH: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

✅ argoexec found in PATH
Running argoexec --help:
----------------------------------------
argoexec is the executor sidecar to workflow containers

Usage:
  argoexec [flags]
  argoexec [command]

Available Commands:
  agent       
  artifact    
  completion  Generate the autocompletion script for the specified shell
  data        Process data
  emissary    
  help        Help about any command
  init        Load artifacts
  kill        
  resource    update a resource and wait for resource conditions
  version     Print version information
  wait        wait for main container to finish and save artifacts
----------------------------------------

Testing argoexec version:
argoexec version v3.4.4

🔍 Additional system information:
Operating System: Linux x86_64
Available disk space:
Filesystem      Size  Used Avail Use% Mounted on
overlay          20G  1.2G   18G   7% /

Test completed successfully! ✅
```

## 🔧 Configuration Details

### Security Features
- **Non-root user**: Runs as user 1000 (clnstrt)
- **No privilege escalation**: `allowPrivilegeEscalation: false`
- **Resource limits**: CPU and memory constraints applied
- **TTL cleanup**: Job automatically cleaned up after 5 minutes

### Resource Requirements
- **Memory**: 64Mi request, 128Mi limit
- **CPU**: 50m request, 100m limit
- **Namespace**: Isolated in `argo-workflow-exec-test`

## 🐛 Troubleshooting

### Job Fails to Start
```bash
kubectl describe job argo-workflow-exec-test-job -n argo-workflow-exec-test
```

### Pod Stuck in Pending
```bash
kubectl describe pod -n argo-workflow-exec-test -l app=argo-workflow-exec
```
