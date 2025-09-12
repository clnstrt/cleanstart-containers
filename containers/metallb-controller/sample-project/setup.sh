#!/bin/bash

# MetalLB Sample Project Setup Script for Linux/macOS
# This script sets up the MetalLB sample project environment

set -e

echo "🚀 Setting up MetalLB Sample Project"
echo "===================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

print_success "Docker is installed"

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

print_success "Docker Compose is installed"

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    print_warning "kubectl is not installed. Some features may not work."
    print_status "To install kubectl, visit: https://kubernetes.io/docs/tasks/tools/"
else
    print_success "kubectl is installed"
fi

# Create necessary directories
print_status "Creating directories..."
mkdir -p config
mkdir -p manifests
mkdir -p monitoring/grafana/dashboards
mkdir -p monitoring/grafana/datasources

print_success "Directories created"

# Create basic configuration files
print_status "Creating configuration files..."

# Create nginx configuration for web service
cat > basic-layer2/nginx.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    upstream backend {
        server nginx-web:80;
    }

    server {
        listen 80;
        server_name _;

        location / {
            proxy_pass http://backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
EOF

# Create nginx configuration for API service
cat > multi-pool/api.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    upstream api_backend {
        server nginx-api:80;
    }

    server {
        listen 80;
        server_name _;

        location /api/ {
            proxy_pass http://api_backend/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        location /health {
            return 200 '{"status":"healthy","service":"api"}';
            add_header Content-Type application/json;
        }
    }
}
EOF

# Create Prometheus configuration
cat > monitoring/prometheus.yml << 'EOF'
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'metallb-controller'
    static_configs:
      - targets: ['metallb-controller:7472']

  - job_name: 'nginx-web'
    static_configs:
      - targets: ['nginx-web:80']

  - job_name: 'nginx-api'
    static_configs:
      - targets: ['nginx-api:80']

  - job_name: 'postgres-db'
    static_configs:
      - targets: ['postgres-db:5432']
EOF

# Create Grafana datasource configuration
cat > monitoring/grafana/datasources/prometheus.yml << 'EOF'
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
EOF

# Create Grafana dashboard configuration
cat > monitoring/grafana/dashboards/dashboard.yml << 'EOF'
apiVersion: 1

providers:
  - name: 'default'
    orgId: 1
    folder: ''
    type: file
    disableDeletion: false
    updateIntervalSeconds: 10
    allowUiUpdates: true
    options:
      path: /etc/grafana/provisioning/dashboards
EOF

print_success "Configuration files created"

# Make scripts executable
print_status "Making scripts executable..."
chmod +x basic-layer2/test-connection.sh
chmod +x bgp-setup/verify-bgp.sh
chmod +x multi-pool/test-pools.sh

print_success "Scripts made executable"

# Pull required images
print_status "Pulling required Docker images..."
docker pull cleanstart/metallb-controller:latest || print_warning "Failed to pull cleanstart/metallb-controller:latest"
docker pull nginx:1.21
docker pull postgres:13
docker pull prom/prometheus:latest
docker pull grafana/grafana:latest

print_success "Docker images pulled"

# Create a simple test script
cat > test-setup.sh << 'EOF'
#!/bin/bash

echo "🧪 Testing MetalLB Sample Project Setup"
echo "======================================="

# Test Docker Compose
echo "Testing Docker Compose..."
if docker-compose ps | grep -q "Up"; then
    echo "✅ Docker Compose services are running"
else
    echo "❌ Docker Compose services are not running"
    echo "Run: docker-compose up -d"
fi

# Test web service
echo "Testing web service..."
if curl -s http://localhost:8080 | grep -q "Welcome to nginx"; then
    echo "✅ Web service is accessible"
else
    echo "❌ Web service is not accessible"
fi

# Test API service
echo "Testing API service..."
if curl -s http://localhost:8081/health | grep -q "healthy"; then
    echo "✅ API service is accessible"
else
    echo "❌ API service is not accessible"
fi

# Test Prometheus
echo "Testing Prometheus..."
if curl -s http://localhost:9090/api/v1/status/config | grep -q "prometheus"; then
    echo "✅ Prometheus is accessible"
else
    echo "❌ Prometheus is not accessible"
fi

# Test Grafana
echo "Testing Grafana..."
if curl -s http://localhost:3000/api/health | grep -q "ok"; then
    echo "✅ Grafana is accessible"
else
    echo "❌ Grafana is not accessible"
fi

echo ""
echo "🎯 Access URLs:"
echo "  Web Service: http://localhost:8080"
echo "  API Service: http://localhost:8081"
echo "  Prometheus: http://localhost:9090"
echo "  Grafana: http://localhost:3000 (admin/admin)"
echo "  Database: localhost:5432 (testuser/testpass)"
EOF

chmod +x test-setup.sh

print_success "Test script created"

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "📋 Next Steps:"
echo "1. Start the services: docker-compose up -d"
echo "2. Test the setup: ./test-setup.sh"
echo "3. Explore the sample projects in the subdirectories"
echo ""
echo "🔗 Access URLs (after starting services):"
echo "  Web Service: http://localhost:8080"
echo "  API Service: http://localhost:8081"
echo "  Prometheus: http://localhost:9090"
echo "  Grafana: http://localhost:3000 (admin/admin)"
echo "  Database: localhost:5432 (testuser/testpass)"
echo ""
echo "📚 Sample Projects:"
echo "  Basic Layer 2: ./basic-layer2/"
echo "  BGP Setup: ./bgp-setup/"
echo "  Multi-Pool: ./multi-pool/"
echo ""
print_success "Happy Load Balancing! ⚖️"
