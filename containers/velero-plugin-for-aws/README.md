**CleanStart Container for Velero Plugin for AWS**

Official Velero Plugin for AWS container image optimized for enterprise environments. Includes comprehensive Kubernetes backup and restore functionality specifically for AWS environments with disaster recovery capabilities. Features security-hardened base image, minimal attack surface, and FIPS-compliant cryptographic modules. Supports both production deployments and development workflows with separate tagged versions. Includes Velero CLI, AWS plugin, and essential backup tools.

**Key Features**
* Complete backup and restore environment with AWS integration
* Optimized for cloud-native and microservices architectures

**Common Use Cases**
* Building and deploying backup solutions
* Cloud-native disaster recovery development

**Quick Start**

## Link to DockerHub 

https://hub.docker.com/r/cleanstart/velero-plugin-for-aws

**Pull Commands**
Download the runtime container images

```bash
docker pull cleanstart/velero-plugin-for-aws:latest
docker pull cleanstart/velero-plugin-for-aws:latest-dev
```

**Interactive Development**
Start interactive session for development

```bash
docker run --rm -it --entrypoint /bin/sh cleanstart/velero-plugin-for-aws:latest-dev
```

**Container Start**
Start the container
```bash
docker run --rm -it --name velero-plugin-aws-dev cleanstart/velero-plugin-for-aws:latest
```

**Best Practices**
* Use specific image tags for production (avoid latest)
* Configure resource limits: memory and CPU constraints
* Enable read-only root filesystem when possible

**Architecture Support**

**Multi-Platform Images**

```bash
docker pull --platform linux/amd64 cleanstart/velero-plugin-for-aws:latest
docker pull --platform linux/arm64 cleanstart/velero-plugin-for-aws:latest
```

**Resources & Documentation**

**Essential Links**
* **CleanStart Website**: https://www.cleanstart.com
* **Velero Official**: https://velero.io/

---