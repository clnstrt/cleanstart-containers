# Step CLI Examples

This directory contains Step CLI examples for the cleanstart-containers project.

## Next Steps for Sample Project Testing

You have already pulled the Step CLI image from Docker Hub and run the container. Now you can test the complete sample project to verify the image functionality.

## Available Examples

### sample-project
A comprehensive PKI and certificate management system built with Step CLI that demonstrates:
- Basic PKI operations and certificate generation
- Advanced certificate management with automated workflows
- Production-ready PKI setup with security best practices
- Integration examples with various systems

## Sample Project Testing Results

The Step CLI sample project has been thoroughly tested and verified to work perfectly:

### ✅ Verified Features
- **Basic PKI**: Certificate generation and management accessible via CLI
- **Advanced Certificates**: Complex certificate workflows and automation
- **Production PKI**: Enterprise-grade certificate authority setup
- **Integration**: Docker Compose and Kubernetes integration examples
- **Security**: Non-root user implementation and security best practices

### ✅ PKI Operations Tested
- `step certificate create` - Generate self-signed certificates
- `step ca init` - Initialize certificate authority
- `step crypto key create` - Generate cryptographic keys
- `step certificate inspect` - Inspect certificate details

### ✅ User Experience Flow
1. User pulls `cleanstart/step-cli` from Docker Hub ✅
2. User runs the container to get started ✅
3. User navigates to sample project from GitHub ✅
4. User runs the PKI examples using Docker ✅
5. Certificate management works perfectly with all features ✅

## Quick Start

### Option 1: Using Docker (Recommended)
```bash
# Navigate to sample project
cd sample-project

# Run basic PKI example
cd basic-pki
docker-compose up -d

# Run advanced certificates example
cd ../advanced-certificates
docker-compose up -d

# Run production PKI example
cd ../production-pki
docker-compose up -d
```

### Option 2: Direct CLI Usage
```bash
# Check Step CLI version
docker run --rm cleanstart/step-cli:latest step version

# Generate a self-signed certificate
docker run -it --rm \
  -v $(pwd)/certs:/app/certs \
  cleanstart/step-cli:latest \
  step certificate create \
    --self-signed \
    --no-password \
    --insecure \
    "My Certificate" \
    my-cert.crt \
    my-cert.key
```

## Docker Support

All Step CLI examples include Docker support for easy deployment:

```bash
# Run with volume mounts
docker run -it --rm \
  -v $(pwd)/certs:/app/certs \
  -v $(pwd)/secrets:/app/secrets \
  cleanstart/step-cli:latest
```

## Technology Stack

- **Step CLI**: Modern PKI and certificate management tool
- **Smallstep CA**: Certificate authority server
- **Docker**: Containerization for easy deployment
- **Kubernetes**: Orchestration and scaling
- **TLS/SSL**: Secure communication protocols

## Testing and Validation

The Step CLI sample project has been tested and validated to ensure:
- ✅ All PKI operations work correctly
- ✅ Certificate generation and management function properly
- ✅ CA initialization and configuration work seamlessly
- ✅ Docker containerization works flawlessly
- ✅ Security best practices are implemented

## Sample Project Features

- **Basic PKI**: Simple certificate generation and management
- **Advanced Certificates**: Complex workflows and automation
- **Production PKI**: Enterprise-grade setup with security
- **Integration Examples**: Docker Compose and Kubernetes manifests
- **Health Checks**: Built-in monitoring for all services

## Troubleshooting

If you encounter any issues:
1. Ensure Docker is running
2. Check that required ports are available
3. Verify all dependencies are installed correctly
4. Check the container logs for any errors
5. Ensure proper file permissions for certificate storage
