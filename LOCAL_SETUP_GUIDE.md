# Local Setup Guide for Sample Projects

This guide provides step-by-step instructions for setting up and running all sample projects locally on your machine.

## Prerequisites

Before setting up any project, ensure you have the following installed:

### **System Requirements:**
- **Operating System**: Windows, macOS, or Linux
- **Git**: For cloning the repository
- **Docker** (optional): For containerized development

### **Language-Specific Requirements:**

#### **Ruby Projects:**
- Ruby 3.3+ 
- Bundler gem

#### **Python Projects:**
- Python 3.12+
- pip (Python package manager)
- virtualenv (recommended)

#### **Node.js Projects:**
- Node.js 18+
- npm (comes with Node.js)

#### **Java Projects:**
- Java 17+ (JDK)
- Maven 3.6+

#### **Go Projects:**
- Go 1.21+

#### **PostgreSQL Projects:**
- PostgreSQL 15+
- Python 3.12+ (for Flask app)

---

## 1. Ruby Sample Project Setup

### **Install Ruby:**

**On Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install ruby ruby-bundler
```

**On macOS:**
```bash
# Using Homebrew
brew install ruby

# Or using rbenv
brew install rbenv
rbenv install 3.3.0
rbenv global 3.3.0
```

**On Windows:**
```bash
# Download from https://rubyinstaller.org/
# Or use WSL (Windows Subsystem for Linux)
```

### **Setup Project:**
```bash
# Navigate to Ruby sample project
cd images/Ruby/sample-project

# Install dependencies
bundle install

# Run the application
ruby app.rb

# Access at http://localhost:4567
```

### **Verify Installation:**
```bash
ruby --version
bundle --version
```

---

## 2. Python Sample Project Setup

### **Install Python:**

**On Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install python3 python3-pip python3-venv
```

**On macOS:**
```bash
# Using Homebrew
brew install python@3.12

# Or download from https://www.python.org/downloads/
```

**On Windows:**
```bash
# Download from https://www.python.org/downloads/
# Make sure to check "Add Python to PATH"
```

### **Setup Project:**
```bash
# Navigate to Python sample project
cd images/database-examples/web-app

# Create virtual environment
python3 -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run the application
python app.py

# Access at http://localhost:5000
```

### **Verify Installation:**
```bash
python3 --version
pip --version
```

---

## 3. Node.js Sample Project Setup

### **Install Node.js:**

**On Ubuntu/Debian:**
```bash
# Using NodeSource repository
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

**On macOS:**
```bash
# Using Homebrew
brew install node

# Or download from https://nodejs.org/
```

**On Windows:**
```bash
# Download from https://nodejs.org/
```

### **Setup Project:**
```bash
# Navigate to Node.js sample project
cd images/node/sample-project

# Install dependencies
npm install

# Run the application
npm start

# Access at http://localhost:3000
```

### **Verify Installation:**
```bash
node --version
npm --version
```

---

## 4. Java Sample Project Setup

### **Install Java:**

**On Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install openjdk-17-jdk maven
```

**On macOS:**
```bash
# Using Homebrew
brew install openjdk@17 maven

# Set JAVA_HOME
echo 'export JAVA_HOME=/opt/homebrew/opt/openjdk@17' >> ~/.zshrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
```

**On Windows:**
```bash
# Download OpenJDK from https://adoptium.net/
# Download Maven from https://maven.apache.org/download.cgi
# Set JAVA_HOME and MAVEN_HOME environment variables
```

### **Setup Project:**
```bash
# Navigate to Java sample project
cd images/java/sample-project/java-web

# Build the application
mvn clean package

# Run the application
java -jar target/database-web-app-1.0.0.jar

# Access at http://localhost:8080
```

### **Verify Installation:**
```bash
java --version
mvn --version
```

---

## 5. Go Sample Project Setup

### **Install Go:**

**On Ubuntu/Debian:**
```bash
# Download from https://golang.org/dl/
wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc
```

**On macOS:**
```bash
# Using Homebrew
brew install go

# Or download from https://golang.org/dl/
```

**On Windows:**
```bash
# Download from https://golang.org/dl/
# Run the installer and follow the setup wizard
```

### **Setup Project:**
```bash
# Navigate to Go sample project
cd images/go/sample-project/go-web

# Download dependencies
go mod tidy

# Run the application
go run main.go

# Access at http://localhost:8080
```

### **Verify Installation:**
```bash
go version
```

---

## 6. PostgreSQL Sample Project Setup

### **Install PostgreSQL:**

**On Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib python3 python3-pip python3-venv

# Start PostgreSQL service
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Set up initial user
sudo -u postgres createuser --interactive
sudo -u postgres createdb helloworld
```

**On macOS:**
```bash
# Using Homebrew
brew install postgresql python@3.12

# Start PostgreSQL service
brew services start postgresql

# Create database
createdb helloworld
```

**On Windows:**
```bash
# Download from https://www.postgresql.org/download/windows/
# Run the installer and follow the setup wizard
# Create database using pgAdmin or command line
```

### **Setup Project:**
```bash
# Navigate to PostgreSQL sample project
cd images/postgres/sample-project

# Create virtual environment
python3 -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate

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

### **Verify Installation:**
```bash
psql --version
python3 --version
```

---

## Database Setup Instructions

### **SQLite (Used by Ruby, Python, Node.js, Go projects):**
SQLite databases are automatically created when you run the applications. No additional setup required.

### **PostgreSQL Setup:**
```bash
# Connect to PostgreSQL
psql -U postgres

# Create database
CREATE DATABASE helloworld;

# Create user (if needed)
CREATE USER myuser WITH PASSWORD 'mypassword';

# Grant privileges
GRANT ALL PRIVILEGES ON DATABASE helloworld TO myuser;

# Exit psql
\q
```

---

## Environment Variables

Most projects use environment variables for configuration. Set them based on your operating system:

### **Windows (Command Prompt):**
```cmd
set DB_HOST=localhost
set DB_NAME=helloworld
set DB_USER=postgres
set DB_PASSWORD=your_password
set DB_PORT=5432
```

### **Windows (PowerShell):**
```powershell
$env:DB_HOST="localhost"
$env:DB_NAME="helloworld"
$env:DB_USER="postgres"
$env:DB_PASSWORD="your_password"
$env:DB_PORT="5432"
```

### **macOS/Linux:**
```bash
export DB_HOST=localhost
export DB_NAME=helloworld
export DB_USER=postgres
export DB_PASSWORD=your_password
export DB_PORT=5432
```

---

## Troubleshooting Common Issues

### **1. Port Already in Use:**
```bash
# Find process using the port
lsof -i :5000  # macOS/Linux
netstat -ano | findstr :5000  # Windows

# Kill the process
kill -9 <PID>  # macOS/Linux
taskkill /PID <PID> /F  # Windows
```

### **2. Permission Issues:**
```bash
# For Python virtual environments
chmod +x venv/bin/activate

# For Ruby gems
sudo gem install bundler

# For Node.js packages
sudo npm install -g npm
```

### **3. Database Connection Issues:**
```bash
# Check if PostgreSQL is running
sudo systemctl status postgresql  # Linux
brew services list | grep postgresql  # macOS

# Test connection
psql -h localhost -U postgres -d helloworld
```

### **4. Dependencies Not Found:**
```bash
# Ruby
bundle install

# Python
pip install -r requirements.txt

# Node.js
npm install

# Go
go mod tidy

# Java
mvn clean install
```

### **5. Version Conflicts:**
```bash
# Use version managers
# Ruby: rbenv or rvm
# Node.js: nvm
# Python: pyenv
# Go: gvm
```

---

## Quick Start Commands Summary

| Project | Navigate | Install | Run | Access |
|---------|----------|---------|-----|--------|
| Ruby | `cd images/Ruby/sample-project` | `bundle install` | `ruby app.rb` | `http://localhost:4567` |
| Python | `cd images/database-examples/web-app` | `pip install -r requirements.txt` | `python app.py` | `http://localhost:5000` |
| Node.js | `cd images/node/sample-project` | `npm install` | `npm start` | `http://localhost:3000` |
| Java | `cd images/java/sample-project/java-web` | `mvn clean package` | `java -jar target/database-web-app-1.0.0.jar` | `http://localhost:8080` |
| Go | `cd images/go/sample-project/go-web` | `go mod tidy` | `go run main.go` | `http://localhost:8080` |
| PostgreSQL | `cd images/postgres/sample-project` | `pip install -r requirements.txt` | `python app.py` | `http://localhost:5000` |

---

## Next Steps

After setting up the projects locally:

1. **Explore the code**: Understand the project structure and implementation
2. **Modify features**: Add new functionality or modify existing ones
3. **Test changes**: Verify your modifications work correctly
4. **Deploy**: Consider deploying to cloud platforms
5. **Contribute**: Submit improvements back to the project

Happy coding! 🚀
