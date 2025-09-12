**CleanStart Container for MetalLB Controller**

Official MetalLB Controller container image optimized for enterprise environments. Includes comprehensive load balancer management tools for Kubernetes environments with Layer 2 and BGP support. Features security-hardened base image, minimal attack surface, and FIPS-compliant cryptographic modules. Supports both production deployments and development workflows with separate tagged versions. Includes MetalLB controller, speaker, and essential load balancing tools.

**Key Features**
* Complete load balancer environment with MetalLB capabilities
* Optimized for cloud-native and microservices architectures

**Common Use Cases**
* Building and deploying load balancers
* Cloud-native networking development

**Quick Start**

## Link to DockerHub 

https://hub.docker.com/r/cleanstart/metallb-controller

**Pull Commands**
Download the runtime container images

```bash
docker pull cleanstart/metallb-controller:latest
docker pull cleanstart/metallb-controller:latest-dev
```

**Interactive Development**
Start interactive session for development

```bash
docker run --rm -it --entrypoint /bin/sh cleanstart/metallb-controller:latest-dev
```

**Container Start**
Start the container
```bash
docker run --rm -it --name metallb-controller-dev cleanstart/metallb-controller:latest
```

**Best Practices**
* Use specific image tags for production (avoid latest)
* Configure resource limits: memory and CPU constraints
* Enable read-only root filesystem when possible

**Architecture Support**

**Multi-Platform Images**

```bash
docker pull --platform linux/amd64 cleanstart/metallb-controller:latest
docker pull --platform linux/arm64 cleanstart/metallb-controller:latest
```

**Resources & Documentation**

**Essential Links**
* **CleanStart Website**: https://www.cleanstart.com
* **MetalLB Official**: https://metallb.universe.tf/

---