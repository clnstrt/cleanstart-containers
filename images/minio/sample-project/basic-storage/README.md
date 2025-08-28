# 🚀 MinIO Basic Storage - Beginner's Guide

Welcome to your first MinIO object storage setup! This guide is designed for college students who are new to cloud storage and want to learn how to store and manage files using MinIO.

## 📚 What You'll Learn

By the end of this tutorial, you'll understand:
- **What is object storage?** - A way to store files in the cloud
- **What is MinIO?** - A free, S3-compatible storage system
- **What is a bucket?** - Like a folder for organizing your files
- **What is Docker?** - A tool that packages your storage system like a box
- **How to upload, download, and manage files** - Basic file operations

## 🎯 What This Setup Does

This is a **Basic Object Storage System** - think of it like your own personal Google Drive or Dropbox where you can:
- ✅ **Store any type of files** (photos, documents, videos, etc.)
- ✅ **Organize files in buckets** (like folders on your computer)
- ✅ **Upload files** (put files into storage)
- ✅ **Download files** (get files from storage)
- ✅ **Browse your files** (see what you've stored)
- ✅ **Delete files** (remove files you don't need)

## 🛠️ What You Need (Prerequisites)

### For Complete Beginners:
- **A computer** (Windows, Mac, or Linux)
- **Basic computer skills** (knowing how to open files and folders)
- **An internet connection** (to download the tools)

### Tools You'll Install:
1. **Docker** - Think of this as a "magic box" that contains everything your storage system needs
2. **A web browser** - Like Chrome, Firefox, or Safari (you probably already have this!)

## 🚀 Quick Start (The Easy Way)

### Step 1: Install Docker
**What is Docker?** Docker is like a "magic box" that contains everything your storage system needs to run. It's like having a mini-computer inside your computer!

**How to install:**
1. Go to [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
2. Download Docker Desktop for your computer (Windows/Mac/Linux)
3. Install it like any other software
4. Start Docker Desktop

**How to check if it's working:**
```bash
docker --version
```
If you see something like "Docker version 20.10.x", you're good to go!

### Step 2: Pull the MinIO Image
**What we're doing:** We're downloading the MinIO storage system from the internet.

```bash
# Pull the MinIO image from Docker Hub
docker pull cleanstart/minio:latest
```

**What this means:**
- `docker pull` = "Download a program from the internet"
- `cleanstart/minio:latest` = "The name of the MinIO program we want to download"

### Step 3: Start the Storage System
**What we're doing:** We're going to start your MinIO storage system using Docker.

```bash
# Navigate to the project folder
cd images/minio/sample-project/basic-storage

# Start the storage system
docker-compose up -d
```

**What this means:**
- `docker-compose up` = "Start all the services we need"
- `-d` = "Run in the background (like starting an app and letting it run)"
- This starts MinIO (your storage system) and makes it ready to use

### Step 4: Verify Everything is Working
**What we're doing:** We're checking that the storage system started correctly.

```bash
# Check if the container is running
docker ps

# You should see something like:
# minio-basic    Up X seconds (healthy)    0.0.0.0:9000-9001->9000-9001/tcp
```

### Step 5: Test the Web Interface
**What we're doing:** We're making sure you can access the storage system through your web browser.

```bash
# Test the web console (Windows PowerShell)
Invoke-WebRequest -Uri "http://localhost:9001" -Method Head

# Test the web console (Linux/macOS)
curl -I http://localhost:9001

# You should see: HTTP/1.1 200 OK
```

### Step 6: Open Your Web Browser
1. Open your web browser (Chrome, Firefox, Safari, etc.)
2. Go to: `http://localhost:9001`
3. You should see a login page for MinIO Console

**What is localhost?** Localhost means "this computer." So `http://localhost:9001` means "go to the website running on my computer at port 9001."

### Step 7: Login to Your Storage
1. **Username**: `minioadmin`
2. **Password**: `minioadmin123`
3. Click "Login"

## 🎮 How to Use Your Storage System

### Creating Your First Bucket (Folder)
1. Click the "+" button or "Create Bucket"
2. Enter a bucket name (e.g., "my-photos", "documents", "videos")
3. Click "Create Bucket"
4. You now have a folder to store your files!

### Uploading Files
1. Click on your bucket name to open it
2. Click "Upload" or drag and drop files
3. Select the files you want to upload
4. Click "Upload" to start uploading
5. You'll see your files appear in the bucket!

### Downloading Files
1. Click on a file in your bucket
2. Click the download button (down arrow icon)
3. Choose where to save the file on your computer
4. The file will download to your computer!

### Deleting Files
1. Click on a file in your bucket
2. Click the delete button (trash can icon)
3. Confirm the deletion
4. The file will be removed from storage!

### Browsing Your Files
- All your buckets are shown on the left side
- Click on a bucket to see its files
- You can see file names, sizes, and when they were uploaded
- Use the search box to find specific files

## 🔧 For Advanced Beginners (Optional)

### What's Inside the Magic Box?

**The Storage System Structure:**
```
basic-storage/
├── docker-compose.yml    # Instructions for starting the system
├── scripts/              # Helper scripts for testing
│   ├── setup.sh         # Script to create test buckets
│   └── test-upload.sh   # Script to upload test files
└── README.md            # This guide
```

### Understanding the Configuration

**docker-compose.yml** - The setup instructions:
```yaml
# This tells Docker what services to start
services:
  minio:
    image: cleanstart/minio:latest    # Use our MinIO image
    ports:
      - "9000:9000"                   # API port
      - "9001:9001"                   # Web console port
    environment:
      MINIO_ROOT_USER: minioadmin     # Your username
      MINIO_ROOT_PASSWORD: minioadmin123  # Your password
    volumes:
      - minio_data:/data              # Where files are stored
```

**What each part does:**
- `image: cleanstart/minio:latest` = "Use our MinIO storage system"
- `ports: "9000:9000"` = "Make the API available on port 9000"
- `ports: "9001:9001"` = "Make the web console available on port 9001"
- `environment:` = "Set your login credentials"
- `volumes: minio_data:/data` = "Store files in a persistent location"

## 🧪 Complete Testing Guide

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

#### 6. Test Container Logs
```bash
# Check MinIO container logs
docker logs minio-basic

# Expected output should show:
# API: http://127.0.0.1:9000
# WebUI: http://127.0.0.1:9001
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

## 🐛 Troubleshooting (Common Problems)

### Problem: "Docker command not found"
**Solution:** Docker isn't installed or isn't running
1. Make sure Docker Desktop is installed
2. Start Docker Desktop
3. Wait for it to fully start (you'll see a green icon)

### Problem: "Port 9000 or 9001 is already in use"
**Solution:** Something else is using those ports
```bash
# Stop the current containers
docker-compose down

# Use different ports by editing docker-compose.yml
# Change "9000:9000" to "9002:9000" and "9001:9001" to "9003:9001"
# Then restart: docker-compose up -d
# Access at: http://localhost:9003
```

### Problem: "Cannot connect to the storage system"
**Solution:** Check if the containers are running
```bash
# See all running containers
docker ps

# If you don't see minio-basic, start it again
docker-compose up -d
```

### Problem: "The login page doesn't load"
**Solution:** Check your browser
1. Make sure you're going to `http://localhost:9001` (not `https://`)
2. Try a different browser
3. Check if your firewall is blocking the connection

### Problem: "Login credentials don't work"
**Solution:** Check the credentials
1. Username: `minioadmin` (exactly as shown)
2. Password: `minioadmin123` (exactly as shown)
3. Make sure caps lock is off

### Problem: "Container keeps restarting"
**Solution:** Check the container logs
```bash
# Check detailed logs
docker logs minio-basic

# If you see help messages, the command arguments are wrong
# Make sure docker-compose.yml has: command: server /data --console-address :9001
```

### Problem: "Health check failing"
**Solution:** Wait for container to fully start
```bash
# Wait a few seconds for MinIO to initialize
sleep 10

# Check health status again
docker ps
```

## 🎓 Learning Path

### Beginner Level (You are here!)
- ✅ Start the storage system using Docker
- ✅ Login to the web console
- ✅ Create buckets and upload files
- ✅ Download and delete files
- ✅ Understand basic object storage concepts

### Intermediate Level (Next steps)
- Learn how to use the MinIO API
- Understand file permissions and access control
- Learn about file versioning
- Use command-line tools to manage files

### Advanced Level (Future goals)
- Build applications that use MinIO
- Set up automated backups
- Configure advanced security features
- Deploy MinIO in production environments

## 🔗 What's Next?

After you're comfortable with this basic setup, you can:

1. **Try other sample projects:**
   - File Upload App (web application for uploading files)
   - Backup System (automated backup solution)
   - Advanced Storage (with multiple users and permissions)

2. **Learn more about MinIO:**
   - [MinIO Official Documentation](https://docs.min.io/)
   - [MinIO Console Guide](https://docs.min.io/docs/minio-console-quickstart-guide.html)

3. **Learn more about cloud storage:**
   - Object storage vs file storage
   - Cloud storage best practices
   - Data backup strategies

## 🤝 Getting Help

If you get stuck:
1. **Check the troubleshooting section above**
2. **Ask your classmates or teacher**
3. **Search online** (Google is your friend!)
4. **Join programming communities** (Reddit r/learnprogramming, Discord servers)

## 🎉 Congratulations!

You've just set up your own cloud storage system! This is a big step in your technology journey. You now understand:
- How to use Docker to run storage systems
- What object storage is and how it works
- How to organize files in buckets
- Basic file management operations
- How to use web-based storage interfaces

**Remember:** Every expert was once a beginner. Keep practicing, keep learning, and don't be afraid to make mistakes - that's how you learn!

---

**Happy Storing! 📦**

*This guide was created specifically for college students who are new to programming. If you found it helpful, share it with your classmates!*
