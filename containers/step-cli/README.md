**CleanStart Container for Step CLI**

Official Step CLI container image optimized for enterprise environments. Includes the complete Step CLI toolkit for zero-trust network identity and certificate management. Features security-hardened base image, minimal attack surface, and FIPS-compliant cryptographic modules. Supports both production deployments and development workflows with separate tagged versions. Includes Step CLI, Step CA, and essential PKI tools for certificate management.

**Key Features**
* Complete Step CLI environment with PKI capabilities
* Optimized for cloud-native and microservices architectures

**Common Use Cases**
* Certificate management and PKI operations
* Zero-trust network identity

**Quick Start**

## Link to DockerHub 

https://hub.docker.com/r/cleanstart/step-cli

**Pull Commands**
Download the runtime container images

```bash
docker pull cleanstart/step-cli:latest
docker pull cleanstart/step-cli:latest-dev
```

**Interactive Development**
Start interactive session for development

```bash
docker run --rm -it --entrypoint /bin/sh cleanstart/step-cli:latest-dev
```

**Container Start**
Start the container
```bash
docker run --rm -it --name step-cli-dev cleanstart/step-cli:latest
```

**Best Practices**
* Use specific image tags for production (avoid latest)
* Configure resource limits: memory and CPU constraints
* Enable read-only root filesystem when possible

**Architecture Support**

**Multi-Platform Images**

```bash
docker pull --platform linux/amd64 cleanstart/step-cli:latest
docker pull --platform linux/arm64 cleanstart/step-cli:latest
```

**Resources & Documentation**

**Essential Links**
* **CleanStart Website**: https://www.cleanstart.com
* **Step CLI Official**: https://smallstep.com/

---
