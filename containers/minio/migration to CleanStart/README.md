**MinIO Migration Project**

This project demonstrates migrating a MinIO setup from the public minio/minio:latest image to the Cleanstart cleanstart/minio:latest-dev image.

**Dockerfiles:**

Dockerfile.v1 – public MinIO image:

```bash
FROM minio/minio:latest
WORKDIR /data
```

Dockerfile.v2 – Cleanstart MinIO image:

```bash
FROM cleanstart/minio:latest-dev
WORKDIR /data
```

Both images inherit the default entrypoint /usr/bin/minio from the base images.


**Build and Run Steps**

1. Build and Run MinIO v1

# Build the v1 image
```bash
docker build -t minio-v1 -f Dockerfile.v1 .
```

# Run v1 container
```bash
docker run -d --name minio-v1-container \
  -p 9000:9000 -p 9001:9001 \
  -v ~/minio/data-v1:/data \
  -e "MINIO_ROOT_USER=admin" \
  -e "MINIO_ROOT_PASSWORD=password123" \
  minio-v1 server /data --console-address ":9001"
```

Check container status:

```bash
docker ps -a
```

Access the MinIO console: http://localhost:9001

2. Build and Run MinIO v2 (Cleanstart image)

# Build the v2 image
```bash
docker build -t minio-v2 -f Dockerfile.v2 .
```

# Create data directory
```bash
mkdir -p ~/minio/data-v2
chmod -R 777 ~/minio/data-v2
```

# Run v2 container
```bash
docker run -d --name minio-v2-container \
  -p 9002:9000 -p 9003:9001 \
  -v ~/minio/data-v2:/data \
  -e "MINIO_ROOT_USER=admin" \
  -e "MINIO_ROOT_PASSWORD=password123" \
  minio-v2 server /data --console-address ":9001"
```

Check container status:

```bash
docker ps -a
```

Access the MinIO console: http://localhost:9003

**Notes & Troubleshooting**

-- Permission Issues
-- If the container fails to start with errors like:
Error: unable to create (/data/.minio.sys/tmp) file access denied
It usually means Docker doesn’t have permission to write to the host volume.

Ensure the data directory exists:
```bash
mkdir -p ~/minio/data-v2
```

Set permissions (may require elevated privileges):
```bash
sudo chmod -R 777 ~/minio/data-v2
```

**Port Conflicts**
-- v1 runs on ports 9000 (API) and 9001 (console).
-- v2 runs on ports 9002 (API) and 9003 (console) to avoid conflicts.

**Stopping Containers**
```bash
docker stop minio-v1-container minio-v2-container
docker rm minio-v1-container minio-v2-container
```

**Summary:**

-- Dockerfile.v1 uses the public MinIO image.
-- Dockerfile.v2 uses the Cleanstart MinIO image.
-- Data persistence is handled via host-mounted volumes (~/minio/data-v1 and ~/minio/data-v2).
-- Ports and permissions must be adjusted appropriately for multiple instances.