# Basic Container Monitoring with cAdvisor

This example demonstrates basic container monitoring using cAdvisor. It includes cAdvisor and several test containers to monitor different types of resource usage.

## 🚀 Quick Start

## 🧪 Complete Testing Guide

### Prerequisites for Testing
```bash
# Pull the cAdvisor image from Docker Hub
docker pull cleanstart/cadvisor:latest
```

### Build with Dockerfile
```bash
 FROM cleanstart/cadvisor:latest-dev

 USER clnstrt

 ENV LD_PRELOAD=

 ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

 ENTRYPOINT ["/usr/bin/cadvisor"]

 CMD ["-logtostderr"]

 COPY --from=builder /path/to/cadvisor /usr/bin/cadvisor
 COPY --from=builder /path/to/certs /etc/ssl/certs/ca-certificates.crt
```

### Build the image
```bash
docker build --no-cache -t my-cadvisor .
```
### Run the Image and see the Output on Localhost
```bash
docker run --rm my-cadvisor
```
Access the Application on http://localhost:8080/

### Step-by-Step Testing Instructions

#### 1. Verify Container Status
```bash
# Check if all containers are healthy
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Expected output:
# cadvisor-basic     Up X minutes (healthy)     0.0.0.0:8085->8080/tcp
# test-app-basic     Up X minutes (healthy)     0.0.0.0:8081->80/tcp
# cpu-test-basic     Up X minutes (healthy)
# memory-test-basic  Up X minutes (healthy)
```

#### 1. Test Web Interfaces

**Test cAdvisor Web UI:**
```bash
# Using curl (Linux/macOS)
curl -I http://localhost:8085

# Using PowerShell (Windows)
Invoke-WebRequest -Uri "http://localhost:8080" -Method Head

# Expected result: HTTP/1.1 200 OK
```

#### 3. Test Container Activity
```bash
# Check CPU test container logs
docker logs cpu-test-basic --tail 5
# Expected: "CPU test running..." messages

# Check memory test container
docker logs memory-test-basic --tail 3
# Expected: No output (silently consuming memory)

# Check Nginx test container
docker logs test-app-basic --tail 3
# Expected: HTTP request logs
```

#### 4. Access Web Dashboards

**Open in your browser:**
- **cAdvisor Dashboard**: http://localhost:8080

**What to look for in cAdvisor:**
- Container list with all running containers
- CPU usage graphs (especially from cpu-test-basic)
- Memory usage graphs (especially from memory-test-basic)
- Network activity from test-app-basic
- System-wide metrics

#### 6. Test Container Metrics via API
```bash
# Get all container metrics
curl http://localhost:8085/api/v1.3/docker/

# Get specific container metrics
curl http://localhost:8085/api/v1.3/docker/cpu-test-basic

# Get system metrics
curl http://localhost:8085/api/v1.3/machine/
```


### Troubleshooting Testing Issues

**Port Conflicts:**
```bash
# If port 8085 is already in use, check what's using it
netstat -tulpn | grep :8080

# Stop conflicting containers
docker stop <container-name>


### Expected Test Results

**✅ Successful Test Indicators:**
- All containers show "Up" status with "(healthy)"
- cAdvisor web UI returns HTTP 200 OK
- Test application web UI returns HTTP 200 OK
- CPU test container shows continuous activity logs
- Memory test container is running (may not show logs)
- Nginx test container shows HTTP request logs
- cAdvisor dashboard displays all containers and metrics

## 🔍 Key Metrics to Watch

### CPU Usage
- **test-app-basic**: Low CPU usage (normal web server)
- **cpu-test-basic**: Higher CPU usage (continuous loop)
- **memory-test-basic**: Low CPU usage (memory-focused)

### Network I/O
- **test-app-basic**: Network traffic when accessed
- **cpu-test-basic**: Minimal network usage
- **memory-test-basic**: Minimal network usage


### cAdvisor API Access
```bash
# Get metrics in JSON format
curl http://localhost:8080/api/v1.3/docker/

# Get specific container metrics
curl http://localhost:8080/api/v1.3/docker/cpu-test-basic

# Get system metrics
curl http://localhost:8080/api/v1.3/machine/
```

