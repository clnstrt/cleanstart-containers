# Quick Reference: Complete User Workflow

## 🚀 Complete Workflow in 5 Steps

### **Step 1: Pull Image from Docker Hub**
```bash
docker pull cleanstart/ruby
docker pull cleanstart/python
docker pull cleanstart/node
docker pull cleanstart/go
docker pull cleanstart/postgres
docker pull cleanstart/jdk
docker pull cleanstart/jre
```

### **Step 2: Test Image Functionality**
```bash
docker run --rm cleanstart/ruby --version
docker run --rm cleanstart/python --version
docker run --rm cleanstart/node --version
docker run --rm cleanstart/go version
docker run --rm cleanstart/postgres --version
docker run --rm cleanstart/jdk --version
```

### **Step 3: Clone Repository**
```bash
git clone https://github.com/your-username/cleanstart-containers.git
cd cleanstart-containers
```

### **Step 4: Navigate to Sample Project**
```bash
# Choose your project:
cd images/Ruby/sample-project          # Ruby web app
cd images/database-examples/web-app    # Python Flask app
cd images/node/sample-project          # Node.js Express app
cd images/java/sample-project/java-web # Java Spring Boot app
cd images/go/sample-project/go-web     # Go Gin app
cd images/postgres/sample-project      # PostgreSQL + Flask app
```

### **Step 5: Set Up and Run**

#### **Option A: Automated Setup (Recommended)**
```bash
# For Ruby, Python, Node.js:
./setup_local.sh    # Linux/macOS
setup_local.bat     # Windows
```

#### **Option B: Manual Setup**
```bash
# Ruby
bundle install && ruby app.rb

# Python
python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt && python app.py

# Node.js
npm install && npm start

# Java
mvn clean package && java -jar target/database-web-app-1.0.0.jar

# Go
go mod tidy && go run main.go

# PostgreSQL
python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt && python app.py
```

---

## 📋 Project Quick Reference

| Project | Location | Setup Script | Run Command | Access URL |
|---------|----------|--------------|-------------|------------|
| **Ruby** | `images/Ruby/sample-project` | ✅ Yes | `ruby app.rb` | `http://localhost:4567` |
| **Python** | `images/database-examples/web-app` | ✅ Yes | `python app.py` | `http://localhost:5000` |
| **Node.js** | `images/node/sample-project` | ✅ Yes | `npm start` | `http://localhost:3000` |
| **Java** | `images/java/sample-project/java-web` | ❌ No | `java -jar target/database-web-app-1.0.0.jar` | `http://localhost:8080` |
| **Go** | `images/go/sample-project/go-web` | ❌ No | `go run main.go` | `http://localhost:8080` |
| **PostgreSQL** | `images/postgres/sample-project` | ❌ No | `python app.py` | `http://localhost:5000` |

---

## 🎯 One-Liner Commands

### **Complete Ruby Workflow:**
```bash
docker pull cleanstart/ruby && docker run --rm cleanstart/ruby --version && git clone https://github.com/your-username/cleanstart-containers.git && cd cleanstart-containers/images/Ruby/sample-project && ./setup_local.sh
```

### **Complete Python Workflow:**
```bash
docker pull cleanstart/python && docker run --rm cleanstart/python --version && git clone https://github.com/your-username/cleanstart-containers.git && cd cleanstart-containers/images/database-examples/web-app && ./setup_local.sh
```

### **Complete Node.js Workflow:**
```bash
docker pull cleanstart/node && docker run --rm cleanstart/node --version && git clone https://github.com/your-username/cleanstart-containers.git && cd cleanstart-containers/images/node/sample-project && ./setup_local.sh
```

---

## 🔧 Prerequisites Checklist

### **System Requirements:**
- [ ] Git installed
- [ ] Docker installed
- [ ] Required language runtime (Ruby/Python/Node.js/Java/Go)

### **For Automated Setup Scripts:**
- [ ] Ruby 3.3+ (for Ruby projects)
- [ ] Python 3.12+ (for Python/PostgreSQL projects)
- [ ] Node.js 18+ (for Node.js projects)

### **For Manual Setup:**
- [ ] Java 17+ + Maven (for Java projects)
- [ ] Go 1.21+ (for Go projects)
- [ ] PostgreSQL 15+ (for PostgreSQL projects)

---

## 🧪 Testing Commands

### **Health Checks:**
```bash
curl http://localhost:4567/health  # Ruby
curl http://localhost:5000/health  # Python/PostgreSQL
curl http://localhost:3000/health  # Node.js
curl http://localhost:8080/health  # Java/Go
```

### **API Tests:**
```bash
curl http://localhost:8080/api/users
curl -X POST http://localhost:8080/api/users -H "Content-Type: application/json" -d '{"name":"Test","email":"test@example.com"}'
```

---

## 📚 Documentation Links

- **Complete Workflow Guide:** `USER_WORKFLOW_GUIDE.md`
- **Detailed Setup Guide:** `LOCAL_SETUP_GUIDE.md`
- **Setup Summary:** `SETUP_SUMMARY.md`
- **Project READMEs:** Individual README files in each project directory

---

## 🆘 Quick Troubleshooting

| Issue | Solution |
|-------|----------|
| "Command not found" | Install required language/runtime |
| Permission errors | Use `sudo` (Linux/macOS) or run as Administrator (Windows) |
| Port conflicts | Change port or kill existing process |
| Database issues | Ensure database is running and connection parameters are correct |
| Dependency issues | Run setup script again or check detailed guide |

---

## 🎉 Success Indicators

✅ **Image pulled successfully**  
✅ **Version command works**  
✅ **Repository cloned**  
✅ **Setup script completed**  
✅ **Application starts without errors**  
✅ **Web interface accessible**  
✅ **API endpoints responding**  

**You're ready to develop! 🚀**
