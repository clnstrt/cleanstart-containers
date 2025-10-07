**CleanStart Container for jre**

Official jre container image optimized for enterprise environments. Includes the complete jre Development Kit (jre) and jre Runtime Environment (JRE) for jre application development and deployment. Features security-hardened base image, minimal attack surface, and FIPS-compliant cryptographic modules. Supports both production deployments and development workflows with separate tagged versions. Includes jre runtime, development tools, and essential jre libraries.

**Key Features**
* Complete jre development environment with jre and JRE capabilities
* Optimized for cloud-native and microservices architectures

**Common Use Cases**
* Building and deploying jre applications
* Cloud-native jre development

**Pull Commands**
Download the runtime container images

```bash
docker pull cleanstart/jre:latest
```
```bash
docker pull cleanstart/jre:latest-dev
```

**Interactive Development**
Start interactive session for development

```bash
docker run --rm -it --entrypoint /bin/sh cleanstart/jre:latest-dev
```

**Container Start**
Start the container
```bash
docker run --rm -it --name jre-dev cleanstart/jre:latest
```

**Best Practices**
* Use specific image tags for production (avoid latest)
* Configure resource limits: memory and CPU constraints
* Enable read-only root filesystem when possible

**Architecture Support**

**Multi-Platform Images**

```bash
docker pull --platform linux/amd64 cleanstart/jre:latest
```
```bash
docker pull --platform linux/arm64 cleanstart/jre:latest
```

**Resources & Documentation**

**Essential Links**
* **CleanStart Website**: https://www.cleanstart.com
* **jre Official**: https://www.oracle.com/jre/

**Reference:**

CleanStart Community Images: https://hub.docker.com/u/cleanstart 

Get more from CleanStart images from https://github.com/clnstrt/cleanstart-containers/tree/main/containers⁠, 

  -  how-to-Run sample projects using dockerfile 
  -  how-to-Deploy via Kubernete YAML 
  -  how-to-Migrate from public images to CleanStart images

**Reference:**

CleanStart Community Images: https://hub.docker.com/u/cleanstart 

Get more from CleanStart images from https://github.com/clnstrt/cleanstart-containers/tree/main/containers⁠, 

  -  how-to-Run sample projects using dockerfile 
  -  how-to-Deploy via Kubernete YAML 
  -  how-to-Migrate from public images to CleanStart images
