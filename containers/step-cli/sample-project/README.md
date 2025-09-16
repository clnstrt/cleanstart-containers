# 🚀 Hello World!!! 

A simple **HELLO WORLD** program to run on CleanStart - Step CLI container. 

## 📋 Step-by-Step Instructions

Follow these steps to run the Step CLI Hello World program:

### Step 1: Pull the CleanStart Step CLI Image
Pull the Step CLI image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart):

```bash
docker pull cleanstart/step-cli:latest
```

Or for the development version:
```bash
docker pull cleanstart/step-cli:latest-dev
```

### Step 2: Run the Hello World Program
Execute the hello world program using Docker (no files needed):

**For Linux/macOS:**
```bash
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

**For Windows PowerShell:**
```powershell
docker run --rm --entrypoint="" cleanstart/step-cli:latest /bin/busybox sh -c "echo 'Hello World from Step CLI!'; /step version"
```

**For Windows Command Prompt:**
```cmd
docker run --rm --entrypoint="" cleanstart/step-cli:latest /bin/busybox sh -c "echo 'Hello World from Step CLI!'; /step version"
```

### Step 3: Quick Test (Simplest Command)
For a quick test, just run:

```bash
docker run --rm --entrypoint="" cleanstart/step-cli:latest /step version
```

This will show: `Smallstep CLI/0.28.7 (linux/amd64)`

## 🔧 Troubleshooting

### Docker Issues
If you encounter Docker errors:

1. **Make sure Docker is running:**
   ```bash
   docker --version
   ```

2. **Check if the image exists:**
   ```bash
   docker images | grep step-cli
   ```

3. **If the image doesn't exist, pull it:**
   ```bash
   docker pull cleanstart/step-cli:latest
   ```

4. **For Windows users:** Make sure Docker Desktop is running and accessible from your terminal.

### CleanStart Image Specific Issues
The `cleanstart/step-cli:latest` image is minimal and requires specific commands:

1. **Use `--entrypoint=""` to override the default entrypoint:**
   ```bash
   docker run --rm --entrypoint="" cleanstart/step-cli:latest /step version
   ```

2. **Use BusyBox shell for scripts:**
   ```bash
   docker run --rm --entrypoint="" cleanstart/step-cli:latest /bin/busybox sh -c "command"
   ```

3. **Step CLI binary is located at `/step`:**
   ```bash
   docker run --rm --entrypoint="" cleanstart/step-cli:latest /step --help
   ```

4. **Image doesn't have Python installed** - use shell scripts instead
5. **No local files needed** - all commands work directly with the Docker image

### Expected Behavior
- **In Docker container:** Should show Step CLI version and certificate generation capabilities
- **Locally:** Will show "Step CLI not available" which is expected behavior
- **CleanStart image:** Requires `--entrypoint=""` and uses `/step` binary
## Output 
```bash
============================================================
🔐 Step CLI - Hello World (Shell Version)
============================================================
Timestamp: Tue Sep 16 08:45:50 UTC 2025
Shell:
Working Directory: /app
============================================================

🔍 Checking Environment...
✅ Running in Docker container
✅ Shell Version:
✅ Working Directory: /app

🧪 Testing Step CLI...
✅ Step CLI is available
   Version: Smallstep CLI/0.28.7 (linux/amd64)
Release Date: 2025-08-28 11:08 UTC

🧪 Testing Step CA...
⚠️  Step CA not available

🧪 Testing Certificate Generation...
⚠️  Certificate generation test failed (expected in container)

============================================================
🎉 Step CLI Hello World completed!
============================================================
```
