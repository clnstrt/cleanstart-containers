# 🔐 Step CLI - Basic PKI Example

A simple example demonstrating fundamental PKI operations and certificate management using Step CLI with CleanStart containers.

## 🎯 What This Example Demonstrates

- **Certificate Generation**: Create various types of certificates
- **CA Setup**: Initialize and configure a local Certificate Authority
- **Certificate Management**: Basic certificate operations and validation
- **Certificate Inspection**: Tools for examining and validating certificates
- **Simple Operations**: Easy-to-follow certificate tasks

## 🚀 Quick Start

### Prerequisites

- Docker installed
- CleanStart Step CLI image available (`cleanstart/step-cli:latest`)

### Step 1: Pull CleanStart Step CLI Image

```bash
# Pull the latest CleanStart Step CLI image
docker pull cleanstart/step-cli:latest
```

**Why this command?** This ensures you have the latest CleanStart Step CLI image locally before running PKI operations.

### Step 2: Test Basic Step CLI Functionality

#### Test 1: Check Step CLI Version

```bash
# Quick test to verify Step CLI is working
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step version
```

**Why this command?** Verifies that Step CLI is properly installed and accessible in the CleanStart container.

#### Test 2: Check Available Commands

```bash
# Check Step CLI help
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step --help
```

**Why this command?** Shows all available Step CLI commands and options for PKI operations.

#### Test 3: Check Certificate Commands

```bash
# Check certificate command help
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step certificate --help
```

**Why this command?** Provides detailed information about certificate management commands.

#### Test 4: Check CA Commands

```bash
# Check CA command help
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step ca --help
```

**Why this command?** Shows Certificate Authority management commands and options.

### Step 3: Test Basic PKI Operations

#### Test 5: Initialize a Certificate Authority

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

#### Test 6: Inspect Certificates

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

#### Test 7: Get Certificate Fingerprints

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

**Why this command?** Shows how to get certificate fingerprints, useful for certificate verification and trust establishment.

### Step 4: Test Certificate Generation

#### Test 8: Generate Self-Signed Certificate

```bash
# Generate a self-signed certificate

docker run --rm --entrypoint="" cleanstart/step-cli:latest /bin/busybox sh -c '
echo "📜 Generating Self-Signed Certificate..."
/step certificate create "test.local" /tmp/test.crt /tmp/test.key --profile self-signed --subtle --no-password --insecure
echo "✅ Self-signed certificate generated!"
echo "Certificate details:"
/step certificate inspect /tmp/test.crt
'
```

**Why this command?** Demonstrates basic certificate generation without requiring a CA setup.

#### Test 9: Generate Certificate with SANs

```bash
# Generate a certificate with multiple SANs

docker run --rm --entrypoint="" cleanstart/step-cli:latest /bin/busybox sh -c '
echo "🌐 Generating Certificate with SANs..."
/step certificate create "example.com" /tmp/example.crt /tmp/example.key \
  --san example.com --san www.example.com --san api.example.com \
  --profile self-signed --subtle --no-password --insecure
echo "✅ Certificate with SANs generated!"
echo "Certificate details:"
/step certificate inspect /tmp/example.crt
'
```

**Why this command?** Shows how to create certificates with multiple Subject Alternative Names (SANs) for different domains.

## 📋 Expected Output

When you run these tests, you should see output similar to:

```
Smallstep CLI/0.28.7 (linux/amd64)
Release Date: 2025-08-28 11:08 UTC

🏭 Initializing Certificate Authority...
✅ CA initialized successfully!
Root certificate fingerprint: 0d7d3834cf187726cf331c40a31aa7ef6b29ba4df601416c9788f6ee01058cf3

🔍 Inspecting Certificates...
Root Certificate Details:
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 1234567890 (0x499602d2)
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN=Test CA
        Validity
            Not Before: Sep 17 15:30:45 2025 GMT
            Not After : Sep 17 15:30:45 2026 GMT
        Subject: CN=Test CA
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

## 📈 Understanding PKI Concepts

### Certificate Types

| Type | Description | Use Case |
|------|-------------|----------|
| **Self-Signed Certificate** | Certificate signed by itself | Testing, development |
| **CA Certificate** | Certificate from Certificate Authority | Production, trust chain |
| **Server Certificate** | For web servers and services | HTTPS, TLS connections |
| **Client Certificate** | For client authentication | Mutual TLS, API authentication |

### Key Operations

| Operation | Description | Command Example |
|-----------|-------------|-----------------|
| **Generate** | Create new certificates | `step certificate create` |
| **Inspect** | Examine certificate details | `step certificate inspect` |
| **Fingerprint** | Get certificate fingerprint | `step certificate fingerprint` |
| **Verify** | Validate certificate chain | `step certificate verify` |

## 🚀 Next Steps

After mastering these basic PKI operations:

1. **Try Advanced Features**: Experiment with certificate policies and constraints
2. **Explore Production Setup**: Learn about production CA configurations
3. **Read Documentation**: Learn more about Step CLI capabilities
4. **Build Your Own**: Create custom certificate management workflows

## 📚 Resources

- **Step CLI Documentation**: https://smallstep.com/docs/step-cli
- **CleanStart Containers**: Check the main repository README
- **Smallstep Official**: https://smallstep.com/

---

**Happy Certificate Management! 🔐**