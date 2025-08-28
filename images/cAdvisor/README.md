# cAdvisor Docker Image

A container monitoring tool that provides detailed resource usage and performance characteristics of running containers. cAdvisor (Container Advisor) helps you understand the resource usage and performance characteristics of your containerized applications.

## 🚀 Quick Start

### Option 1: Using Pre-built Image from Docker Hub
```bash
# Pull the image from Docker Hub
docker pull cleanstart/cadvisor:latest

# Run the container with host access for monitoring
docker run -d \
  --name=cadvisor \
  --restart=unless-stopped \
  -p 8080:8080 \
  -v /:/rootfs:ro \
  -v /var/run:/var/run:ro \
  -v /sys:/sys:ro \
  -v /var/lib/docker/:/var/lib/docker:ro \
  -v /dev/disk/:/dev/disk:ro \
  cleanstart/cadvisor:latest

# Access the web UI
open http://localhost:8080
```

### Option 2: Build Locally
```bash
# Build the image locally
docker build -t cadvisor-hello .

# Run the container
docker run -d \
  --name=cadvisor \
  -p 8080:8080 \
  -v /:/rootfs:ro \
  -v /var/run:/var/run:ro \
  -v /sys:/sys:ro \
  -v /var/lib/docker/:/var/lib/docker:ro \
  cadvisor-hello
```

### Using Docker Compose
```yaml
version: '3.8'
services:
  cadvisor:
    image: cleanstart/cadvisor:latest
    container_name: cadvisor
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
      - /dev/disk/:/dev/disk:ro
    privileged: true
```

## 📋 Prerequisites

- Docker installed on your system
- Basic understanding of container monitoring and metrics
- Access to host system resources (for full monitoring)

## 🛠️ Installation & Setup

### Method 1: Using Pre-built Image (Recommended for Quick Start)

1. **Ensure Docker is installed and running**
   ```bash
   docker --version
   ```

2. **Pull the image from Docker Hub**
   ```bash
   docker pull cleanstart/cadvisor:latest
   ```

3. **Run the container with proper permissions**
   ```bash
   docker run -d \
     --name=cadvisor \
     --restart=unless-stopped \
     -p 8080:8080 \
     -v /:/rootfs:ro \
     -v /var/run:/var/run:ro \
     -v /sys:/sys:ro \
     -v /var/lib/docker/:/var/lib/docker:ro \
     -v /dev/disk/:/dev/disk:ro \
     cleanstart/cadvisor:latest
   ```

4. **Verify the container is running**
   ```bash
   docker ps
   ```

5. **Access the web UI**
   - Open your browser and go to: `http://localhost:8080`
   - Or use curl: `curl http://localhost:8080`

### Method 2: Build and Run Locally

1. **Clone or download this repository**
   ```bash
   git clone <repository-url>
   cd cleanstart-containers
   ```

2. **Navigate to the cAdvisor directory**
   ```bash
   cd images/cAdvisor
   ```

3. **Build the Docker image locally**
   ```bash
   docker build -t cadvisor-hello .
   ```

4. **Run the container**
   ```bash
   docker run -d \
     --name=cadvisor \
     -p 8080:8080 \
     -v /:/rootfs:ro \
     -v /var/run:/var/run:ro \
     -v /sys:/sys:ro \
     -v /var/lib/docker/:/var/lib/docker:ro \
     cadvisor-hello
   ```

### Method 3: Using Sample Projects

1. **Navigate to sample projects**
   ```bash
   cd images/cAdvisor/sample-project
   ```

2. **Choose an example to test:**
   - **Basic Monitoring:** `cd basic-monitoring`
   - **Multi-Container:** `cd multi-container`
   - **Production Setup:** `cd production-setup`

3. **Run the example**
   ```bash
   # For basic monitoring
   docker-compose up -d
   
   # For multi-container monitoring
   docker-compose -f docker-compose.multi.yml up -d
   
   # For production setup
   docker-compose -f docker-compose.prod.yml up -d
   ```

## 🧪 Testing & Verification

### Quick Test Commands
```bash
# Test if container is running
docker ps | grep cadvisor

# Test web UI response
curl -I http://localhost:8080

# Check container logs
docker logs cadvisor

# Test metrics endpoint
curl http://localhost:8080/metrics
```

### Expected Results
- **HTTP Status:** 200 OK
- **Content-Type:** text/html (for web UI)
- **Metrics:** Available at `/metrics` endpoint
- **Web UI:** Interactive dashboard at root URL

## 🚀 Complete Sample Project Testing Guide

### Prerequisites for Testing
```bash
# Ensure Docker and Docker Compose are installed
docker --version
docker-compose --version

# Pull the cAdvisor image from Docker Hub
docker pull cleanstart/cadvisor:latest
```

### Step-by-Step Testing Instructions

#### 1. Navigate to Sample Project
```bash
# Navigate to the basic monitoring example
cd images/cAdvisor/sample-project/basic-monitoring
```

#### 2. Start the Sample Project
```bash
# Start all containers in detached mode
docker-compose up -d

# Verify all containers are running
docker ps
```

#### 3. Test Container Status
```bash
# Check if all containers are healthy
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Expected output should show:
# cadvisor-basic     Up 24 minutes (healthy)     0.0.0.0:8085->8080/tcp
# test-app-basic     Up 24 minutes (healthy)     0.0.0.0:8081->80/tcp
# cpu-test-basic     Up 24 minutes (healthy)
# memory-test-basic  Up 24 minutes (healthy)
```

#### 4. Test Web Interfaces

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

#### 5. Test Container Activity
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

#### 6. Access Web Dashboards

**Open in your browser:**
- **cAdvisor Dashboard**: http://localhost:8085
- **Test Nginx App**: http://localhost:8081

**What to look for in cAdvisor:**
- Container list with all running containers
- CPU usage graphs (especially from cpu-test-basic)
- Memory usage graphs (especially from memory-test-basic)
- Network activity from test-app-basic
- System-wide metrics

#### 7. Test Different Sample Projects

**Multi-Container Monitoring:**
```bash
cd ../multi-container
docker-compose up -d
# Access at: http://localhost:8085
```

**Production Setup:**
```bash
cd ../production-setup
docker-compose up -d
# Access cAdvisor at: http://localhost:8085
# Access Grafana at: http://localhost:3000 (admin/admin)
# Access Prometheus at: http://localhost:9090
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
# If port 8080 is already in use, check what's using it
netstat -tulpn | grep :8080

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

## 🎯 What You'll Learn

- **Container Monitoring**: Understanding resource usage patterns
- **Performance Metrics**: CPU, memory, disk, and network monitoring
- **Resource Optimization**: Identifying bottlenecks and optimization opportunities
- **Capacity Planning**: Understanding resource requirements
- **Troubleshooting**: Debugging performance issues
- **Docker Best Practices**: Monitoring and observability patterns

## 🔧 Key Features

### Core Functionality
- **Real-time Monitoring**: Live resource usage tracking
- **Historical Data**: Performance trends over time
- **Container-level Metrics**: Individual container statistics
- **System-level Metrics**: Host system resource usage
- **Web Dashboard**: Interactive visualization interface
- **REST API**: Programmatic access to metrics

### Monitoring Capabilities
- **CPU Usage**: Per-core and overall CPU utilization
- **Memory Usage**: RAM consumption and limits
- **Disk I/O**: Read/write operations and throughput
- **Network I/O**: Network traffic and bandwidth usage
- **Container Events**: Start, stop, and lifecycle events
- **Resource Limits**: CPU and memory limits enforcement

### Integration Features
- **Prometheus Integration**: Metrics export for Prometheus
- **Grafana Dashboards**: Pre-built visualization templates
- **Alerting**: Resource threshold monitoring
- **Multi-host Support**: Cluster-wide monitoring
- **Custom Metrics**: Application-specific monitoring

## 📁 Project Structure

```
images/cAdvisor/
├── Dockerfile              # Main Dockerfile for cAdvisor setup
├── hello_world.py          # Python script demonstrating monitoring concepts
├── README.md              # This file
└── sample-project/        # Advanced examples and tutorials
    ├── basic-monitoring/  # Basic single-container monitoring
    ├── multi-container/   # Multi-container monitoring setup
    ├── production-setup/  # Production-ready monitoring
    ├── setup.sh          # Linux/macOS setup script
    └── setup.bat         # Windows setup script
```

## 🐳 Docker Hub Integration

### Available Images
- **`cleanstart/cadvisor:latest`** - Latest stable version
- **`cleanstart/cadvisor:v0.47`** - Specific version tag

### Pull and Run Commands
```bash
# Pull the latest image
docker pull cleanstart/cadvisor:latest

# Run with basic monitoring
docker run -d -p 8080:8080 --name cadvisor cleanstart/cadvisor:latest

# Run with full host access
docker run -d \
  --name=cadvisor \
  -p 8080:8080 \
  -v /:/rootfs:ro \
  -v /var/run:/var/run:ro \
  -v /sys:/sys:ro \
  -v /var/lib/docker/:/var/lib/docker:ro \
  cleanstart/cadvisor:latest
```

### Docker Compose Example
```yaml
version: '3.8'
services:
  cadvisor:
    image: cleanstart/cadvisor:latest
    container_name: cadvisor
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    privileged: true
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:8080/healthz"]
      interval: 30s
      timeout: 10s
      retries: 3
```

## 🎓 Learning Path

### Beginner Level
1. **Start with basic setup** - Run cAdvisor and explore the web UI
2. **Understand metrics** - Learn about CPU, memory, and disk metrics
3. **Monitor simple containers** - Watch resource usage of basic applications

### Intermediate Level
1. **Multi-container monitoring** - Monitor multiple containers simultaneously
2. **Performance analysis** - Identify bottlenecks and optimization opportunities
3. **Custom dashboards** - Create custom monitoring views

### Advanced Level
1. **Production deployment** - Set up monitoring for production environments
2. **Integration with other tools** - Connect with Prometheus, Grafana, etc.
3. **Custom metrics** - Add application-specific monitoring
4. **Alerting and automation** - Set up automated monitoring and alerts

## 🔍 Comparison with Other Monitoring Tools

| Feature | cAdvisor | Prometheus | Grafana | Datadog |
|---------|----------|------------|---------|---------|
| **Ease of Setup** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Container Focus** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Real-time Data** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Historical Data** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Web UI** | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Integration** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

## 📚 Common Use Cases

### 1. Development Environment Monitoring
```bash
# Monitor development containers
docker run -d \
  --name=cadvisor-dev \
  -p 8080:8080 \
  -v /var/run:/var/run:ro \
  -v /sys:/sys:ro \
  cleanstart/cadvisor:latest
```

### 2. Production Monitoring
```yaml
# docker-compose.prod.yml
version: '3.8'
services:
  cadvisor:
    image: cleanstart/cadvisor:latest
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    privileged: true
```

### 3. Kubernetes Integration
```yaml
# cadvisor-daemonset.yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: cadvisor
spec:
  selector:
    matchLabels:
      name: cadvisor
  template:
    metadata:
      labels:
        name: cadvisor
    spec:
      containers:
      - name: cadvisor
        image: cleanstart/cadvisor:latest
        ports:
        - containerPort: 8080
        volumeMounts:
        - name: rootfs
          mountPath: /rootfs
          readOnly: true
        - name: var-run
          mountPath: /var/run
          readOnly: true
        - name: sys
          mountPath: /sys
          readOnly: true
        - name: docker
          mountPath: /var/lib/docker
          readOnly: true
      volumes:
      - name: rootfs
        hostPath:
          path: /
      - name: var-run
        hostPath:
          path: /var/run
      - name: sys
        hostPath:
          path: /sys
      - name: docker
        hostPath:
          path: /var/lib/docker
```

## 🛡️ Security Best Practices

1. **Use read-only volumes** - Mount host directories as read-only
2. **Limit container privileges** - Avoid running as root when possible
3. **Network isolation** - Use internal networks for monitoring
4. **Access control** - Implement authentication for web UI
5. **Regular updates** - Keep cAdvisor updated to latest version
6. **Audit monitoring** - Monitor the monitoring system itself

## 🔧 Troubleshooting

### Common Issues

**Container won't start**
```bash
# Check container logs
docker logs cadvisor

# Check if ports are available
netstat -tulpn | grep :8080

# Check volume permissions
ls -la /var/run /sys /var/lib/docker
```

**No metrics visible**
```bash
# Check if cAdvisor has access to Docker socket
docker exec cadvisor ls -la /var/run/docker.sock

# Verify volume mounts
docker exec cadvisor ls -la /var/lib/docker

# Check cAdvisor logs
docker logs cadvisor
```

**Permission denied errors**
```bash
# Run with proper permissions
docker run -d \
  --name=cadvisor \
  -p 8080:8080 \
  --privileged \
  cleanstart/cadvisor:latest
```

**Web UI not accessible**
```bash
# Check if container is running
docker ps | grep cadvisor

# Test connectivity
curl -v http://localhost:8080

# Check firewall settings
sudo ufw status
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.

## 🆘 Support

If you encounter any issues or have questions:

1. Check the troubleshooting section above
2. Review the cAdvisor documentation
3. Open an issue in the repository
4. Join our community discussions

---

**Happy Monitoring! 📊**
