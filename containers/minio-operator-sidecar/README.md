# MinIO Operator Sidecar Docker Image

A Kubernetes operator for managing MinIO object storage tenants and clusters.

## Pull Image
```bash
docker pull cleanstart/minio-operator-sidecar:latest
```

## Run Container
```bash
# Interactive run
docker run -it --rm cleanstart/minio-operator-sidecar:latest

# Run with volume mounts
docker run -it --rm -v $(pwd)/config:/app/config -v $(pwd)/manifests:/app/manifests cleanstart/minio-operator-sidecar:latest

# Run MinIO operator
docker run --rm cleanstart/minio-operator-sidecar:latest operator --version
```

## Check Version
```bash
docker run --rm cleanstart/minio-operator-sidecar:latest operator --version
```

## Check Image Size
```bash
docker images cleanstart/minio-operator-sidecar:latest
```

## Test Container
```bash
# Test MinIO operator installation
docker run --rm cleanstart/minio-operator-sidecar:latest operator --version

# Run hello world
docker run --rm cleanstart/minio-operator-sidecar:latest python hello_world.py
```

## Sample Projects
For detailed usage examples and demonstrations, see the `sample-project/` directory.
