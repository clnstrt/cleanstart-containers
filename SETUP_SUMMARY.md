# Sample Projects Setup Summary

This document provides a quick overview of how to set up and run all sample projects locally.

## 🚀 Quick Setup Options

### **Option 1: Automated Setup Scripts (Recommended)**

Each sample project now includes automated setup scripts:

#### **For Linux/macOS:**
```bash
# Ruby
cd images/Ruby/sample-project
chmod +x setup_local.sh
./setup_local.sh

# Python
cd images/database-examples/web-app
chmod +x setup_local.sh
./setup_local.sh

# Node.js
cd images/node/sample-project
chmod +x setup_local.sh
./setup_local.sh
```

#### **For Windows:**
```cmd
# Ruby
cd images\Ruby\sample-project
setup_local.bat

# Python
cd images\database-examples\web-app
setup_local.bat

# Node.js
cd images\node\sample-project
setup_local.bat
```

### **Option 2: Manual Setup**

Follow the detailed instructions in `LOCAL_SETUP_GUIDE.md`

### **Option 3: Docker Setup**

All projects also support Docker for easy containerized development.

---

## 📋 Project Quick Reference

| Project | Location | Setup Script | Run Command | Access URL |
|---------|----------|--------------|-------------|------------|
| **Ruby** | `images/Ruby/sample-project` | `setup_local.sh` / `setup_local.bat` | `ruby app.rb` | `http://localhost:4567` |
| **Python** | `images/database-examples/web-app` | `setup_local.sh` / `setup_local.bat` | `python app.py` | `http://localhost:5000` |
| **Node.js** | `images/node/sample-project` | `setup_local.sh` / `setup_local.bat` | `npm start` | `http://localhost:3000` |
| **Java** | `images/java/sample-project/java-web` | Manual setup | `java -jar target/database-web-app-1.0.0.jar` | `http://localhost:8080` |
| **Go** | `images/go/sample-project/go-web` | Manual setup | `go run main.go` | `http://localhost:8080` |
| **PostgreSQL** | `images/postgres/sample-project` | Manual setup | `python app.py` | `http://localhost:5000` |

---

## 🔧 Prerequisites Checklist

Before running any project, ensure you have:

### **System Requirements:**
- [ ] Git installed
- [ ] Docker (optional, for containerized development)

### **Language-Specific Requirements:**

#### **Ruby Projects:**
- [ ] Ruby 3.3+ installed
- [ ] Bundler gem installed

#### **Python Projects:**
- [ ] Python 3.12+ installed
- [ ] pip installed
- [ ] virtualenv (recommended)

#### **Node.js Projects:**
- [ ] Node.js 18+ installed
- [ ] npm installed

#### **Java Projects:**
- [ ] Java 17+ (JDK) installed
- [ ] Maven 3.6+ installed

#### **Go Projects:**
- [ ] Go 1.21+ installed

#### **PostgreSQL Projects:**
- [ ] PostgreSQL 15+ installed
- [ ] Python 3.12+ installed

---

## 🎯 Getting Started

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd cleanstart-containers
   ```

2. **Choose your project:**
   - Navigate to the desired sample project directory
   - Run the appropriate setup script

3. **Follow the setup instructions:**
   - The setup scripts will guide you through the process
   - They check prerequisites and install dependencies automatically

4. **Run the application:**
   - Each project has specific run commands
   - Access the application via the provided URL

---

## 🆘 Troubleshooting

### **Common Issues:**

1. **"Command not found" errors:**
   - Install the required language/runtime
   - Add to PATH environment variable

2. **Permission errors:**
   - Use `sudo` on Linux/macOS for system-wide installations
   - Run as Administrator on Windows

3. **Port conflicts:**
   - Change the port in the application configuration
   - Or kill the process using the port

4. **Dependency issues:**
   - Run the setup script again
   - Check the detailed guide in `LOCAL_SETUP_GUIDE.md`

### **Getting Help:**

- Check the `LOCAL_SETUP_GUIDE.md` for detailed instructions
- Review the project-specific README files
- Check the troubleshooting section in each project

---

## 📚 Additional Resources

- **Detailed Setup Guide:** `LOCAL_SETUP_GUIDE.md`
- **Project Documentation:** Individual README files in each project directory
- **Docker Setup:** Dockerfile and docker-compose.yml files in each project

---

## 🎉 Success!

Once you've completed the setup:

1. **Explore the code:** Understand the project structure
2. **Test the features:** Try all the functionality
3. **Modify and experiment:** Make changes and see how they work
4. **Learn and grow:** Use these projects as learning resources

Happy coding! 🚀
