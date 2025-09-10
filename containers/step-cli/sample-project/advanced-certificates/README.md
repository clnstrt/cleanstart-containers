# 🚀 Step CLI - Advanced Certificates Example

An advanced example demonstrating complex certificate scenarios, multi-CA environments, automation, and comprehensive certificate lifecycle management using Step CLI.

## 🎯 What This Example Demonstrates

- **Multi-CA Setup**: Primary and secondary Certificate Authorities
- **Certificate Automation**: Automated certificate lifecycle management
- **Advanced Signing**: Complex certificate signing scenarios
- **Certificate Monitoring**: Real-time monitoring and alerting
- **Load Balancing**: High availability CA setup
- **Metrics Collection**: Prometheus integration for certificate metrics

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Ports 443, 8443, 8080, 9090, 9091, 8444, 8445 available
- Understanding of advanced PKI concepts
- 2GB+ RAM recommended

### 1. Start the Services

```bash
# Navigate to the example directory
cd images/step-cli/sample-project/advanced-certificates

# Start all services
docker compose up -d

# Check service status
docker compose ps

# View logs
docker compose logs -f
```

### 2. Initialize the CAs

```bash
# Initialize primary CA
docker exec -it step-cli-advanced bash -c "
  export STEPPATH=/app/secrets/primary
  step ca init \
    --name 'Primary CA' \
    --dns 'step-ca-primary' \
    --address ':443' \
    --provisioner 'admin@primary.com' \
    --password-file /app/scripts/ca-password.txt
"

# Initialize secondary CA
docker exec -it step-cli-advanced bash -c "
  export STEPPATH=/app/secrets/secondary
  step ca init \
    --name 'Secondary CA' \
    --dns 'step-ca-secondary' \
    --address ':443' \
    --provisioner 'admin@secondary.com' \
    --password-file /app/scripts/ca-password.txt
"

# Restart CA servers
docker compose restart step-ca-primary step-ca-secondary
```

### 3. Set Up Certificate Automation

```bash
# Configure certificate automation
docker exec -it cert-automation python3 /app/setup_automation.py

# Start certificate monitoring
docker exec -it cert-monitor python3 /app/setup_monitoring.py
```

### 4. Access the Services

```bash
# Access certificate automation interface
open http://localhost:8080

# Access certificate monitoring
open http://localhost:9090

# Access Prometheus metrics
open http://localhost:9091

# Access HAProxy stats
open http://localhost:8445
```

## 📊 Access Points

| Service | URL | Description |
|---------|-----|-------------|
| **Primary CA** | `https://localhost:443` | Primary Certificate Authority |
| **Secondary CA** | `https://localhost:8443` | Secondary Certificate Authority |
| **HAProxy Load Balancer** | `https://localhost:8444` | Load balanced CA access |
| **HAProxy Stats** | `http://localhost:8445` | Load balancer statistics |
| **Certificate Automation** | `http://localhost:8080` | Automated certificate management |
| **Certificate Monitor** | `http://localhost:9090` | Certificate monitoring dashboard |
| **Prometheus** | `http://localhost:9091` | Metrics collection and querying |

## 🔍 Advanced Certificate Operations

### Multi-CA Certificate Generation

```bash
# Generate certificate from primary CA
docker exec -it step-cli-advanced bash -c "
  export STEPPATH=/app/secrets/primary
  step certificate create \
    --san example.com \
    --san www.example.com \
    'example.com' \
    /app/certs/example-primary.crt \
    /app/certs/example-primary.key
"

# Generate certificate from secondary CA
docker exec -it step-cli-advanced bash -c "
  export STEPPATH=/app/secrets/secondary
  step certificate create \
    --san api.example.com \
    --san admin.example.com \
    'api.example.com' \
    /app/certs/api-secondary.crt \
    /app/certs/api-secondary.key
"
```

### Certificate Automation

```bash
# Set up automated certificate renewal
docker exec -it cert-automation python3 /app/scripts/setup_renewal.py

# Configure certificate monitoring
docker exec -it cert-monitor python3 /app/scripts/setup_monitoring.py

# Set up certificate alerts
docker exec -it cert-monitor python3 /app/scripts/setup_alerts.py
```

### Advanced Signing Scenarios

```bash
# Generate intermediate CA certificate
docker exec -it step-cli-advanced bash -c "
  export STEPPATH=/app/secrets/primary
  step certificate create \
    --profile intermediate-ca \
    'Intermediate CA' \
    /app/certs/intermediate.crt \
    /app/certs/intermediate.key
"

# Sign certificate with intermediate CA
docker exec -it step-cli-advanced bash -c "
  export STEPPATH=/app/secrets/primary
  step certificate create \
    --ca /app/certs/intermediate.crt \
    --ca-key /app/certs/intermediate.key \
    --san service.example.com \
    'service.example.com' \
    /app/certs/service.crt \
    /app/certs/service.key
"
```

## 📈 Understanding Advanced PKI

### Multi-CA Architecture

```
Root CA (Primary)
├── Intermediate CA 1
│   ├── Server Certificates
│   └── Client Certificates
└── Intermediate CA 2
    ├── Code Signing Certificates
    └── Email Certificates

Root CA (Secondary)
├── Backup Certificates
└── Disaster Recovery
```

### Certificate Lifecycle Management

| Phase | Description | Automation |
|-------|-------------|------------|
| **Generation** | Create new certificates | Automated CSR processing |
| **Signing** | Sign certificate requests | Automated approval workflows |
| **Distribution** | Deploy certificates | Automated deployment scripts |
| **Monitoring** | Track certificate status | Real-time monitoring |
| **Renewal** | Renew expiring certificates | Automated renewal process |
| **Revocation** | Revoke compromised certificates | Automated revocation |

### Load Balancing Strategy

- **HAProxy**: Round-robin load balancing between CA servers
- **Health Checks**: Automatic failover when CA servers become unhealthy
- **Session Persistence**: Optional sticky sessions for consistent CA access
- **SSL Termination**: Handle SSL/TLS termination at load balancer

## 🔧 Configuration Details

### Primary CA Configuration

```json
{
  "root": "/app/secrets/certs/root_ca.crt",
  "crt": "/app/secrets/certs/intermediate_ca.crt",
  "key": "/app/secrets/certs/intermediate_ca_key",
  "address": ":443",
  "dnsNames": ["step-ca-primary"],
  "provisioners": [
    {
      "name": "admin@primary.com",
      "type": "JWK"
    }
  ]
}
```

### Secondary CA Configuration

```json
{
  "root": "/app/secrets/certs/root_ca.crt",
  "crt": "/app/secrets/certs/intermediate_ca.crt",
  "key": "/app/secrets/certs/intermediate_ca_key",
  "address": ":443",
  "dnsNames": ["step-ca-secondary"],
  "provisioners": [
    {
      "name": "admin@secondary.com",
      "type": "JWK"
    }
  ]
}
```

### HAProxy Configuration

```haproxy
global
    daemon

defaults
    mode http
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend ca_frontend
    bind *:80
    default_backend ca_backend

backend ca_backend
    balance roundrobin
    option httpchk GET /health
    server ca1 step-ca-primary:443 check
    server ca2 step-ca-secondary:443 check

listen stats
    bind *:8404
    stats enable
    stats uri /stats
    stats refresh 30s
```

## 🧪 Testing Scenarios

### 1. Multi-CA Certificate Generation Test

```bash
# Generate certificates from both CAs
docker exec -it step-cli-advanced bash -c "
  export STEPPATH=/app/secrets/primary
  step certificate create primary-test primary-test.crt primary-test.key
"

docker exec -it step-cli-advanced bash -c "
  export STEPPATH=/app/secrets/secondary
  step certificate create secondary-test secondary-test.crt secondary-test.key
"

# Verify certificates
docker exec -it step-cli-advanced step certificate inspect /app/certs/primary-test.crt
docker exec -it step-cli-advanced step certificate inspect /app/certs/secondary-test.crt
```

### 2. Load Balancing Test

```bash
# Test load balancer
curl -k https://localhost:8444/health

# Check HAProxy stats
curl http://localhost:8445/stats

# Test failover
docker stop step-ca-primary
curl -k https://localhost:8444/health
docker start step-ca-primary
```

### 3. Certificate Automation Test

```bash
# Set up automated certificate renewal
curl -X POST http://localhost:8080/automation/setup \
  -H "Content-Type: application/json" \
  -d '{"certificate": "example.com", "renewal_days": 30}'

# Check automation status
curl http://localhost:8080/automation/status

# Trigger manual renewal
curl -X POST http://localhost:8080/automation/renew \
  -H "Content-Type: application/json" \
  -d '{"certificate": "example.com"}'
```

### 4. Monitoring Test

```bash
# Check certificate monitoring
curl http://localhost:9090/metrics

# View certificate status
curl http://localhost:9090/certificates

# Check Prometheus metrics
curl http://localhost:9091/api/v1/query?query=certificate_expiry_days
```

## 🔍 Troubleshooting

### Common Issues

**CA servers not starting**
```bash
# Check CA logs
docker compose logs step-ca-primary
docker compose logs step-ca-secondary

# Verify CA configuration
docker exec -it step-cli-advanced cat /app/secrets/primary/config/ca.json
docker exec -it step-cli-advanced cat /app/secrets/secondary/config/ca.json

# Check CA health
docker exec -it step-cli-advanced step ca health --ca-url https://step-ca-primary:443
```

**Load balancer issues**
```bash
# Check HAProxy logs
docker compose logs haproxy-ca

# Verify HAProxy configuration
docker exec -it haproxy-ca cat /usr/local/etc/haproxy/haproxy.cfg

# Check backend health
curl http://localhost:8445/stats
```

**Automation service issues**
```bash
# Check automation logs
docker compose logs cert-automation

# Verify automation configuration
docker exec -it cert-automation python3 /app/check_config.py

# Test automation API
curl http://localhost:8080/health
```

**Monitoring issues**
```bash
# Check monitoring logs
docker compose logs cert-monitor

# Verify monitoring configuration
docker exec -it cert-monitor python3 /app/check_monitoring.py

# Check Prometheus targets
curl http://localhost:9091/api/v1/targets
```

### Debug Commands

```bash
# Check all container statuses
docker compose ps

# View real-time logs
docker compose logs -f --tail=100

# Check network connectivity
docker exec -it step-cli-advanced ping step-ca-primary
docker exec -it step-cli-advanced ping step-ca-secondary

# Verify volume mounts
docker exec -it step-cli-advanced ls -la /app/secrets/primary/
docker exec -it step-cli-advanced ls -la /app/secrets/secondary/
```

## 📚 Next Steps

After mastering this advanced example:

1. **Try Production PKI**: Enterprise-grade PKI with security best practices
2. **Explore Integration Examples**: Connect with various tools and platforms
3. **Customize Automation**: Modify automation scripts for your use case
4. **Add More Monitoring**: Implement additional monitoring and alerting

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

**Happy Advanced Certificate Management! 🚀**
