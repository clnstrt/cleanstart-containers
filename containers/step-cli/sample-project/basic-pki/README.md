# 🔐 Step CLI - Basic PKI Example

A comprehensive example demonstrating fundamental PKI operations and certificate management using Step CLI. This example covers certificate generation, CA setup, and basic certificate lifecycle management.

## 🎯 What This Example Demonstrates

- **Certificate Generation**: Create various types of certificates
- **CA Setup**: Initialize and configure a local Certificate Authority
- **Certificate Management**: Basic certificate operations and validation
- **Certificate Inspection**: Tools for examining and validating certificates
- **Automated Operations**: Scripts for common certificate tasks

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Ports 443, 8080, 8081 available
- Basic understanding of PKI concepts

### 1. Start the Services

```bash
# Navigate to the example directory
cd images/step-cli/sample-project/basic-pki

# Start all services
docker compose up -d

# Check service status
docker compose ps

# View logs
docker compose logs -f
```

### 2. Initialize the CA

```bash
# Initialize the Certificate Authority
docker exec -it step-cli-basic step ca init \
  --name "Basic PKI CA" \
  --dns "step-ca" \
  --address ":443" \
  --provisioner "admin@example.com" \
  --password-file /app/config/ca-password.txt

# Start the CA server
docker compose restart step-ca
```

### 3. Generate Test Certificates

```bash
# Generate a server certificate
docker exec -it step-cli-basic step certificate create \
  --san localhost \
  --san 127.0.0.1 \
  --san step-ca \
  "localhost" \
  /app/certs/localhost.crt \
  /app/certs/localhost.key

# Generate a client certificate
docker exec -it step-cli-basic step certificate create \
  --profile client \
  "client@example.com" \
  /app/certs/client.crt \
  /app/certs/client.key
```

### 4. Access the Services

```bash
# Access certificate generator web interface
open http://localhost:8080

# Access certificate inspector
open http://localhost:8081

# Check CA health
curl -k https://localhost:443/health
```

## 📊 Access Points

| Service | URL | Description |
|---------|-----|-------------|
| **Step CA** | `https://localhost:443` | Certificate Authority server |
| **Certificate Generator** | `http://localhost:8080` | Web interface for certificate generation |
| **Certificate Inspector** | `http://localhost:8081` | Certificate inspection and validation |
| **Step CLI** | Interactive shell access | Command-line certificate operations |

## 🔍 Certificate Operations

### Basic Certificate Generation

```bash
# Generate a self-signed certificate
docker exec -it step-cli-basic step certificate create \
  --self-signed \
  --no-password \
  --insecure \
  "My Certificate" \
  /app/certs/self-signed.crt \
  /app/certs/self-signed.key

# Generate a certificate with multiple SANs
docker exec -it step-cli-basic step certificate create \
  --san example.com \
  --san www.example.com \
  --san api.example.com \
  "example.com" \
  /app/certs/example.crt \
  /app/certs/example.key
```

### CA Operations

```bash
# Check CA status
docker exec -it step-cli-basic step ca health

# List CA certificates
docker exec -it step-cli-basic step ca certificates

# Get CA root certificate
docker exec -it step-cli-basic step ca root /app/certs/ca.crt

# Bootstrap with CA
docker exec -it step-cli-basic step ca bootstrap \
  --ca-url https://step-ca:443 \
  --fingerprint $(docker exec -it step-cli-basic step certificate fingerprint /app/secrets/certs/root_ca.crt)
```

### Certificate Inspection

```bash
# Inspect a certificate
docker exec -it step-cli-basic step certificate inspect /app/certs/localhost.crt

# Get certificate fingerprint
docker exec -it step-cli-basic step certificate fingerprint /app/certs/localhost.crt

# Verify certificate chain
docker exec -it step-cli-basic step certificate verify \
  --roots /app/secrets/certs/root_ca.crt \
  /app/certs/localhost.crt
```

## 📈 Understanding PKI Concepts

### Certificate Types

| Type | Description | Use Case |
|------|-------------|----------|
| **Server Certificate** | For web servers and services | HTTPS, TLS connections |
| **Client Certificate** | For client authentication | Mutual TLS, API authentication |
| **Root CA Certificate** | Root of trust | Certificate chain validation |
| **Intermediate CA** | Subordinate CA | Certificate hierarchy |

### Key Operations

| Operation | Description | Command Example |
|-----------|-------------|-----------------|
| **Generate** | Create new certificates | `step certificate create` |
| **Sign** | Sign certificate requests | `step ca sign` |
| **Inspect** | Examine certificate details | `step certificate inspect` |
| **Verify** | Validate certificate chain | `step certificate verify` |
| **Revoke** | Revoke compromised certificates | `step ca revoke` |

## 🔧 Configuration Details

### CA Configuration

The CA is configured with:
- **Name**: "Basic PKI CA"
- **DNS**: step-ca
- **Address**: :443
- **Provisioner**: admin@example.com
- **Password**: Stored in configuration file

### Certificate Storage

- **Certificates**: `/app/certs/` directory
- **CA Secrets**: `/app/secrets/` directory
- **Configuration**: `/app/config/` directory
- **Scripts**: `/app/scripts/` directory

### Network Configuration

- **PKI Network**: Internal network for CA communication
- **Port Mapping**: Exposed ports for external access
- **TLS**: Secure communication between services

## 🧪 Testing Scenarios

### 1. Basic Certificate Generation Test

```bash
# Generate a test certificate
docker exec -it step-cli-basic step certificate create \
  --san test.example.com \
  "test.example.com" \
  /app/certs/test.crt \
  /app/certs/test.key

# Verify the certificate
docker exec -it step-cli-basic step certificate inspect /app/certs/test.crt

# Check certificate validity
docker exec -it step-cli-basic step certificate verify \
  --roots /app/secrets/certs/root_ca.crt \
  /app/certs/test.crt
```

### 2. CA Health Test

```bash
# Check CA health
docker exec -it step-cli-basic step ca health

# List CA configuration
docker exec -it step-cli-basic step ca config

# Check CA certificates
docker exec -it step-cli-basic step ca certificates
```

### 3. Certificate Chain Test

```bash
# Generate intermediate certificate
docker exec -it step-cli-basic step certificate create \
  --profile intermediate-ca \
  "Intermediate CA" \
  /app/certs/intermediate.crt \
  /app/certs/intermediate.key

# Verify certificate chain
docker exec -it step-cli-basic step certificate verify \
  --roots /app/secrets/certs/root_ca.crt \
  --intermediates /app/certs/intermediate.crt \
  /app/certs/test.crt
```

## 🔍 Troubleshooting

### Common Issues

**CA won't start**
```bash
# Check CA logs
docker compose logs step-ca

# Verify CA configuration
docker exec -it step-cli-basic cat /app/secrets/config/ca.json

# Check secrets directory
docker exec -it step-cli-basic ls -la /app/secrets/
```

**Certificate generation fails**
```bash
# Check certificate directory permissions
docker exec -it step-cli-basic ls -la /app/certs/

# Verify Step configuration
docker exec -it step-cli-basic step path

# Check CA connectivity
docker exec -it step-cli-basic step ca health
```

**Certificate validation fails**
```bash
# Check certificate format
docker exec -it step-cli-basic step certificate inspect /app/certs/test.crt

# Verify certificate chain
docker exec -it step-cli-basic step certificate verify \
  --roots /app/secrets/certs/root_ca.crt \
  /app/certs/test.crt

# Check CA root certificate
docker exec -it step-cli-basic step certificate inspect /app/secrets/certs/root_ca.crt
```

### Debug Commands

```bash
# Check all container statuses
docker compose ps

# View real-time logs
docker compose logs -f --tail=100

# Check network connectivity
docker exec -it step-cli-basic ping step-ca

# Verify volume mounts
docker exec -it step-cli-basic ls -la /app/certs/
docker exec -it step-cli-basic ls -la /app/secrets/
```

## 📚 Next Steps

After mastering this basic example:

1. **Try Advanced Certificates**: Complex certificate scenarios and automation
2. **Explore Production PKI**: Enterprise-grade PKI with security best practices
3. **Customize Certificates**: Modify certificate configurations for your use case
4. **Add Automation**: Implement automated certificate management

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

**Happy Certificate Management! 🔐**
