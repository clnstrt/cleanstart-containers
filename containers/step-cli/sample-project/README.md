# Step CLI Sample Projects

This directory contains practical examples demonstrating how to use the Step CLI for certificate management and PKI operations in various scenarios.

## 🎯 What You'll Learn

- **Basic PKI Operations**: Certificate generation, signing, and management
- **CA Setup**: Initialize and configure Certificate Authorities
- **Advanced Certificate Management**: Complex certificate scenarios and automation
- **Production PKI**: Enterprise-grade certificate management with security best practices
- **Integration Examples**: Connect with various tools and platforms

## 📁 Project Structure

```
sample-project/
├── basic-pki/                 # 🔐 Basic PKI operations and certificate management
├── advanced-certificates/     # 🚀 Advanced certificate scenarios and automation
├── production-pki/            # 🏭 Production-ready PKI setup with security
├── integration-examples/      # 🔗 Integration with other tools and platforms
├── README.md                  # 📖 This comprehensive guide
├── setup.sh                   # 🐧 Linux/macOS setup script
└── setup.bat                  # 🪟 Windows setup script
```

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Basic understanding of PKI and certificate management
- Ports 443, 8080, 9090 available (depending on example)
- 1GB+ RAM for basic examples, 2GB+ for production setup

### Choose Your Learning Path

| Level | Example | Description | Time to Complete |
|-------|---------|-------------|------------------|
| **🟢 Beginner** | `basic-pki/` | Basic certificate operations and PKI setup | 20-30 minutes |
| **🟡 Intermediate** | `advanced-certificates/` | Complex certificate scenarios and automation | 30-45 minutes |
| **🔴 Advanced** | `production-pki/` | Enterprise-grade PKI with security best practices | 45-60 minutes |
| **🔗 Integration** | `integration-examples/` | Integration with tools and platforms | 60+ minutes |

### Run Any Example

```bash
# Navigate to the example directory
cd basic-pki

# Start the services
docker compose up -d

# Check status
docker compose ps

# View logs
docker compose logs -f

# Stop services
docker compose down
```

## 📊 Example Overview

### 1. 🔐 Basic PKI (`basic-pki/`)

**Purpose**: Learn fundamental PKI operations and certificate management basics.

**Components**:
- **Step CLI**: Certificate management and PKI operations
- **Sample CA**: Local Certificate Authority for testing
- **Certificate Generator**: Automated certificate generation
- **Certificate Inspector**: Certificate validation and inspection tools

**Access Points**:
- Step CLI: Interactive shell access
- Certificate Storage: `./certs/` directory
- CA Configuration: `./secrets/` directory
- Sample Scripts: `./scripts/` directory

**Learning Objectives**:
- Basic certificate generation and management
- Understanding PKI concepts
- CA initialization and configuration
- Certificate inspection and validation

**Time to Complete**: 20-30 minutes

### 2. 🚀 Advanced Certificates (`advanced-certificates/`)

**Purpose**: Master complex certificate scenarios, automation, and advanced PKI operations.

**Components**:
- **Multi-CA Setup**: Multiple Certificate Authorities
- **Certificate Automation**: Automated certificate lifecycle management
- **Advanced Signing**: Complex certificate signing scenarios
- **Certificate Monitoring**: Certificate expiration and renewal monitoring

**Access Points**:
- Primary CA: `http://localhost:443`
- Secondary CA: `http://localhost:8443`
- Certificate Dashboard: `http://localhost:8080`
- Monitoring Interface: `http://localhost:9090`

**Learning Objectives**:
- Advanced certificate management
- Multi-CA environments
- Certificate automation and scripting
- Monitoring and alerting

**Time to Complete**: 30-45 minutes

### 3. 🏭 Production PKI (`production-pki/`)

**Purpose**: Implement enterprise-grade PKI with security best practices and compliance.

**Components**:
- **Production CA**: Secure, high-availability Certificate Authority
- **Security Hardening**: Security best practices and compliance
- **High Availability**: Multi-instance CA with load balancing
- **Audit Logging**: Comprehensive audit trails and compliance reporting
- **Backup & Recovery**: Automated backup and disaster recovery

**Access Points**:
- Production CA: `https://localhost:443`
- Admin Interface: `https://localhost:8080`
- Audit Dashboard: `https://localhost:9090`
- Backup Interface: `https://localhost:8081`

**Learning Objectives**:
- Production PKI architecture
- Security hardening and compliance
- High availability and disaster recovery
- Audit and compliance reporting

**Time to Complete**: 45-60 minutes

### 4. 🔗 Integration Examples (`integration-examples/`)

**Purpose**: Integrate Step CLI with various tools and platforms for comprehensive certificate management.

**Examples**:
- **Kubernetes Integration**: Certificate management in K8s environments
- **CI/CD Integration**: Automated certificate management in pipelines
- **Web Server Integration**: Nginx, Apache, and other web servers
- **Database Integration**: Certificate management for databases
- **Cloud Integration**: AWS, Azure, and GCP certificate management

**Access Points**:
- Kubernetes: Various cluster endpoints
- CI/CD Pipeline: Jenkins/GitHub Actions interfaces
- Web Servers: Nginx/Apache configuration
- Cloud Platforms: AWS/Azure/GCP consoles

**Learning Objectives**:
- Integration with popular tools
- Cloud-native certificate management
- CI/CD automation
- Platform-specific configurations

**Time to Complete**: 60+ minutes

## 🔧 Setup Scripts

### Linux/macOS Setup

```bash
# Make script executable
chmod +x setup.sh

# Run interactive setup script
./setup.sh
```

### Windows Setup

```cmd
# Run interactive setup script
setup.bat
```

## 📈 Certificate Management Best Practices

### Key Operations to Master

| Operation | Description | Best Practice | Example Command |
|-----------|-------------|---------------|-----------------|
| **Certificate Generation** | Create new certificates | Use strong key sizes and proper SANs | `step certificate create --san example.com` |
| **CA Initialization** | Set up Certificate Authority | Use secure passwords and proper DNS | `step ca init --name "My CA"` |
| **Certificate Signing** | Sign certificate requests | Validate identity and purpose | `step ca sign --csr request.csr` |
| **Certificate Renewal** | Renew expiring certificates | Automate renewal process | `step ca renew --daemon` |
| **Certificate Revocation** | Revoke compromised certificates | Maintain CRL and OCSP | `step ca revoke --cert cert.crt` |

### Security Considerations

```bash
# Use strong key sizes
step certificate create --kty RSA --size 4096

# Enable proper certificate validation
step certificate verify --roots ca.crt cert.crt

# Implement certificate pinning
step certificate fingerprint cert.crt

# Use secure storage
step crypto key create --kty EC --curve P-256
```

## 🎓 Learning Path

### 🟢 Beginner Level (20-30 minutes)
1. **Start with Basic PKI**
   - Understand certificate concepts
   - Learn basic certificate operations
   - Set up a local CA
   - Generate and inspect certificates

2. **Practice Certificate Operations**
   - Generate different types of certificates
   - Understand certificate formats
   - Learn certificate validation
   - Explore certificate inspection

### 🟡 Intermediate Level (30-45 minutes)
1. **Move to Advanced Certificates**
   - Understand multi-CA environments
   - Learn certificate automation
   - Implement certificate monitoring
   - Master advanced signing scenarios

2. **Certificate Lifecycle Management**
   - Implement automated renewal
   - Set up certificate monitoring
   - Handle certificate revocation
   - Manage certificate storage

### 🔴 Advanced Level (45-60 minutes)
1. **Production PKI Setup**
   - Implement enterprise-grade PKI
   - Configure security hardening
   - Set up high availability
   - Implement audit and compliance

2. **Security and Compliance**
   - Configure security best practices
   - Implement compliance reporting
   - Set up disaster recovery
   - Configure backup strategies

### 🔗 Expert Level (60+ minutes)
1. **Integration Examples**
   - Kubernetes certificate management
   - CI/CD integration
   - Cloud platform integration
   - Web server integration

2. **Custom Solutions**
   - Build custom certificate workflows
   - Implement custom integrations
   - Create specialized automation
   - Advanced security configurations

## 🔍 Testing and Validation

### Health Checks

```bash
# Check Step CLI version
docker run --rm cleanstart/step-cli:latest step version

# Verify CA connectivity
docker run --rm cleanstart/step-cli:latest step ca health

# Check certificate validity
docker run --rm cleanstart/step-cli:latest step certificate verify cert.crt
```

### Certificate Testing

```bash
# Generate test certificate
docker run -it --rm \
  -v $(pwd)/certs:/app/certs \
  cleanstart/step-cli:latest \
  step certificate create test-cert test.crt test.key

# Validate certificate
docker run --rm \
  -v $(pwd)/certs:/app/certs \
  cleanstart/step-cli:latest \
  step certificate inspect test.crt
```

### CA Testing

```bash
# Initialize test CA
docker run -it --rm \
  -v $(pwd)/secrets:/app/secrets \
  cleanstart/step-cli:latest \
  step ca init --name "Test CA"

# Start CA server
docker run -d \
  --name test-ca \
  -p 443:443 \
  -v $(pwd)/secrets:/app/secrets \
  cleanstart/step-cli:latest \
  step-ca /app/secrets/config/ca.json
```

## 🛡️ Security Considerations

### Network Security
- Use TLS encryption for all CA communications
- Implement proper network segmentation
- Use strong authentication mechanisms
- Regular security audits and updates

### Key Management
- Use hardware security modules (HSMs) for production
- Implement proper key rotation policies
- Secure key storage and backup
- Monitor key usage and access

### Certificate Security
- Implement certificate pinning
- Use strong cryptographic algorithms
- Regular certificate validation
- Monitor certificate expiration and renewal

## 🔧 Troubleshooting

### Common Issues

**CA initialization fails**
```bash
# Check secrets directory permissions
docker run --rm -v $(pwd)/secrets:/app/secrets cleanstart/step-cli:latest ls -la /app/secrets

# Verify CA configuration
docker run --rm -v $(pwd)/secrets:/app/secrets cleanstart/step-cli:latest step ca config
```

**Certificate generation fails**
```bash
# Check certificate directory permissions
docker run --rm -v $(pwd)/certs:/app/certs cleanstart/step-cli:latest ls -la /app/certs

# Verify Step configuration
docker run --rm -v $(pwd)/secrets:/app/secrets cleanstart/step-cli:latest step path
```

**CA server won't start**
```bash
# Check CA server logs
docker logs test-ca

# Verify CA configuration file
docker run --rm -v $(pwd)/secrets:/app/secrets cleanstart/step-cli:latest cat /app/secrets/config/ca.json
```

### Debug Commands

```bash
# Check Step CLI configuration
docker run --rm -v $(pwd)/secrets:/app/secrets cleanstart/step-cli:latest step path

# Verify CA connectivity
docker run --rm cleanstart/step-cli:latest step ca health --ca-url https://ca.example.com

# Check certificate details
docker run --rm -v $(pwd)/certs:/app/certs cleanstart/step-cli:latest step certificate inspect cert.crt
```

## 📚 Additional Resources

### Documentation
- [Step CLI Documentation](https://smallstep.com/docs/step-cli/)
- [Step CA Documentation](https://smallstep.com/docs/step-ca/)
- [Certificate Management Guide](https://smallstep.com/docs/tutorials/)

### Community
- [Smallstep Community](https://github.com/smallstep)
- [Step CLI GitHub](https://github.com/smallstep/cli)
- [Step CA GitHub](https://github.com/smallstep/certificates)

### Tools and Extensions
- [Autocert](https://github.com/smallstep/autocert) - Automatic certificate management
- [Certbot](https://certbot.eff.org/) - Let's Encrypt client
- [CFSSL](https://github.com/cloudflare/cfssl) - CloudFlare's PKI toolkit

## 🤝 Contributing

We welcome contributions to improve these examples:

1. **Add new certificate management scenarios**
2. **Improve documentation**
3. **Create additional examples**
4. **Fix bugs and issues**
5. **Add new integration examples**
6. **Improve security configurations**

### How to Contribute

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📞 Support

If you encounter issues or need help:

1. **Check the troubleshooting section above**
2. **Review the individual example READMEs**
3. **Check the logs for specific error messages**
4. **Open an issue on GitHub with detailed information**

---

**Happy Certificate Management! 🔐**
