# MinIO Docker Image

A high-performance object storage server compatible with Amazon S3 API. MinIO is perfect for storing files, images, documents, and any other data in a scalable and secure way.

## 🚀 Quick Start

### Option 1: Using Pre-built Image from Docker Hub
```bash
# Pull the image from Docker Hub
docker pull cleanstart/minio:latest

# Run the container
docker run -d \
  --name minio \
  -p 9000:9000 \
  -p 9001:9001 \
  -e MINIO_ROOT_USER=minioadmin \
  -e MINIO_ROOT_PASSWORD=minioadmin123 \
  cleanstart/minio:latest

# Access the web console
open http://localhost:9001
```

### Option 2: Build Locally
```bash
# Build the image locally
docker build -t minio-hello .

# Run the container
docker run -d \
  --name minio \
  -p 9000:9000 \
  -p 9001:9001 \
  -e MINIO_ROOT_USER=minioadmin \
  -e MINIO_ROOT_PASSWORD=minioadmin123 \
  minio-hello
```

### Using Docker Compose
```yaml
version: '3.8'
services:
  minio:
    image: cleanstart/minio:latest
    container_name: minio
    restart: unless-stopped
    ports:
      - "9000:9000"
      - "9001:9001"
    environment:
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: minioadmin123
    volumes:
      - minio_data:/data
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:9000/minio/health/live"]
      interval: 30s
      timeout: 10s
      retries: 3

volumes:
  minio_data:
```

## 📋 Prerequisites

- Docker installed on your system
- Basic understanding of object storage concepts
- Web browser for accessing the MinIO console

## 🛠️ Installation & Setup

### Method 1: Using Pre-built Image (Recommended for Quick Start)

1. **Ensure Docker is installed and running**
   ```bash
   docker --version
   ```

2. **Pull the image from Docker Hub**
   ```bash
   docker pull cleanstart/minio:latest
   ```

3. **Run the container with proper configuration**
   ```bash
   docker run -d \
     --name minio \
     -p 9000:9000 \
     -p 9001:9001 \
     -e MINIO_ROOT_USER=minioadmin \
     -e MINIO_ROOT_PASSWORD=minioadmin123 \
     cleanstart/minio:latest
   ```

4. **Verify the container is running**
   ```bash
   docker ps
   ```

5. **Access the web console**
   - Open your browser and go to: `http://localhost:9001`
   - Login with:
     - Username: `minioadmin`
     - Password: `minioadmin123`

### Method 2: Build and Run Locally

1. **Clone or download this repository**
   ```bash
   git clone <repository-url>
   cd cleanstart-containers
   ```

2. **Navigate to the MinIO directory**
   ```bash
   cd images/minio
   ```

3. **Build the Docker image locally**
   ```bash
   docker build -t minio-hello .
   ```

4. **Run the container**
   ```bash
   docker run -d \
     --name minio \
     -p 9000:9000 \
     -p 9001:9001 \
     -e MINIO_ROOT_USER=minioadmin \
     -e MINIO_ROOT_PASSWORD=minioadmin123 \
     minio-hello
   ```

### Method 3: Using Sample Projects

1. **Navigate to sample projects**
   ```bash
   cd images/minio/sample-project
   ```

2. **Choose an example to test:**
   - **Basic Storage:** `cd basic-storage`
   - **File Upload App:** `cd file-upload-app`
   - **Backup System:** `cd backup-system`

3. **Run the example**
   ```bash
   # For basic storage
   docker-compose up -d
   
   # For file upload app
   docker-compose -f docker-compose.upload.yml up -d
   
   # For backup system
   docker-compose -f docker-compose.backup.yml up -d
   ```

## 🧪 Testing & Verification

### Quick Test Commands
```bash
# Test if container is running
docker ps | grep minio

# Test API endpoint
curl -I http://localhost:9000/minio/health/live

# Test web console
curl -I http://localhost:9001

# Check container logs
docker logs minio
```

### Expected Results
- **HTTP Status:** 200 OK for health check
- **Web Console:** Accessible at http://localhost:9001
- **API Server:** Running on port 9000
- **Login:** minioadmin/minioadmin123

### Step-by-Step Testing Instructions

#### 1. Pull the MinIO Image
```bash
# Pull the MinIO image from Docker Hub
docker pull cleanstart/minio:latest
```

#### 2. Start the Container
```bash
# Run the container with proper configuration
docker run -d \
  --name minio \
  -p 9000:9000 \
  -p 9001:9001 \
  -e MINIO_ROOT_USER=minioadmin \
  -e MINIO_ROOT_PASSWORD=minioadmin123 \
  cleanstart/minio:latest
```

#### 3. Verify Container Status
```bash
# Check if container is running
docker ps

# Expected output should show:
# minio    Up X minutes (healthy)    0.0.0.0:9000->9000/tcp, 0.0.0.0:9001->9001/tcp
```

#### 4. Test Web Interfaces

**Test MinIO Web Console:**
```bash
# Using curl (Linux/macOS)
curl -I http://localhost:9001

# Using PowerShell (Windows)
Invoke-WebRequest -Uri "http://localhost:9001" -Method Head

# Expected result: HTTP/1.1 200 OK
```

**Test MinIO API:**
```bash
# Using curl (Linux/macOS)
curl -I http://localhost:9000/minio/health/live

# Using PowerShell (Windows)
Invoke-WebRequest -Uri "http://localhost:9000/minio/health/live" -Method Head

# Expected result: HTTP/1.1 200 OK
```

#### 5. Access Web Console
- **MinIO Console**: http://localhost:9001
- **Login Credentials**: minioadmin / minioadmin123

**What to do in the console:**
1. Create a new bucket (e.g., "my-files")
2. Upload a test file
3. Browse the uploaded file
4. Download the file
5. Delete the file

#### 6. Cleanup After Testing
```bash
# Stop and remove the container
docker stop minio
docker rm minio
```

## 🚀 Complete Sample Project Testing Guide

### Prerequisites for Testing
```bash
# Ensure Docker and Docker Compose are installed
docker --version
docker-compose --version

# Pull the MinIO image from Docker Hub
docker pull cleanstart/minio:latest
```

### Step-by-Step Testing Instructions

#### 1. Navigate to Sample Project
```bash
# Navigate to the basic storage example
cd images/minio/sample-project/basic-storage
```

#### 2. Start the Sample Project
```bash
# Start all containers in detached mode
docker-compose up -d

# Verify all containers are running
docker ps
```

#### 3. Test Container Status
```bash
# Check if all containers are healthy
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Expected output should show:
# minio-basic     Up X minutes (healthy)     0.0.0.0:9000->9000/tcp, 0.0.0.0:9001->9001/tcp
```

#### 4. Test Web Interfaces

**Test MinIO Web Console:**
```bash
# Using curl (Linux/macOS)
curl -I http://localhost:9001

# Using PowerShell (Windows)
Invoke-WebRequest -Uri "http://localhost:9001" -Method Head

# Expected result: HTTP/1.1 200 OK
```

**Test MinIO API:**
```bash
# Using curl (Linux/macOS)
curl -I http://localhost:9000/minio/health/live

# Using PowerShell (Windows)
Invoke-WebRequest -Uri "http://localhost:9000/minio/health/live" -Method Head

# Expected result: HTTP/1.1 200 OK
```

#### 5. Access Web Console
- **MinIO Console**: http://localhost:9001
- **Login Credentials**: minioadmin / minioadmin123

**What to do in the console:**
1. Create a new bucket (e.g., "my-files")
2. Upload a test file
3. Browse the uploaded file
4. Download the file
5. Delete the file

#### 6. Test Different Sample Projects

**File Upload Application:**
```bash
cd ../file-upload-app
docker-compose up -d
# Access at: http://localhost:8080
```

**Backup System:**
```bash
cd ../backup-system
docker-compose up -d
# Access MinIO at: http://localhost:9001
# Access backup app at: http://localhost:8080
```

#### 7. Cleanup After Testing
```bash
# Stop and remove containers
docker-compose down

# Remove all related containers and networks
docker-compose down --volumes --remove-orphans

# Verify cleanup
docker ps | grep minio
```

### Troubleshooting Testing Issues

**Port Conflicts:**
```bash
# If port 9000 or 9001 is already in use, check what's using it
netstat -tulpn | grep :9000
netstat -tulpn | grep :9001

# Stop conflicting containers
docker stop <container-name>

# Or modify docker-compose.yml to use different ports
```

**Container Won't Start:**
```bash
# Check detailed logs
docker-compose logs

# Check individual container logs
docker logs minio-basic

# Verify Docker daemon is running
docker info
```

**Permission Issues:**
```bash
# On Linux, ensure Docker socket permissions
sudo chmod 666 /var/run/docker.sock

# Or add user to docker group
sudo usermod -aG docker $USER
```

**Web Console Not Accessible:**
```bash
# Check if containers are running
docker ps

# Test connectivity from inside container
docker exec minio-basic curl -f http://localhost:9001

# Check firewall settings
sudo ufw status
```

### Expected Test Results

**✅ Successful Test Indicators:**
- MinIO container shows "Up" status with "(healthy)"
- Web console returns HTTP 200 OK
- API health check returns HTTP 200 OK
- Can login to web console with minioadmin/minioadmin123
- Can create buckets and upload files
- Can browse and download uploaded files

**❌ Common Issues to Watch For:**
- Port conflicts (containers won't start)
- Permission denied errors (Docker socket access)
- Network connectivity issues (web console not accessible)
- Resource constraints (containers fail to start)
- Volume mount issues (data persistence problems)

## 🎯 What You'll Learn

- **Object Storage**: Understanding file storage in the cloud
- **S3 Compatibility**: Working with Amazon S3 API
- **File Management**: Upload, download, and organize files
- **Web Interfaces**: Using web-based file management
- **API Integration**: Programmatic access to storage
- **Docker Best Practices**: Containerized storage solutions

## 🔧 Key Features

### Core Functionality
- **S3-Compatible API**: Works with existing S3 tools and libraries
- **Web Console**: User-friendly web interface for file management
- **Multi-tenant Support**: Multiple users and access control
- **Versioning**: File version control and history
- **Encryption**: Data encryption at rest and in transit
- **High Performance**: Optimized for speed and scalability

### Storage Capabilities
- **Unlimited Storage**: Scale as needed
- **Any File Type**: Store images, documents, videos, etc.
- **Metadata Support**: Custom file attributes
- **Access Control**: Fine-grained permissions
- **Lifecycle Management**: Automatic file retention policies
- **Replication**: Data redundancy and backup

### Integration Features
- **REST API**: Full RESTful API access
- **SDK Support**: Multiple programming language SDKs
- **CLI Tools**: Command-line interface
- **Webhooks**: Event-driven notifications
- **Monitoring**: Built-in metrics and monitoring
- **Multi-cloud**: Deploy anywhere

## 📁 Project Structure

```
images/minio/
├── Dockerfile              # Main Dockerfile for MinIO setup
├── hello_world.py          # Python script demonstrating storage concepts
├── README.md              # This file
└── sample-project/        # Advanced examples and tutorials
    ├── basic-storage/     # Basic MinIO setup and usage
    ├── file-upload-app/   # Web application for file uploads
    ├── backup-system/     # Automated backup solution
    ├── setup.sh          # Linux/macOS setup script
    └── setup.bat         # Windows setup script
```

## 🐳 Docker Hub Integration

### Available Images
- **`cleanstart/minio:latest`** - Latest stable version
- **`cleanstart/minio:v2024`** - Specific version tag

### Pull and Run Commands
```bash
# Pull the latest image
docker pull cleanstart/minio:latest

# Run with basic configuration
docker run -d -p 9000:9000 -p 9001:9001 --name minio cleanstart/minio:latest

# Run with custom credentials
docker run -d \
  --name minio \
  -p 9000:9000 \
  -p 9001:9001 \
  -e MINIO_ROOT_USER=myuser \
  -e MINIO_ROOT_PASSWORD=mypassword123 \
  cleanstart/minio:latest
```

### Docker Compose Example
```yaml
version: '3.8'
services:
  minio:
    image: cleanstart/minio:latest
    container_name: minio
    restart: unless-stopped
    ports:
      - "9000:9000"
      - "9001:9001"
    environment:
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: minioadmin123
    volumes:
      - minio_data:/data
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:9000/minio/health/live"]
      interval: 30s
      timeout: 10s
      retries: 3

volumes:
  minio_data:
```

## 🎓 Learning Path

### Beginner Level
1. **Start with basic setup** - Run MinIO and explore the web console
2. **Understand buckets** - Learn about organizing files
3. **Upload and download** - Basic file operations

### Intermediate Level
1. **API integration** - Use MinIO with programming languages
2. **Access control** - Manage users and permissions
3. **Advanced features** - Versioning, encryption, lifecycle

### Advanced Level
1. **Production deployment** - Set up for production use
2. **Integration with applications** - Connect with web apps
3. **Monitoring and optimization** - Performance tuning

## 🔍 Comparison with Other Storage Solutions

| Feature | MinIO | AWS S3 | Google Cloud Storage | Azure Blob |
|---------|-------|--------|---------------------|------------|
| **Deployment** | Self-hosted | Cloud | Cloud | Cloud |
| **Cost** | Free | Pay-per-use | Pay-per-use | Pay-per-use |
| **S3 Compatibility** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Performance** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Setup Complexity** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Control** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |

## 📚 Common Use Cases

### 1. File Storage for Applications
```bash
# Store user uploads, documents, images
docker run -d \
  --name minio-app \
  -p 9000:9000 \
  -p 9001:9001 \
  -v app_data:/data \
  cleanstart/minio:latest
```

### 2. Backup Storage
```yaml
# docker-compose.backup.yml
version: '3.8'
services:
  minio:
    image: cleanstart/minio:latest
    ports:
      - "9000:9000"
      - "9001:9001"
    volumes:
      - backup_data:/data
    environment:
      MINIO_ROOT_USER: backupuser
      MINIO_ROOT_PASSWORD: securepassword123
```

### 3. Static Website Hosting
```bash
# Host static websites
docker run -d \
  --name minio-web \
  -p 9000:9000 \
  -p 9001:9001 \
  -v website_data:/data \
  cleanstart/minio:latest
```

## 🛡️ Security Best Practices

1. **Change default credentials** - Use strong passwords
2. **Use HTTPS** - Enable SSL/TLS encryption
3. **Access control** - Implement proper user permissions
4. **Network security** - Use firewalls and VPNs
5. **Regular updates** - Keep MinIO updated
6. **Backup strategy** - Regular data backups

## 🔧 Troubleshooting

### Common Issues

**Container won't start**
```bash
# Check container logs
docker logs minio

# Check if ports are available
netstat -tulpn | grep :9000
netstat -tulpn | grep :9001

# Check volume permissions
ls -la /path/to/minio/data
```

**Cannot access web console**
```bash
# Check if container is running
docker ps | grep minio

# Test connectivity
curl -v http://localhost:9001

# Check firewall settings
sudo ufw status
```

**Permission denied errors**
```bash
# Run with proper permissions
docker run -d \
  --name minio \
  -p 9000:9000 \
  -p 9001:9001 \
  --user root \
  cleanstart/minio:latest
```

**Data persistence issues**
```bash
# Use named volumes
docker run -d \
  --name minio \
  -p 9000:9000 \
  -p 9001:9001 \
  -v minio_data:/data \
  cleanstart/minio:latest
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.

## 🆘 Support

If you encounter any issues or have questions:

1. Check the troubleshooting section above
2. Review the MinIO documentation
3. Open an issue in the repository
4. Join our community discussions

---

**Happy Storing! 📦**
