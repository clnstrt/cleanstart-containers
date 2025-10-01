**CleanStart Container for MinIO**

Official MinIO container image optimized for enterprise environments. Includes high-performance object storage server compatible with Amazon S3 API for scalable and secure data storage. Features security-hardened base image, minimal attack surface, and FIPS-compliant cryptographic modules. Supports both production deployments and development workflows with separate tagged versions. Includes MinIO server, web console, and essential object storage tools.

**Key Features**
* Complete object storage environment with S3-compatible API
* Optimized for cloud-native and microservices architectures

**Common Use Cases**
* Building and deploying object storage solutions
* Cloud-native data storage development

**Quick Start**

## Link to DockerHub 

https://hub.docker.com/r/cleanstart/minio

**Pull Commands**
Download the runtime container images

```bash
docker pull cleanstart/minio:latest
docker pull cleanstart/minio:latest-dev
```

**Interactive Development**
Start interactive session for development

```bash
docker run --rm -it --entrypoint /bin/sh cleanstart/minio:latest-dev
```

**Container Start**
Start the container with proper configuration

```bash
docker run -d \
  --name minio-cleanstart \
  -p 9000:9000 \
  -p 9090:9090 \
  --tmpfs /data \
  -e MINIO_ROOT_USER=minioadmin \
  -e MINIO_ROOT_PASSWORD=minioadmin \
  cleanstart/minio:latest \
  server /data --console-address ":9090"
```

**Access URLs**
* **MinIO Web Console**: http://localhost:9090
  - Username: `minioadmin`
  - Password: `minioadmin`
* **MinIO API**: http://localhost:9000
  - Access Key: `minioadmin`
  - Secret Key: `minioadmin`

**Container Management**
```bash
# Check container status
docker ps | grep minio

# View logs
docker logs minio-cleanstart

# Stop container
docker stop minio-cleanstart

# Remove container
docker rm minio-cleanstart
```

**Best Practices**
* Use specific image tags for production (avoid latest)
* Configure resource limits: memory and CPU constraints
* Enable read-only root filesystem when possible

**Architecture Support**

**Multi-Platform Images**

```bash
docker pull --platform linux/amd64 cleanstart/minio:latest
docker pull --platform linux/arm64 cleanstart/minio:latest
```

**Resources & Documentation**

**Essential Links**
* **CleanStart Website**: https://www.cleanstart.com
* **MinIO Official**: https://min.io/

---