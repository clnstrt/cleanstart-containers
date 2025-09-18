**CleanStart Container for cAdvisor**

cAdvisor (Container Advisor) provides container users with resource usage and performance characteristics of running containers. It is a running daemon that collects, aggregates, processes, and exports information about running containers. Specifically, for each container it keeps resource isolation parameters, historical resource usage, histograms of complete historical resource usage and network statistics. This container includes enterprise-grade security hardening and monitoring capabilities optimized for production deployments.

📌 **CleanStart Foundation**: Security-hardened, minimal base OS designed for enterprise containerized environments.

**Key Features**
* Real-time container resource monitoring and metrics collection
* Native Prometheus metrics endpoint integration
* Historical performance data analysis and storage
* Enterprise-grade security with RBAC support

**Common Use Cases**
* Container resource usage monitoring in production environments
* Performance analysis and capacity planning for containerized applications
* Resource utilization tracking for Kubernetes clusters
* Container metrics collection for observability platforms

**Quick Start**

**Pull Latest Image**
Download the container image from the registry

```bash
docker pull cleanstart/cadvisor:latest
```
```bash
docker pull cleanstart/cadvisor:latest-dev
```

**Basic Run**
Run the container with basic configuration

```bash
docker run -d --name cadvisor -v /:/rootfs:ro -v /var/run:/var/run:ro -v /sys:/sys:ro -v /var/lib/docker/:/var/lib/docker:ro -v /dev/disk/:/dev/disk:ro -p 8080:8080 cleanstart/cadvisor:latest
```

**Production Deployment**
Deploy with production security settings

```bash
docker run -d --name cadvisor-prod \
  --read-only \
  --security-opt=no-new-privileges \
  --user 1000:1000 \
  -v /:/rootfs:ro \
  -v /var/run:/var/run:ro \
  -v /sys:/sys:ro \
  -v /var/lib/docker/:/var/lib/docker:ro \
  -v /dev/disk/:/dev/disk:ro \
  -p 8080:8080 \
  cleanstart/cadvisor:latest
```

**Volume Mount**
Mount required system directories for monitoring

```bash
docker run -d -v /:/rootfs:ro -v /var/run:/var/run:ro -v /sys:/sys:ro cleanstart/cadvisor:latest
```

**Port Forwarding**
Run with metrics endpoint exposed

```bash
docker run -d -p 8080:8080 cleanstart/cadvisor:latest
```

**Architecture Support**

**Multi-Platform Images**

```bash
docker pull --platform linux/amd64 cleanstart/cadvisor:latest
```
```bash
docker pull --platform linux/arm64 cleanstart/cadvisor:latest
```

**Resources & Documentation**

**Essential Links**
* **CleanStart Website**: https://www.cleanstart.com
* **cAdvisor GitHub Repository**: https://github.com/google/cadvisor
* **cAdvisor Documentation**: https://github.com/google/cadvisor/tree/master/docs

---
