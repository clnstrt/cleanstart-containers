# Database Examples Web Application

A modern web interface for the cross-language database examples, built with Flask and Bootstrap.

## 🚀 Quick Start - Run Locally

### Prerequisites
- **Python 3.x** (3.8 or higher recommended)
- **Internet connection** (for downloading dependencies)

### Step 1: Navigate to Web App Directory
```bash
cd containers/database-examples/web-app
```

### Step 2: Create Virtual Environment
```bash
python3 -m venv venv
```

### Step 3: Activate Virtual Environment
```bash
# On Linux/macOS:
source venv/bin/activate

# On Windows:
venv\Scripts\activate
```

### Step 4: Install Dependencies
```bash
pip install -r requirements.txt
```

### Step 5: Run the Application
```bash
python app.py
```

### Step 6: Access the Web App
Open your browser and go to: **http://localhost:5000**

## 🔧 Detailed Setup Instructions

### Check Python Installation
```bash
# Verify Python is installed
python3 --version

# Should show something like: Python 3.8.10
```

### Complete Setup Commands
```bash
# Navigate to web app directory
cd containers/database-examples/web-app

# Create virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate  # Linux/macOS
# OR
venv\Scripts\activate     # Windows

# Install dependencies
pip install -r requirements.txt

# Run the application
python app.py
```

### Expected Output
```
Database initialized with sample data
Starting web application...
Access the application at: http://localhost:5000
Press Ctrl+C to stop the server
 * Serving Flask app 'app' (lazy loading)
 * Environment: production
 * Debug mode: on
 * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)
```

## 📋 System Requirements

### Operating System Support
- ✅ **Linux** (Ubuntu, Debian, CentOS, etc.)
- ✅ **macOS** (10.14+)
- ✅ **Windows** (7, 8, 10, 11)

### Python Version Requirements
- **Minimum**: Python 3.8+
- **Recommended**: Python 3.9+
- **Latest**: Python 3.12+

## 🛠️ Installation by Operating System

### Ubuntu/Debian
```bash
# Install Python and pip
sudo apt update
sudo apt install python3 python3-pip python3-venv

# Verify installation
python3 --version
pip3 --version
```

### CentOS/RHEL/Fedora
```bash
# Install Python and pip
sudo yum install python3 python3-pip
# or for newer versions:
sudo dnf install python3 python3-pip

# Verify installation
python3 --version
pip3 --version
```

### macOS
```bash
# Using Homebrew
brew install python3

# Or download from python.org
# https://www.python.org/downloads/macos/

# Verify installation
python3 --version
pip3 --version
```

### Windows
```bash
# Download from python.org
# https://www.python.org/downloads/windows/

# Or using Chocolatey
choco install python

# Or using winget
winget install Python.Python.3.12

# Verify installation
python --version
pip --version
```

## 🌐 What You'll See

### Home Page (`/`)
- **Users Table**: Display all users with ID, name, email, and creation date
- **Actions**: Add new users, delete existing users, reset database
- **API Testing**: Interactive buttons to test the REST API endpoints

### Add User Page (`/add_user`)
- **Form**: Add new users with name and email validation
- **Quick Add**: Pre-filled example users for easy testing
- **Validation**: Client-side and server-side form validation

## 🔌 API Endpoints

### GET `/api/users`
Returns all users as JSON:
```json
[
  {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "created_at": "2024-01-01 12:00:00"
  }
]
```

### POST `/api/users`
Add a new user via JSON:
```json
{
  "name": "New User",
  "email": "newuser@example.com"
}
```

## 🗄️ Database Schema

The web app uses the same SQLite database structure as the command-line examples:

```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 📁 Files Created
- `users.db` - SQLite database file (created automatically)
- `venv/` - Python virtual environment directory
- `__pycache__/` - Python bytecode cache (created automatically)

## 🚨 Troubleshooting

### Common Issues

1. **Python not found**
   ```bash
   # Check if Python is installed
   which python3
   which python
   
   # Install if missing
   sudo apt install python3 python3-pip  # Ubuntu/Debian
   brew install python3                  # macOS
   ```

2. **Virtual environment issues**
   ```bash
   # Remove existing venv and recreate
   rm -rf venv
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```

3. **Flask not found**
   ```bash
   # Make sure virtual environment is activated
   source venv/bin/activate
   
   # Reinstall Flask
   pip install Flask
   ```

4. **Port already in use**
   ```bash
   # Change port in app.py
   # Find this line: app.run(debug=True, host='0.0.0.0', port=5000)
   # Change port=5000 to port=5001
   
   # Or kill process using port 5000
   lsof -ti:5000 | xargs kill -9
   ```

5. **Permission denied**
   ```bash
   # Fix permissions
   chmod 755 .
   chmod +x app.py
   ```

### Verification Commands
```bash
# Test Python installation
python3 --version

# Test virtual environment
source venv/bin/activate
python --version

# Test Flask installation
python -c "import flask; print('Flask is installed!')"

# Test the application
python app.py
```

## 🎯 Key Features
- **Web Interface**: Beautiful, responsive web UI
- **User Management**: View, add, and delete users
- **Database Operations**: Reset database with sample data
- **Mobile Friendly**: Responsive design works on all devices
- **REST API**: JSON endpoints for programmatic access
- **Modern UI**: Bootstrap 5 with custom styling

## 📚 Learning Points
- **Flask Web Framework**: Route handling, templates, forms
- **Database Integration**: SQLite with Flask
- **Frontend Development**: HTML, CSS, JavaScript
- **API Development**: RESTful endpoints
- **User Experience**: Form validation, error handling

## 🔗 Related Examples
This web app complements the command-line examples in:
- `../python/` - Python SQLite example
- `../javascript/` - Node.js SQLite example
- `../java/` - Java JDBC example
- `../c/` - C SQLite API example

All examples use the same database schema and operations!

## 📖 Additional Resources
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Bootstrap Documentation](https://getbootstrap.com/docs/)
- [SQLite Python Tutorial](https://www.sqlitetutorial.net/sqlite-python/)
- [Flask Web Development](https://flask.palletsprojects.com/en/2.3.x/quickstart/)
