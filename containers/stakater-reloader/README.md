**CleanStart Container for Stakater Reloader**

Official Stakater Reloader container image optimized for enterprise environments. Includes comprehensive Kubernetes resource reloading capabilities for automatic pod restarts when ConfigMaps or Secrets change. Features security-hardened base image, minimal attack surface, and FIPS-compliant cryptographic modules. Supports both production deployments and development workflows with separate tagged versions. Includes Reloader controller, webhook support, and essential Kubernetes automation tools.

**Key Features**
* Complete Stakater Reloader environment with automatic resource reloading capabilities
* Optimized for cloud-native and microservices architectures

**Common Use Cases**
* Building and deploying automatic resource reloading
* Cloud-native configuration management development

**Quick Start**

## Link to DockerHub 

https://hub.docker.com/r/cleanstart/stakater-reloader

**Pull Commands**
Download the runtime container images

```bash
docker pull cleanstart/stakater-reloader:latest
docker pull cleanstart/stakater-reloader:latest-dev
```

**Interactive Development**
Start interactive session for development

```bash
docker run --rm -it --entrypoint /bin/sh cleanstart/stakater-reloader:latest-dev
```

**Build**

```bash
docker build -t cleanstart/stakater-reloader:latest .
```

**Container Start**
Start the container
```bash
 docker run --rm  cleanstart/stakater-reloader:latest
 ```

**Best Practices**
* Use specific image tags for production (avoid latest)
* Configure resource limits: memory and CPU constraints
* Enable read-only root filesystem when possible

**Architecture Support**

**Multi-Platform Images**

```bash
docker pull --platform linux/amd64 cleanstart/stakater-reloader:latest
docker pull --platform linux/arm64 cleanstart/stakater-reloader:latest
```

**Resources & Documentation**

**Essential Links**
* **CleanStart Website**: https://www.cleanstart.com
* **Stakater Reloader Official**: https://github.com/stakater/Reloader

---
