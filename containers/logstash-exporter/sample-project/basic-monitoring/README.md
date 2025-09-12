# 📊 Logstash Exporter - Basic Monitoring Example

A comprehensive example demonstrating how to monitor a single Logstash instance using the logstash-exporter for Prometheus metrics collection.

## 🎯 What This Example Demonstrates

- **Single Logstash Instance**: Basic Logstash setup with sample pipeline
- **logstash-exporter**: Prometheus exporter for Logstash metrics collection
- **Sample Data Generator**: Python web application for generating test log data
- **Test Web App**: Simple nginx application for testing log generation
- **Real-time Monitoring**: Live metrics collection and visualization

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Ports 9198, 9600, 8080, 8081 available
- Basic understanding of Logstash and monitoring concepts

### 1. Start the Services

```bash
# Navigate to the example directory
cd images/logstash-exporter/sample-project/basic-monitoring

# Start all services
docker compose up -d

# Check service status
docker compose ps

# View logs
docker compose logs -f
```

### 2. Verify Services Are Running

```bash
# Check Logstash health
curl http://localhost:9600/_node/stats

# Check logstash-exporter health
curl http://localhost:9198/health

# Check metrics endpoint
curl http://localhost:9198/metrics

# Check log generator health
curl http://localhost:8080/health

# Check test app
curl http://localhost:8081
```

### 3. Generate Sample Logs

```bash
# Generate logs via API
curl -X POST http://localhost:8080/generate \
  -H "Content-Type: application/json" \
  -d '{"count": 100, "level": "info"}'

# Generate logs via web interface
open http://localhost:8080
```

## 📊 Access Points

| Service | URL | Description |
|---------|-----|-------------|
| **Logstash** | `http://localhost:9600` | Logstash API and monitoring |
| **logstash-exporter** | `http://localhost:9198` | Prometheus metrics endpoint |
| **Log Generator** | `http://localhost:8080` | Web interface for generating logs |
| **Test App** | `http://localhost:8081` | Simple web app for testing |

## 🔍 Monitoring and Testing

### Check Logstash Metrics

```bash
# Get all metrics
curl http://localhost:9198/metrics

# Filter specific metrics
curl http://localhost:9198/metrics | grep events_in_total
curl http://localhost:9198/metrics | grep jvm_mem_heap
curl http://localhost:9198/metrics | grep pipeline
```

### Monitor Logstash Performance

```bash
# Check JVM heap usage
curl http://localhost:9198/metrics | grep jvm_mem_heap_used_percent

# Monitor event processing
curl http://localhost:9198/metrics | grep events_in_total
curl http://localhost:9198/metrics | grep events_out_total

# Check queue status
curl http://localhost:9198/metrics | grep queue_events_count
```

### Generate Different Log Patterns

```bash
# Generate info logs
curl -X POST http://localhost:8080/generate \
  -H "Content-Type: application/json" \
  -d '{"count": 50, "level": "info"}'

# Generate error logs
curl -X POST http://localhost:8080/generate \
  -H "Content-Type: application/json" \
  -d '{"count": 20, "level": "error"}'

# Generate warning logs
curl -X POST http://localhost:8080/generate \
  -H "Content-Type: application/json" \
  -d '{"count": 30, "level": "warning"}'
```

## 📈 Understanding the Metrics

### Key Metrics to Monitor

| Metric | Description | What to Look For |
|--------|-------------|------------------|
| `logstash_pipeline_events_in_total` | Total events received | Should increase as you generate logs |
| `logstash_pipeline_events_out_total` | Total events processed | Should match or be close to input |
| `logstash_node_stats_jvm_mem_heap_used_percent` | JVM heap usage | Should stay below 80% |
| `logstash_pipeline_queue_events_count` | Events in queue | Should be low (near 0) |
| `logstash_plugin_events_duration_in_millis` | Processing time | Should be reasonable (< 1000ms) |

### Expected Behavior

1. **Startup**: All services should start within 1-2 minutes
2. **Health Checks**: All services should show healthy status
3. **Log Generation**: Logs should flow through Logstash pipeline
4. **Metrics**: Metrics should update every 15 seconds
5. **Performance**: Logstash should process logs efficiently

## 🔧 Configuration Details

### Logstash Configuration

The Logstash instance is configured with:
- **Input**: TCP (port 5000) and Beats (port 5044)
- **Filter**: Basic parsing and enrichment
- **Output**: Console and file output
- **Monitoring**: X-Pack monitoring enabled

### logstash-exporter Configuration

The exporter is configured with:
- **Target**: `http://logstash:9600`
- **Timeout**: 5 seconds
- **Port**: 9198
- **Health Check**: `/health` endpoint

### Network Configuration

- **Monitoring Network**: For monitoring services
- **Logstash Network**: For log processing services
- **Port Mapping**: Exposed ports for external access

## 🧪 Testing Scenarios

### 1. Basic Functionality Test

```bash
# Test basic log generation
curl -X POST http://localhost:8080/generate \
  -H "Content-Type: application/json" \
  -d '{"count": 10, "level": "info"}'

# Verify logs are processed
docker compose logs logstash | tail -20
```

### 2. Performance Test

```bash
# Generate high volume of logs
curl -X POST http://localhost:8080/generate \
  -H "Content-Type: application/json" \
  -d '{"count": 1000, "level": "info"}'

# Monitor metrics during load
watch -n 1 'curl -s http://localhost:9198/metrics | grep events_in_total'
```

### 3. Error Handling Test

```bash
# Generate error logs
curl -X POST http://localhost:8080/generate \
  -H "Content-Type: application/json" \
  -d '{"count": 50, "level": "error"}'

# Check error handling in Logstash
docker compose logs logstash | grep -i error
```

## 🔍 Troubleshooting

### Common Issues

**Logstash won't start**
```bash
# Check Logstash logs
docker compose logs logstash

# Verify configuration files exist
ls -la logstash/config/
ls -la logstash/pipeline/

# Check port availability
netstat -tulpn | grep :9600
```

**Exporter shows no metrics**
```bash
# Check exporter logs
docker compose logs logstash-exporter

# Verify Logstash connectivity
docker exec logstash-exporter-basic wget -O- http://logstash:9600/_node/stats

# Check environment variables
docker exec logstash-exporter-basic env | grep LOGSTASH
```

**No logs being processed**
```bash
# Check Logstash pipeline status
curl http://localhost:9600/_node/stats/pipeline

# Verify input plugins are working
curl http://localhost:9600/_node/stats/inputs

# Check log generator is working
curl http://localhost:8080/health
```

### Debug Commands

```bash
# Check all container statuses
docker compose ps

# View real-time logs
docker compose logs -f --tail=100

# Check network connectivity
docker exec logstash-exporter-basic ping logstash

# Verify volume mounts
docker exec logstash-basic ls -la /usr/share/logstash/pipeline/
```

## 📚 Next Steps

After mastering this basic example:

1. **Try Multi-Instance Monitoring**: Monitor multiple Logstash instances
2. **Explore Production Setup**: Full monitoring stack with Prometheus and Grafana
3. **Customize Pipelines**: Modify Logstash configuration for your use case
4. **Add Alerting**: Configure alerts based on metrics thresholds

## 🧹 Cleanup

```bash
# Stop all services
docker compose down

# Remove containers and networks
docker compose down --remove-orphans

# Remove volumes (optional)
docker compose down -v

# Clean up images (optional)
docker compose down --rmi all
```

---

**Happy Monitoring! 📊**
