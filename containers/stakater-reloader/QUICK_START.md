# Stakater Reloader Quick Start Guide

This guide will help you quickly test and run the Stakater Reloader container.

## Prerequisites

- Docker installed and running
- Docker Compose (optional, for easier management)

## Quick Test

### Option 1: Using the Test Script (Linux/macOS)
```bash
# Make the script executable and run it
chmod +x test-reloader.sh
./test-reloader.sh
```

### Option 2: Using PowerShell (Windows)
```powershell
# Run the PowerShell test script
.\test-reloader.ps1
```

### Option 3: Manual Testing

#### 1. Test the container directly
```bash
# Run with help command
docker run --rm cleanstart/stakater-reloader:latest /usr/bin/Reloader --help

# Run with version command
docker run --rm cleanstart/stakater-reloader:latest /usr/bin/Reloader --version
```

#### 2. Run interactively
```bash
# Start an interactive session
docker run --rm -it cleanstart/stakater-reloader:latest /bin/sh
```

#### 3. Using Docker Compose
```bash
# Start the container with docker-compose
docker-compose up stakater-reloader

# Start interactive mode
docker-compose up stakater-reloader-interactive
```

## Expected Output

When you run the container, you should see output similar to:

```
Stakater Reloader v1.0.0

Usage:
  Reloader [flags]

Flags:
  -h, --help                    help for Reloader
      --log-format string       Log format (text/json) (default "text")
      --log-level string        Log level (default "info")
      --version                 version for Reloader
```

## What This Container Does

The Stakater Reloader is a Kubernetes controller that watches for changes in ConfigMaps and Secrets and automatically restarts the associated pods. This is useful for:

- **Configuration Management**: Automatically restart pods when configuration changes
- **Secret Rotation**: Restart pods when secrets are updated
- **Zero-Downtime Deployments**: Ensure pods pick up new configurations

## Sample Kubernetes Resources

The container includes sample Kubernetes resources in the `sample-project/` directory:

- `hello_world.yaml` - Complete example with ConfigMap, Deployment, and Service
- `basic-policies/` - Various policy examples for different scenarios

## Next Steps

1. **Deploy to Kubernetes**: Use the sample YAML files to deploy Reloader to your cluster
2. **Configure Monitoring**: Set up monitoring for the Reloader controller
3. **Customize Policies**: Modify the sample policies for your specific use cases

## Troubleshooting

### Container won't start
- Check if Docker is running: `docker info`
- Verify the image exists: `docker images | grep stakater-reloader`

### Permission issues
- The container runs as a non-root user (`clnstrt`)
- Ensure proper file permissions for mounted volumes

### Network issues
- The container exposes port 8080 by default
- Check firewall settings if accessing from outside the container

## Support

- **CleanStart Website**: https://www.cleanstart.com
- **Stakater Reloader GitHub**: https://github.com/stakater/Reloader
- **Documentation**: Check the `README.md` files in the sample-project directory
