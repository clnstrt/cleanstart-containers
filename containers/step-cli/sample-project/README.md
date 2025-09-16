# 🔐 Step CLI - Sample Project

Welcome to the Step CLI sample project! This directory contains simple examples and demonstrations of Step CLI functionality using the CleanStart container.

## 🚀 Quick Start

### Prerequisites

- Docker installed
- CleanStart Step CLI image available (`cleanstart/step-cli:latest`)

### Step 1: Pull the CleanStart Step CLI Image

```bash
# Pull the latest CleanStart Step CLI image
docker pull cleanstart/step-cli:latest
```

### Step 2: Test Step CLI Basic Functionality

#### Test 1: Check Step CLI Version

```bash
# Quick test to verify Step CLI is working
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step version
```

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
/step ca version
echo "✅ Step CA is available"
echo ""
echo "============================================================"
echo "🎉 Step CLI Hello World completed!"
echo "============================================================"
'
```

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

#### Test 5: Get Certificate Fingerprints

```bash
# Get certificate fingerprints
docker run --rm --entrypoint="" cleanstart/step-cli:latest /bin/busybox sh -c '
echo "🔐 Certificate Fingerprints..."
cd /tmp
echo "password" > password.txt
/step ca init --name "Test CA" --dns "localhost" --address ":8443" --provisioner "admin" --password-file password.txt --pki
echo ""
echo "Root CA Fingerprint:"
/step certificate fingerprint /home/clnstrt/.step/certs/root_ca.crt
echo ""
echo "Intermediate CA Fingerprint:"
/step certificate fingerprint /home/clnstrt/.step/certs/intermediate_ca.crt
'
```

### Step 4: Test Help System

#### Test 6: Step CLI Help

```bash
# Check Step CLI help
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step --help
```

#### Test 7: Certificate Help

```bash
# Check certificate command help
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step certificate --help
```

#### Test 8: CA Help

```bash
# Check CA command help
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step ca --help
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
No help topic for 'version'
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

**CleanStart Image Specific Issues**
The `cleanstart/step-cli:latest` image is minimal and requires specific commands:

1. **Use `--entrypoint=""` to override the default entrypoint**
2. **Use BusyBox shell for scripts**: `/bin/busybox sh -c "command"`
3. **Step CLI binary is located at `/step`**
4. **Image doesn't have Python installed** - use shell scripts instead
5. **No local files needed** - all commands work directly with the Docker image

## 📚 Next Steps

After running these basic tests:

1. **Explore Production PKI**: Check out the `production-pki/` directory
2. **Try Advanced Features**: Experiment with certificate generation
3. **Read Documentation**: Learn more about Step CLI capabilities

## 🆘 Getting Help

- **Step CLI Documentation**: https://smallstep.com/docs/step-cli
- **CleanStart Containers**: Check the main repository README

---

**Happy Certificate Management! 🔐**