**CleanStart Container for MinIO Operator Sidecar**

Official MinIO Operator Sidecar container image optimized for enterprise environments. Includes the complete MinIO operator toolkit for managing MinIO object storage tenants and clusters in Kubernetes. Features security-hardened base image, minimal attack surface, and FIPS-compliant cryptographic modules. Supports both production deployments and development workflows with separate tagged versions. Includes MinIO operator, kubectl, and essential Kubernetes tools for tenant management.

**Key Features**
* Complete MinIO operator environment with tenant management capabilities
* Optimized for cloud-native and microservices architectures

**Common Use Cases**
* Managing MinIO object storage tenants in Kubernetes
* Cloud-native object storage operations

**Quick Start**

## Link to DockerHub 

https://hub.docker.com/r/cleanstart/minio-operator-sidecar

**Pull Commands**
Download the runtime container images

```bash
docker pull cleanstart/minio-operator-sidecar:latest
docker pull cleanstart/minio-operator-sidecar:latest-dev
```

**Interactive Development**
Start interactive session for development

```bash
docker run --rm -it --entrypoint /bin/sh cleanstart/minio-operator-sidecar:latest-dev
```

**Container Start**
Start the container
```bash
docker run --rm -it --name minio-operator-dev cleanstart/minio-operator-sidecar:latest
```

**Best Practices**
* Use specific image tags for production (avoid latest)
* Configure resource limits: memory and CPU constraints
* Enable read-only root filesystem when possible

**Architecture Support**

**Multi-Platform Images**

```bash
docker pull --platform linux/amd64 cleanstart/minio-operator-sidecar:latest
docker pull --platform linux/arm64 cleanstart/minio-operator-sidecar:latest
```

**Resources & Documentation**

**Essential Links**
* **CleanStart Website**: https://www.cleanstart.com
* **MinIO Official**: https://min.io/

---
