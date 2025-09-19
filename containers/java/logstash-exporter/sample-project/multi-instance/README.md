# 🔄 Logstash Exporter - Multi-Instance Monitoring Example

An advanced example demonstrating how to monitor multiple Logstash instances with load balancing, high availability, and shared queue management using the logstash-exporter.

## 🎯 What This Example Demonstrates

- **Multiple Logstash Instances**: Two Logstash instances for high availability
- **Load Balancing**: HAProxy for distributing traffic across instances
- **Shared Queue**: Redis for shared log processing queue
- **logstash-exporter**: Monitoring multiple Logstash targets simultaneously
- **Failover Support**: Automatic failover when one instance fails
- **Cluster Health Monitoring**: Comprehensive cluster monitoring

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Ports 9198, 9600, 9601, 6379, 8080, 8081, 8082 available
- Understanding of load balancing and clustering concepts

### 1. Start the Services

```bash
# Navigate to the example directory
cd images/logstash-exporter/sample-project/multi-instance

# Start all services
docker compose up -d

# Check service status
docker compose ps

# View logs
docker compose logs -f
```

### 2. Verify Services Are Running

```bash
# Check both Logstash instances
curl http://localhost:9600/_node/stats
curl http://localhost:9601/_node/stats

# Check logstash-exporter health
curl http://localhost:9198/health

# Check HAProxy stats
curl http://localhost:8081

# Check Redis connectivity
docker exec redis-multi redis-cli ping

# Check log generator
curl http://localhost:8082/health
```

### 3. Generate Test Logs

```bash
# Generate logs via API (will be load balanced)
curl -X POST http://localhost:8082/generate \
  -H "Content-Type: application/json" \
  -d '{"count": 100, "level": "info"}'

# Generate logs via web interface
open http://localhost:8082
```

## 📊 Access Points

| Service | URL | Description |
|---------|-----|-------------|
| **Logstash Instance 1** | `http://localhost:9600` | First Logstash API and monitoring |
| **Logstash Instance 2** | `http://localhost:9601` | Second Logstash API and monitoring |
| **logstash-exporter** | `http://localhost:9198` | Prometheus metrics endpoint |
| **HAProxy Load Balancer** | `http://localhost:8080` | Load balancer web interface |
| **HAProxy Stats** | `http://localhost:8081` | HAProxy statistics and monitoring |
| **Log Generator** | `http://localhost:8082` | Web interface for generating logs |
| **Redis** | `localhost:6379` | Shared queue for log processing |

## 🔍 Monitoring and Testing

### Check Multi-Instance Metrics

```bash
# Get all metrics from both instances
curl http://localhost:9198/metrics

# Filter metrics by instance
curl http://localhost:9198/metrics | grep "instance.*logstash-1"
curl http://localhost:9198/metrics | grep "instance.*logstash-2"

# Check load distribution
curl http://localhost:9198/metrics | grep events_in_total
```

### Monitor Cluster Health

```bash
# Check individual instance health
curl http://localhost:9600/_node/stats | jq '.jvm.mem.heap_used_percent'
curl http://localhost:9601/_node/stats | jq '.jvm.mem.heap_used_percent'

# Check HAProxy backend status
curl http://localhost:8081 | grep -A 10 "logstash"

# Check Redis queue status
docker exec redis-multi redis-cli info memory
```

### Test Load Balancing

```bash
# Generate logs and monitor distribution
for i in {1..10}; do
  curl -X POST http://localhost:8082/generate \
    -H "Content-Type: application/json" \
    -d "{\"count\": 10, \"level\": \"info\"}"
  sleep 2
done

# Check which instance processed more logs
curl http://localhost:9198/metrics | grep events_in_total
```

## 📈 Understanding the Architecture

### Load Balancing Strategy

- **HAProxy**: Round-robin load balancing between Logstash instances
- **Health Checks**: Automatic failover when instances become unhealthy
- **Session Persistence**: Optional sticky sessions for consistent processing

### Shared Queue Management

- **Redis**: Centralized queue for log events
- **Queue Monitoring**: Track queue depth and processing rates
- **Backpressure Handling**: Automatic scaling based on queue depth

### Monitoring Strategy

- **Multi-Target Exporter**: Single exporter monitoring multiple Logstash instances
- **Instance Labeling**: Metrics labeled by instance for individual monitoring
- **Cluster Aggregation**: Combined metrics for cluster-wide monitoring

## 🔧 Configuration Details

### Logstash Configuration

Each Logstash instance is configured with:
- **Input**: TCP (ports 5000, 5001) and Beats (port 5044)
- **Filter**: Instance-specific parsing and enrichment
- **Output**: Console, file, and Redis queue output
- **Monitoring**: X-Pack monitoring enabled with unique node names

### HAProxy Configuration

The load balancer is configured with:
- **Backend Servers**: Two Logstash instances
- **Health Checks**: HTTP health checks every 2 seconds
- **Load Balancing**: Round-robin algorithm
- **Failover**: Automatic failover on health check failure

### logstash-exporter Configuration

The exporter is configured with:
- **Multiple Targets**: `http://logstash-1:9600,http://logstash-2:9600`
- **Timeout**: 5 seconds per target
- **Port**: 9198
- **Health Check**: `/health` endpoint

## 🧪 Testing Scenarios

### 1. Basic Load Balancing Test

```bash
# Generate logs and verify distribution
curl -X POST http://localhost:8082/generate \
  -H "Content-Type: application/json" \
  -d '{"count": 50, "level": "info"}'

# Check metrics from both instances
curl http://localhost:9198/metrics | grep events_in_total
```

### 2. Failover Test

```bash
# Stop one Logstash instance
docker stop logstash-multi-1

# Generate logs (should still work)
curl -X POST http://localhost:8082/generate \
  -H "Content-Type: application/json" \
  -d '{"count": 20, "level": "info"}'

# Check HAProxy stats (should show one backend down)
curl http://localhost:8081

# Restart the instance
docker start logstash-multi-1
```

### 3. High Load Test

```bash
# Generate high volume of logs
curl -X POST http://localhost:8082/generate \
  -H "Content-Type: application/json" \
  -d '{"count": 1000, "level": "info"}'

# Monitor both instances during load
watch -n 2 'curl -s http://localhost:9198/metrics | grep events_in_total'
```

### 4. Redis Queue Test

```bash
# Check Redis queue status
docker exec redis-multi redis-cli info keyspace

# Monitor queue depth
docker exec redis-multi redis-cli llen logstash_queue

# Check Redis memory usage
docker exec redis-multi redis-cli info memory | grep used_memory_human
```

## 🔍 Troubleshooting

### Common Issues

**One Logstash instance not responding**
```bash
# Check instance logs
docker compose logs logstash-1
docker compose logs logstash-2

# Check HAProxy backend status
curl http://localhost:8081 | grep -A 5 "logstash"

# Check network connectivity
docker exec logstash-multi-1 ping logstash-2
```

**Load balancing not working**
```bash
# Check HAProxy configuration
docker exec haproxy-multi cat /usr/local/etc/haproxy/haproxy.cfg

# Check HAProxy logs
docker compose logs haproxy

# Verify backend health
curl http://localhost:8081 | grep -A 10 "Backend"
```

**Redis connection issues**
```bash
# Check Redis logs
docker compose logs redis

# Test Redis connectivity
docker exec redis-multi redis-cli ping

# Check Redis memory
docker exec redis-multi redis-cli info memory
```

**Exporter showing partial metrics**
```bash
# Check exporter logs
docker compose logs logstash-exporter

# Verify connectivity to both instances
docker exec logstash-exporter-multi wget -O- http://logstash-1:9600/_node/stats
docker exec logstash-exporter-multi wget -O- http://logstash-2:9600/_node/stats

# Check environment variables
docker exec logstash-exporter-multi env | grep LOGSTASH
```

### Debug Commands

```bash
# Check all container statuses
docker compose ps

# View real-time logs
docker compose logs -f --tail=100

# Check network connectivity between instances
docker exec logstash-multi-1 ping logstash-2
docker exec logstash-multi-1 ping redis

# Verify HAProxy backend configuration
docker exec haproxy-multi cat /usr/local/etc/haproxy/haproxy.cfg

# Check Redis queue status
docker exec redis-multi redis-cli info keyspace
```

## 📊 Performance Monitoring

### Key Metrics to Monitor

| Metric | Description | Alert Threshold |
|--------|-------------|-----------------|
| `logstash_pipeline_events_in_total` | Events received per instance | Monitor for imbalance |
| `logstash_node_stats_jvm_mem_heap_used_percent` | JVM heap usage per instance | > 80% |
| `logstash_pipeline_queue_events_count` | Queue depth per instance | > 1000 |
| HAProxy backend status | Backend health status | Any backend down |
| Redis memory usage | Redis memory consumption | > 80% of available |

### Cluster Health Indicators

1. **Load Distribution**: Events should be distributed evenly between instances
2. **Instance Health**: All instances should show healthy status
3. **Queue Depth**: Redis queue should remain low
4. **Response Times**: API response times should be consistent
5. **Memory Usage**: JVM heap usage should be balanced across instances

## 📚 Next Steps

After mastering this multi-instance example:

1. **Try Production Setup**: Full monitoring stack with Prometheus and Grafana
2. **Scale to More Instances**: Add additional Logstash instances
3. **Implement Auto-scaling**: Dynamic scaling based on load
4. **Add Geographic Distribution**: Multi-region deployment

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

**Happy Clustering! 🔄**
