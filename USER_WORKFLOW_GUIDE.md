# Complete User Workflow: From Docker Hub to Local Development

This guide walks you through the complete process: from pulling images from Docker Hub to setting up and running sample projects locally.

## 🎯 Complete Workflow Overview

1. **Pull image from Docker Hub** → 2. **Test basic functionality** → 3. **Get sample project from GitHub** → 4. **Set up locally** → 5. **Run and test**

---

## 📋 Step-by-Step Workflow

### **Step 1: Pull Image from Docker Hub**

First, pull the desired image from the cleanstart Docker Hub repository:

```bash
# Pull the image you want to test
docker pull cleanstart/ruby
docker pull cleanstart/python
docker pull cleanstart/node
docker pull cleanstart/go
docker pull cleanstart/postgres
docker pull cleanstart/jdk
docker pull cleanstart/jre
```

### **Step 2: Test Basic Image Functionality**

Verify the image works correctly:

```bash
# Test Ruby
docker run --rm cleanstart/ruby --version

# Test Python
docker run --rm cleanstart/python --version

# Test Node.js
docker run --rm cleanstart/node --version

# Test Go
docker run --rm cleanstart/go version

# Test PostgreSQL
docker run --rm cleanstart/postgres --version

# Test Java
docker run --rm cleanstart/jdk --version
```

### **Step 3: Get Sample Project from GitHub**

Clone the repository to get the sample projects:

```bash
# Clone the repository
git clone https://github.com/your-username/cleanstart-containers.git
cd cleanstart-containers
```

### **Step 4: Choose Your Sample Project**

Navigate to the sample project you want to test:

```bash
# Available sample projects:
cd images/Ruby/sample-project          # Ruby web app
cd images/database-examples/web-app    # Python Flask app
cd images/node/sample-project          # Node.js Express app
cd images/java/sample-project/java-web # Java Spring Boot app
cd images/go/sample-project/go-web     # Go Gin app
cd images/postgres/sample-project      # PostgreSQL + Flask app
```

### **Step 5: Set Up Locally**

Choose your preferred setup method:

---

## 🚀 Setup Options

### **Option A: Automated Setup (Recommended)**

#### **For Ruby, Python, and Node.js projects:**

**Linux/macOS:**
```bash
# Make script executable and run
chmod +x setup_local.sh
./setup_local.sh
```

**Windows:**
```cmd
setup_local.bat
```

#### **For Java, Go, and PostgreSQL projects:**

Follow the manual setup instructions below.

### **Option B: Manual Setup**

#### **Ruby Sample Project:**
```bash
cd images/Ruby/sample-project

# Install dependencies
bundle install

# Run the application
ruby app.rb

# Access at http://localhost:4567
```

#### **Python Sample Project:**
```bash
cd images/database-examples/web-app

# Create virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate  # Linux/macOS
# or
venv\Scripts\activate     # Windows

# Install dependencies
pip install -r requirements.txt

# Run the application
python app.py

# Access at http://localhost:5000
```

#### **Node.js Sample Project:**
```bash
cd images/node/sample-project

# Install dependencies
npm install

# Run the application
npm start

# Access at http://localhost:3000
```

#### **Java Sample Project:**
```bash
cd images/java/sample-project/java-web

# Build the application
mvn clean package

# Run the application
java -jar target/database-web-app-1.0.0.jar

# Access at http://localhost:8080
```

#### **Go Sample Project:**
```bash
cd images/go/sample-project/go-web

# Download dependencies
go mod tidy

# Run the application
go run main.go

# Access at http://localhost:8080
```

#### **PostgreSQL Sample Project:**
```bash
cd images/postgres/sample-project

# Create virtual environment
python3 -m venv venv
source venv/bin/activate  # Linux/macOS
# or
venv\Scripts\activate     # Windows

# Install dependencies
pip install -r requirements.txt

# Set environment variables
export DB_HOST=localhost
export DB_NAME=helloworld
export DB_USER=postgres
export DB_PASSWORD=your_password
export DB_PORT=5432

# Run the application
python app.py

# Access at http://localhost:5000
```

### **Option C: Docker Setup**

All projects also support Docker for containerized development:

```bash
# Run with Docker
docker run -p 8080:8080 my-app

# Or use docker-compose (for PostgreSQL project)
docker-compose up -d
```

---

## 🔧 Prerequisites Installation

Before setting up any project locally, ensure you have the required software:

### **System Requirements:**
- **Git**: For cloning the repository
- **Docker**: For pulling images and optional containerized development

### **Language-Specific Requirements:**

#### **Ruby Projects:**
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install ruby ruby-bundler

# macOS
brew install ruby

# Windows
# Download from https://rubyinstaller.org/
```

#### **Python Projects:**
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install python3 python3-pip python3-venv

# macOS
brew install python@3.12

# Windows
# Download from https://www.python.org/downloads/
```

#### **Node.js Projects:**
```bash
# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# macOS
brew install node

# Windows
# Download from https://nodejs.org/
```

#### **Java Projects:**
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install openjdk-17-jdk maven

# macOS
brew install openjdk@17 maven

# Windows
# Download OpenJDK from https://adoptium.net/
# Download Maven from https://maven.apache.org/download.cgi
```

#### **Go Projects:**
```bash
# Ubuntu/Debian
wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# macOS
brew install go

# Windows
# Download from https://golang.org/dl/
```

#### **PostgreSQL Projects:**
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install postgresql postgresql-contrib python3 python3-pip python3-venv
sudo systemctl start postgresql
sudo systemctl enable postgresql

# macOS
brew install postgresql python@3.12
brew services start postgresql

# Windows
# Download from https://www.postgresql.org/download/windows/
```

---

## 🧪 Testing Your Setup

After setting up any project, test it to ensure everything works:

### **Health Check Endpoints:**
```bash
# Ruby
curl http://localhost:4567/health

# Python
curl http://localhost:5000/health

# Node.js
curl http://localhost:3000/health

# Java
curl http://localhost:8080/health

# Go
curl http://localhost:8080/health

# PostgreSQL
curl http://localhost:5000/health
```

### **API Endpoints:**
```bash
# Test user listing
curl http://localhost:8080/api/users

# Test user creation
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com"}'
```

---

## 📊 Complete Workflow Summary

| Step | Action | Command/Description |
|------|--------|-------------------|
| 1 | Pull Image | `docker pull cleanstart/[language]` |
| 2 | Test Image | `docker run --rm cleanstart/[language] --version` |
| 3 | Clone Repo | `git clone https://github.com/your-username/cleanstart-containers.git` |
| 4 | Navigate | `cd images/[language]/sample-project` |
| 5 | Setup | Run setup script or manual commands |
| 6 | Run | Execute the application |
| 7 | Test | Access the web interface and test features |

---

## 🎯 Quick Start Commands

### **Complete Ruby Workflow:**
```bash
# 1. Pull image
docker pull cleanstart/ruby

# 2. Test image
docker run --rm cleanstart/ruby --version

# 3. Clone and setup
git clone https://github.com/your-username/cleanstart-containers.git
cd cleanstart-containers/images/Ruby/sample-project

# 4. Setup (choose one)
./setup_local.sh                    # Linux/macOS
setup_local.bat                     # Windows
bundle install && ruby app.rb       # Manual

# 5. Access
open http://localhost:4567
```

### **Complete Python Workflow:**
```bash
# 1. Pull image
docker pull cleanstart/python

# 2. Test image
docker run --rm cleanstart/python --version

# 3. Clone and setup
git clone https://github.com/your-username/cleanstart-containers.git
cd cleanstart-containers/images/database-examples/web-app

# 4. Setup (choose one)
./setup_local.sh                    # Linux/macOS
setup_local.bat                     # Windows
python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt && python app.py  # Manual

# 5. Access
open http://localhost:5000
```

---

## 🆘 Troubleshooting

### **Common Issues and Solutions:**

1. **"Command not found" errors:**
   - Install the required language/runtime
   - Add to PATH environment variable

2. **Permission errors:**
   - Use `sudo` on Linux/macOS
   - Run as Administrator on Windows

3. **Port conflicts:**
   - Change the port in application configuration
   - Or kill the process using the port

4. **Database connection issues:**
   - Ensure database is running
   - Check connection parameters

5. **Dependency issues:**
   - Run setup script again
   - Check detailed guide in `LOCAL_SETUP_GUIDE.md`

---

## 📚 Additional Resources

- **Detailed Setup Guide:** `LOCAL_SETUP_GUIDE.md`
- **Setup Summary:** `SETUP_SUMMARY.md`
- **Project Documentation:** Individual README files in each project directory
- **Docker Setup:** Dockerfile and docker-compose.yml files in each project

---

## 🎉 Success!

Once you've completed the workflow:

1. **✅ Image pulled from Docker Hub**
2. **✅ Basic functionality verified**
3. **✅ Sample project set up locally**
4. **✅ Application running successfully**
5. **✅ Features tested and working**

You now have a complete development environment with:
- Working Docker images from cleanstart
- Local development setup
- Sample applications to learn from
- Foundation for building your own projects

Happy coding! 🚀
