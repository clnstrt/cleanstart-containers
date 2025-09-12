# Multi-Pool MetalLB Setup

This example demonstrates multiple IP address pools configuration for different service tiers and environments using MetalLB.

## 🎯 What This Example Does

- Configures multiple IP address pools for different service tiers
- Sets up separate pools for web, API, and database services
- Demonstrates service-specific IP pool assignment
- Shows how to manage different environments (dev, staging, prod)
- Implements pool-based service isolation

## 📋 Prerequisites

- Kubernetes cluster (local or remote)
- kubectl configured to access your cluster
- Network access to multiple IP ranges
- Understanding of service tier concepts

## 🚀 Quick Start

### Step 1: Deploy MetalLB
```bash
# Deploy MetalLB controller and speaker
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.2/config/manifests/metallb-native.yaml

# Wait for MetalLB to be ready
kubectl wait --for=condition=ready pod -l app=metallb -n metallb-system --timeout=60s
```

### Step 2: Configure Multiple IP Pools
```bash
# Apply the multi-pool configuration
kubectl apply -f web-pool-config.yaml
kubectl apply -f api-pool-config.yaml
kubectl apply -f database-pool-config.yaml

# Verify the configuration
kubectl get ipaddresspools -n metallb-system
kubectl get l2advertisements -n metallb-system
```

### Step 3: Deploy Sample Applications
```bash
# Deploy sample applications for each tier
kubectl apply -f sample-apps.yaml

# Check the LoadBalancer services
kubectl get services
```

### Step 4: Test Pool Assignment
```bash
# Run pool testing script
chmod +x test-pools.sh
./test-pools.sh
```

## 📁 Files Explained

### `web-pool-config.yaml`
Contains the web tier IP pool configuration:
- **IPAddressPool**: Web tier IP range (192.168.1.240-192.168.1.245)
- **L2Advertisement**: Layer 2 advertisement for web services

### `api-pool-config.yaml`
Contains the API tier IP pool configuration:
- **IPAddressPool**: API tier IP range (192.168.1.246-192.168.1.250)
- **L2Advertisement**: Layer 2 advertisement for API services

### `database-pool-config.yaml`
Contains the database tier IP pool configuration:
- **IPAddressPool**: Database tier IP range (192.168.1.251-192.168.1.255)
- **L2Advertisement**: Layer 2 advertisement for database services

### `sample-apps.yaml`
Contains sample applications for each tier:
- **Web Service**: NGINX web server
- **API Service**: Simple API server
- **Database Service**: Database with management interface

### `test-pools.sh`
Script to test multi-pool configuration:
- Verifies IP pool assignments
- Tests service connectivity
- Displays pool utilization

## 🔧 Configuration Details

### Web Tier Pool
```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: web-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.1.240-192.168.1.245
```

### API Tier Pool
```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: api-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.1.246-192.168.1.250
```

### Database Tier Pool
```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: database-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.1.251-192.168.1.255
```

## 🧪 Testing

### Manual Testing
```bash
# Check IP pool assignments
kubectl get ipaddresspools -n metallb-system

# Check service IP assignments
kubectl get services -o wide

# Test web service
curl http://<WEB_IP>

# Test API service
curl http://<API_IP>/api/health

# Test database service
curl http://<DB_IP>/admin
```

### Automated Testing
```bash
# Run the pool testing script
./test-pools.sh
```

## 🔍 Troubleshooting

### Common Issues

**Services not getting IPs from correct pools**
```bash
# Check IP address pool status
kubectl describe ipaddresspool -n metallb-system

# Check L2 advertisement configuration
kubectl describe l2advertisement -n metallb-system

# Verify service annotations
kubectl get service <service-name> -o yaml
```

**IP pool conflicts**
```bash
# Check for overlapping IP ranges
kubectl get ipaddresspools -n metallb-system -o yaml

# Verify network configuration
kubectl describe ipaddresspool <pool-name> -n metallb-system
```

**Services not accessible**
```bash
# Check service endpoints
kubectl get endpoints

# Check pod status
kubectl get pods -l app=<app-label>

# Check service selector
kubectl describe service <service-name>
```

## 📊 Expected Output

After successful deployment, you should see:

```bash
$ kubectl get ipaddresspools -n metallb-system
NAME         AGE
web-pool     2m
api-pool     2m
database-pool 2m

$ kubectl get services
NAME            TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)        AGE
web-service     LoadBalancer   10.96.123.45    192.168.1.240    80:32456/TCP   2m
api-service     LoadBalancer   10.96.123.46    192.168.1.246    8080:32457/TCP 2m
database-service LoadBalancer  10.96.123.47    192.168.1.251    5432:32458/TCP 2m
```

## 🎯 Advanced Use Cases

### Service-Specific Pool Assignment
```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service
  annotations:
    metallb.universe.tf/address-pool: web-pool
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 80
  selector:
    app: web
```

### Environment-Specific Pools
```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: dev-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.1.200-192.168.1.210
---
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: prod-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.1.100-192.168.1.110
```

## 🎯 Next Steps

1. **Implement pool-based security** - Use network policies with IP pools
2. **Set up pool monitoring** - Monitor IP pool utilization
3. **Configure pool failover** - Set up pool redundancy
4. **Implement pool quotas** - Limit IP usage per namespace

## 🔗 Related Examples

- [Basic Layer 2](../basic-layer2/) - Simple Layer 2 configuration
- [BGP Setup](../bgp-setup/) - BGP-based configuration
- [Production Setup](../production/) - Production-ready configuration

---

**Happy Multi-Pool Load Balancing! 🎯**
