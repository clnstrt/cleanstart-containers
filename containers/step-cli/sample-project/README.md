# 🔐 Step CLI - Sample Project

A simple and clean testing environment for the CleanStart Step CLI container.

## 🚀 Quick Testing

### Prerequisites
- Docker installed
- CleanStart Step CLI image available

### Step 1: Pull the Image
```bash
docker pull cleanstart/step-cli:latest-dev
```

### Alternative: Build the Image
```bash
cd containers/step-cli
docker build -t cleanstart/step-cli:latest-dev .
```

### Step 2: Run All Tests
```bash
cd containers/step-cli/sample-project
chmod +x run-all-tests.sh
./run-all-tests.sh
```

## 🧪 Individual Test Commands

### Basic Version Check
```bash
docker run --rm --entrypoint="" cleanstart/step-cli:latest-dev ./step version
```

### Main Help Test
```bash
docker run --rm --entrypoint="" cleanstart/step-cli:latest-dev ./step --help
```

### Certificate Authority Help
```bash
docker run --rm --entrypoint="" cleanstart/step-cli:latest-dev ./step ca --help
```

### Certificate Commands Help
```bash
docker run --rm --entrypoint="" cleanstart/step-cli:latest-dev ./step certificate --help
```

### OIDC Commands Help
```bash
docker run --rm --entrypoint="" cleanstart/step-cli:latest-dev ./step oidc --help
```

### Crypto Commands Help
```bash
docker run --rm --entrypoint="" cleanstart/step-cli:latest-dev ./step crypto --help
```

## 📋 Expected Output

When everything is working correctly, you should see:

```
Smallstep CLI/0.28.7 (linux/amd64)
Release Date: 2025-08-28 11:08 UTC

NAME
  step -- plumbing for distributed systems

USAGE
  step command [arguments]

COMMANDS
  certificate  manage certificates and other credentials
  ca           run a certificate authority (CA)
  oidc         OIDC provisioning
  crypto       cryptographic utilities
  ssh          SSH certificate management
  flow         OAuth and OIDC flows

OPTIONS
  --help, -h  show help
```

**Note**: The container is extremely minimal and doesn't include shell commands. The tests focus on verifying that the Step CLI binary is functional and all major command categories are available.

## 🔍 Troubleshooting

### Common Issues

**Image not found**
```bash
docker pull cleanstart/step-cli:latest-dev
```

**Command not found**
- Use `--entrypoint=""` to override the default entrypoint
- Use `./step` (the binary is in the working directory)
- **No shell available**: The container is extremely minimal and doesn't include `sh`, `bash`, or other shell commands
- Focus on direct `./step` command execution only

**Permission denied**
```bash
chmod +x run-all-tests.sh
```

## 📁 Project Structure

```
sample-project/
├── README.md                    # This documentation
└── run-all-tests.sh            # Complete test script
```

## 📚 Resources

- **Step CLI Documentation**: https://smallstep.com/docs/step-cli
- **CleanStart Containers**: Check the main repository README
- **Smallstep Official**: https://smallstep.com/

---

**Happy Certificate Management! 🔐**