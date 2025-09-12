# Environment Promotion with Velero

This sample project demonstrates how to promote applications between different environments (development, staging, production) using Velero plugin for AWS.

## What You'll Learn

- Moving applications between environments
- Environment-specific configuration management
- Testing promotion workflows
- Handling environment differences
- Rollback strategies for failed promotions

## Environment Strategy

### Environment Types

1. **Development (dev)**
   - Rapid iteration and testing
   - Minimal resources
   - Frequent deployments

2. **Staging (staging)**
   - Production-like testing
   - Medium resources
   - Pre-production validation

3. **Production (prod)**
   - Live user traffic
   - Full resources
   - Stable, tested releases

## Prerequisites

- Multiple Kubernetes clusters or namespaces for different environments
- Velero installed on all environments with AWS plugin
- Sample application deployed in development environment
- AWS credentials configured with appropriate permissions
- S3 bucket accessible from all environments

## Environment Setup

### 1. Create Environment Namespaces

```bash
# Development environment
kubectl create namespace sample-app-dev
kubectl label namespace sample-app-dev environment=development

# Staging environment
kubectl create namespace sample-app-staging
kubectl label namespace sample-app-staging environment=staging

# Production environment
kubectl create namespace sample-app-prod
kubectl label namespace sample-app-prod environment=production
```

### 2. Deploy Sample Application to Development

```bash
# Deploy to development
kubectl apply -f manifests/sample-app-dev.yaml -n sample-app-dev

# Verify deployment
kubectl get all -n sample-app-dev
```

### 3. Configure Environment-Specific Settings

```bash
# Development configuration
kubectl patch configmap sample-app-config -n sample-app-dev --patch '{"data":{"environment":"development","log_level":"debug"}}'

# Staging configuration
kubectl patch configmap sample-app-config -n sample-app-staging --patch '{"data":{"environment":"staging","log_level":"info"}}'

# Production configuration
kubectl patch configmap sample-app-config -n sample-app-prod --patch '{"data":{"environment":"production","log_level":"warn"}}'
```

## Promotion Workflows

### Development to Staging Promotion

#### Step 1: Create Development Backup
```bash
# Create backup of development environment
velero backup create dev-to-staging-backup \
  --include-namespaces=sample-app-dev \
  --annotations promotion-source=development,promotion-target=staging,version=1.0.0 \
  --wait
```

#### Step 2: Verify Backup
```bash
# Check backup status
velero backup describe dev-to-staging-backup

# Verify backup contents
velero backup logs dev-to-staging-backup
```

#### Step 3: Promote to Staging
```bash
# Restore to staging environment
velero restore create dev-to-staging-promotion \
  --from-backup=dev-to-staging-backup \
  --namespace-mappings sample-app-dev:sample-app-staging \
  --annotations promotion-type=dev-to-staging,version=1.0.0 \
  --wait
```

#### Step 4: Verify Staging Promotion
```bash
# Check staging resources
kubectl get all -n sample-app-staging

# Verify configuration
kubectl get configmap sample-app-config -n sample-app-staging -o yaml

# Test application functionality
kubectl port-forward svc/sample-app-service 8081:80 -n sample-app-staging
```

### Staging to Production Promotion

#### Step 1: Create Staging Backup
```bash
# Create backup of staging environment
velero backup create staging-to-prod-backup \
  --include-namespaces=sample-app-staging \
  --annotations promotion-source=staging,promotion-target=production,version=1.0.0 \
  --wait
```

#### Step 2: Production Pre-Promotion Checks
```bash
# Verify production readiness
kubectl get nodes --label-columns=node-role.kubernetes.io/worker
kubectl get storageclass

# Check resource availability
kubectl describe nodes | grep -A 5 "Allocated resources"
```

#### Step 3: Promote to Production
```bash
# Restore to production environment
velero restore create staging-to-prod-promotion \
  --from-backup=staging-to-prod-backup \
  --namespace-mappings sample-app-staging:sample-app-prod \
  --annotations promotion-type=staging-to-production,version=1.0.0 \
  --wait
```

#### Step 4: Production Validation
```bash
# Verify production resources
kubectl get all -n sample-app-prod

# Run production smoke tests
kubectl run smoke-test --image=busybox --rm -it --restart=Never -- \
  wget -qO- http://sample-app-service.sample-app-prod.svc.cluster.local

# Check application health
kubectl get pods -n sample-app-prod -o wide
```

## Configuration Management

### Environment-Specific Configurations

#### 1. Resource Scaling
```bash
# Development: Minimal resources
kubectl patch deployment sample-app-deployment -n sample-app-dev --patch '{"spec":{"replicas":1}}'

# Staging: Medium resources
kubectl patch deployment sample-app-deployment -n sample-app-staging --patch '{"spec":{"replicas":2}}'

# Production: Full resources
kubectl patch deployment sample-app-deployment -n sample-app-prod --patch '{"spec":{"replicas":5}}'
```

#### 2. Environment Variables
```bash
# Development: Debug mode
kubectl set env deployment/sample-app-deployment -n sample-app-dev DEBUG=true LOG_LEVEL=debug

# Staging: Testing mode
kubectl set env deployment/sample-app-deployment -n sample-app-staging DEBUG=false LOG_LEVEL=info

# Production: Production mode
kubectl set env deployment/sample-app-deployment -n sample-app-prod DEBUG=false LOG_LEVEL=warn
```

#### 3. Storage Configuration
```bash
# Development: Local storage
kubectl patch pvc sample-app-pvc -n sample-app-dev --patch '{"spec":{"storageClassName":"local-storage"}}'

# Staging: Standard storage
kubectl patch pvc sample-app-pvc -n sample-app-staging --patch '{"spec":{"storageClassName":"gp2"}}'

# Production: High-performance storage
kubectl patch pvc sample-app-pvc -n sample-app-prod --patch '{"spec":{"storageClassName":"io1"}}'
```

## Promotion Testing

### 1. Pre-Promotion Validation
```bash
# Run tests in source environment
kubectl run integration-test --image=busybox --rm -it --restart=Never -- \
  wget -qO- http://sample-app-service.sample-app-dev.svc.cluster.local

# Check application health
kubectl get pods -n sample-app-dev -o wide
kubectl logs -l app=sample-app -n sample-app-dev --tail=50
```

### 2. Post-Promotion Validation
```bash
# Verify all resources are running
kubectl get all -n sample-app-staging

# Run smoke tests
kubectl run smoke-test --image=busybox --rm -it --restart=Never -- \
  wget -qO- http://sample-app-service.sample-app-staging.svc.cluster.local

# Check application logs
kubectl logs -l app=sample-app -n sample-app-staging --tail=50
```

### 3. Performance Testing
```bash
# Load testing in staging
kubectl run load-test --image=busybox --rm -it --restart=Never -- \
  for i in {1..100}; do wget -qO- http://sample-app-service.sample-app-staging.svc.cluster.local; done

# Monitor resource usage
kubectl top pods -n sample-app-staging
```

## Rollback Strategies

### 1. Quick Rollback
```bash
# If promotion fails, rollback to previous environment
velero restore create rollback-to-dev \
  --from-backup=dev-to-staging-backup \
  --namespace-mappings sample-app-dev:sample-app-staging \
  --wait
```

### 2. Partial Rollback
```bash
# Rollback specific resources
velero restore create partial-rollback \
  --from-backup=dev-to-staging-backup \
  --include-resources=deployments,services \
  --namespace-mappings sample-app-dev:sample-app-staging \
  --wait
```

### 3. Environment-Specific Rollback
```bash
# Rollback production to staging
velero restore create prod-rollback \
  --from-backup=staging-to-prod-backup \
  --namespace-mappings sample-app-staging:sample-app-prod \
  --wait
```

## Automation and CI/CD Integration

### 1. Automated Promotion Pipeline
```bash
#!/bin/bash
# promotion-pipeline.sh

ENVIRONMENT=$1
VERSION=$2

case $ENVIRONMENT in
  "staging")
    echo "Promoting to staging..."
    velero backup create dev-to-staging-backup-$VERSION \
      --include-namespaces=sample-app-dev \
      --annotations promotion-source=development,promotion-target=staging,version=$VERSION \
      --wait
    
    velero restore create dev-to-staging-promotion-$VERSION \
      --from-backup=dev-to-staging-backup-$VERSION \
      --namespace-mappings sample-app-dev:sample-app-staging \
      --wait
    ;;
  "production")
    echo "Promoting to production..."
    velero backup create staging-to-prod-backup-$VERSION \
      --include-namespaces=sample-app-staging \
      --annotations promotion-source=staging,promotion-target=production,version=$VERSION \
      --wait
    
    velero restore create staging-to-prod-promotion-$VERSION \
      --from-backup=staging-to-prod-backup-$VERSION \
      --namespace-mappings sample-app-staging:sample-app-prod \
      --wait
    ;;
  *)
    echo "Unknown environment: $ENVIRONMENT"
    exit 1
    ;;
esac
```

### 2. Promotion Validation Script
```bash
#!/bin/bash
# validate-promotion.sh

NAMESPACE=$1
ENVIRONMENT=$2

echo "Validating promotion to $ENVIRONMENT..."

# Check resource status
kubectl get all -n $NAMESPACE

# Run health checks
kubectl get pods -n $NAMESPACE -o wide

# Test application functionality
kubectl run validation-test --image=busybox --rm -it --restart=Never -- \
  wget -qO- http://sample-app-service.$NAMESPACE.svc.cluster.local

echo "Promotion validation completed for $ENVIRONMENT"
```

## Monitoring and Observability

### 1. Promotion Metrics
```bash
# Track promotion success rates
velero backup get --output json | jq '.items[] | select(.Metadata.Annotations.promotion-type) | {name: .Metadata.Name, type: .Metadata.Annotations.promotion-type, status: .Status.Phase}'

# Monitor promotion durations
velero backup describe <backup-name> --output json | jq '.Status.StartTimestamp, .Status.CompletionTimestamp'
```

### 2. Environment Health Monitoring
```bash
# Monitor all environments
for env in dev staging prod; do
  echo "=== $env Environment ==="
  kubectl get pods -n sample-app-$env -o wide
  echo ""
done
```

## Best Practices

### 1. Promotion Strategy
- Always test in staging before production
- Use blue-green deployments for zero-downtime
- Implement automated rollback triggers
- Document all promotion procedures

### 2. Configuration Management
- Use environment-specific configurations
- Implement configuration validation
- Version control all configurations
- Test configuration changes in lower environments

### 3. Testing and Validation
- Run comprehensive tests in staging
- Implement automated testing
- Use canary deployments for production
- Monitor application metrics during promotion

### 4. Documentation
- Document promotion procedures
- Maintain environment runbooks
- Record promotion history
- Document rollback procedures

## Troubleshooting

### Common Promotion Issues

1. **Resource Conflicts**
   - Check for existing resources
   - Use `--restore-velero-exclude` for conflicts
   - Clean up target environment before promotion

2. **Configuration Mismatches**
   - Verify environment-specific configurations
   - Check storage class compatibility
   - Validate resource requirements

3. **Network Issues**
   - Verify service connectivity
   - Check ingress configurations
   - Test external access

### Debug Commands

```bash
# Check promotion status
velero restore describe <restore-name>

# View promotion logs
velero restore logs <restore-name>

# Check environment resources
kubectl get all -n <namespace>

# Verify configuration
kubectl get configmap -n <namespace> -o yaml
```

## Next Steps

After completing environment promotion:

1. **Set up automated promotion pipelines**
2. **Implement comprehensive testing**
3. **Create monitoring and alerting**
4. **Document promotion procedures**
5. **Train team members on workflows**

## Additional Resources

- [Velero Namespace Mapping](https://velero.io/docs/v1.11/restore-reference/#namespace-mapping)
- [Environment Promotion Best Practices](https://velero.io/docs/v1.11/best-practices/#environment-promotion)
- [Configuration Management Strategies](https://kubernetes.io/docs/concepts/configuration/)
