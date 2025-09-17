# Cluster Migration with Velero

This sample project demonstrates how to migrate workloads between different Kubernetes clusters or AWS regions using Velero plugin for AWS.

## What You'll Learn

- Cross-cluster backup and restore operations
- Multi-region migration strategies
- Handling cluster-specific configurations
- Migration validation and testing
- Rollback procedures for failed migrations

## Migration Scenarios

### Scenario 1: Same Region, Different Cluster
- Moving workloads between clusters in the same AWS region
- Shared S3 bucket for backup storage
- Similar infrastructure and configurations

### Scenario 2: Cross-Region Migration
- Moving workloads between different AWS regions
- Cross-region S3 bucket replication
- Handling region-specific configurations

### Scenario 3: Multi-Cluster Architecture
- Distributing workloads across multiple clusters
- Load balancing and traffic management
- Disaster recovery considerations

### Scenario 4: Cloud Migration
- Moving from on-premises to AWS
- Hybrid cloud configurations
- Network connectivity and security

## Prerequisites

- Source Kubernetes cluster running
- Target Kubernetes cluster ready
- Velero installed on both clusters with AWS plugin
- AWS credentials configured with cross-region access
- S3 bucket accessible from both clusters
- Sample application deployed in source cluster

## Pre-Migration Preparation

### 1. Source Cluster Assessment

#### Inventory Current Resources
```bash
# List all namespaces
kubectl get namespaces

# List all resources in target namespace
kubectl get all -n sample-app

# Check persistent volumes
kubectl get pv,pvc -n sample-app

# List ConfigMaps and Secrets
kubectl get configmap,secret -n sample-app

# Check storage classes
kubectl get storageclass
```

#### Document Cluster Configuration
```bash
# Export cluster configuration
kubectl config view --minify --flatten > source-cluster-config.yaml

# Export storage classes
kubectl get storageclass -o yaml > source-storage-classes.yaml

# Export namespace configuration
kubectl get namespace sample-app -o yaml > source-namespace.yaml
```

### 2. Target Cluster Preparation

#### Verify Target Cluster Readiness
```bash
# Check cluster status
kubectl cluster-info

# Verify node resources
kubectl get nodes -o wide

# Check available storage classes
kubectl get storageclass

# Verify Velero installation
velero get backup-location
velero get backup-storage-location
```

#### Prepare Target Environment
```bash
# Create target namespace
kubectl create namespace sample-app

# Apply storage classes if needed
kubectl apply -f target-storage-classes.yaml

# Configure backup storage location
kubectl apply -f target-backup-storage.yaml
```

## Migration Workflows

### Same Region Migration

#### Step 1: Create Source Backup
```bash
# Create comprehensive backup
velero backup create cluster-migration-backup \
  --include-namespaces=sample-app \
  --include-resources=* \
  --annotations migration-source=cluster1,migration-target=cluster2,region=us-west-2 \
  --wait
```

#### Step 2: Verify Backup
```bash
# Check backup status
velero backup describe cluster-migration-backup

# Verify backup contents
velero backup logs cluster-migration-backup

# List backup resources
velero backup describe cluster-migration-backup --output json | jq '.Spec.IncludedResources'
```

#### Step 3: Restore to Target Cluster
```bash
# Switch to target cluster context
kubectl config use-context target-cluster

# Restore from backup
velero restore create cluster-migration-restore \
  --from-backup=cluster-migration-backup \
  --namespace-mappings sample-app:sample-app \
  --annotations migration-type=same-region,source=cluster1,target=cluster2 \
  --wait
```

#### Step 4: Verify Migration
```bash
# Check restored resources
kubectl get all -n sample-app

# Verify persistent volumes
kubectl get pv,pvc -n sample-app

# Test application functionality
kubectl port-forward svc/sample-app-service 8080:80 -n sample-app
```

### Cross-Region Migration

#### Step 1: Configure Cross-Region Backup Storage
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

#### Step 2: Create Cross-Region Backup
```bash
# Create backup with cross-region storage
velero backup create cross-region-migration \
  --include-namespaces=sample-app \
  --storage-location=aws-cross-region \
  --annotations migration-type=cross-region,source=us-west-2,target=us-east-1 \
  --wait
```

#### Step 3: Restore in Target Region
```bash
# Switch to target region cluster
kubectl config use-context target-region-cluster

# Restore from cross-region backup
velero restore create cross-region-restore \
  --from-backup=cross-region-migration \
  --namespace-mappings sample-app:sample-app \
  --annotations migration-type=cross-region,source=us-west-2,target=us-east-1 \
  --wait
```

#### Step 4: Handle Region-Specific Configurations
```bash
# Update region-specific configurations
kubectl patch configmap sample-app-config -n sample-app --patch '{"data":{"aws_region":"us-east-1"}}'

# Update storage classes for target region
kubectl patch pvc sample-app-pvc -n sample-app --patch '{"spec":{"storageClassName":"gp2"}}'

# Update ingress configurations
kubectl patch ingress sample-app-ingress -n sample-app --patch '{"spec":{"rules":[{"host":"sample-app.us-east-1.example.com"}]}}'
```

## Advanced Migration Strategies

### 1. Blue-Green Migration

#### Step 1: Deploy Blue Environment
```bash
# Deploy application to blue namespace
velero restore create blue-deployment \
  --from-backup=cluster-migration-backup \
  --namespace-mappings sample-app:sample-app-blue \
  --wait
```

#### Step 2: Test Blue Environment
```bash
# Verify blue deployment
kubectl get all -n sample-app-blue

# Run comprehensive tests
kubectl run migration-test --image=busybox --rm -it --restart=Never -- \
  wget -qO- http://sample-app-service.sample-app-blue.svc.cluster.local

# Check application logs
kubectl logs -l app=sample-app -n sample-app-blue --tail=100
```

#### Step 3: Switch Traffic to Blue
```bash
# Update ingress to point to blue environment
kubectl patch ingress sample-app-ingress --patch '{"spec":{"rules":[{"host":"sample-app.example.com","http":{"paths":[{"path":"/","pathType":"Prefix","backend":{"service":{"name":"sample-app-service-blue","port":{"number":80}}}}]}}]}}'

# Verify traffic routing
curl -H "Host: sample-app.example.com" http://localhost:8080
```

#### Step 4: Cleanup Green Environment
```bash
# Remove old green environment
kubectl delete namespace sample-app

# Verify cleanup
kubectl get namespaces | grep sample-app
```

### 2. Canary Migration

#### Step 1: Deploy Canary
```bash
# Deploy small percentage of traffic to new cluster
velero restore create canary-deployment \
  --from-backup=cluster-migration-backup \
  --namespace-mappings sample-app:sample-app-canary \
  --wait

# Scale down canary deployment
kubectl scale deployment sample-app-deployment --replicas=1 -n sample-app-canary
```

#### Step 2: Gradual Traffic Shift
```bash
# Update ingress to route 10% traffic to canary
kubectl patch ingress sample-app-ingress --patch '{"spec":{"rules":[{"host":"sample-app.example.com","http":{"paths":[{"path":"/","pathType":"Prefix","backend":{"service":{"name":"sample-app-service","port":{"number":80}}}},{"path":"/canary","pathType":"Prefix","backend":{"service":{"name":"sample-app-service-canary","port":{"number":80}}}}]}}]}}'
```

#### Step 3: Monitor and Scale
```bash
# Monitor canary performance
kubectl top pods -n sample-app-canary

# Check application metrics
kubectl logs -l app=sample-app -n sample-app-canary --tail=50

# Gradually increase canary traffic
kubectl scale deployment sample-app-deployment --replicas=3 -n sample-app-canary
```

### 3. Rolling Migration

#### Step 1: Migrate Non-Critical Resources
```bash
# Migrate ConfigMaps and Secrets first
velero restore create config-migration \
  --from-backup=cluster-migration-backup \
  --include-resources=configmaps,secrets \
  --namespace-mappings sample-app:sample-app \
  --wait
```

#### Step 2: Migrate Data Layer
```bash
# Migrate persistent volumes
velero restore create data-migration \
  --from-backup=cluster-migration-backup \
  --include-resources=persistentvolumeclaims \
  --namespace-mappings sample-app:sample-app \
  --wait
```

#### Step 3: Migrate Application Layer
```bash
# Migrate deployments and services
velero restore create app-migration \
  --from-backup=cluster-migration-backup \
  --include-resources=deployments,services \
  --namespace-mappings sample-app:sample-app \
  --wait
```

## Migration Validation

### 1. Resource Verification

#### Check All Resources
```bash
# Verify complete migration
kubectl get all -n sample-app

# Check persistent volumes
kubectl get pv,pvc -n sample-app

# Verify ConfigMaps and Secrets
kubectl get configmap,secret -n sample-app

# Check ingress and services
kubectl get ingress,svc -n sample-app
```

#### Validate Resource States
```bash
# Check pod readiness
kubectl get pods -n sample-app -o wide

# Verify service endpoints
kubectl get endpoints sample-app-service -n sample-app

# Check persistent volume status
kubectl get pv,pvc -n sample-app -o wide
```

### 2. Application Testing

#### Functional Testing
```bash
# Test application connectivity
kubectl run connectivity-test --image=busybox --rm -it --restart=Never -- \
  wget -qO- http://sample-app-service.sample-app.svc.cluster.local

# Test external access
kubectl port-forward svc/sample-app-service 8080:80 -n sample-app
# Then test in browser: http://localhost:8080
```

#### Performance Testing
```bash
# Load testing
kubectl run load-test --image=busybox --rm -it --restart=Never -- \
  for i in {1..100}; do wget -qO- http://sample-app-service.sample-app.svc.cluster.local; done

# Monitor resource usage
kubectl top pods -n sample-app
```

### 3. Data Integrity Verification

#### Verify Data Consistency
```bash
# Check application data
kubectl exec -it <pod-name> -n sample-app -- cat /data/important-file

# Verify configuration
kubectl get configmap sample-app-config -n sample-app -o yaml

# Check secrets
kubectl get secret sample-app-secret -n sample-app -o yaml
```

## Rollback Procedures

### 1. Quick Rollback
```bash
# If migration fails, rollback to source cluster
kubectl config use-context source-cluster

# Verify source environment is intact
kubectl get all -n sample-app

# Update DNS/ingress to point back to source
```

### 2. Partial Rollback
```bash
# Rollback specific failed components
velero restore create partial-rollback \
  --from-backup=cluster-migration-backup \
  --include-resources=deployments,services \
  --namespace-mappings sample-app:sample-app \
  --wait
```

### 3. Full Rollback
```bash
# Complete rollback to source state
kubectl delete namespace sample-app

# Restore from source backup
velero restore create full-rollback \
  --from-backup=source-backup \
  --namespace-mappings sample-app:sample-app \
  --wait
```

## Post-Migration Tasks

### 1. Update External Configurations
```bash
# Update DNS records
# Update load balancer configurations
# Update monitoring and alerting
# Update CI/CD pipelines
```

### 2. Performance Optimization
```bash
# Scale resources based on new environment
kubectl scale deployment sample-app-deployment --replicas=5 -n sample-app

# Optimize resource requests/limits
kubectl patch deployment sample-app-deployment --patch '{"spec":{"template":{"spec":{"containers":[{"name":"sample-app","resources":{"requests":{"memory":"128Mi","cpu":"250m"},"limits":{"memory":"256Mi","cpu":"500m"}}}]}}}}'
```

### 3. Monitoring and Validation
```bash
# Set up monitoring for new environment
# Configure alerting rules
# Create dashboards
# Set up log aggregation
```

## Best Practices

### 1. Migration Planning
- Document all migration steps
- Test migration procedures
- Plan rollback strategies
- Coordinate with stakeholders

### 2. Data Safety
- Create multiple backups
- Verify backup integrity
- Test restore procedures
- Maintain data consistency

### 3. Network and Security
- Verify network connectivity
- Update security groups
- Configure firewalls
- Test access controls

### 4. Performance and Monitoring
- Monitor migration progress
- Track performance metrics
- Set up alerting
- Document lessons learned

## Troubleshooting

### Common Migration Issues

1. **Storage Class Mismatches**
   - Verify storage class availability
   - Update PVC specifications
   - Check storage class compatibility

2. **Network Connectivity**
   - Verify service endpoints
   - Check ingress configurations
   - Test external access

3. **Resource Conflicts**
   - Check for existing resources
   - Use `--restore-velero-exclude` for conflicts
   - Clean up target environment

### Debug Commands

```bash
# Check migration status
velero restore describe <restore-name>

# View migration logs
velero restore logs <restore-name>

# Check resource status
kubectl get all -n <namespace>

# Verify configurations
kubectl get configmap,secret -n <namespace> -o yaml
```

## Next Steps

After completing cluster migration:

1. **Set up monitoring and alerting**
2. **Optimize performance**
3. **Document migration procedures**
4. **Train team members**
5. **Plan future migrations**

## Additional Resources

- [Velero Cross-Cluster Migration](https://velero.io/docs/v1.11/migration-case/)
- [AWS Cross-Region Backup](https://velero.io/docs/v1.11/aws/#cross-region-backup)
- [Kubernetes Multi-Cluster Management](https://kubernetes.io/docs/concepts/cluster-administration/multicluster/)
- [AWS Multi-Region Strategies](https://aws.amazon.com/solutions/implementations/multi-region-architecture/)
