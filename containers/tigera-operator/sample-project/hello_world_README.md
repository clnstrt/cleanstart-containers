# 🚀 Tigera Operator Hello World

Welcome to the Tigera Operator Hello World example! This simple example demonstrates how to get started with Tigera Operator and Calico networking.

## 📋 What is Tigera Operator?

Tigera Operator is the official operator for managing Calico networking, security, and observability in Kubernetes clusters. It provides:

- **Calico Management**: Automated Calico installation and configuration
- **Network Policies**: Advanced network security policies
- **BGP Support**: Border Gateway Protocol for advanced routing
- **Observability**: Monitoring and metrics collection
- **Multi-Cluster**: Cross-cluster networking capabilities

## 🚀 Quick Start

### Prerequisites

- Kubernetes cluster (v1.21+)
- kubectl configured
- Tigera Operator installed

### Running the Hello World

1. **Apply the hello world resources:**
   ```bash
   kubectl apply -f hello_world.yaml
   ```

2. **Check deployment status:**
   ```bash
   kubectl get pods -n hello-world-namespace
   ```

3. **Test network policies:**
   ```bash
   # Check network policies
   kubectl get networkpolicies -n hello-world-namespace
   
   # Check global network policies
   kubectl get globalnetworkpolicies
   ```

4. **Run test script:**
   ```bash
   # Make script executable
   chmod +x test-calico.sh
   
   # Run test script
   ./test-calico.sh
   ```

## 📊 What the Hello World Does

The `hello_world.yaml` file demonstrates:

1. **Namespace Creation**: Creates a dedicated namespace for testing
2. **Network Policy**: Creates a basic network policy for the namespace
3. **Application Deployment**: Deploys a simple nginx application
4. **Service Creation**: Exposes the application via service
5. **Global Network Policy**: Creates a cluster-wide network policy
6. **Test Script**: Includes a script to test Calico functionality

## 🔧 Configuration

### Network Policy
```yaml
apiVersion: projectcalico.org/v3
kind: NetworkPolicy
metadata:
  name: hello-world-policy
  namespace: hello-world-namespace
spec:
  ingress:
  - action: Allow
    protocol: UDP
    source:
      namespaceSelector: has(projectcalico.org/name)
    destination:
      ports:
      - 53  # DNS
  - action: Allow
    protocol: TCP
    destination:
      ports:
      - 80  # HTTP
      - 443 # HTTPS
```

### Global Network Policy
```yaml
apiVersion: projectcalico.org/v3
kind: GlobalNetworkPolicy
metadata:
  name: hello-world-global-policy
spec:
  namespaceSelector: all()
  types:
  - Ingress
  - Egress
  ingress:
  - action: Allow
    source:
      namespaceSelector: has(projectcalico.org/name)
```

## 🛡️ Network Security

### Policy Types
- **NetworkPolicy**: Namespace-scoped policies
- **GlobalNetworkPolicy**: Cluster-wide policies
- **StagedGlobalNetworkPolicy**: Staged global policies

### Policy Actions
- **Allow**: Permit traffic
- **Deny**: Block traffic
- **Log**: Log traffic (for monitoring)

### Selectors
- **namespaceSelector**: Select by namespace labels
- **podSelector**: Select by pod labels
- **serviceSelector**: Select by service labels

## 🔍 Testing Calico Functionality

### Check Calico Status
```bash
# Check Calico pods
kubectl get pods -n calico-system

# Check Calico nodes
kubectl get nodes -l kubernetes.io/os=linux

# Check Calico configuration
kubectl get installation default -o yaml
```

### Test Network Policies
```bash
# Test pod connectivity
kubectl run test-pod --image=busybox:latest --rm -i --restart=Never -n hello-world-namespace -- nslookup kubernetes.default.svc.cluster.local

# Test HTTP connectivity
kubectl run test-pod --image=busybox:latest --rm -i --restart=Never -n hello-world-namespace -- wget -qO- hello-world-service
```

### Monitor Network Traffic
```bash
# Check Calico logs
kubectl logs -n calico-system -l k8s-app=calico-node

# Check policy enforcement
kubectl get events --field-selector reason=PolicyViolation
```

## 🛠️ Key Features Demonstrated

- **Network Policies**: Namespace and global network policies
- **Pod Security**: Network-level pod security
- **Service Mesh**: Basic service mesh capabilities
- **DNS Resolution**: DNS traffic management
- **HTTP/HTTPS**: Web traffic management

## 📚 Next Steps

1. **Explore Basic Setup**: Check out `basic-setup/` for complete installation
2. **Advanced Networking**: See `advanced-networking/` for BGP configuration
3. **Security Policies**: Review `security-policies/` for advanced security
4. **Monitoring**: Use `monitoring/` for observability setup

## 🔧 Configuration Options

### Tigera Operator Installation
```bash
# Install via Helm
helm repo add tigera-operator https://docs.tigera.io/calico/latest/operations/install
helm install tigera-operator tigera-operator/tigera-operator

# Or via kubectl
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.4/manifests/tigera-operator.yaml
```

### Calico Installation
```bash
# Install Calico
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.4/manifests/calico.yaml
```

## 🆘 Troubleshooting

### Common Issues

1. **Pods Not Starting**: Check Calico installation
2. **Network Policies Not Working**: Verify Calico configuration
3. **DNS Resolution Issues**: Check DNS policy configuration

### Debug Commands

```bash
# Check Tigera Operator status
kubectl get pods -n tigera-operator

# Check Calico status
kubectl get pods -n calico-system

# View Calico logs
kubectl logs -n calico-system -l k8s-app=calico-node

# Check network policies
kubectl get networkpolicies --all-namespaces
```

## 📖 Learn More

- [Tigera Operator Documentation](https://docs.tigera.io/calico/latest/operations/install)
- [Calico Documentation](https://docs.tigera.io/calico/latest/about)
- [Network Policies Guide](https://docs.tigera.io/calico/latest/security/calico-network-policy)

## 🎯 Use Cases

Tigera Operator is perfect for:

- **Network Security**: Advanced network policies
- **Multi-Cluster**: Cross-cluster networking
- **Service Mesh**: Service-to-service communication
- **Compliance**: Regulatory compliance requirements
- **Observability**: Network monitoring and metrics
- **Automation**: Automated network management

---

**Happy Networking with Calico!** 🌐
