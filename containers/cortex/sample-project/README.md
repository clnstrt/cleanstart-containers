# 🚀 Cortex Sample Projects

This directory contains sample projects demonstrating Cortex metrics storage and querying capabilities for Prometheus-compatible monitoring systems.

## 📁 Sample Projects

### 1. Basic Setup (`basic-setup/`)
- **Single Binary Mode**: Simple Cortex deployment
- **Configuration Examples**: Basic Cortex configuration
- **Storage Backends**: Filesystem and S3 storage examples

### 2. Microservices Mode (`microservices-mode/`)
- **Distributed Deployment**: Cortex microservices architecture
- **Service Configuration**: Individual service configurations
- **Load Balancing**: Load balancer configurations

### 3. Storage Backends (`storage-backends/`)
- **Filesystem Storage**: Local filesystem storage
- **S3 Storage**: Amazon S3 storage configuration
- **GCS Storage**: Google Cloud Storage configuration
- **Azure Storage**: Azure Blob Storage configuration

### 4. Monitoring Setup (`monitoring-setup/`)
- **Self-Monitoring**: Cortex self-monitoring configuration
- **Grafana Integration**: Grafana dashboard setup
- **Alerting**: Alert manager integration

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose
- Kubernetes cluster (for K8s examples)
- Storage backend (S3, GCS, Azure, or local filesystem)

### Running Cortex Locally

1. **Clone and Navigate**:
```bash
cd containers/cortex/sample-project
```

2. **Start Basic Setup**:
```bash
docker-compose -f basic-setup/docker-compose.yml up -d
```

3. **Verify Cortex is Running**:
```bash
curl http://localhost:9009/ready
curl http://localhost:9009/metrics
```

4. **Access Cortex UI**:
```bash
open http://localhost:9009
```

### Running Cortex in Kubernetes

1. **Apply Cortex Configuration**:
```bash
kubectl apply -f microservices-mode/
```

2. **Check Pod Status**:
```bash
kubectl get pods -n cortex
```

3. **Access Cortex Service**:
```bash
kubectl port-forward svc/cortex 9009:9009 -n cortex
```

## 📚 Configuration Examples

### Basic Cortex Configuration
```yaml
# cortex.yml
target: all

server:
  http_listen_port: 9009
  grpc_listen_port: 9095

distributor:
  ring:
    kvstore:
      store: memberlist

ingester:
  lifecycler:
    ring:
      kvstore:
        store: memberlist
    join_after: 0s
    num_tokens: 512
    heartbeat_period: 1s
    observe_period: 0s
    min_ready_duration: 0s
    finalize_ready_duration: 0s

schema:
  configs:
    - from: 2020-05-15
      store: boltdb
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 168h

storage:
  boltdb:
    directory: /var/lib/cortex/boltdb
  filesystem:
    directory: /var/lib/cortex/chunks

limits:
  enforce_metric_name: false
  reject_old_samples: true
  reject_old_samples_max_age: 168h
```

### S3 Storage Configuration
```yaml
storage:
  aws:
    s3:
      bucket_name: cortex-metrics
      region: us-west-2
      access_key_id: ${AWS_ACCESS_KEY_ID}
      secret_access_key: ${AWS_SECRET_ACCESS_KEY}
      s3forcepathstyle: true
```

### Microservices Configuration
```yaml
# distributor.yml
target: distributor

server:
  http_listen_port: 9009
  grpc_listen_port: 9095

distributor:
  ring:
    kvstore:
      store: consul
      consul:
        host: consul:8500
```

## 🧪 Testing Cortex

### Send Test Metrics
```bash
# Send sample metrics to Cortex
curl -X POST http://localhost:9009/api/v1/push \
  -H "Content-Type: application/json" \
  -d '{
    "streams": [
      {
        "stream": {
          "job": "test",
          "instance": "localhost"
        },
        "values": [
          ["'$(date +%s%N)'", "test metric value"]
        ]
      }
    ]
  }'
```

### Query Metrics
```bash
# Query metrics from Cortex
curl "http://localhost:9009/api/v1/query?query=up"
```

### Check Storage
```bash
# Check stored chunks
ls -la /var/lib/cortex/chunks/
```

## 🔧 Advanced Configuration

### Multi-Tenant Setup
```yaml
auth_enabled: true
server:
  http_listen_port: 9009
  grpc_listen_port: 9095

distributor:
  ring:
    kvstore:
      store: consul
      consul:
        host: consul:8500
```

### High Availability Setup
```yaml
ingester:
  lifecycler:
    ring:
      kvstore:
        store: consul
        consul:
          host: consul:8500
    join_after: 30s
    num_tokens: 512
    heartbeat_period: 5s
    observe_period: 10s
```

### Performance Tuning
```yaml
limits:
  max_series_per_user: 1000000
  max_series_per_metric: 100000
  max_global_series_per_user: 1000000
  max_global_series_per_metric: 100000
  ingestion_rate: 10000
  ingestion_burst_size: 20000
```

## 📊 Monitoring

### Cortex Metrics
- Request rate and latency
- Storage usage and performance
- Ingestion rate and errors
- Query performance metrics

### Health Checks
- Cortex readiness endpoint
- Storage backend connectivity
- Service discovery health

### Grafana Dashboards
- Cortex operational dashboard
- Storage performance dashboard
- Query performance dashboard

## 🛠️ Troubleshooting

### Common Issues
1. **Storage Backend Errors**: Check credentials and connectivity
2. **High Memory Usage**: Adjust limits and chunk size
3. **Slow Queries**: Optimize storage and indexing

### Debug Commands
```bash
# Check Cortex logs
docker logs cortex

# Verify storage connectivity
curl http://localhost:9009/ready

# Check metrics
curl http://localhost:9009/metrics
```

## 📚 Resources

- [Cortex Documentation](https://cortexmetrics.io/docs/)
- [Prometheus Remote Write](https://prometheus.io/docs/prometheus/latest/storage/#remote-storage-integrations)
- [CleanStart Website](https://www.cleanstart.com/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Adding new configuration examples
- Improving documentation
- Reporting issues
- Suggesting new features

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
