# Prometheus Docker Image

An open-source systems monitoring and alerting toolkit for collecting and querying metrics.

## Pull Image
```bash
docker pull cleanstart/prometheus:latest
```

## Run Container
```bash
# Basic run with default configuration
docker run -d --name prometheus-container -p 9090:9090 cleanstart/prometheus:latest

# Run with custom configuration
docker run -d --name prometheus-container -p 9090:9090 -v $(pwd)/prometheus.yml:/etc/prometheus/prometheus.yml cleanstart/prometheus:latest

# Run with volume mount for data persistence
docker run -d --name prometheus-container -p 9090:9090 -v prometheus_data:/prometheus cleanstart/prometheus:latest
```

## Check Version
```bash
docker run --rm cleanstart/prometheus:latest prometheus --version
```

## Check Image Size
```bash
docker images cleanstart/prometheus:latest
```

## Test Container
```bash
# Test Prometheus installation
docker run --rm cleanstart/prometheus:latest prometheus --version

# Check health endpoint
curl http://localhost:9090/-/healthy

# Access Prometheus UI
open http://localhost:9090
```

## Sample Projects
For detailed usage examples and demonstrations, see the `sample-project/` directory.
