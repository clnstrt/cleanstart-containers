# 🔐 Step CLI - Sample Project

Welcome to the Step CLI sample project! This directory contains essential examples and demonstrations of Step CLI functionality using the CleanStart container.

## 🌟 Features

- **Hello World Testing**: Simple Step CLI functionality verification
- **Basic PKI Operations**: Essential certificate management and CA setup
- **CleanStart Integration**: Uses CleanStart Step CLI container
- **Docker Ready**: Easy testing with Docker commands

## 🚀 Quick Start

### Prerequisites

- Docker installed
- CleanStart Step CLI image available (`cleanstart/step-cli:latest`)

### Step 1: Pull the CleanStart Step CLI Image

```bash
# Pull the latest CleanStart Step CLI image
docker pull cleanstart/step-cli:latest
```

**Why this command?** This ensures you have the latest CleanStart Step CLI image locally before running tests.

### Step 2: Test Step CLI Basic Functionality

#### Test 1: Check Step CLI Version

```bash
# Quick test to verify Step CLI is working
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step version
```

**Why this command?** Verifies that Step CLI is properly installed and accessible in the CleanStart container.

#### Test 2: Run Hello World Program

```bash
# Run Step CLI hello world directly in container
docker run --rm --entrypoint="" cleanstart/step-cli:latest /bin/busybox sh -c '
echo "============================================================"
echo "🔐 Step CLI - Hello World"
echo "============================================================"
echo "Timestamp: $(date)"
echo "Working Directory: $(pwd)"
echo "============================================================"
echo ""
echo "🧪 Testing Step CLI..."
/step version
echo "✅ Step CLI is available"
echo ""
echo "🧪 Testing Step CA..."
/step ca --help
echo "✅ Step CA is available"
echo ""
echo "============================================================"
echo "🎉 Step CLI Hello World completed!"
echo "============================================================"
'
```

**Why this command?** Comprehensive test that verifies both Step CLI and Step CA functionality with detailed output.

### Step 3: Test Basic PKI Operations

#### Test 3: Initialize a Certificate Authority

```bash
# Initialize a basic CA
docker run --rm --entrypoint="" cleanstart/step-cli:latest /bin/busybox sh -c '
echo "🏭 Initializing Certificate Authority..."
cd /tmp
echo "password" > password.txt
/step ca init --name "Test CA" --dns "localhost" --address ":8443" --provisioner "admin" --password-file password.txt --pki
echo "✅ CA initialized successfully!"
echo "Root certificate fingerprint:"
/step certificate fingerprint /home/clnstrt/.step/certs/root_ca.crt
'
```

**Why this command?** Tests the core PKI functionality by initializing a Certificate Authority and generating root certificates.

#### Test 4: Inspect Certificates

```bash
# Inspect the generated certificates
docker run --rm --entrypoint="" cleanstart/step-cli:latest /bin/busybox sh -c '
echo "🔍 Inspecting Certificates..."
cd /tmp
echo "password" > password.txt
/step ca init --name "Test CA" --dns "localhost" --address ":8443" --provisioner "admin" --password-file password.txt --pki
echo ""
echo "Root Certificate Details:"
/step certificate inspect /home/clnstrt/.step/certs/root_ca.crt | head -10
echo ""
echo "Intermediate Certificate Details:"
/step certificate inspect /home/clnstrt/.step/certs/intermediate_ca.crt | head -10
'
```

**Why this command?** Demonstrates certificate inspection capabilities, essential for PKI operations and troubleshooting.

### Step 4: Test Help System

#### Test 5: Step CLI Help

```bash
# Check Step CLI help
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step --help
```

**Why this command?** Shows all available Step CLI commands and options for further exploration.

#### Test 6: Certificate Help

```bash
# Check certificate command help
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step certificate --help
```

**Why this command?** Provides detailed information about certificate management commands.

#### Test 7: CA Help

```bash
# Check CA command help
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step ca --help
```

**Why this command?** Shows Certificate Authority management commands and options.

## 📁 Project Structure

```
sample-project/
├── README.md                    # This documentation
├── hello_world.sh              # Simple test script
└── basic-pki/                  # Basic PKI operations
    ├── README.md               # PKI-specific documentation
    ├── docker-compose.yml      # PKI services setup
    ├── cert-generator/         # Certificate generation tools
    │   └── cert_generator.py   # Python certificate generator
    └── inspector/              # Certificate inspection tools
        └── index.html          # Web-based certificate inspector
```

## 📋 Expected Output

When you run these tests, you should see output similar to:

```
Smallstep CLI/0.28.7 (linux/amd64)
Release Date: 2025-08-28 11:08 UTC

============================================================
🔐 Step CLI - Hello World
============================================================
Timestamp: Mon Sep 16 17:30:45 UTC 2025
Working Directory: /
============================================================

🧪 Testing Step CLI...
Smallstep CLI/0.28.7 (linux/amd64)
Release Date: 2025-08-28 11:08 UTC
✅ Step CLI is available

🧪 Testing Step CA...
✅ Step CA is available

============================================================
🎉 Step CLI Hello World completed!
============================================================
```

## 🔍 Troubleshooting

### Common Issues

**Docker not running**
```bash
# Check Docker status
docker --version
docker info
```

**Image not found**
```bash
# Pull the image again
docker pull cleanstart/step-cli:latest
```

**Command not found**
```bash
# Use the correct entrypoint override
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step version
```

### CleanStart Image Specific Issues

The `cleanstart/step-cli:latest` image is minimal and requires specific commands:

1. **Use `--entrypoint=""` to override the default entrypoint**
2. **Use BusyBox shell for scripts**: `/bin/busybox sh -c "command"`
3. **Step CLI binary is located at `/step`**
4. **Image doesn't have Python installed** - use shell scripts instead
5. **No local files needed** - all commands work directly with the Docker image

## 🚀 Next Steps

After running these basic tests:

1. **Explore Basic PKI**: Check out the `basic-pki/` directory for certificate operations
2. **Try Certificate Generation**: Experiment with creating different types of certificates
3. **Read Documentation**: Learn more about Step CLI capabilities
4. **Build Your Own**: Create custom certificate management workflows

## 📚 Resources

- **Step CLI Documentation**: https://smallstep.com/docs/step-cli
- **CleanStart Containers**: Check the main repository README
- **Smallstep Official**: https://smallstep.com/

---

**Happy Certificate Management! 🔐**