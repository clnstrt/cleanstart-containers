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

**Reference:**

CleanStart Community Images: https://hub.docker.com/u/cleanstart 

Get more from CleanStart images from https://github.com/clnstrt/cleanstart-containers/tree/main/containers⁠, 

  -  how-to-Run sample projects using dockerfile 
  -  how-to-Deploy via Kubernete YAML 
  -  how-to-Migrate from public images to CleanStart images

---

# Vulnerability Disclaimer

CleanStart offers Docker images that include third-party open-source libraries and packages maintained by independent contributors. While CleanStart maintains these images and applies industry-standard security practices, it cannot guarantee the security or integrity of upstream components beyond its control.

Users acknowledge and agree that open-source software may contain undiscovered vulnerabilities or introduce new risks through updates. CleanStart shall not be liable for security issues originating from third-party libraries, including but not limited to zero-day exploits, supply chain attacks, or contributor-introduced risks.

Security remains a shared responsibility: CleanStart provides updated images and guidance where possible, while users are responsible for evaluating deployments and implementing appropriate controls.