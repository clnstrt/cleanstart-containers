# Disaster Recovery with Velero

This sample project demonstrates comprehensive disaster recovery scenarios using Velero plugin for AWS.

## What You'll Learn

- Full cluster disaster recovery procedures
- Cross-AZ volume restoration strategies
- Emergency backup creation and management
- Recovery time objective (RTO) optimization
- Recovery point objective (RPO) management

## Disaster Recovery Scenarios

### Scenario 1: Complete Cluster Failure
- Cluster becomes completely unavailable
- All nodes are down or unreachable
- Need to restore to a new cluster

### Scenario 2: Data Corruption
- Application data becomes corrupted
- Need to restore from a known good backup
- Point-in-time recovery

### Scenario 3: Region Failure
- AWS region becomes unavailable
- Need to restore to a different region
- Cross-region backup and restore

### Scenario 4: Partial Resource Loss
- Specific namespaces or resources are lost
- Selective recovery without full cluster restore

## Prerequisites

- Source Kubernetes cluster running
- Target Kubernetes cluster (for cross-cluster recovery)
- Velero installed on both clusters with AWS plugin
- AWS credentials configured with cross-region access
- S3 bucket accessible from both clusters
- Sample application deployed (use basic-backup-restore first)

## Pre-Disaster Preparation

### 1. Create Comprehensive Backup Strategy

```bash
# Create daily backups with retention
velero schedule create daily-backup \
  --schedule="0 2 * * *" \
  --include-namespaces=sample-app \
  --ttl=168h \
  --annotations backup-type=daily,environment=production

# Create weekly full backups
velero schedule create weekly-backup \
  --schedule="0 3 * * 0" \
  --include-namespaces=sample-app \
  --ttl=720h \
  --annotations backup-type=weekly,environment=production

# Create pre-deployment backups
velero backup create pre-deployment-backup \
  --include-namespaces=sample-app \
  --annotations backup-type=pre-deployment,environment=production
```

### 2. Test Recovery Procedures

```bash
# Test restore to a different namespace
velero restore create test-restore \
  --from-backup=pre-deployment-backup \
  --namespace-mappings sample-app:sample-app-test

# Verify test restore
kubectl get all -n sample-app-test

# Cleanup test restore
kubectl delete namespace sample-app-test
```

### 3. Document Recovery Procedures

Create a recovery runbook with:
- Contact information for key personnel
- Step-by-step recovery procedures
- Expected recovery times
- Rollback procedures

## Disaster Recovery Procedures

### Complete Cluster Recovery

#### Step 1: Assess the Situation
```bash
# Check cluster status
kubectl cluster-info
kubectl get nodes

# If cluster is completely down, proceed to recovery
```

#### Step 2: Prepare Target Cluster
```bash
# Install Velero on target cluster
velero install \
  --provider aws \
  --plugins velero/velero-plugin-for-aws \
  --bucket my-velero-backups \
  --secret-file ~/.aws/credentials \
  --backup-location-config region=us-west-2
```

#### Step 3: Restore from Latest Backup
```bash
# List available backups
velero backup get

# Get latest backup details
velero backup describe <latest-backup-name>

# Restore entire application
velero restore create disaster-recovery-restore \
  --from-backup=<latest-backup-name> \
  --namespace-mappings sample-app:sample-app \
  --wait
```

#### Step 4: Verify Recovery
```bash
# Check all resources
kubectl get all -n sample-app

# Verify application functionality
kubectl port-forward svc/sample-app-service 8080:80 -n sample-app

# Check logs for any errors
kubectl logs -l app=sample-app -n sample-app
```

### Cross-Region Recovery

#### Step 1: Create Cross-Region Backup
```bash
# Create backup with cross-region storage
velero backup create cross-region-backup \
  --include-namespaces=sample-app \
  --storage-location=aws-cross-region \
  --annotations backup-type=cross-region,environment=production
```

#### Step 2: Configure Target Region
```bash
# Create backup storage location in target region
cat <<EOF | kubectl apply -f -
apiVersion: velero.io/v1
kind: BackupStorageLocation
metadata:
  name: aws-cross-region
  namespace: velero
spec:
  provider: aws
  objectStorage:
    bucket: my-velero-backups
  config:
    region: us-east-1
EOF
```

#### Step 3: Restore in Target Region
```bash
# Restore from cross-region backup
velero restore create cross-region-restore \
  --from-backup=cross-region-backup \
  --namespace-mappings sample-app:sample-app \
  --wait
```

### Point-in-Time Recovery

#### Step 1: Identify Recovery Point
```bash
# List backups with timestamps
velero backup get --output wide

# Get backup details to find exact recovery point
velero backup describe <backup-name>
```

#### Step 2: Restore to Specific Point
```bash
# Restore from specific backup
velero restore create point-in-time-restore \
  --from-backup=<backup-name> \
  --namespace-mappings sample-app:sample-app \
  --wait
```

#### Step 3: Verify Data Integrity
```bash
# Check application data
kubectl exec -it <pod-name> -n sample-app -- cat /data/important-file

# Verify application state
kubectl get configmap sample-app-config -n sample-app -o yaml
```

## Recovery Time Optimization

### 1. Parallel Restore Operations
```bash
# Restore multiple namespaces in parallel
velero restore create parallel-restore-1 \
  --from-backup=my-backup \
  --include-namespaces=namespace1 &

velero restore create parallel-restore-2 \
  --from-backup=my-backup \
  --include-namespaces=namespace2 &

# Wait for all restores to complete
wait
```

### 2. Selective Resource Restoration
```bash
# Restore only critical resources first
velero restore create critical-restore \
  --from-backup=my-backup \
  --include-resources=deployments,services \
  --wait

# Then restore non-critical resources
velero restore create non-critical-restore \
  --from-backup=my-backup \
  --exclude-resources=deployments,services \
  --wait
```

### 3. Pre-warm Resources
```bash
# Scale up deployments immediately after restore
kubectl scale deployment sample-app-deployment --replicas=5 -n sample-app

# Pre-pull images
kubectl get pods -n sample-app -o jsonpath='{.items[*].spec.containers[*].image}' | xargs -n1 docker pull
```

## Monitoring and Validation

### 1. Health Checks
```bash
# Check pod readiness
kubectl get pods -n sample-app -o wide

# Verify service endpoints
kubectl get endpoints sample-app-service -n sample-app

# Check persistent volumes
kubectl get pv,pvc -n sample-app
```

### 2. Application Testing
```bash
# Run smoke tests
kubectl run test-pod --image=busybox --rm -it --restart=Never -- \
  wget -qO- http://sample-app-service.sample-app.svc.cluster.local

# Check application logs
kubectl logs -l app=sample-app -n sample-app --tail=100
```

### 3. Performance Validation
```bash
# Check resource usage
kubectl top pods -n sample-app

# Monitor application metrics
kubectl port-forward svc/sample-app-service 8080:80 -n sample-app
# Then access application metrics endpoint
```

## Post-Recovery Procedures

### 1. Update DNS and Load Balancers
```bash
# Update external DNS if needed
# Update load balancer configurations
# Verify external access
```

### 2. Notify Stakeholders
- Send recovery completion notification
- Provide recovery time summary
- Document lessons learned

### 3. Update Monitoring
```bash
# Re-enable monitoring and alerting
# Update dashboard configurations
# Verify alerting rules
```

## Rollback Procedures

### 1. Quick Rollback
```bash
# If recovery fails, rollback to previous state
velero restore create rollback-restore \
  --from-backup=<previous-backup> \
  --namespace-mappings sample-app:sample-app \
  --wait
```

### 2. Partial Rollback
```bash
# Rollback specific resources
velero restore create partial-rollback \
  --from-backup=<backup> \
  --include-resources=deployments \
  --wait
```

## Best Practices

### 1. Regular Testing
- Test recovery procedures monthly
- Document all test results
- Update procedures based on findings

### 2. Backup Validation
- Verify backup integrity regularly
- Test restore procedures
- Monitor backup success rates

### 3. Documentation
- Keep recovery procedures updated
- Include contact information
- Document known issues and solutions

### 4. Training
- Train team members on recovery procedures
- Conduct disaster recovery drills
- Review and update procedures regularly

## Troubleshooting

### Common Recovery Issues

1. **Volume Restore Failures**
   - Check EBS snapshot accessibility
   - Verify storage class compatibility
   - Ensure proper volume snapshot locations

2. **Resource Conflicts**
   - Check for existing resources
   - Use `--restore-velero-exclude` for conflicts
   - Review restore logs for specific errors

3. **Cross-Region Issues**
   - Verify IAM permissions
   - Check S3 bucket accessibility
   - Ensure proper backup storage locations

### Debug Commands

```bash
# Check Velero status
velero get backup-location
velero get backup-storage-location

# View detailed logs
velero restore logs <restore-name>
velero backup logs <backup-name>

# Check AWS plugin status
kubectl get pods -n velero
kubectl logs -n velero -l app=velero
```

## Next Steps

After completing disaster recovery:

1. **Set up automated backup schedules**
2. **Implement monitoring and alerting**
3. **Create runbooks for common scenarios**
4. **Train team members on procedures**
5. **Regular testing and validation**

## Additional Resources

- [Velero Disaster Recovery Guide](https://velero.io/docs/v1.11/disaster-case/)
- [AWS Cross-Region Backup](https://velero.io/docs/v1.11/aws/#cross-region-backup)
- [Recovery Time Optimization](https://velero.io/docs/v1.11/best-practices/#recovery-time-optimization)
