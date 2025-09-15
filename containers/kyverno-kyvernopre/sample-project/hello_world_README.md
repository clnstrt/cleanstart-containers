# 🚀 Kyverno Hello World

Welcome to the Kyverno Hello World example! This simple example demonstrates how to get started with Kyverno for Kubernetes policy management.

## 📋 What is Kyverno?

Kyverno is a policy engine designed specifically for Kubernetes. It provides:

- **Policy as Code**: Define policies using YAML
- **Validation**: Enforce policies on Kubernetes resources
- **Mutation**: Automatically modify resources
- **Generation**: Create additional resources
- **RBAC Integration**: Works with Kubernetes RBAC

## 🚀 Quick Start

### Prerequisites

- Kubernetes cluster (v1.14+)
- kubectl configured
- Kyverno installed

### Running the Hello World

1. **Apply the hello world policy:**
   ```bash
   kubectl apply -f hello_world.yaml
   ```

2. **Test with valid pod:**
   ```bash
   kubectl apply -f - <<EOF
   apiVersion: v1
   kind: Pod
   metadata:
     name: test-pod-valid
     labels:
       hello-world: "true"
   spec:
     containers:
     - name: test
       image: busybox:latest
       command: ["echo", "Hello, Kyverno!"]
   EOF
   ```

3. **Test with invalid pod (should be rejected):**
   ```bash
   kubectl apply -f - <<EOF
   apiVersion: v1
   kind: Pod
   metadata:
     name: test-pod-invalid
     labels:
       app: test
       # Missing hello-world label
   spec:
     containers:
     - name: test
       image: busybox:latest
       command: ["echo", "This should be rejected!"]
   EOF
   ```

## 📊 What the Hello World Does

The `hello_world.yaml` file demonstrates:

1. **Policy Creation**: Creates a simple validation policy
2. **Resource Matching**: Matches all Pod resources
3. **Validation Rules**: Ensures pods have required labels
4. **Test Cases**: Includes valid and invalid examples
5. **Policy Enforcement**: Shows how policies block invalid resources

## 🔧 Policy Structure

### ClusterPolicy
```yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: hello-world-policy
spec:
  validationFailureAction: enforce
  background: true
  rules:
  - name: require-hello-world-label
    match:
      any:
      - resources:
          kinds:
          - Pod
    validate:
      message: "All pods must have a hello-world label"
      pattern:
        metadata:
          labels:
            hello-world: "true"
```

### Key Components

- **validationFailureAction**: `enforce` blocks invalid resources
- **background**: Policy runs in background mode
- **match**: Specifies which resources to apply policy to
- **validate**: Defines validation rules
- **pattern**: Specifies required resource structure

## 🎯 Policy Rules

### Validation Rule
The policy enforces that all pods must have:
```yaml
metadata:
  labels:
    hello-world: "true"
```

### Test Cases

1. **Valid Pod**: Has `hello-world: "true"` label ✅
2. **Invalid Pod**: Missing `hello-world` label ❌

## 🔍 Testing the Policy

### Check Policy Status
```bash
kubectl get clusterpolicy hello-world-policy
```

### View Policy Details
```bash
kubectl describe clusterpolicy hello-world-policy
```

### Test Policy Violations
```bash
# This should be rejected
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: invalid-pod
spec:
  containers:
  - name: test
    image: busybox:latest
EOF
```

## 🛠️ Key Features Demonstrated

- **Policy Definition**: YAML-based policy creation
- **Resource Matching**: Target specific Kubernetes resources
- **Validation**: Enforce resource requirements
- **Error Messages**: Clear policy violation messages
- **Test Cases**: Valid and invalid examples

## 📚 Next Steps

1. **Explore Basic Policies**: Check out `basic-policies/` for more examples
2. **Advanced Policies**: Learn about mutations and generations
3. **Policy Testing**: Use Kyverno CLI for policy testing
4. **Production Policies**: Implement security and compliance policies

## 🔧 Configuration

The hello world policy uses:

- **Policy Type**: ClusterPolicy (cluster-wide)
- **Action**: enforce (block invalid resources)
- **Background**: true (continuous monitoring)
- **Target**: Pod resources

## 🆘 Troubleshooting

### Common Issues

1. **Policy Not Applied**: Check Kyverno installation
2. **Resources Not Blocked**: Verify policy syntax
3. **Permission Denied**: Check RBAC permissions

### Debug Commands

```bash
# Check Kyverno installation
kubectl get pods -n kyverno

# View policy violations
kubectl get events --field-selector reason=PolicyViolation

# Test policy with CLI
kyverno test hello_world.yaml
```

## 📖 Learn More

- [Kyverno Documentation](https://kyverno.io/docs/)
- [Policy Examples](https://kyverno.io/policies/)
- [Kyverno CLI](https://kyverno.io/docs/kyverno-cli/)

## 🎯 Use Cases

Kyverno is perfect for:

- **Security Policies**: Enforce security requirements
- **Compliance**: Meet regulatory requirements
- **Best Practices**: Enforce Kubernetes best practices
- **Resource Validation**: Validate resource configurations
- **Automation**: Automatically modify resources
- **Governance**: Implement organizational policies

---

**Happy Policy Management with Kyverno!** 🛡️
