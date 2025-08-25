# Cross-Language Database Examples

This container demonstrates how to perform basic SQLite database operations across multiple programming languages.

## Overview

The examples show how to:
- Create a SQLite database and users table
- Insert user records
- Query and display all users
- Handle basic database operations

## Languages Included

- **Python** - Using built-in sqlite3 module
- **JavaScript (Node.js)** - Using sqlite3 package
- **Java** - Using JDBC with SQLite
- **C** - Using SQLite C API
- **Web Application** - Flask web interface

## 🚀 Quick Start - Run All Examples Locally

### Option 1: Automated Setup (Recommended)
```bash
# Navigate to the database-examples directory
cd containers/database-examples

# Set up and run all examples
make run-all
```

### Option 2: Individual Language Setup

#### Python
```bash
cd python
python database_example.py
```

#### JavaScript (Node.js)
```bash
cd javascript
npm install
node database_example.js
```

#### Java
```bash
cd java
make java  # Downloads JDBC driver and compiles
java -cp ".:sqlite-jdbc-3.42.0.0.jar" DatabaseExample
```

#### C
```bash
cd c
make c  # Compiles the program
./database_example
```

#### Web Application
```bash
cd web-app
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python app.py
# Then open http://localhost:5000 in your browser
```

## 📋 System Requirements & Installation

### Prerequisites
- **Python 3.x** (built-in sqlite3 module)
- **Node.js** (version 12 or higher) + npm
- **Java 8 or higher** + JDK
- **GCC compiler** + SQLite3 development library
- **Internet connection** (for downloading dependencies)

### Installation by Operating System

#### Ubuntu/Debian
```bash
# Update package list
sudo apt update

# Install Python (usually pre-installed)
sudo apt install python3 python3-pip

# Install Node.js and npm
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# Install Java
sudo apt install openjdk-11-jdk

# Install C development tools and SQLite
sudo apt install build-essential libsqlite3-dev

# Install pipx for Python package management
sudo apt install pipx
```

#### macOS
```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install all dependencies
brew install python node java sqlite3
```

#### Windows
```bash
# Install Python from https://python.org
# Install Node.js from https://nodejs.org
# Install Java JDK from https://oracle.com/java/technologies/downloads/
# For C compilation, use WSL or MinGW
```

## 🔧 Local Development Setup

### 1. Clone or Navigate to Project
```bash
cd containers/database-examples
```

### 2. Verify Prerequisites
```bash
# Check Python
python3 --version

# Check Node.js
node --version
npm --version

# Check Java
java -version
javac -version

# Check GCC
gcc --version
```

### 3. Run Individual Examples

#### Python Example
```bash
cd python
python3 database_example.py
```

#### JavaScript Example
```bash
cd javascript
npm install
node database_example.js
```

#### Java Example
```bash
cd java
# Automatic setup
make java
java -cp ".:sqlite-jdbc-3.42.0.0.jar" DatabaseExample

# Or manual setup
curl -O https://repo1.maven.org/maven2/org/xerial/sqlite-jdbc/3.42.0.0/sqlite-jdbc-3.42.0.0.jar
javac -cp ".:sqlite-jdbc-3.42.0.0.jar" DatabaseExample.java
java -cp ".:sqlite-jdbc-3.42.0.0.jar" DatabaseExample
```

#### C Example
```bash
cd c
# Automatic setup
make c
./database_example

# Or manual setup
gcc -o database_example database_example.c -lsqlite3
./database_example
```

#### Web Application
```bash
cd web-app
# Create virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run the application
python app.py

# Open browser to http://localhost:5000
```

## 📊 Expected Output

All examples should produce similar output:
```
Database created successfully
Table created successfully
User inserted successfully
User inserted successfully
User inserted successfully
All users:
ID: 1, Name: John Doe, Email: john@example.com
ID: 2, Name: Jane Smith, Email: jane@example.com
ID: 3, Name: Bob Johnson, Email: bob@example.com
Database connection closed
```

## 🗄️ Database Schema

All examples create the same database structure:
- Database file: `users.db`
- Table: `users`
- Fields: `id` (INTEGER PRIMARY KEY), `name` (TEXT), `email` (TEXT)

## 🛠️ Troubleshooting

### Common Issues

1. **Python: Module not found**
   ```bash
   # Use virtual environment
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```

2. **Node.js: npm not found**
   ```bash
   # Install Node.js from https://nodejs.org
   # Or use package manager
   sudo apt install nodejs npm  # Ubuntu/Debian
   brew install node  # macOS
   ```

3. **Java: JDBC driver not found**
   ```bash
   cd java
   make java  # This downloads the driver automatically
   ```

4. **C: SQLite not found**
   ```bash
   sudo apt install libsqlite3-dev  # Ubuntu/Debian
   brew install sqlite3  # macOS
   ```

5. **Permission denied errors**
   ```bash
   chmod +x c/database_example  # Make C executable runnable
   ```

### Verification Commands
```bash
# Test all examples
make clean    # Remove all generated files
make run-all  # Run all examples

# Check database files
find . -name "*.db" -type f
```

## 📁 Project Structure
```
database-examples/
├── README.md                 # This file
├── Makefile                  # Build automation
├── python/
│   ├── database_example.py   # Python implementation
│   └── README.md            # Python-specific instructions
├── javascript/
│   ├── database_example.js   # JavaScript implementation
│   ├── package.json         # Node.js dependencies
│   └── README.md            # JavaScript-specific instructions
├── java/
│   ├── DatabaseExample.java # Java implementation
│   └── README.md            # Java-specific instructions
├── c/
│   ├── database_example.c   # C implementation
│   └── README.md            # C-specific instructions
└── web-app/
    ├── app.py               # Flask web application
    ├── requirements.txt     # Python dependencies
    ├── templates/           # HTML templates
    └── README.md            # Web app instructions
```

## 🎯 Learning Objectives

- **Database Operations**: Connection management, CRUD operations
- **Language-Specific Patterns**: Best practices for each language
- **Error Handling**: Proper exception/error management
- **Resource Management**: Connection cleanup and memory management
- **Cross-Language Comparison**: See how the same operations differ across languages

## 🔗 Related Resources

- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [Python sqlite3 Module](https://docs.python.org/3/library/sqlite3.html)
- [Node.js sqlite3 Package](https://github.com/mapbox/node-sqlite3)
- [Java JDBC Tutorial](https://docs.oracle.com/javase/tutorial/jdbc/)
- [SQLite C API](https://www.sqlite.org/c3ref/intro.html)
- [Flask Web Framework](https://flask.palletsprojects.com/)
