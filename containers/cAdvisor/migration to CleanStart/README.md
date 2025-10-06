**cAdvisor Migration Project**

This project demonstrates running and testing **cAdvisor** on two different Docker images:

- **v1** → based on `bitnami/cadvisor:latest`  
- **v2** → based on `cleanstart/cadvisor:latest` (Cleanstart image)

This setup is useful for comparing and validating cAdvisor functionality across images.

---

## Project Structure

cadvisor/
├── Dockerfile.v1
├── Dockerfile.v2
└── README.md


### Dockerfile.v1

```bash
# Use Bitnami's cAdvisor image as base
FROM bitnami/cadvisor:latest

# Expose default cadvisor port
EXPOSE 8080
```

### Dockerfile.v2

```bash
# Use Cleanstart's cAdvisor image as base
FROM cleanstart/cadvisor:latest

# Expose default cadvisor port
EXPOSE 8080
```

**Steps to Run**

1. Build Images

```bash
# Build v1 (Bitnami cAdvisor)
docker build -t cadvisor-v1 -f Dockerfile.v1 .
```

```bash
# Build v2 (Cleanstart cAdvisor)
docker build -t cadvisor-v2 -f Dockerfile.v2 .
```

2. Run Containers
Run with system access so cAdvisor can collect metrics:

```bash
# Run v1 (Bitnami)
docker run -d \
  --name cadvisor-v1-container \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  -p 8081:8080 \
  cadvisor-v1
```

```bash
# Run v2 (Cleanstart)
docker run -d \
  --name cadvisor-v2-container \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  -p 8082:8080 \
  cadvisor-v2
```

3. Test cAdvisor UI
Open your browser:

v1 (Bitnami) → http://localhost:8081

v2 (Cleanstart) → http://localhost:8082

Both should show the cAdvisor web UI with live container metrics.

4. Stopping Containers

```bash
docker stop cadvisor-v1-container cadvisor-v2-container
docker rm cadvisor-v1-container cadvisor-v2-container
```

**Notes:**
v1 (Bitnami) → maintained community build.

v2 (Cleanstart) → lightweight, runs as user clnstrt, defaults to -logtostderr, and exposes health check at /healthz.

Both images expose the cAdvisor dashboard on port 8080.