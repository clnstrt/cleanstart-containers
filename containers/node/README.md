**CleanStart Container for Node.js**

Official Node.js runtime container image optimized for enterprise environments. Includes the complete Node.js development toolkit, npm package manager, and runtime environment. Features security-hardened base image, minimal attack surface, and FIPS-compliant cryptographic modules. Supports both production deployments and development workflows with separate tagged versions. Includes standard Node.js tools like npm, yarn, and essential development tools for scalable network applications.

**Key Features**
* Complete Node.js development environment with npm and package management
* Optimized for cloud-native and microservices architectures

**Common Use Cases**
* Building and deploying Node.js web applications
* Server-side JavaScript development

**Quick Start**

## Link to DockerHub 

https://hub.docker.com/r/cleanstart/node

**Pull Commands**
Download the runtime container images

```bash
docker pull cleanstart/node:latest
docker pull cleanstart/node:latest-dev
```

**Interactive Development**
Start interactive session for development

```bash
docker run --rm -it --entrypoint /bin/sh cleanstart/node:latest-dev
```

**Container Start**
Start the container
```bash
docker run --rm -it --name node-web-dev cleanstart/node:latest
```

**Best Practices**
* Use specific image tags for production (avoid latest)
* Configure resource limits: memory and CPU constraints
* Enable read-only root filesystem when possible

**Architecture Support**

**Multi-Platform Images**

```bash
docker pull --platform linux/amd64 cleanstart/node:latest
docker pull --platform linux/arm64 cleanstart/node:latest
```

**Resources & Documentation**

**Essential Links**
* **CleanStart Website**: https://www.cleanstart.com
* **Node.js Official**: https://nodejs.org/

---
