# 🔗 Logstash Exporter - Integration Examples

Advanced integration examples demonstrating how to connect logstash-exporter with various tools and platforms including ELK Stack, Kubernetes, custom dashboards, and alerting systems.

## 🎯 What This Example Demonstrates

- **ELK Stack Integration**: Complete Elasticsearch, Logstash, Kibana setup
- **Kubernetes Deployment**: K8s manifests and configurations
- **Custom Dashboards**: Grafana dashboard templates and configurations
- **Alert Rules**: Prometheus alerting rules and configurations
- **CI/CD Integration**: Automated deployment and monitoring
- **Custom Metrics**: Extended monitoring and custom metric collection

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Kubernetes cluster (for K8s examples)
- Basic understanding of ELK Stack and Kubernetes
- Ports 9200, 5601, 9600, 9198, 9090, 3000 available

### 1. Choose Your Integration

```bash
# Navigate to the integration examples directory
cd images/logstash-exporter/sample-project/integration-examples

# List available integrations
ls -la

# Choose an integration to explore
cd elk-stack-integration  # or kubernetes-deployment, custom-dashboards, etc.
```

## 📊 Available Integrations

### 1. ELK Stack Integration (`elk-stack-integration/`)

Complete Elasticsearch, Logstash, Kibana setup with logstash-exporter monitoring.

**Components:**
- **Elasticsearch**: Log storage and search
- **Logstash**: Log processing and transformation
- **Kibana**: Log visualization and analysis
- **logstash-exporter**: Prometheus metrics collection
- **Prometheus**: Metrics storage and querying
- **Grafana**: Metrics visualization

**Access Points:**
- Elasticsearch: `http://localhost:9200`
- Kibana: `http://localhost:5601`
- Logstash: `http://localhost:9600`
- logstash-exporter: `http://localhost:9198`
- Prometheus: `http://localhost:9090`
- Grafana: `http://localhost:3000`

### 2. Kubernetes Deployment (`kubernetes-deployment/`)

Production-ready Kubernetes manifests for deploying logstash-exporter in K8s.

**Components:**
- **Deployment**: logstash-exporter deployment
- **Service**: Service for metrics exposure
- **ConfigMap**: Configuration management
- **ServiceMonitor**: Prometheus operator integration
- **Ingress**: External access configuration

**Features:**
- Horizontal Pod Autoscaling (HPA)
- Resource limits and requests
- Health checks and probes
- Service discovery
- ConfigMap-based configuration

### 3. Custom Dashboards (`custom-dashboards/`)

Pre-built Grafana dashboards for comprehensive Logstash monitoring.

**Dashboard Types:**
- **Logstash Overview**: High-level metrics and health
- **Performance Metrics**: Throughput, latency, and resource usage
- **Error Analysis**: Error rates and patterns
- **Infrastructure**: Container and system metrics
- **Custom Metrics**: Application-specific monitoring

### 4. Alert Rules (`alert-rules/`)

Comprehensive Prometheus alerting rules for Logstash monitoring.

**Alert Categories:**
- **Performance Alerts**: High CPU, memory, and queue usage
- **Error Alerts**: High error rates and failed events
- **Availability Alerts**: Service down and health check failures
- **Capacity Alerts**: Disk space and resource exhaustion

## 🔍 Integration Examples

### ELK Stack Integration

```bash
# Start ELK Stack with monitoring
cd elk-stack-integration
docker compose up -d

# Wait for services to start
sleep 60

# Verify Elasticsearch
curl http://localhost:9200/_cluster/health

# Verify Kibana
curl http://localhost:5601/api/status

# Verify Logstash
curl http://localhost:9600/_node/stats

# Verify logstash-exporter
curl http://localhost:9198/health
```

### Kubernetes Deployment

```bash
# Deploy to Kubernetes
cd kubernetes-deployment

# Apply manifests
kubectl apply -f namespace.yaml
kubectl apply -f configmap.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f servicemonitor.yaml

# Check deployment status
kubectl get pods -n logstash-monitoring
kubectl get services -n logstash-monitoring

# Check logs
kubectl logs -n logstash-monitoring -l app=logstash-exporter
```

### Custom Dashboards

```bash
# Import Grafana dashboards
cd custom-dashboards

# Start Grafana with pre-configured dashboards
docker compose up -d

# Access Grafana
open http://localhost:3000

# Import dashboard JSON files
# 1. Go to Grafana → Import
# 2. Upload dashboard JSON files
# 3. Configure data source (Prometheus)
```

### Alert Rules

```bash
# Configure Prometheus with alert rules
cd alert-rules

# Copy alert rules to Prometheus
cp *.yml /path/to/prometheus/rules/

# Reload Prometheus configuration
curl -X POST http://localhost:9090/-/reload

# Check alert rules
curl http://localhost:9090/api/v1/rules
```

## 📈 Understanding the Integrations

### ELK Stack Architecture

```
Logs → Logstash → Elasticsearch → Kibana
  ↓
logstash-exporter → Prometheus → Grafana
```

**Data Flow:**
1. **Logs** are ingested by Logstash
2. **Logstash** processes and sends to Elasticsearch
3. **Kibana** visualizes logs from Elasticsearch
4. **logstash-exporter** collects metrics from Logstash
5. **Prometheus** stores metrics from the exporter
6. **Grafana** visualizes metrics from Prometheus

### Kubernetes Architecture

```
Kubernetes Cluster
├── Namespace: logstash-monitoring
├── Deployment: logstash-exporter
├── Service: logstash-exporter-service
├── ConfigMap: logstash-exporter-config
└── ServiceMonitor: prometheus-operator integration
```

**Features:**
- **Auto-scaling**: HPA based on CPU/memory usage
- **Service Discovery**: Automatic target discovery
- **Configuration Management**: ConfigMap-based config
- **Health Monitoring**: Liveness and readiness probes

### Dashboard Architecture

```
Prometheus Metrics → Grafana Dashboards
├── Overview Dashboard
├── Performance Dashboard
├── Error Analysis Dashboard
├── Infrastructure Dashboard
└── Custom Application Dashboard
```

## 🧪 Testing Scenarios

### 1. ELK Stack Integration Test

```bash
# Generate logs and verify end-to-end flow
curl -X POST http://localhost:8080/generate \
  -H "Content-Type: application/json" \
  -d '{"count": 100, "level": "info"}'

# Check Elasticsearch for indexed logs
curl http://localhost:9200/logstash-*/_search?size=10

# Check Kibana for log visualization
open http://localhost:5601

# Check Prometheus for metrics
curl http://localhost:9090/api/v1/query?query=logstash_pipeline_events_in_total
```

### 2. Kubernetes Deployment Test

```bash
# Scale the deployment
kubectl scale deployment logstash-exporter --replicas=3 -n logstash-monitoring

# Check pod distribution
kubectl get pods -n logstash-monitoring -o wide

# Test service discovery
kubectl get endpoints -n logstash-monitoring

# Check Prometheus targets
curl http://localhost:9090/api/v1/targets
```

### 3. Dashboard Testing

```bash
# Generate different log patterns
curl -X POST http://localhost:8080/generate \
  -H "Content-Type: application/json" \
  -d '{"count": 50, "level": "error"}'

# Check dashboard updates
open http://localhost:3000

# Verify alert triggers
curl http://localhost:9093/api/v1/alerts
```

### 4. Alert Testing

```bash
# Generate high volume to trigger alerts
curl -X POST http://localhost:8080/generate \
  -H "Content-Type: application/json" \
  -d '{"count": 1000, "level": "info"}'

# Check alert status
curl http://localhost:9090/api/v1/alerts

# Check AlertManager
curl http://localhost:9093/api/v1/alerts
```

## 🔧 Configuration Details

### ELK Stack Configuration

**Elasticsearch:**
```yaml
# elasticsearch.yml
cluster.name: "logstash-cluster"
node.name: "elasticsearch-node"
network.host: 0.0.0.0
discovery.type: single-node
```

**Logstash:**
```ruby
# logstash.conf
input {
  tcp {
    port => 5000
    codec => json
  }
}

output {
  elasticsearch {
    hosts => ["elasticsearch:9200"]
    index => "logstash-%{+YYYY.MM.dd}"
  }
}
```

### Kubernetes Configuration

**Deployment:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: logstash-exporter
  namespace: logstash-monitoring
spec:
  replicas: 2
  selector:
    matchLabels:
      app: logstash-exporter
  template:
    metadata:
      labels:
        app: logstash-exporter
    spec:
      containers:
      - name: logstash-exporter
        image: prom/logstash-exporter:latest
        ports:
        - containerPort: 9198
        env:
        - name: LOGSTASH_SERVER
          value: "http://logstash:9600"
```

### Grafana Dashboard Configuration

**Dashboard JSON:**
```json
{
  "dashboard": {
    "title": "Logstash Monitoring",
    "panels": [
      {
        "title": "Events Processing Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(logstash_pipeline_events_in_total[5m])"
          }
        ]
      }
    ]
  }
}
```

## 🔍 Troubleshooting

### Common Issues

**ELK Stack not working**
```bash
# Check Elasticsearch health
curl http://localhost:9200/_cluster/health

# Check Logstash logs
docker compose logs logstash

# Check Kibana status
curl http://localhost:5601/api/status
```

**Kubernetes deployment issues**
```bash
# Check pod status
kubectl get pods -n logstash-monitoring

# Check pod logs
kubectl logs -n logstash-monitoring -l app=logstash-exporter

# Check service endpoints
kubectl get endpoints -n logstash-monitoring
```

**Dashboard not loading**
```bash
# Check Grafana data source
curl -u admin:admin http://localhost:3000/api/datasources

# Check Prometheus connectivity
curl http://localhost:9090/-/healthy

# Check dashboard configuration
curl -u admin:admin http://localhost:3000/api/dashboards
```

**Alerts not firing**
```bash
# Check alert rules
curl http://localhost:9090/api/v1/rules

# Check AlertManager configuration
curl http://localhost:9093/api/v1/status

# Check alert evaluation
curl http://localhost:9090/api/v1/query?query=ALERTS
```

## 📚 Next Steps

After mastering these integrations:

1. **Customize Dashboards**: Create application-specific dashboards
2. **Implement CI/CD**: Automated deployment and monitoring
3. **Add More Integrations**: Connect with additional tools
4. **Scale to Production**: Implement in production environments

## 🧹 Cleanup

```bash
# Stop ELK Stack
cd elk-stack-integration
docker compose down -v

# Remove Kubernetes resources
cd kubernetes-deployment
kubectl delete -f .

# Stop custom dashboards
cd custom-dashboards
docker compose down

# Clean up all integration examples
cd ..
docker compose down -v --remove-orphans
```

---

**Happy Integrating! 🔗**
