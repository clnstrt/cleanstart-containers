# Basic Layer 2 MetalLB Setup

This example demonstrates a simple Layer 2 MetalLB configuration, perfect for getting started with load balancer services in Kubernetes.

## 🎯 What This Example Does

- Configures MetalLB with Layer 2 mode
- Sets up an IP address pool for LoadBalancer services
- Deploys a sample NGINX application
- Exposes the application using a LoadBalancer service
- Demonstrates automatic IP assignment

## 📋 Prerequisites

- Kubernetes cluster (local or remote)
- kubectl configured to access your cluster
- Network access to the IP range you'll use (192.168.1.240-192.168.1.250)

## 🚀 Quick Start

### Step 1: Deploy MetalLB
```bash
# Deploy MetalLB controller and speaker
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.2/config/manifests/metallb-native.yaml

# Wait for MetalLB to be ready
kubectl wait --for=condition=ready pod -l app=metallb -n metallb-system --timeout=60s
```

### Step 2: Configure Layer 2 Mode
```bash
# Apply the Layer 2 configuration
kubectl apply -f metallb-config.yaml

# Verify the configuration
kubectl get ipaddresspools -n metallb-system
kubectl get l2advertisements -n metallb-system
```

### Step 3: Deploy Sample Application
```bash
# Deploy NGINX application
kubectl apply -f sample-app.yaml

# Check the LoadBalancer service
kubectl get services
```

### Step 4: Test the Setup
```bash
# Get the external IP
EXTERNAL_IP=$(kubectl get service nginx-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Test the connection
curl http://$EXTERNAL_IP

# Or use the test script
chmod +x test-connection.sh
./test-connection.sh
```

## 📁 Files Explained

### `metallb-config.yaml`
Contains the MetalLB Layer 2 configuration:
- **IPAddressPool**: Defines the IP address range (192.168.1.240-192.168.1.250)
- **L2Advertisement**: Configures Layer 2 advertisement for the IP pool

### `sample-app.yaml`
Contains a complete sample application:
- **Deployment**: NGINX deployment with 3 replicas
- **Service**: LoadBalancer service that will get an external IP

### `test-connection.sh`
Script to test the LoadBalancer service:
- Waits for IP assignment
- Tests HTTP connectivity
- Displays service information

## 🔧 Configuration Details

### IP Address Pool
```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.1.240-192.168.1.250
```

### Layer 2 Advertisement
```yaml
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: example
  namespace: metallb-system
spec:
  ipAddressPools:
  - first-pool
```

## 🧪 Testing

### Manual Testing
```bash
# Check if IP is assigned
kubectl get service nginx-service

# Test HTTP response
curl -I http://<EXTERNAL_IP>

# Check MetalLB logs
kubectl logs -n metallb-system deployment/metallb-controller
kubectl logs -n metallb-system daemonset/metallb-speaker
```

### Automated Testing
```bash
# Run the test script
./test-connection.sh
```

## 🔍 Troubleshooting

### Common Issues

**No external IP assigned**
```bash
# Check MetalLB status
kubectl get pods -n metallb-system

# Check IP address pool
kubectl describe ipaddresspool first-pool -n metallb-system

# Check L2 advertisement
kubectl describe l2advertisement example -n metallb-system
```

**Cannot access the service**
```bash
# Check if IP is in the correct range
kubectl get service nginx-service -o wide

# Verify network connectivity
ping <EXTERNAL_IP>

# Check service endpoints
kubectl get endpoints nginx-service
```

**MetalLB pods not ready**
```bash
# Check pod status
kubectl get pods -n metallb-system

# Check pod logs
kubectl logs -n metallb-system deployment/metallb-controller
kubectl logs -n metallb-system daemonset/metallb-speaker

# Check node labels
kubectl get nodes --show-labels
```

## 📊 Expected Output

After successful deployment, you should see:

```bash
$ kubectl get services
NAME            TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)        AGE
nginx-service   LoadBalancer   10.96.123.45    192.168.1.240    80:32456/TCP   2m

$ curl http://192.168.1.240
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
...
```

## 🎯 Next Steps

1. **Try different applications** - Deploy other services with LoadBalancer type
2. **Configure multiple pools** - Set up different IP pools for different services
3. **Explore BGP mode** - Try the BGP configuration example
4. **Add monitoring** - Set up Prometheus monitoring for MetalLB

## 🔗 Related Examples

- [BGP Setup](../bgp-setup/) - Advanced BGP configuration
- [Multi-Pool Setup](../multi-pool/) - Multiple IP address pools
- [Production Setup](../production/) - Production-ready configuration

---

**Happy Load Balancing! ⚖️**
