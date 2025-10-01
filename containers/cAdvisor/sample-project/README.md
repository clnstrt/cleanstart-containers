# Basic Container Monitoring with cAdvisor

This example demonstrates basic container monitoring using cAdvisor. It includes cAdvisor and several test containers to monitor different types of resource usage.

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Basic understanding of container monitoring

### Running the Example

2. **Access cAdvisor Web UI**
   - Open your browser and go to: `http://localhost:8080`
   - You'll see the cAdvisor dashboard with all running containers

3. **Test the monitored applications**
   - **Nginx Test App**: `http://localhost:8080`
   - **CPU Test**: Running in background (check logs with `docker logs cpu-test-basic`)
   - **Memory Test**: Running in background (check logs with `docker logs memory-test-basic`)

## 🧪 Complete Testing Guide

### Prerequisites for Testing
```bash
docker pull cleanstart/cadvisor:latest
```

### Step-by-Step Testing Instructions

#### 1. Start the Sample Project
# Navigate to the basic monitoring directory
```bash
cd images/cAdvisor/sample-project
```

# Build the dockerfile
```bash
docker build -t cadvisor-sample-project .   
```
# Run the dockerfile
```bash
docker run -d -p 8080:8080 cadvisor-sample-project
```
# Verify the container is running
```bash
docker ps
```
Access web application UI of cAdvisor at http://localhost:8080
---

**Happy Monitoring! 📊**
