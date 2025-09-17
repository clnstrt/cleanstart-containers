# 🚀 Cortex Hello World

Welcome to the Cortex Hello World example! This simple example demonstrates how to get started with Cortex for Prometheus-compatible metrics storage.

## 📋 What is Cortex?

Cortex is a horizontally scalable, highly available, multi-tenant Prometheus-compatible metrics storage system. It provides:

- **Prometheus-compatible API**: Drop-in replacement for Prometheus
- **Horizontal scaling**: Scale to handle millions of metrics
- **Multi-tenancy**: Isolate metrics by tenant
- **Long-term storage**: Store metrics in object storage (S3, GCS, etc.)

## 🚀 Quick Start

### Prerequisites

- Python 3.6+
- Docker and Docker Compose (optional)

### Running the Hello World

1. **Run the Python script directly:**
   ```bash
   python hello_world.py
   ```

2. **Or start Cortex with Docker Compose:**
   ```bash
   cd basic-setup
   docker-compose up -d
   python ../hello_world.py
   ```

## 📊 What the Hello World Does

The `hello_world.py` script demonstrates:

1. **Configuration Testing**: Validates Cortex configuration structure
2. **Metrics Simulation**: Creates sample metrics data
3. **Query Testing**: Simulates PromQL queries
4. **Connection Testing**: Tests Cortex API connectivity

## 🔧 Configuration

The hello world uses a basic Cortex configuration:

```yaml
server:
  http_listen_port: 9009
  grpc_listen_port: 9095

storage:
  engine: filesystem
  filesystem:
    dir: /tmp/cortex
```

## 📈 Sample Metrics

The script creates sample metrics:

```json
{
  "metric_name": "hello_world_counter",
  "value": 1,
  "labels": {
    "job": "hello_world",
    "instance": "localhost:9009"
  }
}
```

## 🔍 Sample Queries

Try these PromQL queries:

```promql
# Get all hello_world metrics
hello_world_counter

# Filter by job
hello_world_counter{job="hello_world"}

# Rate of change
rate(hello_world_counter[5m])
```

## 🌐 API Endpoints

When Cortex is running, you can access:

- **Health Check**: `http://localhost:9009/ready`
- **Metrics Push**: `http://localhost:9009/api/v1/push`
- **Query**: `http://localhost:9009/api/v1/query`
- **Query Range**: `http://localhost:9009/api/v1/query_range`

## 📚 Next Steps

1. **Explore Basic Setup**: Check out `basic-setup/` for complete installation
2. **Advanced Configuration**: See `advanced-networking/` for BGP setup
3. **Security Policies**: Review `security-policies/` for network security
4. **Monitoring**: Use `monitoring/` for observability setup

## 🆘 Troubleshooting

### Common Issues

1. **Connection Refused**: Make sure Cortex is running on port 9009
2. **Configuration Error**: Check YAML syntax in config files
3. **Storage Issues**: Ensure `/tmp/cortex` directory is writable

### Debug Commands

```bash
# Check Cortex status
curl http://localhost:9009/ready

# View Cortex logs
docker logs cortex-basic

# Test metrics push
curl -X POST http://localhost:9009/api/v1/push \
  -H "Content-Type: application/json" \
  -d '{"streams":[{"stream":{"job":"test"},"values":[["'$(date +%s)'000000000","1"]]}]}'
```

## 📖 Learn More

- [Cortex Documentation](https://cortexmetrics.io/docs/)
- [Prometheus Querying](https://prometheus.io/docs/prometheus/latest/querying/basics/)
- [PromQL Tutorial](https://prometheus.io/docs/prometheus/latest/querying/examples/)

---

**Happy Monitoring with Cortex!** 📊
