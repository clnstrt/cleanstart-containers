# 🔐 Step CLI - Sample Project

A simple and clean testing environment for the CleanStart Step CLI container.

## 🚀 Quick Testing

### Prerequisites
- Docker installed
- CleanStart Step CLI image available

### Step 1: Verify Your Image
First, let's inspect your built image to confirm it's ready for testing:

```bash
# Inspect the image metadata
docker inspect cleanstart/step-cli:latest-dev

# Check image size and layers
docker images cleanstart/step-cli:latest-dev

# Verify the image exists locally
docker image ls | grep step-cli
```

### Step 2: Pull the Image (if needed)
```bash
docker pull cleanstart/step-cli:latest-dev
```

### Alternative: Build the Image
```bash
cd containers/step-cli
docker build -t cleanstart/step-cli:latest-dev .
```

### Step 3: Run Simple Tests
```bash
cd containers/step-cli/sample-project
chmod +x simple-test.sh
./simple-test.sh
```

### Step 4: Run Complete Test Suite
```bash
chmod +x run-all-tests.sh
./run-all-tests.sh
```

## 🔍 Image Validation

### Verify Image Metadata
Based on your docker inspect output, your image should have these characteristics:

```bash
# Check image details
docker inspect cleanstart/step-cli:latest-dev | jq '.[0] | {
  Id: .Id,
  RepoTags: .RepoTags,
  Architecture: .Architecture,
  Os: .Os,
  Size: .Size,
  User: .Config.User,
  WorkingDir: .Config.WorkingDir,
  Entrypoint: .Config.Entrypoint,
  Cmd: .Config.Cmd
}'
```

**Expected Values:**
- **Architecture**: `amd64`
- **OS**: `linux`
- **User**: `clnstrt` (non-root user)
- **Entrypoint**: `["./step"]`
- **Default Cmd**: `["--help"]`
- **Size**: ~453MB (may vary)

### Verify Image Labels
```bash
docker inspect cleanstart/step-cli:latest-dev | jq '.[0].Config.Labels'
```

**Expected Labels:**
- `Cleanstart.main.package`: `step-cli`
- `org.opencontainers.image.authors`: `Cleanstart Team https://www.cleanstart.com/`
- `org.opencontainers.image.vendor`: `Cleanstart`

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

### OIDC Commands Help (Note: May not be available in all builds)
```bash
docker run --rm --entrypoint="" cleanstart/step-cli:latest-dev ./step oidc --help
```
**Note**: OIDC support may not be available in minimal builds. This is expected behavior.

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
├── simple-test.sh              # Quick validation script
└── run-all-tests.sh            # Complete test script
```

## 🚀 Quick Start Testing

For the fastest way to test your image:

```bash
# Make scripts executable
chmod +x simple-test.sh run-all-tests.sh

# Run simple validation (recommended first)
./simple-test.sh

# Run comprehensive tests
./run-all-tests.sh
```

The `simple-test.sh` script provides:
- ✅ Image existence verification
- ✅ Metadata inspection
- ✅ Basic functionality tests
- ✅ Non-root user validation
- ✅ Quick pass/fail results

## 📚 Resources

- **Step CLI Documentation**: https://smallstep.com/docs/step-cli
- **CleanStart Containers**: Check the main repository README
- **Smallstep Official**: https://smallstep.com/

---

**Happy Certificate Management! 🔐**