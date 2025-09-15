**CleanStart Container for Kyverno KyvernoPre**

Official Kyverno KyvernoPre container image optimized for enterprise environments. Includes comprehensive Kubernetes policy management tools for admission control, validation, and mutation of Kubernetes resources. Features security-hardened base image, minimal attack surface, and FIPS-compliant cryptographic modules. Supports both production deployments and development workflows with separate tagged versions. Includes Kyverno CLI, policy engine, and essential Kubernetes policy tools.

**Key Features**
* Complete Kyverno policy management environment with admission control capabilities
* Optimized for cloud-native and microservices architectures

**Common Use Cases**
* Building and deploying Kubernetes policy management
* Cloud-native security and compliance development

**Quick Start**

## Link to DockerHub 

https://hub.docker.com/r/cleanstart/kyverno-kyvernopre

**Pull Commands**
Download the runtime container images

```bash
docker pull cleanstart/kyverno-kyvernopre:latest
docker pull cleanstart/kyverno-kyvernopre:latest-dev
```

**Interactive Development**
Start interactive session for development

```bash
docker run --rm -it --entrypoint /bin/sh cleanstart/kyverno-kyvernopre:latest-dev
```

**Container Start**
Start the container
```bash
docker run --rm -it --name kyverno-kyvernopre-dev cleanstart/kyverno-kyvernopre:latest
```

**Best Practices**
* Use specific image tags for production (avoid latest)
* Configure resource limits: memory and CPU constraints
* Enable read-only root filesystem when possible

**Architecture Support**

**Multi-Platform Images**

```bash
docker pull --platform linux/amd64 cleanstart/kyverno-kyvernopre:latest
docker pull --platform linux/arm64 cleanstart/kyverno-kyvernopre:latest
```

**Resources & Documentation**

**Essential Links**
* **CleanStart Website**: https://www.cleanstart.com
* **Kyverno Official**: https://kyverno.io/

---
