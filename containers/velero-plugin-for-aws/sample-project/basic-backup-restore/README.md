# Basic Backup & Restore

This sample project demonstrates the fundamental backup and restore operations using Velero plugin for AWS.

## 🚀 **Quick Setup (3 Minutes)**

### **Prerequisites Check**
```bash
# Check if Velero CLI is available
velero version

# Check if kubectl is configured
kubectl cluster-info

# Check if you have a Kubernetes cluster running
kubectl get nodes
```

### **Quick Test**
```bash
# 1. Deploy sample application
kubectl apply -f manifests/sample-app.yaml

# 2. Wait for pods to be ready
kubectl wait --for=condition=ready pod -l app=sample-app -n sample-app --timeout=300s

# 3. Run backup script
cd scripts/
./backup.sh

# 4. Test restore functionality
./restore.sh
```

## 📚 **What You'll Learn**

- Creating your first backup
- Managing backup resources
- Restoring applications from backups
- Working with namespaces and resource selection
- Basic troubleshooting

## 🛠️ **Prerequisites**

- Kubernetes cluster running
- Velero installed with AWS plugin
- AWS credentials configured
- S3 bucket accessible
- Sample application deployed (we'll create one)

## Step 1: Deploy Sample Application

First, let's deploy a simple web application to backup:

```bash
# Create namespace
kubectl create namespace sample-app

# Deploy sample application
kubectl apply -f manifests/sample-app.yaml -n sample-app

# Verify deployment
kubectl get all -n sample-app
```

## Step 2: Create Your First Backup

```bash
# Create a backup of the entire sample-app namespace
velero backup create sample-app-backup --include-namespaces=sample-app

# Check backup status
velero backup describe sample-app-backup

# List all backups
velero backup get
```

## Step 3: Simulate Data Loss

Let's simulate a disaster by deleting the application:

```bash
# Delete the namespace (this will remove all resources)
kubectl delete namespace sample-app

# Verify everything is gone
kubectl get all -n sample-app
# This should show "namespace not found"
```

## Step 4: Restore from Backup

Now let's restore the application from our backup:

```bash
# Restore the entire namespace from backup
velero restore create sample-app-restore --from-backup=sample-app-backup

# Check restore status
velero restore describe sample-app-restore

# Wait for restore to complete, then verify
kubectl get all -n sample-app
```

## Step 5: Verify Restoration

```bash
# Check if all resources are restored
kubectl get pods,svc,deploy -n sample-app

# Test the application (if it has a service)
kubectl port-forward svc/sample-app-service 8080:80 -n sample-app
# Then visit http://localhost:8080 in your browser
```

## Advanced Backup Options

### Selective Backup

```bash
# Backup only specific resources
velero backup create selective-backup \
  --include-namespaces=sample-app \
  --include-resources=deployments,services

# Backup excluding certain resources
velero backup create filtered-backup \
  --include-namespaces=sample-app \
  --exclude-resources=secrets,configmaps
```

### Label-Based Backup

```bash
# Backup resources with specific labels
velero backup create labeled-backup \
  --include-namespaces=sample-app \
  --selector app=sample-app
```

### Backup with Annotations

```bash
# Add custom annotations to backup
velero backup create annotated-backup \
  --include-namespaces=sample-app \
  --annotations backup-type=daily,environment=development
```

## Restore Options

### Selective Restore

```bash
# Restore only specific resources
velero restore create selective-restore \
  --from-backup=sample-app-backup \
  --include-resources=deployments,services

# Restore to different namespace
velero restore create namespace-restore \
  --from-backup=sample-app-backup \
  --namespace-mappings sample-app:sample-app-restored
```

### Restore with Filters

```bash
# Restore excluding certain resources
velero restore create filtered-restore \
  --from-backup=sample-app-backup \
  --exclude-resources=secrets,configmaps
```

## Monitoring and Management

### Check Backup Status

```bash
# Get detailed backup information
velero backup describe sample-app-backup

# Check backup logs
velero backup logs sample-app-backup

# List backup storage locations
velero get backup-storage-location
```

### Check Restore Status

```bash
# Get detailed restore information
velero restore describe sample-app-restore

# Check restore logs
velero restore logs sample-app-restore

# List all restores
velero restore get
```

## Cleanup

```bash
# Delete the backup (this removes it from S3)
velero backup delete sample-app-backup

# Delete the restore
velero restore delete sample-app-restore

# Remove the sample application
kubectl delete namespace sample-app
```

## Troubleshooting

### Common Issues

1. **Backup fails with AWS errors**
   - Verify AWS credentials and permissions
   - Check S3 bucket accessibility
   - Ensure proper IAM roles

2. **Restore fails with resource conflicts**
   - Check if resources already exist
   - Use `--restore-velero-exclude` to skip conflicting resources
   - Review restore logs for specific errors

3. **Volume restore issues**
   - Verify EBS snapshots are accessible
   - Check storage class compatibility
   - Ensure proper volume snapshot locations

### Debug Commands

```bash
# Check Velero installation
velero get backup-location
velero get backup-storage-location

# Check AWS plugin status
kubectl get pods -n velero

# View Velero logs
kubectl logs -n velero -l app=velero
```

## Next Steps

After completing this basic project:

1. **Explore Disaster Recovery** - Learn full cluster recovery
2. **Try Environment Promotion** - Move apps between environments
3. **Practice Cluster Migration** - Work with multiple clusters
4. **Set up Compliance Backups** - Automate backup scheduling

## Files in This Project

- `manifests/sample-app.yaml` - Sample application to backup
- `scripts/backup.sh` - Automated backup script
- `scripts/restore.sh` - Automated restore script
- `scripts/cleanup.sh` - Cleanup and verification script

## Additional Resources

- [Velero CLI Reference](https://velero.io/docs/v1.11/cli-reference/)
- [AWS Plugin Configuration](https://velero.io/docs/v1.11/aws/)
- [Backup and Restore Best Practices](https://velero.io/docs/v1.11/best-practices/)
