# Go Database Web Application

A modern web interface for SQLite database operations built with **Go**, **Gin**, and **Bootstrap**.

## 🚀 Quick Start - Run Locally

### Prerequisites
- **Go 1.21 or higher**
- **GCC compiler** (for SQLite CGO)
- **Internet connection** (to download dependencies)

### Step 1: Install Go
```bash
# Install Go (Ubuntu/Debian)
sudo apt update
sudo apt install golang-go

# Or download from https://golang.org/dl/
# For other systems, visit: https://golang.org/doc/install

# Verify Go installation
go version
# Should show: go version go1.21.x linux/amd64
```

### Step 2: Install GCC (for SQLite CGO)
```bash
# Ubuntu/Debian
sudo apt install gcc

# CentOS/RHEL/Fedora
sudo yum install gcc
# or
sudo dnf install gcc

# macOS
xcode-select --install
```

### Step 3: Navigate to Go Web Directory
```bash
cd containers/app4/test/go-web
```

### Step 4: Build and Run the Application
```bash
# Download dependencies
go mod tidy

# Run the application
go run main.go
```

### Step 5: Access the Web Application
Open your browser and go to: **http://localhost:8080**

## 🎯 Quick One-Liner Commands

Here's a complete sequence to run everything:
```bash
# Install dependencies and run
sudo apt update && sudo apt install golang-go gcc
cd containers/app4/test/go-web
go mod tidy && go run main.go
# Then open http://localhost:8080 in your browser
```

## 📋 Expected Output

### Go Build Output
You should see output like this:
```
go: downloading github.com/gin-gonic/gin v1.9.1
go: downloading github.com/mattn/go-sqlite3 v1.14.17
Database created successfully
Table created successfully
User inserted successfully
User inserted successfully
User inserted successfully
All users:
ID: 1, Name: John Doe, Email: john@example.com
ID: 2, Name: Jane Smith, Email: jane@example.com
ID: 3, Name: Bob Johnson, Email: bob@example.com
Starting Go web server on http://localhost:8080
[GIN-debug] Listening and serving HTTP on :8080
```

### Application Access
Once started, you can access the application at: **http://localhost:8080**

## 🔧 Detailed Setup Instructions

### Check Go Installation
```bash
# Verify Go is installed
go version

# Should show something like:
# go version go1.21.0 linux/amd64
```

### Check GCC Installation
```bash
# Verify GCC is installed
gcc --version

# Should show something like:
# gcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0
```

### Run the Program
```bash
# Download dependencies
go mod tidy

# Run the application
go run main.go

# Or build and run
go build -o go-web-app main.go
./go-web-app
```

## 🌐 Web Interface Features

### Main Dashboard
- View all users in a responsive table
- Add new users with form validation
- Edit existing users
- Delete users with confirmation
- Modern Bootstrap UI with Font Awesome icons

### API Endpoints
- `GET /api/users` - Retrieve all users in JSON format
- `POST /api/users` - Create a new user via API

### Example API Usage
```bash
# Get all users
curl http://localhost:8080/api/users

# Create a new user
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe","email":"john@example.com"}'
```

## 📋 System Requirements

### Operating System Support
- ✅ **Linux** (Ubuntu, Debian, CentOS, Fedora, etc.)
- ✅ **macOS** (10.14+)
- ✅ **Windows** (7, 8, 10, 11)

### Go Version Requirements
- **Minimum**: Go 1.21+
- **Recommended**: Go 1.21+
- **Latest**: Go 1.22+

### Dependencies
- **Gin Web Framework** - HTTP web framework
- **SQLite3 Driver** - Database driver for Go
- **Bootstrap 5** - CSS framework (CDN)
- **Font Awesome** - Icon library (CDN)

## 🛠️ Installation by Operating System

### Ubuntu/Debian
```bash
# Install Go
sudo apt update
sudo apt install golang-go

# Install GCC
sudo apt install gcc

# Verify installations
go version
gcc --version
```

### CentOS/RHEL/Fedora
```bash
# Install Go
sudo yum install golang
# or for newer versions:
sudo dnf install golang

# Install GCC
sudo yum install gcc
# or
sudo dnf install gcc

# Verify installations
go version
gcc --version
```

### macOS
```bash
# Using Homebrew
brew install go

# Install Xcode Command Line Tools (includes GCC)
xcode-select --install

# Verify installations
go version
gcc --version
```

### Windows
```bash
# Download Go from https://golang.org/dl/
# Install MinGW-w64 for GCC: https://www.mingw-w64.org/

# Or use WSL2 for Linux environment
wsl --install
```

## 🏗️ Project Structure

```
go-web/
├── main.go              # Main application file
├── go.mod               # Go module file
├── go.sum               # Dependency checksums
├── templates/           # HTML templates
│   ├── base.html        # Base template
│   ├── index.html       # Main page
│   ├── add_user.html    # Add user form
│   ├── edit_user.html   # Edit user form
│   └── error.html       # Error page
├── users.db             # SQLite database (created at runtime)
└── README.md           # This file
```

## 🔍 Code Features

### Database Operations
- **Create Database**: Automatic SQLite database creation
- **Create Table**: Users table with ID, name, and email fields
- **Insert Users**: Add new users with validation
- **Query Users**: Retrieve all users or by ID
- **Update Users**: Modify existing user information
- **Delete Users**: Remove users from database

### Web Framework Features
- **Gin Router**: Fast HTTP web framework
- **HTML Templates**: Server-side rendering with Go templates
- **Form Handling**: POST form processing with validation
- **JSON API**: RESTful API endpoints
- **Error Handling**: Comprehensive error management

### Security Features
- **Input Validation**: Form data validation
- **SQL Injection Prevention**: Parameterized queries
- **Error Sanitization**: Safe error messages

## 🚀 Deployment

### Local Development
```bash
go run main.go
```

### Production Build
```bash
# Build for current platform
go build -o go-web-app main.go

# Build for specific platform
GOOS=linux GOARCH=amd64 go build -o go-web-app main.go

# Run the binary
./go-web-app
```

### Docker Deployment
```dockerfile
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o go-web-app main.go

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/go-web-app .
EXPOSE 8080
CMD ["./go-web-app"]
```

## 🐛 Troubleshooting

### Common Issues

#### 1. CGO Error
```
# github.com/mattn/go-sqlite3
exec: "gcc": executable file not found in $PATH
```
**Solution**: Install GCC compiler
```bash
sudo apt install gcc  # Ubuntu/Debian
sudo yum install gcc  # CentOS/RHEL
```

#### 2. Port Already in Use
```
listen tcp :8080: bind: address already in use
```
**Solution**: Change port or kill existing process
```bash
# Kill process on port 8080
sudo lsof -ti:8080 | xargs kill -9
```

#### 3. Permission Denied
```
permission denied: go-web-app
```
**Solution**: Make executable
```bash
chmod +x go-web-app
```

## 📚 Learning Resources

- [Go Official Documentation](https://golang.org/doc/)
- [Gin Web Framework](https://gin-gonic.com/)
- [SQLite with Go](https://github.com/mattn/go-sqlite3)
- [Go Templates](https://golang.org/pkg/html/template/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
