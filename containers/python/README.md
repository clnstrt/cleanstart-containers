# Python Hello World Application

A minimal Python application using the `cleanstart/python:latest-dev` base image.

## Files

- `Dockerfile` - Container configuration
- `app.py` - Simple hello world Python application
- `requirements.txt` - Python dependencies (currently empty)

## Quick Start

### Step 1: Navigate to the project directory
```bash
cd /path/to/cleanstart-containers/containers/python
```

### Step 2: Build the Docker image
```bash
docker build -t python-hello .
```

### Step 3: Run the application
```bash
docker run python-hello
```

### Expected output
```
Hello, World!
Welcome to Python with cleanstart/python:latest-dev
This is a minimal Python application running in Docker
```

## Adding Dependencies

### Step 1: Edit requirements.txt
Add your Python packages to `requirements.txt`:
```bash
echo "requests==2.31.0" >> requirements.txt
echo "flask==2.3.3" >> requirements.txt
```

### Step 2: Rebuild the image
```bash
docker build -t python-hello .
```

### Step 3: Run with new dependencies
```bash
docker run python-hello
```

## Development Mode

For development with live code changes:

### Step 1: Run with volume mount
```bash
docker run -v $(pwd):/app python-hello
```

This mounts your current directory into the container, so changes to your code are reflected immediately.

## Troubleshooting

- **Permission issues**: Make sure Docker is running and you have proper permissions
- **Build fails**: Check that you're in the correct directory with Dockerfile
- **Container won't start**: Verify the base image `cleanstart/python:latest-dev` is available