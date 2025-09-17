**CleanStart Container for Argo Workflow Exec**

Official Argo Workflow Exec container image optimized for enterprise environments. Includes the complete Argo Workflows CLI toolkit for managing workflows and orchestrating parallel jobs on Kubernetes. Features security-hardened base image, minimal attack surface, and FIPS-compliant cryptographic modules. Supports both production deployments and development workflows with separate tagged versions. Includes Argo CLI, kubectl, and essential Kubernetes tools for workflow management.

**Key Features**
* Complete Argo Workflows environment with CLI and orchestration capabilities
* Optimized for cloud-native and microservices architectures

**Common Use Cases**
* Building and deploying workflow orchestration
* Cloud-native workflow development

**Quick Start**

## Link to DockerHub 

https://hub.docker.com/r/cleanstart/argo-workflow-exec

**Pull Commands**
Download the runtime container images

```bash
docker pull cleanstart/argo-workflow-exec:latest
```
```bash
docker pull cleanstart/argo-workflow-exec:latest-dev
```

**Interactive Development**
Start interactive session for development

```bash
docker run --rm -it --entrypoint /bin/sh cleanstart/argo-workflow-exec:latest-dev
```

**Container Start**
Start the container
```bash
docker run --rm -it --name argo-workflow-dev cleanstart/argo-workflow-exec:latest
```

**Best Practices**
* Use specific image tags for production (avoid latest)
* Configure resource limits: memory and CPU constraints
* Enable read-only root filesystem when possible

**Architecture Support**

**Multi-Platform Images**

```bash
docker pull --platform linux/amd64 cleanstart/argo-workflow-exec:latest
```
```bash
docker pull --platform linux/arm64 cleanstart/argo-workflow-exec:latest
```

**Resources & Documentation**

**Essential Links**
* **CleanStart Website**: https://www.cleanstart.com
* **Argo Workflows Official**: https://argoproj.github.io/workflows/


---

