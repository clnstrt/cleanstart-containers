# 🚀 ArgoCD Basic Extensions - Beginner's Guide

Welcome to your first ArgoCD extension setup! This guide is designed for college students who are new to GitOps and want to learn how to manage ArgoCD extensions for basic deployment scenarios.

## 📚 What You'll Learn

By the end of this tutorial, you'll understand:
- **What is ArgoCD?** - A GitOps continuous delivery tool for Kubernetes
- **What are extensions?** - Additional features that enhance ArgoCD functionality
- **What is GitOps?** - A way to manage infrastructure using Git as the source of truth
- **What is Kubernetes?** - A container orchestration platform
- **How to install and manage extensions** - Basic extension operations

## 🎯 What This Setup Does

This is a **Basic ArgoCD Extension Management System** - think of it like a plugin manager for your GitOps workflow where you can:
- ✅ **Install ArgoCD Notifications** - Get alerts when deployments happen
- ✅ **Install ArgoCD Image Updater** - Automatically update container images
- ✅ **Manage extension configurations** - Configure how extensions work
- ✅ **Monitor extension health** - Check if extensions are working properly
- ✅ **Browse available extensions** - See what extensions you can install
- ✅ **Update extensions** - Keep extensions up to date

## 🛠️ What You Need (Prerequisites)

### For Complete Beginners:
- **A computer** (Windows, Mac, or Linux)
- **Basic computer skills** (knowing how to open files and folders)
- **An internet connection** (to download the tools)

### Tools You'll Install:
1. **Docker** - Think of this as a "magic box" that contains everything your extension manager needs
2. **A web browser** - Like Chrome, Firefox, or Safari (you probably already have this!)
3. **kubectl** - A tool to talk to Kubernetes clusters (optional for this demo)

## 🚀 Quick Start (The Easy Way)

### Step 1: Install Docker
**What is Docker?** Docker is like a "magic box" that contains everything your extension manager needs to run. It's like having a mini-computer inside your computer!

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

### Step 2: Pull the ArgoCD Extension Installer Image
**What we're doing:** We're downloading the ArgoCD extension manager from the internet.

```bash
# Pull the ArgoCD Extension Installer image from Docker Hub
docker pull cleanstart/argocd-extension-installer:latest
```

**What this means:**
- `docker pull` = "Download a program from the internet"
- `cleanstart/argocd-extension-installer:latest` = "The name of the extension manager we want to download"

### Step 3: Start the Extension Manager
**What we're doing:** We're going to start your ArgoCD extension manager using Docker.

```bash
# Navigate to the project folder
cd images/argocd-extension-installer/sample-project/basic-extensions

# Start the extension manager
docker-compose up -d
```

**What this means:**
- `docker-compose up` = "Start all the services we need"
- `-d` = "Run in the background (like starting an app and letting it run)"
- This starts the extension manager and makes it ready to use

### Step 4: Verify Everything is Working
**What we're doing:** We're checking that the extension manager started correctly.

```bash
# Check if the container is running
docker ps

# You should see something like:
# argocd-extensions-basic    Up X seconds (healthy)    0.0.0.0:8080->8080/tcp
```

### Step 5: Test the Web Interface
**What we're doing:** We're making sure you can access the extension manager through your web browser.

```bash
# Test the web interface (Windows PowerShell)
Invoke-WebRequest -Uri "http://localhost:8080" -Method Head

# Test the web interface (Linux/macOS)
curl -I http://localhost:8080

# You should see: HTTP/1.1 200 OK
```

### Step 6: Open Your Web Browser
1. Open your web browser (Chrome, Firefox, Safari, etc.)
2. Go to: `http://localhost:8080`
3. You should see the ArgoCD Extension Installer dashboard

**What is localhost?** Localhost means "this computer." So `http://localhost:8080` means "go to the website running on my computer at port 8080."

## 🎮 How to Use Your Extension Manager

### Browsing Available Extensions
1. Click on "Available Extensions" in the dashboard
2. You'll see a list of extensions you can install
3. Each extension has a description of what it does
4. Click on an extension to see more details

### Installing Your First Extension
1. Find "ArgoCD Notifications" in the list
2. Click "Install" next to it
3. The extension will be downloaded and installed
4. You'll see a success message when it's done

### Installing ArgoCD Image Updater
1. Find "ArgoCD Image Updater" in the list
2. Click "Install" next to it
3. This extension helps automatically update container images
4. Wait for the installation to complete

### Checking Extension Status
1. Click on "Installed Extensions" in the dashboard
2. You'll see all the extensions you've installed
3. Each extension shows its status (Running, Stopped, etc.)
4. Green means it's working, red means there's a problem

### Configuring Extensions
1. Click on an installed extension
2. Click "Configure" to change its settings
3. You can modify how the extension works
4. Click "Save" to apply your changes

## 🔧 For Advanced Beginners (Optional)

### What's Inside the Magic Box?

**The Extension Manager Structure:**
```
basic-extensions/
├── docker-compose.yml    # Instructions for starting the system
├── config/              # Configuration files for extensions
│   ├── notifications.yaml
│   └── image-updater.yaml
└── README.md            # This guide
```

### Understanding the Configuration

**docker-compose.yml** - The setup instructions:
```yaml
# This tells Docker what services to start
services:
  argocd-extensions:
    image: cleanstart/argocd-extension-installer:latest    # Use our extension manager
    ports:
      - "8080:8080"                   # Web interface port
    environment:
      - EXTENSION_MODE=basic          # Run in basic mode
      - LOG_LEVEL=info                # Log level for debugging
    volumes:
      - extension_data:/app/extensions # Where extensions are stored
```

**What each part does:**
- `image: cleanstart/argocd-extension-installer:latest` = "Use our extension manager"
- `ports: "8080:8080"` = "Make the web interface available on port 8080"
- `environment: EXTENSION_MODE=basic` = "Run in basic mode for beginners"
- `volumes: extension_data:/app/extensions` = "Store extensions in a persistent location"

## 🧪 Complete Testing Guide

### Prerequisites for Testing
```bash
# Ensure Docker and Docker Compose are installed
docker --version
docker-compose --version

# Pull the ArgoCD Extension Installer image from Docker Hub
docker pull cleanstart/argocd-extension-installer:latest
```

### Step-by-Step Testing Instructions

#### 1. Navigate to Sample Project
```bash
# Navigate to the basic extensions example
cd images/argocd-extension-installer/sample-project/basic-extensions
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
# argocd-extensions-basic     Up X minutes (healthy)     0.0.0.0:8080->8080/tcp
```

#### 4. Test Web Interfaces

**Test Extension Installer Web Interface:**
```bash
# Using curl (Linux/macOS)
curl -I http://localhost:8080

# Using PowerShell (Windows)
Invoke-WebRequest -Uri "http://localhost:8080" -Method Head

# Expected result: HTTP/1.1 200 OK
```

#### 5. Access Web Interface
- **Extension Installer**: http://localhost:8080
- **Extension Dashboard**: http://localhost:8080/dashboard
- **Extension Management**: http://localhost:8080/manage

**What to do in the interface:**
1. Browse available extensions
2. Install ArgoCD Notifications
3. Install ArgoCD Image Updater
4. Configure extension settings
5. Monitor extension health

#### 6. Test Extension Installation
```bash
# Check extension installation status
docker exec argocd-extensions-basic /app/scripts/check-extensions.sh

# Expected output should show installed extensions
```

#### 7. Cleanup After Testing
```bash
# Stop and remove containers
docker-compose down

# Remove all related containers and networks
docker-compose down --volumes --remove-orphans

# Verify cleanup
docker ps | grep argocd
```

### Expected Test Results

**✅ Successful Test Indicators:**
- Extension installer container shows "Up" status with "(healthy)"
- Web interface returns HTTP 200 OK
- Can access extension dashboard
- Can browse available extensions
- Can install basic extensions
- Can monitor extension health

**❌ Common Issues to Watch For:**
- Port conflicts (containers won't start)
- Permission denied errors (Docker socket access)
- Network connectivity issues (web interface not accessible)
- Resource constraints (containers fail to start)
- Volume mount issues (extension data persistence problems)

## 🐛 Troubleshooting (Common Problems)

### Problem: "Docker command not found"
**Solution:** Docker isn't installed or isn't running
1. Make sure Docker Desktop is installed
2. Start Docker Desktop
3. Wait for it to fully start (you'll see a green icon)

### Problem: "Port 8080 is already in use"
**Solution:** Something else is using that port
```bash
# Stop the current containers
docker-compose down

# Use different ports by editing docker-compose.yml
# Change "8080:8080" to "8082:8080"
# Then restart: docker-compose up -d
# Access at: http://localhost:8082
```

### Problem: "Cannot connect to the extension manager"
**Solution:** Check if the containers are running
```bash
# See all running containers
docker ps

# If you don't see argocd-extensions-basic, start it again
docker-compose up -d
```

### Problem: "The web interface doesn't load"
**Solution:** Check your browser
1. Make sure you're going to `http://localhost:8080` (not `https://`)
2. Try a different browser
3. Check if your firewall is blocking the connection

### Problem: "Extensions won't install"
**Solution:** Check the container logs
```bash
# Check detailed logs
docker logs argocd-extensions-basic

# Check if the extension manager is healthy
docker ps
```

### Problem: "Health check failing"
**Solution:** Wait for container to fully start
```bash
# Wait a few seconds for the extension manager to initialize
sleep 10

# Check health status again
docker ps
```

## 🎓 Learning Path

### Beginner Level (You are here!)
- ✅ Start the extension manager using Docker
- ✅ Access the web interface
- ✅ Browse available extensions
- ✅ Install basic extensions
- ✅ Understand basic extension concepts

### Intermediate Level (Next steps)
- Learn how to configure extensions
- Understand extension dependencies
- Learn about advanced extension features
- Use command-line tools to manage extensions

### Advanced Level (Future goals)
- Build custom extensions
- Set up automated extension management
- Configure advanced extension features
- Deploy extensions in production environments

## 🔗 What's Next?

After you're comfortable with this basic setup, you can:

1. **Try other sample projects:**
   - Advanced Extensions (more complex extension management)
   - Custom Extensions (building your own extensions)
   - Production Setup (real-world deployment)

2. **Learn more about ArgoCD:**
   - [ArgoCD Official Documentation](https://argo-cd.readthedocs.io/)
   - [ArgoCD Extensions Guide](https://argo-cd.readthedocs.io/en/stable/operator-manual/extensions/)

3. **Learn more about GitOps:**
   - GitOps principles and practices
   - Kubernetes deployment strategies
   - CI/CD pipeline integration

## 🤝 Getting Help

If you get stuck:
1. **Check the troubleshooting section above**
2. **Ask your classmates or teacher**
3. **Search online** (Google is your friend!)
4. **Join programming communities** (Reddit r/learnprogramming, Discord servers)

## 🎉 Congratulations!

You've just set up your own ArgoCD extension manager! This is a big step in your GitOps journey. You now understand:
- How to use Docker to run extension managers
- What ArgoCD extensions are and how they work
- How to install and manage extensions
- Basic extension configuration
- How to use web-based extension interfaces

**Remember:** Every expert was once a beginner. Keep practicing, keep learning, and don't be afraid to make mistakes - that's how you learn!

---

**Happy Extending! 🚀**

*This guide was created specifically for college students who are new to programming. If you found it helpful, share it with your classmates!*
