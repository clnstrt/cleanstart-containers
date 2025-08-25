# JavaScript Database Web Application

A modern web interface for SQLite database operations built with **Express.js**, **Node.js**, and **Bootstrap**.

## 🚀 Quick Start - Run Locally

### Prerequisites
- **Node.js 14 or higher** (with npm)
- **Internet connection** (to download dependencies)

### Step 1: Install Node.js (if not installed)
```bash
# Check if Node.js is installed
node --version
npm --version

# Install Node.js if needed (Ubuntu/Debian)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Or install via package manager
sudo apt update
sudo apt install nodejs npm
```

### Step 2: Navigate to JavaScript Web Directory
```bash
cd containers/database-examples/javascript-web
```

### Step 3: Install Dependencies
```bash
npm install
```

### Step 4: Run the Application
```bash
npm start
```

### Step 5: Access the Web Application
Open your browser and go to: **http://localhost:3000**

## 🎯 Quick One-Liner Commands

Here's a complete sequence to run everything:
```bash
# Install Node.js and run
sudo apt update && sudo apt install nodejs npm
cd containers/database-examples/javascript-web
npm install
npm start
# Then open http://localhost:3000 in your browser
```

## 📋 Expected Output

### npm install Output
You should see output like this:
```
added 123 packages, and audited 124 packages in 1s
found 0 vulnerabilities
```

### Application Startup Output
```
🚀 JavaScript Database Web App running on http://localhost:3000
📊 Database initialized with sample data
🌐 Open your browser and go to: http://localhost:3000
```

### Application Access
Once started, you can access the application at: **http://localhost:3000**

## 🔧 Detailed Setup Instructions

### Check Node.js Installation
```bash
# Verify Node.js is installed
node --version

# Verify npm is installed
npm --version

# Should show something like:
# v18.17.0
# 9.6.7
```

### Install Dependencies (if needed)

#### Install Node.js 14+
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install nodejs npm

# CentOS/RHEL/Fedora
sudo yum install nodejs npm
# or
sudo dnf install nodejs npm

# macOS
brew install node

# Windows
# Download from https://nodejs.org/
```

### Run the Application
```bash
# Navigate to the project directory
cd containers/database-examples/javascript-web

# Install dependencies
npm install

# Run the application
npm start

# Access the application at: http://localhost:3000
```

## 🌐 What You'll See on Localhost

Once you open **http://localhost:3000**, you'll see:

### Home Page Features:
- **Hero Section**: Modern gradient header with Node.js branding
- **Users Table**: Display all users with ID, name, email, and creation date
- **Add User Button**: Add new users to the database
- **Delete Buttons**: Remove users from the database
- **Reset Database Button**: Clear all data and recreate sample users
- **API Testing Section**: Interactive buttons to test REST API endpoints
- **Quick Stats**: Real-time user count and database status
- **Server Status Indicator**: Live status of the application

### Interactive Features:
- **Modal Forms**: Clean add user interface
- **Real-time Updates**: Automatic table refresh after operations
- **Error Handling**: User-friendly error messages
- **Success Notifications**: Confirmation messages for actions
- **API Testing**: Built-in API endpoint testing
- **Keyboard Shortcuts**: Ctrl+R (refresh), Ctrl+N (add user)

## 🔌 API Endpoints

### Web Interface
- `GET /` - Home page with users table
- `GET /api/users` - Get all users (JSON)
- `POST /api/users` - Add new user (JSON)
- `DELETE /api/users/:id` - Delete user by ID (JSON)
- `POST /api/reset` - Reset database with sample data (JSON)

### API Testing Examples

#### Get all users:
```bash
curl http://localhost:3000/api/users
```

#### Add a new user:
```bash
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com"}'
```

#### Delete a user:
```bash
curl -X DELETE http://localhost:3000/api/users/1
```

#### Reset database:
```bash
curl -X POST http://localhost:3000/api/reset
```

## 🗄️ Database Schema

The application uses the same SQLite database structure:

```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 📁 Project Structure

```
javascript-web/
├── package.json                           # Node.js dependencies
├── README.md                             # This file
├── app.js                                # Main Express.js application
├── public/
│   ├── index.html                        # Main web page
│   └── script.js                         # Frontend JavaScript
└── users.db                              # SQLite database (created automatically)
```

## 🚨 Troubleshooting

### Common Issues

1. **Node.js not found**
   ```bash
   # Check if Node.js is installed
   node --version
   
   # Install if missing
   sudo apt install nodejs npm  # Ubuntu/Debian
   brew install node            # macOS
   ```

2. **Port 3000 already in use**
   ```bash
   # Kill process using port 3000
   lsof -ti:3000 | xargs kill -9
   
   # Or change port in app.js
   # Change const PORT = 3000; to const PORT = 3001;
   # Then access at: http://localhost:3001
   ```

3. **npm install errors**
   ```bash
   # Clear npm cache
   npm cache clean --force
   
   # Delete node_modules and reinstall
   rm -rf node_modules package-lock.json
   npm install
   ```

4. **Permission errors**
   ```bash
   # Fix npm permissions
   sudo chown -R $USER:$GROUP ~/.npm
   sudo chown -R $USER:$GROUP ~/.config
   ```

5. **Database errors**
   ```bash
   # Remove existing database and restart
   rm users.db
   npm start
   ```

### Verification Commands
```bash
# Test Node.js installation
node --version
npm --version

# Test the application
npm start

# Check if application is running
curl http://localhost:3000/api/users

# Check if port 3000 is in use
lsof -i :3000
```

## 🎯 Key Features
- **Express.js**: Fast, unopinionated web framework
- **Node.js**: JavaScript runtime environment
- **SQLite Database**: File-based database operations
- **Bootstrap 5**: Responsive, modern web interface
- **REST API**: JSON endpoints for programmatic access
- **Real-time Updates**: Live status and data refresh
- **Interactive UI**: Modal forms, notifications, API testing
- **Port 3000**: Default web server port

## 📚 Learning Points
- **Express.js**: Web application development
- **Node.js**: Server-side JavaScript
- **Database Integration**: SQLite with Node.js
- **Web Development**: HTML, CSS, JavaScript
- **API Development**: RESTful endpoints
- **npm**: Package management and dependencies
- **Port Management**: Web server configuration
- **Async/Await**: Modern JavaScript patterns

## 🔗 Related Examples
This JavaScript web application complements the other examples:
- `../python/` - Python SQLite example
- `../javascript/` - Node.js command-line example
- `../java/` - Java command-line example
- `../java-web/` - Spring Boot web interface
- `../c/` - C SQLite API example
- `../web-app/` - Flask web interface

All examples use the same database schema and operations!

## 📖 Additional Resources
- [Node.js Documentation](https://nodejs.org/docs/)
- [Express.js Documentation](https://expressjs.com/)
- [npm Documentation](https://docs.npmjs.com/)
- [Bootstrap Documentation](https://getbootstrap.com/docs/)
- [SQLite Documentation](https://www.sqlite.org/docs.html)

## 🚀 Development Mode

For development with auto-restart:
```bash
# Install nodemon globally (optional)
npm install -g nodemon

# Run in development mode
npm run dev
```

This will automatically restart the server when you make changes to the code!
