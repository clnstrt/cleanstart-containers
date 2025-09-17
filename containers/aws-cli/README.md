**CleanStart Container for AWS CLI**

Official AWS CLI container image optimized for enterprise environments. Includes the complete AWS CLI toolkit for managing cloud resources and services. Features security-hardened base image, minimal attack surface, and FIPS-compliant cryptographic modules. Supports both production deployments and development workflows with separate tagged versions. Includes AWS CLI, kubectl, and essential cloud management tools.

**Key Features**
* Complete AWS CLI environment with cloud management capabilities
* Optimized for cloud-native and microservices architectures

**Common Use Cases**
* Building and deploying cloud applications
* Cloud-native infrastructure management

**Quick Start**

## Link to DockerHub 

https://hub.docker.com/r/cleanstart/aws-cli

**Pull Commands**
Download the runtime container images

```bash
docker pull cleanstart/aws-cli:latest
docker pull cleanstart/aws-cli:latest-dev
```

**Interactive Development**
Start interactive session for development

```bash
docker run --rm -it --entrypoint /bin/sh cleanstart/aws-cli:latest-dev
```

**Container Start**
Start the container
```bash
docker run --rm -it --name aws-cli-dev cleanstart/aws-cli:latest
```

**Best Practices**
* Use specific image tags for production (avoid latest)
* Configure resource limits: memory and CPU constraints
* Enable read-only root filesystem when possible

**Architecture Support**

**Multi-Platform Images**

```bash
docker pull --platform linux/amd64 cleanstart/aws-cli:latest
docker pull --platform linux/arm64 cleanstart/aws-cli:latest
```

**Resources & Documentation**

**Essential Links**
* **CleanStart Website**: https://www.cleanstart.com
* **AWS CLI Official**: https://aws.amazon.com/cli/

---