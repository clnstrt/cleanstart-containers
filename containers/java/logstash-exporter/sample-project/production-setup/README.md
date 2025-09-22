# 🏭 Logstash Exporter - Production Setup Example

An enterprise-grade monitoring setup demonstrating a complete observability stack with Logstash, logstash-exporter, Prometheus, Grafana, AlertManager, and security best practices.

## 🎯 What This Example Demonstrates

- **Production Logstash**: Optimized Logstash configuration with resource limits
- **logstash-exporter**: Secure and optimized Prometheus exporter
- **Prometheus**: Metrics collection, storage, and querying
- **Grafana**: Advanced dashboards and visualization
- **AlertManager**: Alert routing and notification management
- **Nginx Proxy**: Reverse proxy for security and access control
- **Security**: Network isolation, resource limits, and health checks
- **High Availability**: Production-ready configuration with monitoring

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Ports 9198, 9600, 9090, 3000, 9093, 8080 available
- 4GB+ RAM available for the full stack
- Understanding of production monitoring concepts

### 1. Start the Production Stack

```bash
# Navigate to the example directory
cd images/logstash-exporter/sample-project/production-setup

# Start all services
docker compose up -d

# Check service status
docker compose ps

# View logs
docker compose logs -f
```

### 2. Verify Services Are Running

```bash
# Check logstash-exporter health
curl http://localhost:9198/health

# Check Prometheus health
curl http://localhost:9090/-/healthy

# Check Grafana health
curl http://localhost:3000/api/health

# Check AlertManager health
curl http://localhost:9093/-/healthy

# Check Nginx proxy
curl http://localhost:8080
```

### 3. Access the Monitoring Stack

```bash
# Prometheus (metrics collection)
open http://localhost:9090

# Grafana (dashboards) - admin/admin123
open http://localhost:3000

# AlertManager (alerts)
open http://localhost:9093

# Nginx proxy (secure access)
open http://localhost:8080
```

## 📊 Access Points

| Service | URL | Credentials | Description |
|---------|-----|-------------|-------------|
| **Prometheus** | `http://localhost:9090` | None | Metrics collection and querying |
| **Grafana** | `http://localhost:3000` | admin/admin123 | Dashboards and visualization |
| **AlertManager** | `http://localhost:9093` | None | Alert management and routing |
| **logstash-exporter** | `http://localhost:9198` | None | Prometheus metrics endpoint |
| **Nginx Proxy** | `http://localhost:8080` | None | Secure access to all services |
| **Logstash** | `http://localhost:9600` | None | Logstash API (internal only) |

## 🔍 Monitoring and Testing

### Check Prometheus Metrics

```bash
# Query Logstash metrics
curl "http://localhost:9090/api/v1/query?query=logstash_pipeline_events_in_total"

# Query JVM heap usage
curl "http://localhost:9090/api/v1/query?query=logstash_node_stats_jvm_mem_heap_used_percent"

# Query all Logstash metrics
curl "http://localhost:9090/api/v1/query?query={__name__=~\"logstash_.*\"}"
```

### Test Grafana Dashboards

```bash
# Check if Grafana is ready
curl http://localhost:3000/api/health

# List available dashboards
curl -u admin:admin123 http://localhost:3000/api/search?type=dash-db

# Check data sources
curl -u admin:admin123 http://localhost:3000/api/datasources
```

### Generate Test Data

```bash
# Generate logs to create metrics
curl -X POST http://localhost:8080/generate \
  -H "Content-Type: application/json" \
  -d '{"count": 100, "level": "info"}'

# Generate error logs to trigger alerts
curl -X POST http://localhost:8080/generate \
  -H "Content-Type: application/json" \
  -d '{"count": 50, "level": "error"}'
```

## 📈 Understanding the Production Architecture

### Security Features

- **Network Isolation**: Internal networks for monitoring services
- **Reverse Proxy**: Nginx proxy for secure external access
- **Resource Limits**: CPU and memory limits for all containers
- **Health Checks**: Comprehensive health monitoring
- **Log Rotation**: Automatic log rotation and management

### Monitoring Stack

- **Prometheus**: Time-series metrics collection and storage
- **Grafana**: Advanced visualization and dashboarding
- **AlertManager**: Intelligent alert routing and notification
- **logstash-exporter**: Secure metrics collection from Logstash

### High Availability Features

- **Restart Policies**: Automatic restart on failure
- **Health Checks**: Continuous health monitoring
- **Resource Management**: Proper resource allocation
- **Data Persistence**: Persistent volumes for data retention

## 🔧 Configuration Details

### Prometheus Configuration

```yaml
# prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'logstash-exporter'
    static_configs:
      - targets: ['logstash-exporter:9198']
    scrape_interval: 15s
    metrics_path: /metrics
```

### Grafana Configuration

- **Data Source**: Prometheus at `http://prometheus:9090`
- **Dashboards**: Pre-configured Logstash monitoring dashboards
- **Alerting**: Integrated with AlertManager
- **Authentication**: Admin user with secure password

### AlertManager Configuration

```yaml
# alertmanager.yml
global:
  resolve_timeout: 5m

route:
  group_by: ['alertname']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h
  receiver: 'web.hook'

receivers:
  - name: 'web.hook'
    webhook_configs:
      - url: 'http://127.0.0.1:5001/'
```

## 🧪 Testing Scenarios

### 1. Basic Monitoring Test

```bash
# Generate logs and verify metrics collection
curl -X POST http://localhost:8080/generate \
  -H "Content-Type: application/json" \
  -d '{"count": 50, "level": "info"}'

# Check Prometheus metrics
curl "http://localhost:9090/api/v1/query?query=logstash_pipeline_events_in_total"

# Verify Grafana dashboards
curl -u admin:admin123 http://localhost:3000/api/health
```

### 2. Alert Testing

```bash
# Generate high volume to trigger memory alert
curl -X POST http://localhost:8080/generate \
  -H "Content-Type: application/json" \
  -d '{"count": 1000, "level": "info"}'

# Check AlertManager for active alerts
curl http://localhost:9093/api/v1/alerts

# Check Prometheus alert rules
curl http://localhost:9090/api/v1/rules
```

### 3. Performance Testing

```bash
# Generate sustained load
for i in {1..10}; do
  curl -X POST http://localhost:8080/generate \
    -H "Content-Type: application/json" \
    -d '{"count": 100, "level": "info"}'
  sleep 5
done

# Monitor resource usage
docker stats --no-stream

# Check Prometheus for performance metrics
curl "http://localhost:9090/api/v1/query?query=rate(logstash_pipeline_events_in_total[5m])"
```

### 4. Security Testing

```bash
# Test network isolation (should fail)
curl http://logstash:9600/_node/stats

# Test reverse proxy access (should work)
curl http://localhost:8080

# Check container resource limits
docker inspect logstash-prod | grep -A 10 "Resources"
```

## 🔍 Troubleshooting

### Common Issues

**Prometheus not collecting metrics**
```bash
# Check Prometheus logs
docker compose logs prometheus

# Verify target status
curl http://localhost:9090/api/v1/targets

# Check logstash-exporter connectivity
docker exec prometheus-prod wget -O- http://logstash-exporter:9198/metrics
```

**Grafana not loading dashboards**
```bash
# Check Grafana logs
docker compose logs grafana

# Verify data source connection
curl -u admin:admin123 http://localhost:3000/api/datasources

# Check Prometheus connectivity from Grafana
docker exec grafana-prod wget -O- http://prometheus:9090/-/healthy
```

**AlertManager not sending alerts**
```bash
# Check AlertManager logs
docker compose logs alertmanager

# Verify alert rules
curl http://localhost:9090/api/v1/rules

# Check AlertManager configuration
docker exec alertmanager-prod cat /etc/alertmanager/alertmanager.yml
```

**High resource usage**
```bash
# Check container resource usage
docker stats --no-stream

# Check Prometheus storage usage
docker exec prometheus-prod du -sh /prometheus

# Check Grafana database size
docker exec grafana-prod du -sh /var/lib/grafana
```

### Debug Commands

```bash
# Check all container statuses
docker compose ps

# View real-time logs
docker compose logs -f --tail=100

# Check network connectivity
docker exec prometheus-prod ping logstash-exporter
docker exec grafana-prod ping prometheus

# Verify volume mounts
docker exec prometheus-prod ls -la /prometheus
docker exec grafana-prod ls -la /var/lib/grafana
```

## 📊 Production Monitoring Best Practices

### Key Metrics to Monitor

| Metric | Description | Alert Threshold |
|--------|-------------|-----------------|
| `logstash_pipeline_events_in_total` | Events received | Monitor for drops |
| `logstash_node_stats_jvm_mem_heap_used_percent` | JVM heap usage | > 80% |
| `logstash_pipeline_queue_events_count` | Queue depth | > 1000 |
| `prometheus_tsdb_head_samples_appended_total` | Prometheus ingestion rate | Monitor trends |
| `grafana_http_request_duration_seconds` | Grafana response time | > 1s |

### Alert Rules

```yaml
groups:
  - name: logstash_alerts
    rules:
      - alert: LogstashHighMemoryUsage
        expr: logstash_node_stats_jvm_mem_heap_used_percent > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Logstash high memory usage detected"
          
      - alert: LogstashQueueBacklog
        expr: logstash_pipeline_queue_events_count > 1000
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "Logstash queue backlog detected"
```

### Dashboard Configuration

- **Logstash Overview**: Key metrics and health status
- **Performance Metrics**: Throughput, latency, and resource usage
- **Error Analysis**: Error rates and patterns
- **Infrastructure**: Container and system metrics

## 📚 Next Steps

After mastering this production setup:

1. **Customize Dashboards**: Create custom Grafana dashboards
2. **Configure Notifications**: Set up email/Slack notifications
3. **Add More Data Sources**: Integrate additional monitoring tools
4. **Implement Auto-scaling**: Dynamic scaling based on metrics

## 🧹 Cleanup

```bash
# Stop all services
docker compose down

# Remove containers and networks
docker compose down --remove-orphans

# Remove volumes (optional - will delete all data)
docker compose down -v

# Clean up images (optional)
docker compose down --rmi all
```

---

**Happy Production Monitoring! 🏭**
