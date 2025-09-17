**CleanStart Container for Cortex**

Official Cortex container image optimized for enterprise environments. Includes comprehensive metrics storage and querying capabilities for Prometheus-compatible monitoring systems. Features security-hardened base image, minimal attack surface, and FIPS-compliant cryptographic modules. Supports both production deployments and development workflows with separate tagged versions. Includes Cortex server, storage backends, and essential monitoring tools.

**Key Features**
* Complete Cortex metrics storage environment with Prometheus compatibility
* Optimized for cloud-native and microservices architectures

**Common Use Cases**
* Building and deploying metrics storage solutions
* Cloud-native monitoring and observability development

**Quick Start**

## Link to DockerHub 

https://hub.docker.com/r/cleanstart/cortex

**Pull Commands**
Download the runtime container images

```bash
docker pull cleanstart/cortex:latest
docker pull cleanstart/cortex:latest-dev
```

**Interactive Development**
Start interactive session for development

```bash
docker run --rm -it --entrypoint /bin/sh cleanstart/cortex:latest-dev
```

**Container Start**
Start the container
```bash
docker run --rm -it --name cortex-dev cleanstart/cortex:latest
```

**Best Practices**
* Use specific image tags for production (avoid latest)
* Configure resource limits: memory and CPU constraints
* Enable read-only root filesystem when possible

**Architecture Support**

**Multi-Platform Images**

```bash
docker pull --platform linux/amd64 cleanstart/cortex:latest
docker pull --platform linux/arm64 cleanstart/cortex:latest
```

**Resources & Documentation**

**Essential Links**
* **CleanStart Website**: https://www.cleanstart.com
* **Cortex Official**: https://cortexmetrics.io/

---
