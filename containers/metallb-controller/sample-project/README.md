# MetalLB Controller Sample Projects

This directory contains comprehensive sample projects demonstrating various load balancer scenarios using the MetalLB Controller. These projects are designed to be **immediately usable** and **production-ready**.

## 🚀 **Quick Start (5 Minutes)**

### **Step 1: Pull and Run the Image**
```bash
# Pull the image
docker pull cleanstart/metallb-controller:latest

# Run the container
docker run -it --rm cleanstart/metallb-controller:latest

# Inside container, explore sample projects
ls -la sample-project/
```

### **Step 2: Deploy MetalLB in Kubernetes**
```bash
# Deploy MetalLB controller and speaker
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.2/config/manifests/metallb-native.yaml

# Verify deployment
kubectl get pods -n metallb-system
```

### **Step 3: Test Basic Project**
```bash
# Deploy basic Layer 2 configuration
kubectl apply -f basic-layer2/metallb-config.yaml

# Deploy sample application
kubectl apply -f basic-layer2/sample-app.yaml

# Check LoadBalancer service
kubectl get services
```

## 📚 **Available Sample Projects**

### 1. [Basic Layer 2](./basic-layer2/)
**Perfect for beginners** - Simple Layer 2 load balancer setup for getting started with MetalLB.

**What you'll learn:**
- Basic MetalLB configuration
- IP address pool management
- Layer 2 advertisement setup
- LoadBalancer service creation

**Use case:** Perfect for developers new to MetalLB or for simple load balancing needs.

**Files included:**
- `metallb-config.yaml` - MetalLB Layer 2 configuration
- `sample-app.yaml` - Complete sample application
- `README.md` - Basic Layer 2 guide
- `test-connection.sh` - Connection testing script

### 2. [BGP Configuration](./bgp-setup/)
**Advanced networking** - BGP-based load balancer configuration for enterprise environments.

**What you'll learn:**
- BGP peer configuration
- BGP advertisement setup
- Enterprise networking concepts
- Advanced load balancing

**Use case:** Perfect for production environments with BGP-capable network infrastructure.

**Files included:**
- `bgp-config.yaml` - BGP peer and advertisement configuration
- `sample-app.yaml` - Sample application for BGP testing
- `README.md` - BGP setup guide
- `verify-bgp.sh` - BGP verification script

### 3. [Multi-Pool Setup](./multi-pool/)
**Production-ready** - Multiple IP address pools for different service tiers and environments.

**What you'll learn:**
- Multiple IP pool management
- Service tier separation
- Environment-specific configurations
- Advanced pool routing

**Use case:** Perfect for multi-tenant environments or service tier separation.

**Files included:**
- `web-pool-config.yaml` - Web tier IP pool configuration
- `api-pool-config.yaml` - API tier IP pool configuration
- `sample-apps.yaml` - Multiple sample applications
- `README.md` - Multi-pool setup guide
- `test-pools.sh` - Pool testing script

### 4. [Production Setup](./production/)
**Enterprise-grade** - Complete production-ready MetalLB setup with monitoring and security.

**What you'll learn:**
- Production deployment patterns
- Monitoring and observability
- Security best practices
- High availability configuration

**Use case:** Perfect for production Kubernetes clusters requiring robust load balancing.

**Files included:**
- `metallb-deployment.yaml` - Production MetalLB deployment
- `monitoring.yaml` - Prometheus monitoring setup
- `security-policies.yaml` - Security policies and RBAC
- `README.md` - Production setup guide
- `health-check.sh` - Health monitoring script

## 🎯 **Features**

- **Layer 2 Load Balancing** - Simple ARP-based load balancing
- **BGP Load Balancing** - Enterprise-grade BGP-based load balancing
- **Multiple IP Pools** - Support for multiple IP address pools
- **Service Discovery** - Automatic service discovery and IP assignment
- **High Availability** - Redundant controller and speaker deployment
- **Monitoring** - Built-in metrics and monitoring support
- **Security** - RBAC and network security policies

## 📊 **Output**

MetalLB operations output includes:
- IP address pool assignments
- LoadBalancer service status
- BGP peer connectivity
- Service endpoint information
- Network advertisement status

## 🔒 **Security**

- RBAC configuration
- Network security policies
- Secure BGP peer authentication
- IP address pool isolation
- Service mesh integration

## 🧪 **Testing**

Each sample project includes:
- Automated testing scripts
- Health check endpoints
- Connection verification
- Performance monitoring
- Troubleshooting guides

## 🚀 **Getting Started**

1. **Choose a sample project** based on your needs
2. **Follow the README** in each project directory
3. **Deploy the configuration** using kubectl
4. **Test the setup** using provided scripts
5. **Monitor the deployment** using included monitoring

## 🤝 **Contributing**

To add new MetalLB scenarios:
1. Create new directory in sample-project/
2. Add configuration files and documentation
3. Include testing scripts
4. Update this README with project description

---

**Happy Load Balancing! ⚖️**
