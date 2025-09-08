# 🏭 Step CLI - Production PKI Setup Example

An enterprise-grade PKI setup demonstrating production-ready certificate management with security best practices, high availability, comprehensive monitoring, and compliance features.

## 🎯 What This Example Demonstrates

- **Production CA**: Secure, high-availability Certificate Authority
- **Security Hardening**: Security best practices and compliance
- **High Availability**: Multi-instance CA with load balancing
- **Comprehensive Monitoring**: Prometheus, Grafana, and AlertManager
- **Audit Logging**: Complete audit trails and compliance reporting
- **Backup & Recovery**: Automated backup and disaster recovery
- **Reverse Proxy**: Nginx for security and access control

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Ports 80, 443, 8080, 3000, 9090, 9091, 9093, 8443 available
- 4GB+ RAM recommended for full stack
- Understanding of production PKI concepts

### 1. Start the Production Stack

```bash
# Navigate to the example directory
cd images/step-cli/sample-project/production-pki

# Start all services
docker compose up -d

# Check service status
docker compose ps

# View logs
docker compose logs -f
```

### 2. Initialize the Production CA

```bash
# Initialize the production CA with security hardening
docker exec -it step-cli-production bash -c "
  step ca init \
    --name 'Production CA' \
    --dns 'step-ca-production' \
    --address ':443' \
    --provisioner 'admin@production.com' \
    --password-file /app/scripts/ca-password.txt \
    --with-ca-url https://step-ca:443 \
    --with-fingerprint \$(step certificate fingerprint /app/secrets/certs/root_ca.crt)
"

# Restart CA server
docker compose restart step-ca
```

### 3. Configure Security Policies

```bash
# Set up certificate policies
docker exec -it cert-manager-production python3 /app/setup_policies.py

# Configure audit logging
docker exec -it audit-logger-production python3 /app/setup_audit.py

# Set up backup policies
docker exec -it backup-production /app/scripts/setup_backup.sh
```

### 4. Access the Production Stack

```bash
# Access Nginx reverse proxy
open http://localhost:80

# Access Grafana dashboards (admin/admin123)
open http://localhost:3000

# Access Prometheus metrics
open http://localhost:9091

# Access AlertManager
open http://localhost:9093
```

## 📊 Access Points

| Service | URL | Credentials | Description |
|---------|-----|-------------|-------------|
| **Nginx Proxy** | `http://localhost:80` | None | Secure access to all services |
| **Production CA** | `https://localhost:443` | None | Certificate Authority server |
| **Certificate Manager** | `http://localhost:8080` | None | Certificate management interface |
| **Certificate Monitor** | `http://localhost:9090` | None | Certificate monitoring dashboard |
| **Prometheus** | `http://localhost:9091` | None | Metrics collection and querying |
| **Grafana** | `http://localhost:3000` | admin/admin123 | Dashboards and visualization |
| **AlertManager** | `http://localhost:9093` | None | Alert management and routing |

## 🔍 Production Certificate Operations

### Enterprise Certificate Generation

```bash
# Generate production server certificate
docker exec -it step-cli-production bash -c "
  step certificate create \
    --san production.example.com \
    --san www.production.example.com \
    --san api.production.example.com \
    --profile server \
    --kty RSA \
    --size 4096 \
    'production.example.com' \
    /app/certs/production.crt \
    /app/certs/production.key
"

# Generate client certificate for API access
docker exec -it step-cli-production bash -c "
  step certificate create \
    --profile client \
    --kty EC \
    --curve P-256 \
    'api-client@production.com' \
    /app/certs/api-client.crt \
    /app/certs/api-client.key
"
```

### Certificate Lifecycle Management

```bash
# Set up automated certificate renewal
curl -X POST http://localhost:8080/policies/renewal \
  -H "Content-Type: application/json" \
  -d '{
    "certificate": "production.example.com",
    "renewal_days": 30,
    "auto_renew": true,
    "notification_days": [60, 30, 7, 1]
  }'

# Configure certificate monitoring
curl -X POST http://localhost:8080/policies/monitoring \
  -H "Content-Type: application/json" \
  -d '{
    "certificate": "production.example.com",
    "monitoring_enabled": true,
    "alert_thresholds": {
      "expiry_days": 30,
      "usage_threshold": 80
    }
  }'
```

### Security and Compliance

```bash
# Set up certificate policies
curl -X POST http://localhost:8080/policies/security \
  -H "Content-Type: application/json" \
  -d '{
    "min_key_size": 2048,
    "allowed_algorithms": ["RSA", "ECDSA"],
    "max_validity_days": 365,
    "require_san": true,
    "audit_logging": true
  }'

# Configure compliance reporting
curl -X POST http://localhost:8080/policies/compliance \
  -H "Content-Type: application/json" \
  -d '{
    "compliance_standard": "SOC2",
    "audit_retention_days": 2555,
    "reporting_frequency": "monthly",
    "automated_reports": true
  }'
```

## 📈 Understanding Production PKI

### Security Architecture

```
Internet
    ↓
Nginx Reverse Proxy (SSL Termination)
    ↓
Internal Network (PKI)
    ├── Step CA (Production)
    ├── Certificate Manager
    ├── Monitoring Services
    └── Audit Logger

Monitoring Network
    ├── Prometheus
    ├── Grafana
    └── AlertManager

Security Network
    ├── Backup Service
    └── Audit Storage
```

### Certificate Lifecycle Management

| Phase | Description | Automation | Monitoring |
|-------|-------------|------------|------------|
| **Request** | Certificate request submission | Automated validation | Request tracking |
| **Approval** | Certificate approval workflow | Automated approval rules | Approval metrics |
| **Generation** | Certificate creation and signing | Automated generation | Generation metrics |
| **Distribution** | Certificate deployment | Automated deployment | Distribution status |
| **Monitoring** | Certificate health monitoring | Real-time monitoring | Health metrics |
| **Renewal** | Certificate renewal process | Automated renewal | Renewal tracking |
| **Revocation** | Certificate revocation | Automated revocation | Revocation logs |

### Compliance and Audit

- **SOC2 Compliance**: Comprehensive audit trails
- **GDPR Compliance**: Data protection and privacy
- **ISO 27001**: Information security management
- **PCI DSS**: Payment card industry compliance
- **HIPAA**: Healthcare information compliance

## 🔧 Configuration Details

### Production CA Configuration

```json
{
  "root": "/app/secrets/certs/root_ca.crt",
  "crt": "/app/secrets/certs/intermediate_ca.crt",
  "key": "/app/secrets/certs/intermediate_ca_key",
  "address": ":443",
  "dnsNames": ["step-ca-production"],
  "db": {
    "type": "badger",
    "dataSource": "/app/secrets/db"
  },
  "authority": {
    "provisioners": [
      {
        "name": "admin@production.com",
        "type": "JWK",
        "key": {
          "use": "sig",
          "kty": "EC",
          "crv": "P-256"
        }
      }
    ]
  },
  "tls": {
    "cipherSuites": [
      "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
      "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384"
    ]
  }
}
```

### Nginx Configuration

```nginx
upstream step_ca {
    server step-ca:443;
}

upstream cert_manager {
    server cert-manager:8080;
}

upstream cert_monitor {
    server cert-monitor:9090;
}

server {
    listen 80;
    server_name _;
    
    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    listen 443 ssl http2;
    server_name _;
    
    ssl_certificate /etc/nginx/ssl/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/key.pem;
    
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256;
    ssl_prefer_server_ciphers off;
    
    location /ca/ {
        proxy_pass https://step_ca/;
        proxy_ssl_verify off;
    }
    
    location /manager/ {
        proxy_pass http://cert_manager/;
    }
    
    location /monitor/ {
        proxy_pass http://cert_monitor/;
    }
}
```

### Prometheus Configuration

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - "rules/*.yml"

scrape_configs:
  - job_name: 'step-ca'
    static_configs:
      - targets: ['step-ca:443']
    scheme: https
    tls_config:
      insecure_skip_verify: true

  - job_name: 'cert-manager'
    static_configs:
      - targets: ['cert-manager:8080']

  - job_name: 'cert-monitor'
    static_configs:
      - targets: ['cert-monitor:9090']

alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - alertmanager:9093
```

## 🧪 Testing Scenarios

### 1. Production Certificate Generation Test

```bash
# Generate production certificate
docker exec -it step-cli-production bash -c "
  step certificate create \
    --san production.example.com \
    --profile server \
    --kty RSA \
    --size 4096 \
    'production.example.com' \
    /app/certs/production.crt \
    /app/certs/production.key
"

# Verify certificate
docker exec -it step-cli-production step certificate inspect /app/certs/production.crt

# Check certificate in Grafana
open http://localhost:3000
```

### 2. Security Policy Test

```bash
# Test security policies
curl -X POST http://localhost:8080/policies/validate \
  -H "Content-Type: application/json" \
  -d '{
    "certificate": "production.example.com",
    "key_size": 2048,
    "algorithm": "RSA",
    "validity_days": 365
  }'

# Check policy compliance
curl http://localhost:8080/policies/compliance/status
```

### 3. Monitoring and Alerting Test

```bash
# Check certificate monitoring
curl http://localhost:9090/metrics

# View Prometheus metrics
curl http://localhost:9091/api/v1/query?query=certificate_expiry_days

# Check AlertManager
curl http://localhost:9093/api/v1/alerts
```

### 4. Backup and Recovery Test

```bash
# Trigger manual backup
docker exec -it backup-production /app/scripts/backup.sh

# Check backup status
docker exec -it backup-production ls -la /app/backup/

# Test recovery
docker exec -it backup-production /app/scripts/test_recovery.sh
```

## 🔍 Troubleshooting

### Common Issues

**CA server not starting**
```bash
# Check CA logs
docker compose logs step-ca

# Verify CA configuration
docker exec -it step-cli-production cat /app/secrets/config/ca.json

# Check CA health
docker exec -it step-cli-production step ca health
```

**Security policy violations**
```bash
# Check policy logs
docker compose logs cert-manager

# Verify policy configuration
docker exec -it cert-manager-production python3 /app/check_policies.py

# Check audit logs
docker exec -it audit-logger-production tail -f /app/logs/audit.log
```

**Monitoring issues**
```bash
# Check monitoring logs
docker compose logs cert-monitor

# Verify Prometheus configuration
docker exec -it prometheus-production cat /etc/prometheus/prometheus.yml

# Check Grafana connectivity
curl http://localhost:3000/api/health
```

**Backup failures**
```bash
# Check backup logs
docker compose logs backup

# Verify backup configuration
docker exec -it backup-production cat /app/scripts/backup.sh

# Check backup storage
docker exec -it backup-production ls -la /app/backup/
```

### Debug Commands

```bash
# Check all container statuses
docker compose ps

# View real-time logs
docker compose logs -f --tail=100

# Check resource usage
docker stats --no-stream

# Verify network connectivity
docker exec -it step-cli-production ping step-ca
```

## 📚 Next Steps

After mastering this production setup:

1. **Try Integration Examples**: Connect with various tools and platforms
2. **Customize Security Policies**: Modify policies for your compliance requirements
3. **Add More Monitoring**: Implement additional monitoring and alerting
4. **Scale to Multiple Environments**: Implement multi-environment PKI

## 🧹 Cleanup

```bash
# Stop all services
docker compose down

# Remove containers and networks
docker compose down --remove-orphans

# Remove volumes (optional - will delete all certificates and CA data)
docker compose down -v

# Clean up images (optional)
docker compose down --rmi all
```

---

**Happy Production Certificate Management! 🏭**
