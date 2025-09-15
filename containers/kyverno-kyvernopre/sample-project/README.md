# 🚀 Kyverno KyvernoPre Sample Projects

This directory contains sample projects demonstrating Kyverno policy management capabilities for Kubernetes admission control, validation, and mutation.

## 📁 Sample Projects

### 1. Basic Policies (`basic-policies/`)
- **Pod Security Policies**: Basic pod security and resource validation
- **Namespace Policies**: Namespace creation and labeling policies
- **Resource Validation**: Basic resource validation examples

### 2. Advanced Policies (`advanced-policies/`)
- **Network Policies**: Network security and isolation policies
- **RBAC Policies**: Role-based access control policies
- **Resource Quotas**: Resource quota and limit policies

### 3. Mutation Policies (`mutation-policies/`)
- **Image Tag Mutation**: Automatic image tag updates
- **Label Addition**: Automatic label injection
- **Annotation Management**: Automatic annotation handling

### 4. Generate Policies (`generate-policies/`)
- **ConfigMap Generation**: Automatic ConfigMap creation
- **Secret Generation**: Automatic secret management
- **NetworkPolicy Generation**: Automatic network policy creation

## 🚀 Quick Start

### Prerequisites
- Kubernetes cluster (1.19+)
- Kyverno installed in the cluster
- kubectl configured

### Running Sample Policies

1. **Deploy Kyverno** (if not already installed):
```bash
kubectl create -f https://github.com/kyverno/kyverno/releases/download/v1.10.2/install.yaml
```

2. **Apply Basic Policies**:
```bash
kubectl apply -f basic-policies/
```

3. **Test Policy Enforcement**:
```bash
kubectl apply -f tests/test-pod.yaml
```

4. **Check Policy Status**:
```bash
kubectl get clusterpolicies
kubectl get policies
```

## 📚 Policy Examples

### Pod Security Policy
```yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-labels
spec:
  validationFailureAction: enforce
  background: true
  rules:
  - name: check-labels
    match:
      any:
      - resources:
          kinds:
          - Pod
    validate:
      message: "Label 'app' is required"
      pattern:
        metadata:
          labels:
            app: "?*"
```

### Image Validation Policy
```yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: validate-image
spec:
  validationFailureAction: enforce
  background: true
  rules:
  - name: check-image
    match:
      any:
      - resources:
          kinds:
          - Pod
    validate:
      message: "Only approved images are allowed"
      pattern:
        spec:
          containers:
          - image: "registry.example.com/*"
```

### Resource Limits Policy
```yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-resource-limits
spec:
  validationFailureAction: enforce
  background: true
  rules:
  - name: check-resource-limits
    match:
      any:
      - resources:
          kinds:
          - Pod
    validate:
      message: "Resource limits are required"
      pattern:
        spec:
          containers:
          - resources:
              limits:
                memory: "?*"
                cpu: "?*"
```

## 🧪 Testing Policies

### Test Pod Creation
```bash
# This should be blocked by policies
kubectl apply -f tests/test-pod-no-labels.yaml

# This should be allowed
kubectl apply -f tests/test-pod-with-labels.yaml
```

### Policy Violations
```bash
# Check policy violations
kubectl get events --field-selector reason=PolicyViolation

# View policy reports
kubectl get policyreports
kubectl get clusterpolicyreports
```

## 🔧 Configuration

### Policy Configuration
- **Validation Failure Action**: `enforce` or `audit`
- **Background Processing**: Enable/disable background scanning
- **Match Conditions**: Resource selection criteria
- **Validation Rules**: Policy validation logic

### Kyverno Configuration
- **Webhook Configuration**: Admission control settings
- **Metrics**: Prometheus metrics collection
- **Logging**: Log level and format configuration

## 📊 Monitoring

### Policy Metrics
- Policy evaluation count
- Policy violation count
- Policy execution time
- Resource processing metrics

### Health Checks
- Kyverno webhook health
- Policy engine status
- Admission controller status

## 🛠️ Troubleshooting

### Common Issues
1. **Policy Not Applied**: Check policy syntax and match conditions
2. **Webhook Errors**: Verify Kyverno installation and configuration
3. **Resource Blocked**: Check policy validation rules and messages

### Debug Commands
```bash
# Check Kyverno logs
kubectl logs -n kyverno -l app.kubernetes.io/name=kyverno

# Verify webhook configuration
kubectl get validatingwebhookconfigurations kyverno-resource-validating-webhook-cfg

# Check policy status
kubectl describe clusterpolicy require-labels
```

## 📚 Resources

- [Kyverno Documentation](https://kyverno.io/docs/)
- [Policy Examples](https://github.com/kyverno/policies)
- [CleanStart Website](https://www.cleanstart.com/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Adding new policy examples
- Improving documentation
- Reporting issues
- Suggesting new features

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
