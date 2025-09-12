# Basic Container Monitoring with cAdvisor

This example demonstrates basic container monitoring using cAdvisor. It includes cAdvisor and several test containers to monitor different types of resource usage.

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Basic understanding of container monitoring

### Running the Example

1. **Start the monitoring stack**
   ```bash
   docker-compose up -d
   ```

2. **Access cAdvisor Web UI**
   - Open your browser and go to: `http://localhost:8085`
   - You'll see the cAdvisor dashboard with all running containers

3. **Test the monitored applications**
   - **Nginx Test App**: `http://localhost:8081`
   - **CPU Test**: Running in background (check logs with `docker logs cpu-test-basic`)
   - **Memory Test**: Running in background (check logs with `docker logs memory-test-basic`)

## 🧪 Complete Testing Guide

### Prerequisites for Testing
```bash
# Ensure Docker and Docker Compose are installed
docker --version
docker-compose --version

# Pull the cAdvisor image from Docker Hub
docker pull cleanstart/cadvisor:latest
```

### Step-by-Step Testing Instructions

#### 1. Start the Sample Project
```bash
# Navigate to the basic monitoring directory
cd images/cAdvisor/sample-project/basic-monitoring

# Start all containers in detached mode
docker-compose up -d

# Verify all containers are running
docker ps
```

#### 2. Verify Container Status
```bash
# Check if all containers are healthy
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Expected output:
# cadvisor-basic     Up X minutes (healthy)     0.0.0.0:8085->8080/tcp
# test-app-basic     Up X minutes (healthy)     0.0.0.0:8081->80/tcp
# cpu-test-basic     Up X minutes (healthy)
# memory-test-basic  Up X minutes (healthy)
```

#### 3. Test Web Interfaces

**Test cAdvisor Web UI:**
```bash
# Using curl (Linux/macOS)
curl -I http://localhost:8085

# Using PowerShell (Windows)
Invoke-WebRequest -Uri "http://localhost:8085" -Method Head

# Expected result: HTTP/1.1 200 OK
```

**Test Nginx Test Application:**
```bash
# Using curl (Linux/macOS)
curl -I http://localhost:8081

# Using PowerShell (Windows)
Invoke-WebRequest -Uri "http://localhost:8081" -Method Head

# Expected result: HTTP/1.1 200 OK
```

#### 4. Test Container Activity
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

#### 5. Access Web Dashboards

**Open in your browser:**
- **cAdvisor Dashboard**: http://localhost:8085
- **Test Nginx App**: http://localhost:8081

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

#### 7. Monitor Real-time Resource Usage
```bash
# Monitor all containers in real-time
docker stats

# Monitor specific container
docker stats cpu-test-basic memory-test-basic
```

#### 8. Cleanup After Testing
```bash
# Stop and remove containers
docker-compose down

# Remove all related containers and networks
docker-compose down --volumes --remove-orphans

# Verify cleanup
docker ps | grep cadvisor
```

### Troubleshooting Testing Issues

**Port Conflicts:**
```bash
# If port 8085 is already in use, check what's using it
netstat -tulpn | grep :8085

# Stop conflicting containers
docker stop <container-name>

# Or modify docker-compose.yml to use different ports
```

**Container Won't Start:**
```bash
# Check detailed logs
docker-compose logs

# Check individual container logs
docker logs cadvisor-basic

# Verify Docker daemon is running
docker info
```

**Permission Issues:**
```bash
# On Linux, ensure Docker socket permissions
sudo chmod 666 /var/run/docker.sock

# Or add user to docker group
sudo usermod -aG docker $USER
```

**Web UI Not Accessible:**
```bash
# Check if containers are running
docker ps

# Test connectivity from inside container
docker exec cadvisor-basic wget -q -O- http://localhost:8080

# Check firewall settings
sudo ufw status
```

### Expected Test Results

**✅ Successful Test Indicators:**
- All containers show "Up" status with "(healthy)"
- cAdvisor web UI returns HTTP 200 OK
- Test application web UI returns HTTP 200 OK
- CPU test container shows continuous activity logs
- Memory test container is running (may not show logs)
- Nginx test container shows HTTP request logs
- cAdvisor dashboard displays all containers and metrics

**❌ Common Issues to Watch For:**
- Port conflicts (containers won't start)
- Permission denied errors (Docker socket access)
- Network connectivity issues (web UI not accessible)
- Resource constraints (containers fail to start)
- Volume mount issues (cAdvisor can't access host resources)

## 📊 What You'll See

### cAdvisor Dashboard Features
- **Container List**: All running containers on the host
- **Resource Usage**: Real-time CPU, memory, disk, and network metrics
- **Performance Graphs**: Historical data and trends
- **Container Details**: Individual container statistics

### Monitored Containers
1. **cadvisor-basic**: The monitoring tool itself
2. **test-app-basic**: Nginx web server (normal workload)
3. **cpu-test-basic**: Busybox container with continuous CPU usage
4. **memory-test-basic**: Python container consuming memory

## 🔍 Key Metrics to Watch

### CPU Usage
- **test-app-basic**: Low CPU usage (normal web server)
- **cpu-test-basic**: Higher CPU usage (continuous loop)
- **memory-test-basic**: Low CPU usage (memory-focused)

### Memory Usage
- **test-app-basic**: Low memory usage (~10-20MB)
- **cpu-test-basic**: Very low memory usage (~1-2MB)
- **memory-test-basic**: High memory usage (~100MB+)

### Network I/O
- **test-app-basic**: Network traffic when accessed
- **cpu-test-basic**: Minimal network usage
- **memory-test-basic**: Minimal network usage

## 🛠️ Customization

### Adding More Test Containers
Add new services to `docker-compose.yml`:

```yaml
  # Example: Database container
  db-test:
    image: postgres:13-alpine
    container_name: db-test-basic
    environment:
      POSTGRES_PASSWORD: test123
    restart: unless-stopped
```

### Modifying Resource Limits
Add resource constraints to containers:

```yaml
  cpu-test:
    image: busybox:latest
    container_name: cpu-test-basic
    command: ["sh", "-c", "while true; do echo 'CPU test running...'; sleep 1; done"]
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 100M
        reservations:
          cpus: '0.1'
          memory: 50M
```

## 📈 Monitoring Tips

### 1. Watch for Resource Bottlenecks
- **High CPU Usage**: Look for containers using >80% CPU consistently
- **High Memory Usage**: Watch for containers approaching memory limits
- **Disk I/O**: Monitor containers with high read/write operations

### 2. Performance Optimization
- **Identify inefficient containers**: Look for high resource usage with low output
- **Resource limits**: Set appropriate CPU and memory limits
- **Container lifecycle**: Monitor start/stop patterns

### 3. Troubleshooting
- **Container not showing**: Check if container is running (`docker ps`)
- **No metrics**: Verify cAdvisor has proper permissions
- **High resource usage**: Check container logs for issues

## 🔧 Useful Commands

### Check Container Status
```bash
# List all containers
docker ps

# Check specific container logs
docker logs cpu-test-basic

# Monitor resource usage in real-time
docker stats
```

### cAdvisor API Access
```bash
# Get metrics in JSON format
curl http://localhost:8080/api/v1.3/docker/

# Get specific container metrics
curl http://localhost:8080/api/v1.3/docker/cpu-test-basic

# Get system metrics
curl http://localhost:8080/api/v1.3/machine/
```

### Cleanup
```bash
# Stop all containers
docker-compose down

# Remove all containers and volumes
docker-compose down -v

# Remove all images
docker-compose down --rmi all
```

## 🎯 Learning Objectives

After completing this example, you should understand:

1. **How cAdvisor works**: Basic monitoring setup and configuration
2. **Resource monitoring**: CPU, memory, disk, and network metrics
3. **Container performance**: Identifying resource usage patterns
4. **Troubleshooting**: Common monitoring issues and solutions
5. **Best practices**: Container monitoring and optimization

## 🔗 Next Steps

- **Multi-Container Monitoring**: Try the multi-container example
- **Production Setup**: Explore the production-ready configuration
- **Integration**: Connect cAdvisor with Prometheus and Grafana
- **Custom Metrics**: Add application-specific monitoring

---

**Happy Monitoring! 📊**
