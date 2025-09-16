# 🏭 Step CLI - Production PKI Example

A production-ready PKI setup demonstrating enterprise-grade certificate management with Step CLI using the CleanStart container.

## 🚀 Quick Start

### Prerequisites

- Docker installed
- CleanStart Step CLI image available (`cleanstart/step-cli:latest`)

### Step 1: Pull the CleanStart Step CLI Image

```bash
# Pull the latest CleanStart Step CLI image
docker pull cleanstart/step-cli:latest
```

### Step 2: Test Production PKI Features

#### Test 1: Complete Production PKI Test

```bash
# Run comprehensive production PKI test
docker run --rm --entrypoint="" cleanstart/step-cli:latest /bin/busybox sh -c '
echo "🏭 Complete Production PKI Test"
echo "============================================================"
echo "Timestamp: $(date)"
echo "============================================================"
echo ""
echo "1️⃣ CA Initialization..."
cd /tmp
echo "password" > password.txt
/step ca init --name "Production CA" --dns "localhost" --address ":8443" --provisioner "admin" --password-file password.txt --pki
echo ""
echo "2️⃣ Root Certificate..."
/step certificate inspect /home/clnstrt/.step/certs/root_ca.crt | head -5
echo ""
echo "3️⃣ Intermediate Certificate..."
/step certificate inspect /home/clnstrt/.step/certs/intermediate_ca.crt | head -5
echo ""
echo "4️⃣ Certificate Fingerprints..."
echo "Root: $(/step certificate fingerprint /home/clnstrt/.step/certs/root_ca.crt)"
echo "Intermediate: $(/step certificate fingerprint /home/clnstrt/.step/certs/intermediate_ca.crt)"
echo ""
echo "5️⃣ Step CLI Version..."
/step version
echo ""
echo "============================================================"
echo "🎉 Complete Production PKI Test completed!"
echo "============================================================"
'
```

#### Test 2: Certificate Generation Test

```bash
# Test different certificate types
docker run --rm --entrypoint="" cleanstart/step-cli:latest /bin/busybox sh -c '
echo "🔐 Certificate Generation Test"
echo "============================================================"
echo "Timestamp: $(date)"
echo "============================================================"
echo ""
echo "1️⃣ Initializing CA..."
cd /tmp
echo "password" > password.txt
/step ca init --name "Test CA" --dns "localhost" --address ":8443" --provisioner "admin" --password-file password.txt --pki
echo ""
echo "2️⃣ Testing RSA Certificate..."
/step certificate create --kty RSA --size 2048 --ca /home/clnstrt/.step/certs/intermediate_ca.crt --ca-key /home/clnstrt/.step/secrets/intermediate_ca_key --no-password --insecure "rsa.example.com" rsa.crt rsa.key
echo ""
echo "3️⃣ Testing EC Certificate..."
/step certificate create --kty EC --curve P-256 --ca /home/clnstrt/.step/certs/intermediate_ca.crt --ca-key /home/clnstrt/.step/secrets/intermediate_ca_key --no-password --insecure "ec.example.com" ec.crt ec.key
echo ""
echo "4️⃣ Listing Generated Certificates..."
ls -la *.crt *.key
echo ""
echo "============================================================"
echo "🎉 Certificate Generation Test completed!"
echo "============================================================"
'
```

#### Test 3: Advanced Features Test

```bash
# Test advanced certificate features
docker run --rm --entrypoint="" cleanstart/step-cli:latest /bin/busybox sh -c '
echo "🔍 Advanced Features Test"
echo "============================================================"
echo "Timestamp: $(date)"
echo "============================================================"
echo ""
echo "1️⃣ Initializing CA for Advanced Tests..."
cd /tmp
echo "password" > password.txt
/step ca init --name "Advanced Test CA" --dns "localhost" --address ":8443" --provisioner "admin" --password-file password.txt --pki
echo ""
echo "2️⃣ Testing Root Certificate Inspection..."
/step certificate inspect /home/clnstrt/.step/certs/root_ca.crt | head -15
echo ""
echo "3️⃣ Testing Intermediate Certificate Inspection..."
/step certificate inspect /home/clnstrt/.step/certs/intermediate_ca.crt | head -15
echo ""
echo "4️⃣ Testing Root Certificate Fingerprint..."
/step certificate fingerprint /home/clnstrt/.step/certs/root_ca.crt
echo ""
echo "5️⃣ Testing Intermediate Certificate Fingerprint..."
/step certificate fingerprint /home/clnstrt/.step/certs/intermediate_ca.crt
echo ""
echo "============================================================"
echo "🎉 Advanced Features Test completed!"
echo "============================================================"
'
```

### Step 3: Test Production Help System

#### Test 4: Step CLI Help

```bash
# Check Step CLI help
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step --help
```

#### Test 5: Certificate Help

```bash
# Check certificate command help
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step certificate --help
```

#### Test 6: CA Help

```bash
# Check CA command help
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step ca --help
```

#### Test 7: Certificate Inspect Help

```bash
# Check certificate inspect help
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step certificate inspect --help
```

#### Test 8: Certificate Fingerprint Help

```bash
# Check certificate fingerprint help
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step certificate fingerprint --help
```

## 📋 Expected Output

When you run these tests, you should see output similar to:

```
🏭 Complete Production PKI Test
============================================================
Timestamp: Mon Sep 16 17:30:45 UTC 2025
============================================================

1️⃣ CA Initialization...

Generating root certificate... done!
Generating intermediate certificate... done!

✔ Root certificate: /home/clnstrt/.step/certs/root_ca.crt
✔ Root private key: /home/clnstrt/.step/secrets/root_ca_key
✔ Root fingerprint: 1723f595f00bf2406439c6141ec02f3576f3acc42eea2765b81eeb478d98c0bc
✔ Intermediate certificate: /home/clnstrt/.step/certs/intermediate_ca.crt
✔ Intermediate private key: /home/clnstrt/.step/secrets/intermediate_ca_key

2️⃣ Root Certificate...
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 144665024605743293622190618056157509210
    Signature Algorithm: ECDSA-SHA256

3️⃣ Intermediate Certificate...
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 115633024850501358483509748893554950825
    Signature Algorithm: ECDSA-SHA256

4️⃣ Certificate Fingerprints...
Root: 1723f595f00bf2406439c6141ec02f3576f3acc42eea2765b81eeb478d98c0bc
Intermediate: 94ca3db744ba0993f046bfa88140ee596ec3272bdeef02e07e804ed3f949029a

5️⃣ Step CLI Version...
Smallstep CLI/0.28.7 (linux/amd64)
Release Date: 2025-08-28 11:08 UTC

============================================================
🎉 Complete Production PKI Test completed!
============================================================
```

## 🔍 Troubleshooting

### Common Issues

**CA initialization fails**
```bash
# Check Step CLI version
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step version

# Test basic CA init
docker run --rm --entrypoint="" cleanstart/step-cli:latest /bin/busybox sh -c '
cd /tmp
echo "password" > password.txt
/step ca init --name "Test CA" --dns "localhost" --address ":8443" --provisioner "admin" --password-file password.txt --pki
echo "CA initialization successful!"
'
```

**Certificate generation fails**
```bash
# Test certificate creation with no-password flag
docker run --rm --entrypoint="" cleanstart/step-cli:latest /bin/busybox sh -c '
cd /tmp
echo "password" > password.txt
/step ca init --name "Test CA" --dns "localhost" --address ":8443" --provisioner "admin" --password-file password.txt --pki
/step certificate create test-cert test.crt test.key --template "{\"subject\":{\"commonName\":\"test.example.com\"}}" --ca /home/clnstrt/.step/certs/intermediate_ca.crt --ca-key /home/clnstrt/.step/secrets/intermediate_ca_key --no-password --insecure
echo "Certificate generation successful!"
ls -la test.*
'
```

**Permission issues**
```bash
# Use writable directory
docker run --rm --entrypoint="" cleanstart/step-cli:latest /bin/busybox sh -c '
cd /tmp
echo "Using /tmp directory for writable access"
echo "password" > password.txt
/step ca init --name "Test CA" --dns "localhost" --address ":8443" --provisioner "admin" --password-file password.txt --pki
echo "CA initialized in /tmp successfully!"
'
```

### Debug Commands

```bash
# Check Step CLI help
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step --help

# Check CA help
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step ca --help

# Check certificate help
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step certificate --help

# Test basic functionality
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step version
```

## 📚 Next Steps

After mastering this production setup:

1. **Try Basic PKI**: Start with simple certificate generation
2. **Explore Advanced Features**: Use custom templates and profiles
3. **Implement Security**: Use production-grade key sizes and algorithms
4. **Scale Operations**: Implement automated certificate management

## 🧹 Cleanup

```bash
# No cleanup needed - all operations are containerized
# Each test runs in isolated containers
# No persistent data or cleanup required
```

---

**Happy Production Certificate Management! 🏭**