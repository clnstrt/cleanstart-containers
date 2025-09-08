# Python SQLite Database Example

## Overview
This example demonstrates basic SQLite database operations using Python's built-in `sqlite3` module.

## 🚀 Quick Start - Run Locally

### Prerequisites
- **Python 3.x** (sqlite3 module is built-in)
- No additional dependencies required

### Step 1: Navigate to Python Directory
```bash
cd containers/database-examples/python
```

### Step 2: Run the Example
```bash
python3 database_example.py
```

### Step 3: View Results
The program will output database operations and display all users.

## 🔧 Detailed Setup Instructions

### Check Python Installation
```bash
# Verify Python is installed
python3 --version

# Should show something like: Python 3.8.10
```

### Run the Program
```bash
# Simple execution
python3 database_example.py

# Or with Python (if python3 is linked to python)
python database_example.py
```

### Expected Output
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

## 📋 System Requirements

### Operating System Support
- ✅ **Linux** (Ubuntu, Debian, CentOS, etc.)
- ✅ **macOS** (10.14+)
- ✅ **Windows** (7, 8, 10, 11)

### Python Version Requirements
- **Minimum**: Python 3.6+
- **Recommended**: Python 3.8+
- **Latest**: Python 3.12+

## 🛠️ Installation by Operating System

### Ubuntu/Debian
```bash
# Python is usually pre-installed
python3 --version

# If not installed
sudo apt update
sudo apt install python3 python3-pip
```

### CentOS/RHEL/Fedora
```bash
# Python is usually pre-installed
python3 --version

# If not installed
sudo yum install python3 python3-pip
# or for newer versions:
sudo dnf install python3 python3-pip
```

### macOS
```bash
# Using Homebrew
brew install python3

# Or download from python.org
# https://www.python.org/downloads/macos/
```

### Windows
```bash
# Download from python.org
# https://www.python.org/downloads/windows/

# Or using Chocolatey
choco install python

# Or using winget
winget install Python.Python.3.12
```

## 🔍 Code Structure
- `create_database()` - Creates database and users table
- `insert_user()` - Inserts a new user record
- `get_all_users()` - Queries all users from database
- `display_users()` - Formats and displays user data
- `main()` - Orchestrates the entire process

## 🗄️ Database Schema
- **Table**: `users`
- **Fields**:
  - `id` (INTEGER PRIMARY KEY AUTOINCREMENT)
  - `name` (TEXT NOT NULL)
  - `email` (TEXT NOT NULL UNIQUE)

## 📁 Files Created
- `users.db` - SQLite database file (created automatically)

## 🚨 Troubleshooting

### Common Issues

1. **Python not found**
   ```bash
   # Check if Python is installed
   which python3
   which python
   
   # Install if missing
   sudo apt install python3  # Ubuntu/Debian
   brew install python3      # macOS
   ```

2. **Permission denied**
   ```bash
   # Make sure you have write permissions
   chmod 755 .
   ls -la database_example.py
   ```

3. **Database file already exists**
   ```bash
   # The program automatically removes existing database
   # If you want to keep it, modify the code
   ```

4. **SQLite module not found**
   ```bash
   # This is very rare as sqlite3 is built-in
   # Check Python installation
   python3 -c "import sqlite3; print('SQLite3 module found')"
   ```

### Verification Commands
```bash
# Test Python installation
python3 --version

# Test SQLite3 module
python3 -c "import sqlite3; print('SQLite3 available')"

# Test the program
python3 database_example.py

# Check if database was created
ls -la users.db
```

## 🎯 Key Features
- **No Dependencies**: Uses built-in sqlite3 module
- **Cross-Platform**: Works on Linux, macOS, Windows
- **Simple Setup**: No package installation required
- **Error Handling**: Comprehensive exception handling
- **Resource Management**: Proper connection cleanup

## 📚 Learning Points
- **Database Connection**: Using sqlite3.connect()
- **Cursor Operations**: execute(), fetchall()
- **Parameterized Queries**: Preventing SQL injection
- **Transaction Management**: commit() and rollback()
- **Exception Handling**: sqlite3.Error handling

## 🔗 Related Examples
This Python example complements the other language examples:
- `../javascript/` - Node.js SQLite example
- `../java/` - Java JDBC example
- `../c/` - C SQLite API example
- `../web-app/` - Flask web interface

All examples use the same database schema and produce identical results!

## 📖 Additional Resources
- [Python sqlite3 Documentation](https://docs.python.org/3/library/sqlite3.html)
- [SQLite Python Tutorial](https://www.sqlitetutorial.net/sqlite-python/)
- [Python Database Programming](https://docs.python.org/3/library/sqlite3.html#tutorial)
