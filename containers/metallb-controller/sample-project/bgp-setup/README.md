# BGP MetalLB Setup

This example demonstrates BGP-based MetalLB configuration for enterprise environments with BGP-capable network infrastructure.

## 🎯 What This Example Does

- Configures MetalLB with BGP mode
- Sets up BGP peer connections
- Configures BGP advertisements for IP pools
- Deploys sample applications for testing
- Demonstrates enterprise-grade load balancing

## 📋 Prerequisites

- Kubernetes cluster with BGP-capable nodes
- BGP router/switch with BGP peer configuration
- Network access to BGP peers
- Understanding of BGP routing protocols
- Proper network segmentation

## 🚀 Quick Start

### Step 1: Deploy MetalLB
```bash
# Deploy MetalLB controller and speaker
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.2/config/manifests/metallb-native.yaml

# Wait for MetalLB to be ready
kubectl wait --for=condition=ready pod -l app=metallb -n metallb-system --timeout=60s
```

### Step 2: Configure BGP Mode
```bash
# Apply the BGP configuration
kubectl apply -f bgp-config.yaml

# Verify the configuration
kubectl get ipaddresspools -n metallb-system
kubectl get bgppeers -n metallb-system
kubectl get bgpadvertisements -n metallb-system
```

### Step 3: Deploy Sample Application
```bash
# Deploy sample application
kubectl apply -f sample-app.yaml

# Check the LoadBalancer service
kubectl get services
```

### Step 4: Verify BGP Setup
```bash
# Run BGP verification script
chmod +x verify-bgp.sh
./verify-bgp.sh
```

## 📁 Files Explained

### `bgp-config.yaml`
Contains the BGP configuration:
- **IPAddressPool**: Defines the IP address range for BGP advertisement
- **BGPPeer**: Configures BGP peer connection parameters
- **BGPAdvertisement**: Configures BGP route advertisement

### `sample-app.yaml`
Contains a sample application for testing BGP load balancing:
- **Deployment**: NGINX deployment with multiple replicas
- **Service**: LoadBalancer service that will be advertised via BGP

### `verify-bgp.sh`
Script to verify BGP configuration and connectivity:
- Checks BGP peer status
- Verifies route advertisements
- Tests service connectivity

## 🔧 Configuration Details

### IP Address Pool
```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: bgp-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.1.100-192.168.1.110
```

### BGP Peer Configuration
```yaml
apiVersion: metallb.io/v1beta1
kind: BGPPeer
metadata:
  name: sample
  namespace: metallb-system
spec:
  myASN: 64500
  peerASN: 64501
  peerAddress: 192.168.1.1
```

### BGP Advertisement
```yaml
apiVersion: metallb.io/v1beta1
kind: BGPAdvertisement
metadata:
  name: example
  namespace: metallb-system
spec:
  ipAddressPools:
  - bgp-pool
```

## 🧪 Testing

### Manual Testing
```bash
# Check BGP peer status
kubectl describe bgppeer sample -n metallb-system

# Check BGP advertisements
kubectl describe bgpadvertisement example -n metallb-system

# Check service status
kubectl get service nginx-service

# Test connectivity from external network
curl http://<EXTERNAL_IP>
```

### Automated Testing
```bash
# Run the verification script
./verify-bgp.sh
```

## 🔍 Troubleshooting

### Common Issues

**BGP peer not connecting**
```bash
# Check BGP peer status
kubectl describe bgppeer sample -n metallb-system

# Check MetalLB speaker logs
kubectl logs -n metallb-system daemonset/metallb-speaker

# Verify network connectivity
kubectl exec -n metallb-system daemonset/metallb-speaker -- ping 192.168.1.1
```

**Routes not being advertised**
```bash
# Check BGP advertisement status
kubectl describe bgpadvertisement example -n metallb-system

# Check IP address pool
kubectl describe ipaddresspool bgp-pool -n metallb-system

# Verify service has external IP
kubectl get service nginx-service
```

**ASN configuration issues**
```bash
# Check BGP peer configuration
kubectl get bgppeer sample -n metallb-system -o yaml

# Verify ASN values
kubectl describe bgppeer sample -n metallb-system
```

## 📊 Expected Output

After successful deployment, you should see:

```bash
$ kubectl get bgppeers -n metallb-system
NAME     AGE
sample   2m

$ kubectl get bgpadvertisements -n metallb-system
NAME      AGE
example   2m

$ kubectl get services
NAME            TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)        AGE
nginx-service   LoadBalancer   10.96.123.45    192.168.1.100    80:32456/TCP   2m
```

## 🎯 Next Steps

1. **Configure multiple BGP peers** - Set up redundant BGP connections
2. **Implement BGP communities** - Use BGP communities for traffic engineering
3. **Set up BGP route filtering** - Implement route filtering policies
4. **Monitor BGP sessions** - Set up BGP monitoring and alerting

## 🔗 Related Examples

- [Basic Layer 2](../basic-layer2/) - Simple Layer 2 configuration
- [Multi-Pool Setup](../multi-pool/) - Multiple IP address pools
- [Production Setup](../production/) - Production-ready configuration

---

**Happy BGP Load Balancing! 🌐**
