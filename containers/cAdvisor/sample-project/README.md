# cAdvisor Sample Projects

This directory contains comprehensive examples demonstrating container monitoring with cAdvisor. Each example provides different levels of complexity and monitoring scenarios to help you understand and implement container monitoring in various environments.

## 📁 Project Structure

```
images/cAdvisor/sample-project/
├── basic-monitoring/        # Simple single-container monitoring
│   ├── docker-compose.yml   # Basic monitoring setup
│   └── README.md           # Basic monitoring documentation
├── multi-container/         # Full application stack monitoring
│   ├── docker-compose.yml   # Multi-service monitoring
│   └── README.md           # Multi-container documentation
├── production-setup/        # Production-ready monitoring stack
│   ├── docker-compose.yml   # Production monitoring with Prometheus, Grafana
│   └── README.md           # Production setup documentation
├── setup.sh                # Linux/macOS setup script
├── setup.bat               # Windows setup script
└── README.md              # This file
```

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Basic understanding of container monitoring
- At least 2GB of available RAM for production setup

### Using Setup Scripts (Recommended)

**For Linux/macOS:**
```bash
cd images/cAdvisor/sample-project
chmod +x setup.sh
./setup.sh
```

**For Windows:**
```cmd
cd images\cAdvisor\sample-project
setup.bat
```

### Manual Setup

1. **Navigate to the sample project directory**
   ```bash
   cd images/cAdvisor/sample-project
   ```

2. **Choose an example to run:**
   - **Basic Monitoring**: `cd basic-monitoring && docker-compose up -d`
   - **Multi-Container**: `cd multi-container && docker-compose up -d`
   - **Production Setup**: `cd production-setup && docker-compose up -d`

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

#### 1. Basic Monitoring Testing

**Navigate to Basic Monitoring:**
```bash
cd images/cAdvisor/sample-project/basic-monitoring
```

**Start the Sample Project:**
```bash
# Start all containers in detached mode
docker-compose up -d

# Verify all containers are running
docker ps
```

**Expected Container Status:**
```bash
# Check container status
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Expected output:
# cadvisor-basic     Up X minutes (healthy)     0.0.0.0:8085->8080/tcp
# test-app-basic     Up X minutes (healthy)     0.0.0.0:8081->80/tcp
# cpu-test-basic     Up X minutes (healthy)
# memory-test-basic  Up X minutes (healthy)
```

**Test Web Interfaces:**
```bash
# Test cAdvisor Web UI (Linux/macOS)
curl -I http://localhost:8085

# Test cAdvisor Web UI (Windows PowerShell)
Invoke-WebRequest -Uri "http://localhost:8085" -Method Head

# Test Nginx Test App (Linux/macOS)
curl -I http://localhost:8081

# Test Nginx Test App (Windows PowerShell)
Invoke-WebRequest -Uri "http://localhost:8081" -Method Head

# Expected result for both: HTTP/1.1 200 OK
```

**Test Container Activity:**
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

**Access Web Dashboards:**
- **cAdvisor Dashboard**: http://localhost:8085
- **Test Nginx App**: http://localhost:8081

**What to Verify in cAdvisor Dashboard:**
- Container list with all running containers
- CPU usage graphs (especially from cpu-test-basic)
- Memory usage graphs (especially from memory-test-basic)
- Network activity from test-app-basic
- System-wide metrics

#### 2. Multi-Container Testing

**Navigate to Multi-Container:**
```bash
cd ../multi-container
```

**Start Multi-Container Setup:**
```bash
# Start the multi-container environment
docker-compose up -d

# Verify all services are running
docker ps
```

**Test All Services:**
```bash
# Test web application
curl -I http://localhost:8081

# Test API server
curl -I http://localhost:8082

# Test database connectivity
docker exec multi-container-database-1 pg_isready -U postgres

# Test Redis connectivity
docker exec multi-container-cache-1 redis-cli ping
```

**Expected Results:**
- All containers should be healthy
- Web app accessible at http://localhost:8081
- API server accessible at http://localhost:8082
- Database and Redis responding to health checks

#### 3. Production Setup Testing

**Navigate to Production Setup:**
```bash
cd ../production-setup
```

**Start Production Environment:**
```bash
# Start the production monitoring stack
docker-compose up -d

# Wait for all services to be ready (may take 1-2 minutes)
sleep 60

# Verify all services are running
docker ps
```

**Test Production Services:**
```bash
# Test cAdvisor
curl -I http://localhost:8085

# Test Prometheus
curl -I http://localhost:9090

# Test Grafana
curl -I http://localhost:3000

# Test AlertManager
curl -I http://localhost:9093
```

**Access Production Dashboards:**
- **cAdvisor**: http://localhost:8085
- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3000 (admin/admin123)
- **AlertManager**: http://localhost:9093

**Grafana Setup:**
1. Open http://localhost:3000
2. Login with admin/admin123
3. Add Prometheus as data source (http://prometheus:9090)
4. Import cAdvisor dashboards

#### 4. Cleanup After Testing

**Stop and Cleanup:**
```bash
# Stop all containers
docker-compose down

# Remove all related containers and networks
docker-compose down --volumes --remove-orphans

# Verify cleanup
docker ps | grep cadvisor
```

### Troubleshooting Testing Issues

**Port Conflicts:**
```bash
# Check what's using port 8080
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
docker logs <container-name>

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
docker exec <container-name> wget -q -O- http://localhost:8080

# Check firewall settings
sudo ufw status
```

**Production Setup Issues:**
```bash
# Check if all services are ready
docker-compose ps

# Check service dependencies
docker-compose logs prometheus
docker-compose logs grafana

# Verify network connectivity
docker network ls
docker network inspect <network-name>
```

### Expected Test Results

**✅ Successful Test Indicators:**
- All containers show "Up" status with "(healthy)"
- Web UIs return HTTP 200 OK
- CPU test container shows continuous activity logs
- Memory test container is running (may not show logs)
- Nginx test container shows HTTP request logs
- cAdvisor dashboard displays all containers and metrics
- Production setup shows all services (cAdvisor, Prometheus, Grafana, AlertManager)

**❌ Common Issues to Watch For:**
- Port conflicts (containers won't start)
- Permission denied errors (Docker socket access)
- Network connectivity issues (web UI not accessible)
- Resource constraints (containers fail to start)
- Volume mount issues (cAdvisor can't access host resources)
- Service dependency issues (production setup)
- Database connection issues (multi-container setup)

## 📊 Examples Overview

### 1. Basic Monitoring (`basic-monitoring/`)

**Purpose**: Learn the fundamentals of container monitoring with cAdvisor.

**Features**:
- Single cAdvisor instance
- Test containers with different resource usage patterns
- Basic web UI exploration
- Simple metrics understanding

**Components**:
- **cAdvisor**: Container monitoring tool
- **test-app**: Nginx web server (normal workload)
- **cpu-test**: Busybox container with continuous CPU usage
- **memory-test**: Python container consuming memory

**Access Points**:
- cAdvisor Web UI: `http://localhost:8080`
- Test App: `http://localhost:8081`

**Learning Objectives**:
- Understanding basic cAdvisor setup
- Reading container metrics
- Identifying resource usage patterns
- Basic troubleshooting

### 2. Multi-Container Monitoring (`multi-container/`)

**Purpose**: Monitor a complete application stack with multiple interconnected services.

**Features**:
- Full application stack monitoring
- Network communication between services
- Different types of workloads
- Real-world monitoring scenarios

**Components**:
- **cAdvisor**: Container monitoring tool
- **web-app**: Nginx frontend server
- **api-server**: Node.js API server
- **database**: PostgreSQL database
- **cache**: Redis cache server
- **worker**: Python background worker
- **load-generator**: Traffic generator
- **file-processor**: File processing service

**Access Points**:
- cAdvisor Web UI: `http://localhost:8080`
- Web App: `http://localhost:8081`
- API Server: `http://localhost:8082`
- Database: `localhost:5432`
- Redis Cache: `localhost:6379`

**Learning Objectives**:
- Monitoring complex application stacks
- Understanding service dependencies
- Network traffic analysis
- Performance bottleneck identification

### 3. Production Setup (`production-setup/`)

**Purpose**: Enterprise-grade monitoring setup with advanced features and integrations.

**Features**:
- Production-ready monitoring stack
- Metrics persistence and visualization
- Alerting and notification system
- Security and performance optimizations

**Components**:
- **cAdvisor**: Container monitoring tool
- **nginx-proxy**: Reverse proxy for security
- **prometheus**: Metrics collection and storage
- **grafana**: Metrics visualization and dashboards
- **alertmanager**: Alert routing and notification

**Access Points**:
- cAdvisor Web UI: `http://localhost:8080`
- Prometheus: `http://localhost:9090`
- Grafana: `http://localhost:3000` (admin/admin123)
- AlertManager: `http://localhost:9093`

**Learning Objectives**:
- Production monitoring architecture
- Metrics collection and storage
- Dashboard creation and customization
- Alert configuration and management

## 🎯 Learning Path

### Beginner Level
1. **Start with Basic Monitoring**
   - Understand cAdvisor fundamentals
   - Learn to read basic metrics
   - Explore the web UI

2. **Practice with Test Containers**
   - Monitor different resource usage patterns
   - Understand CPU vs Memory vs Network metrics
   - Learn basic troubleshooting

### Intermediate Level
1. **Move to Multi-Container Monitoring**
   - Monitor complex application stacks
   - Understand service dependencies
   - Analyze network communication

2. **Performance Analysis**
   - Identify bottlenecks
   - Optimize resource usage
   - Capacity planning

### Advanced Level
1. **Production Setup**
   - Implement enterprise monitoring
   - Configure alerts and notifications
   - Create custom dashboards

2. **Integration and Automation**
   - Connect with other monitoring tools
   - Implement automated monitoring
   - Scale monitoring infrastructure

## 🔧 Configuration Options

### cAdvisor Configuration

**Basic Configuration**:
```yaml
cadvisor:
  image: cleanstart/cadvisor:latest
  ports:
    - "8080:8080"
  volumes:
    - /:/rootfs:ro
    - /var/run:/var/run:ro
    - /sys:/sys:ro
    - /var/lib/docker/:/var/lib/docker:ro
```

**Production Configuration**:
```yaml
cadvisor:
  image: cleanstart/cadvisor:latest
  ports:
    - "127.0.0.1:8080:8080"  # Bind to localhost only
  volumes:
    - /:/rootfs:ro
    - /var/run:/var/run:ro
    - /sys:/sys:ro
    - /var/lib/docker/:/var/lib/docker:ro
    - cadvisor_data:/var/lib/cadvisor
  environment:
    - CADVISOR_STORAGE_DRIVER=memory
    - CADVISOR_STORAGE_DURATION=2m
  deploy:
    resources:
      limits:
        memory: 512M
        cpus: '0.5'
```

### Resource Limits

**CPU and Memory Limits**:
```yaml
services:
  my-app:
    image: my-app:latest
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 1G
        reservations:
          cpus: '0.5'
          memory: 512M
```

### Health Checks

**Basic Health Check**:
```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:8080/health"]
  interval: 30s
  timeout: 10s
  retries: 3
```

**Advanced Health Check**:
```yaml
healthcheck:
  test: ["CMD-SHELL", "pg_isready -U user -d database"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

## 📈 Monitoring Best Practices

### 1. Resource Monitoring
- **CPU Usage**: Monitor per-core and overall utilization
- **Memory Usage**: Watch for memory leaks and high usage
- **Disk I/O**: Monitor read/write operations and throughput
- **Network I/O**: Track bandwidth usage and connection counts

### 2. Container Lifecycle
- **Start/Stop Events**: Monitor container lifecycle events
- **Restart Patterns**: Identify containers that restart frequently
- **Resource Limits**: Ensure containers respect resource constraints

### 3. Performance Optimization
- **Bottleneck Identification**: Find resource constraints
- **Capacity Planning**: Plan for future resource needs
- **Cost Optimization**: Optimize resource usage for cost efficiency

### 4. Security Monitoring
- **Access Control**: Monitor container access patterns
- **Network Security**: Track network communication
- **Resource Isolation**: Ensure proper resource isolation

## 🔍 Troubleshooting

### Common Issues

**cAdvisor not showing containers**:
```bash
# Check if cAdvisor has proper permissions
docker exec cadvisor ls -la /var/run/docker.sock

# Verify volume mounts
docker exec cadvisor ls -la /var/lib/docker

# Check cAdvisor logs
docker logs cadvisor
```

**High resource usage**:
```bash
# Check container resource usage
docker stats

# View detailed container metrics
curl http://localhost:8080/api/v1.3/docker/<container-id>

# Check container logs for issues
docker logs <container-name>
```

**Web UI not accessible**:
```bash
# Check if container is running
docker ps | grep cadvisor

# Test connectivity
curl -v http://localhost:8080

# Check port binding
netstat -tulpn | grep :8080
```

### Performance Issues

**High CPU Usage**:
- Check for infinite loops or inefficient algorithms
- Monitor CPU limits and reservations
- Consider horizontal scaling

**High Memory Usage**:
- Look for memory leaks
- Monitor memory limits
- Consider garbage collection tuning

**Network Issues**:
- Check network policies and security groups
- Monitor bandwidth usage
- Verify service discovery

## 🛡️ Security Considerations

### 1. Access Control
- Bind cAdvisor to localhost only in production
- Use reverse proxy with authentication
- Implement network segmentation

### 2. Data Protection
- Use read-only volume mounts
- Implement data encryption
- Regular security audits

### 3. Container Security
- Run containers as non-root users
- Use minimal base images
- Regular security updates

## 🔗 Integration Examples

### Prometheus Integration
```yaml
scrape_configs:
  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']
    metrics_path: /metrics
    scrape_interval: 15s
```

### Grafana Dashboard
```json
{
  "dashboard": {
    "title": "Container Monitoring",
    "panels": [
      {
        "title": "CPU Usage",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(container_cpu_usage_seconds_total{name=~\".*\"}[5m])"
          }
        ]
      }
    ]
  }
}
```

### Alert Rules
```yaml
groups:
  - name: container_alerts
    rules:
      - alert: HighCPUUsage
        expr: rate(container_cpu_usage_seconds_total{name=~\".*\"}[5m]) > 0.8
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage detected"
```

## 📚 Additional Resources

### Documentation
- [cAdvisor Official Documentation](https://github.com/google/cadvisor)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)

### Community
- [Docker Community](https://community.docker.com/)
- [Prometheus Community](https://prometheus.io/community/)
- [Grafana Community](https://community.grafana.com/)

### Tools and Extensions
- [cAdvisor Exporter](https://github.com/google/cadvisor/tree/master/cmd/exporters)
- [Grafana Dashboards](https://grafana.com/grafana/dashboards/)
- [Prometheus Exporters](https://prometheus.io/docs/instrumenting/exporters/)

## 🤝 Contributing

We welcome contributions to improve these examples:

1. **Add new monitoring scenarios**
2. **Improve documentation**
3. **Create additional examples**
4. **Fix bugs and issues**
5. **Add new integrations**

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../../LICENSE) file for details.

---

**Happy Monitoring! 📊**
