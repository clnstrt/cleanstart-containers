**Container Documentation for Metallb-Controller**

MetalLB controller container provides Layer 2 and BGP-based load balancing functionality for bare metal Kubernetes clusters. It enables LoadBalancer service types in environments without cloud provider integration, offering enterprise-grade network load balancing capabilities with high availability and automatic failover features.

**Key Features**
Core capabilities and strengths of this container

- Layer 2 and BGP mode support for network load balancing
- Automatic IP address management and allocation
- High availability configuration with leader election
- Native Kubernetes integration for LoadBalancer services

**Common Use Cases**
Typical scenarios where this container excels

- Bare metal Kubernetes cluster load balancing
- On-premises data center service exposure
- Edge computing network management
- Multi-cluster service load balancing

**Pull Latest Image**
Download the container image from the registry

```bash
docker pull Cleanstart/metallb-controller:latest
```

```bash
docker pull Cleanstart/metallb-controller:latest-dev
```

**Basic Run**
Run the container with basic configuration

```bash
docker run -it --name metallb-controller-test Cleanstart/metallb-controller:latest-dev
```

**Production Deployment**
Deploy with production security settings

```bash
docker run -d --name metallb-controller-prod \
  --read-only \
  --security-opt=no-new-privileges \
  --user 1000:1000 \
  Cleanstart/metallb-controller:latest
```

**Documentation Resources**
Essential links and resources for further information

- **Container Registry**: https://www.cleanstart.com/
- **MetalLB Official Documentation**: https://metallb.universe.tf/