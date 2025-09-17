**CleanStart Container for Java**

Official Java container image optimized for enterprise environments. Includes the complete Java Development Kit (JDK) and Java Runtime Environment (JRE) for Java application development and deployment. Features security-hardened base image, minimal attack surface, and FIPS-compliant cryptographic modules. Supports both production deployments and development workflows with separate tagged versions. Includes Java runtime, development tools, and essential Java libraries.

**Key Features**
* Complete Java development environment with JDK and JRE capabilities
* Optimized for cloud-native and microservices architectures

**Common Use Cases**
* Building and deploying Java applications
* Cloud-native Java development

**Quick Start**

## Link to DockerHub 

https://hub.docker.com/r/cleanstart/java

**Pull Commands**
Download the runtime container images

```bash
docker pull cleanstart/jdk:latest
```
```bash
docker pull cleanstart/jdk:latest-dev
```

**Interactive Development**
Start interactive session for development

```bash
docker run --rm -it --entrypoint /bin/sh cleanstart/java:latest-dev
```

**Container Start**
Start the container
```bash
docker run --rm -it --name java-dev cleanstart/java:latest
```

**Best Practices**
* Use specific image tags for production (avoid latest)
* Configure resource limits: memory and CPU constraints
* Enable read-only root filesystem when possible

**Architecture Support**

**Multi-Platform Images**

```bash
docker pull --platform linux/amd64 cleanstart/java:latest
```
```bash
docker pull --platform linux/arm64 cleanstart/java:latest
```

**Resources & Documentation**

**Essential Links**
* **CleanStart Website**: https://www.cleanstart.com
* **Java Official**: https://www.oracle.com/java/


---
