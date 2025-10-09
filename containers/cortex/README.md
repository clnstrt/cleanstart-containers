**CleanStart Container for Cortex**

Cortex is an open-source, horizontally scalable machine learning platform designed for managing and deploying ML models in production. This container provides a secure, enterprise-ready environment for running Cortex workloads with built-in monitoring, autoscaling, and model versioning capabilities. The image includes optimized ML runtime dependencies and security hardening for production deployments.

📌 **CleanStart Foundation**: Security-hardened, minimal base OS designed for enterprise containerized environments.

**Key Features**
* Automated model deployment and scaling
* Real-time prediction API generation
* Built-in monitoring and logging integration
* Enterprise-grade security controls and access management

**Common Use Cases**
* Production ML model serving
* Automated ML pipeline orchestration
* Real-time prediction services
* Scalable AI application deployment

**Quick Start**

**Pull Latest Image**
Download the container image from the registry

```bash
docker pull cleanstart/cortex:latest
docker pull cleanstart/cortex:latest-dev
```

**Basic Run**
Run the container with basic configuration

```bash
docker run -it --name cortex-test cleanstart/cortex:latest-dev
```

**Production Deployment**
Deploy with production security settings

```bash
docker run -d --name cortex-prod \
  --read-only \
  --security-opt=no-new-privileges \
  --user 1000:1000 \
  cleanstart/cortex:latest
```

**Volume Mount**
Mount local directory for persistent data

```bash
docker run -v $(pwd)/data:/data cleanstart/cortex:latest
```

**Port Forwarding**
Run with custom port mappings

```bash
docker run -p 8080:80 cleanstart/cortex:latest
```

**Configuration**

**Environment Variables**

| Variable | Default | Description |
|----------|---------|-------------|
| PATH | /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin | System PATH configuration |
| CORTEX_OPERATOR_ENDPOINT | localhost:8888 | Endpoint for the Cortex operator service |

**Security & Best Practices**

**Recommended Security Context**

```yaml
securityContext:
  runAsNonRoot: true
  runAsUser: 1000
  runAsGroup: 1000
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
  capabilities:
    drop: ['ALL']
```

**Best Practices**
* Use specific image tags for production (avoid latest)
* Configure resource limits: memory and CPU constraints
* Enable read-only root filesystem when possible
* Run containers with non-root user (--user 1000:1000)
* Use --security-opt=no-new-privileges flag
* Regularly update container images for security patches
* Implement proper network segmentation
* Monitor container metrics for anomalies

**Architecture Support**

**Multi-Platform Images**

```bash
docker pull --platform linux/amd64 cleanstart/cortex:latest
docker pull --platform linux/arm64 cleanstart/cortex:latest
```

**Resources & Documentation**

**Essential Links**
* **CleanStart Website**: https://www.cleanstart.com
* **Cortex Documentation**: https://docs.cortex.dev

**Reference:**

CleanStart Community Images: https://hub.docker.com/u/cleanstart 

Get more from CleanStart images from https://github.com/clnstrt/cleanstart-containers/tree/main/containers⁠, 

  -  how-to-Run sample projects using dockerfile 
  -  how-to-Deploy via Kubernete YAML 
  -  how-to-Migrate from public images to CleanStart images

---

# Vulnerability Disclaimer

CleanStart offers Docker images that include third-party open-source libraries and packages maintained by independent contributors. While CleanStart maintains these images and applies industry-standard security practices, it cannot guarantee the security or integrity of upstream components beyond its control.

Users acknowledge and agree that open-source software may contain undiscovered vulnerabilities or introduce new risks through updates. CleanStart shall not be liable for security issues originating from third-party libraries, including but not limited to zero-day exploits, supply chain attacks, or contributor-introduced risks.

Security remains a shared responsibility: CleanStart provides updated images and guidance where possible, while users are responsible for evaluating deployments and implementing appropriate controls.