**CleanStart Container for Curl**

Official Curl container image optimized for enterprise environments. Includes comprehensive HTTP client tools for API testing, web scraping, and data transfer operations. Features security-hardened base image, minimal attack surface, and FIPS-compliant cryptographic modules. Supports both production deployments and development workflows with separate tagged versions. Includes curl, wget, jq, and essential HTTP client tools.

**Key Features**
* Complete HTTP client environment with data transfer capabilities
* Optimized for cloud-native and microservices architectures

**Common Use Cases**
* Building and deploying HTTP clients
* Cloud-native API development

**Pull Commands**
Download the runtime container images

```bash
docker pull cleanstart/curl:latest
docker pull cleanstart/curl:latest-dev
```

**Interactive Development**
Start interactive session for development

```bash
docker run --rm -it --entrypoint /bin/sh cleanstart/curl:latest-dev
```

**Container Start**
Start the container
```bash
docker run --rm -it --name curl-dev cleanstart/curl:latest
```

**Best Practices**
* Use specific image tags for production (avoid latest)
* Configure resource limits: memory and CPU constraints
* Enable read-only root filesystem when possible

**Architecture Support**

**Multi-Platform Images**

```bash
docker pull --platform linux/amd64 cleanstart/curl:latest
docker pull --platform linux/arm64 cleanstart/curl:latest
```

**Resources & Documentation**

**Essential Links**
* **CleanStart Website**: https://www.cleanstart.com
* **Curl Official**: https://curl.se/

**Reference:**

CleanStart Community Images: https://hub.docker.com/u/cleanstart 

Get more from CleanStart images from https://github.com/clnstrt/cleanstart-containers/tree/main/containers⁠, 

  -  how-to-Run sample projects using dockerfile 
  -  how-to-Deploy via Kubernete YAML 
  -  how-to-Migrate from public images to CleanStart images

