# 🚀 ArgoCD Extension Installer Sample Projects - Beginner's Guide

Welcome to the ArgoCD Extension Installer sample projects! This directory contains different examples that show you how to manage ArgoCD extensions in various scenarios. Each example is designed for college students who are new to GitOps and want to learn practical extension management.

## 📚 What You'll Learn

By exploring these sample projects, you'll understand:
- **Basic Extension Management**: How to install and configure ArgoCD extensions
- **Advanced Extension Features**: Complex extension configurations and workflows
- **Custom Extension Development**: Building and deploying custom extensions
- **Extension Integration**: Using extensions with CI/CD pipelines
- **Web Interfaces**: Managing extensions through user-friendly dashboards

## 🎯 Available Sample Projects

### 1. **Basic Extensions** (`basic-extensions/`)
**Perfect for beginners!** Start here if you're new to ArgoCD extensions.

**What it does:**
- Simple extension installer setup
- Basic extension installation and management
- Learn extension management concepts

**What you'll learn:**
- How to start the extension installer using Docker
- How to use the web interface
- Basic extension operations (install, configure, monitor)
- Understanding extension management

**Access:**
- Web Interface: http://localhost:8080
- Extension Dashboard: http://localhost:8080/dashboard

### 2. **Advanced Extensions** (`advanced-extensions/`)
**Great for learning advanced features!** Complex extension management scenarios.

**What it does:**
- Advanced extension configurations
- Multi-extension workflows
- Integration with external services

**What you'll learn:**
- Advanced extension configuration
- Extension dependency management
- Integration patterns
- Performance optimization

**Access:**
- Web Interface: http://localhost:8080
- Advanced Dashboard: http://localhost:8080/advanced

### 3. **Custom Extensions** (`custom-extensions/`)
**Advanced project for extension development!** Build and deploy custom extensions.

**What it does:**
- Custom extension development
- Extension testing and validation
- Extension deployment automation

**What you'll learn:**
- Extension development lifecycle
- Custom extension creation
- Testing and validation
- Deployment strategies

**Access:**
- Development Interface: http://localhost:8080
- Extension Builder: http://localhost:8080/builder

## 🛠️ What You Need (Prerequisites)

### For Complete Beginners:
- **A computer** (Windows, Mac, or Linux)
- **Basic computer skills** (knowing how to open files and folders)
- **An internet connection** (to download the tools)

### Tools You'll Install:
1. **Docker** - Think of this as a "magic box" that contains everything your extension manager needs
2. **A web browser** - Like Chrome, Firefox, or Safari (you probably already have this!)

## 🚀 Quick Start Guide

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

### Step 3: Choose a Sample Project
**Start with Basic Extensions if you're new to ArgoCD:**

```bash
# Navigate to the basic extensions example
cd images/argocd-extension-installer/sample-project/basic-extensions

# Start the project
docker-compose up -d

# Open your browser and go to: http://localhost:8080
```

## 🎮 How to Use Each Sample Project

### Basic Extensions Project
**Perfect for your first time with ArgoCD extensions!**

1. **Start the project:**
   ```bash
   cd basic-extensions
   docker-compose up -d
   ```

2. **Access the web interface:**
   - Go to: http://localhost:8080
   - This is the extension management dashboard

3. **Try these activities:**
   - Browse available extensions
   - Install ArgoCD Notifications
   - Install ArgoCD Image Updater
   - Configure extension settings
   - Monitor extension health

### Advanced Extensions Project
**Great for learning advanced extension management!**

1. **Start the project:**
   ```bash
   cd advanced-extensions
   docker-compose up -d
   ```

2. **Access the advanced interface:**
   - Go to: http://localhost:8080
   - This is an advanced extension management system

3. **Try these activities:**
   - Configure complex extension workflows
   - Set up extension dependencies
   - Integrate with external services
   - Monitor extension performance

### Custom Extensions Project
**Advanced extension development and deployment!**

1. **Start the project:**
   ```bash
   cd custom-extensions
   docker-compose up -d
   ```

2. **Access the development interface:**
   - Go to: http://localhost:8080
   - This is an extension development environment

3. **Try these activities:**
   - Create custom extensions
   - Test extension functionality
   - Deploy extensions
   - Monitor extension deployment

## 🔧 For Advanced Beginners (Optional)

### Understanding the Project Structure

**Each project contains:**
```
project-name/
├── docker-compose.yml    # Instructions for starting the project
├── README.md            # Detailed guide for that project
├── config/              # Configuration files (if any)
└── scripts/             # Helper scripts (if any)
```

### What Each File Does

**docker-compose.yml:**
- Tells Docker what services to start
- Sets up the extension installer and any other services
- Configures networking and storage

**README.md:**
- Step-by-step instructions for that project
- Explains what the project does
- Troubleshooting tips

**Config files:**
- Extension configuration settings
- Environment variables
- Custom settings

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

#### 6. Test Different Sample Projects

**Advanced Extensions:**
```bash
cd ../advanced-extensions
docker-compose up -d
# Access at: http://localhost:8080
```

**Custom Extensions:**
```bash
cd ../custom-extensions
docker-compose up -d
# Access at: http://localhost:8080
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

### Problem: "Port already in use"
**Solution:** Something else is using the ports
```bash
# Stop the current project
docker-compose down

# Check what's using the ports
netstat -tulpn | grep :8080

# Stop conflicting containers
docker stop <container-name>
```

### Problem: "Cannot connect to the application"
**Solution:** Check if the containers are running
```bash
# See all running containers
docker ps

# If containers aren't running, start them again
docker-compose up -d
```

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

### Beginner Level (Start Here!)
1. **Basic Extensions** - Learn extension management fundamentals
   - Set up extension installer using Docker
   - Use the web interface
   - Basic extension operations

2. **Extension Configuration** - Learn extension setup
   - Configure extension settings
   - Manage extension dependencies
   - Monitor extension health

### Intermediate Level
1. **Advanced Extensions** - Learn complex extension management
   - Advanced extension configurations
   - Multi-extension workflows
   - Integration patterns

2. **Extension Development** - Learn extension creation
   - Custom extension development
   - Testing and validation
   - Deployment strategies

### Advanced Level
1. **Production Deployment** - Learn real-world applications
   - Deploy extensions in production
   - Security and performance
   - Monitoring and maintenance

2. **Custom Applications** - Build your own projects
   - Create your own extension management tools
   - Integrate with other services
   - Advanced features and optimizations

## 🔗 What's Next?

After you're comfortable with these sample projects, you can:

1. **Build your own extension management tools:**
   - Create custom extension installers
   - Build extension monitoring dashboards
   - Develop extension automation tools

2. **Learn more about ArgoCD:**
   - [ArgoCD Official Documentation](https://argo-cd.readthedocs.io/)
   - [ArgoCD Extensions Guide](https://argo-cd.readthedocs.io/en/stable/operator-manual/extensions/)

3. **Explore advanced GitOps concepts:**
   - Multi-cluster management
   - Advanced deployment strategies
   - CI/CD pipeline integration

## 🤝 Getting Help

If you get stuck:
1. **Check the troubleshooting section above**
2. **Read the specific project README** (each project has its own guide)
3. **Ask your classmates or teacher**
4. **Search online** (Google is your friend!)
5. **Join programming communities** (Reddit r/learnprogramming, Discord servers)

## 🎉 Congratulations!

You're now ready to explore the world of ArgoCD extension management! These sample projects will help you understand:
- How extension management works
- How to build extension management tools
- How to manage and configure extensions
- How to create automated extension systems

**Remember:** Every expert was once a beginner. Start with the Basic Extensions project and work your way up. Don't be afraid to experiment and make mistakes - that's how you learn!

---

**Happy Learning! 🚀**

*This guide was created specifically for college students who are new to programming. If you found it helpful, share it with your classmates!*
