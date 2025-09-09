# Go Database Web Application

A modern web interface for SQLite database operations built with **Go**, **Gin**, and **Bootstrap**.

## Quick Start - Run Locally

### Prerequisites

### Step 1: Install GCC (for SQLite CGO)
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

### Step 2: Navigate to Go Web Directory
```bash
cd containers/app4/test/go-web
```

### Step 3: Build and Run the Application
```bash
# Download dependencies
go mod tidy

# Run the application
go run main.go
```

### Step 4: Access the Web Application
Open your browser and go to: **http://localhost:8080**

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

## Detailed Setup Instructions

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

## Web Interface Features

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
- **Minimum**: Go 1.18+
- **Recommended**: Go 1.18+
- **Latest**: Go 1.18+

### Dependencies
- **Gin Web Framework** - HTTP web framework
- **SQLite3 Driver** - Database driver for Go
- **Bootstrap 5** - CSS framework (CDN)
- **Font Awesome** - Icon library (CDN)

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
# Build stage
FROM cleanstart/go:latest AS builder

# Install build dependencies
RUN apk add --no-cache 

# Set working directory
WORKDIR /app

# Copy go mod files
COPY go.mod ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Tidy and download dependencies
RUN go mod tidy && go mod download

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o go-web-app main.go

# Final stage
FROM alpine:latest

# Install runtime dependencies
RUN apk --no-cache add ca-certificates

# Create non-root user
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# Set working directory
WORKDIR /app

# Copy binary from builder stage
COPY --from=builder /app/go-web-app .

# Copy templates
COPY --from=builder /app/templates ./templates

# Change ownership to non-root user
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/ || exit 1

# Run the application
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





Go Database Web Application

A modern SQLite User Management System built with Go (Gin) and Bootstrap.






🚀 Quick Start (Docker)
Step 1: Clone Repository
git clone <repo-url>
cd containers/app4/test/go-web

Step 2: Build Image
docker build -t go-web-app .

Step 3: Run Container
docker run -p 8080:8080 go-web-app

Step 4: Access App

Open 👉 http://localhost:8080

📂 Project Structure
go-web/
├── main.go           # App entry
├── go.mod            # Dependencies
├── templates/        # HTML UI (Bootstrap + FontAwesome)
│   ├── index.html
│   ├── add_user.html
│   ├── edit_user.html
│   └── error.html
└── Dockerfile        # Docker build instructions

⚡ Features

📋 View all users in dashboard

➕ Add new users

✏️ Edit user details

❌ Delete users

🌐 API endpoints:

GET /api/users → list users (JSON)

POST /api/users → add user

🐛 Troubleshooting

Port 8080 already in use → run with another port:

docker run -p 8081:8080 go-web-app


App not running → check container:

docker ps

📸 Demo

Add screenshot of dashboard UI here

📄 License

MIT License – see LICENSE









