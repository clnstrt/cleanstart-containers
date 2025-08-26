# App4 - Go Programming Examples

This directory contains comprehensive Go programming examples demonstrating database operations with SQLite, web development with the Gin framework, and modern UI design. These examples mirror the functionality of Java and Python examples in other app folders, providing a complete learning path for Go web development.

## 📁 Directory Structure

```
app4/test/
├── go/                    # Simple Go database example (command-line)
│   ├── database_example.go
│   ├── go.mod
│   ├── Dockerfile
│   └── README.md
├── go-web/               # Go web application with database
│   ├── main.go
│   ├── go.mod
│   ├── templates/
│   │   ├── index.html
│   │   ├── add_user.html
│   │   ├── edit_user.html
│   │   └── error.html
│   ├── Dockerfile
│   └── README.md
└── README.md            # This file
```

## 🚀 Quick Start

### Prerequisites Check
First, ensure you have Go and GCC installed:
```bash
go version
gcc --version
```

### Option 1: Simple Database Example (Command Line)
```bash
cd containers/app4/test/go
go mod tidy
go run database_example.go
```

**Expected Output:**
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
```

### Option 2: Web Application
```bash
cd containers/app4/test/go-web
go mod tidy
go run main.go
```

**Access the application:**
- **Local**: http://localhost:8080
- **WSL/Remote**: http://[WSL-IP]:8080 (e.g., http://172.28.42.146:8080)

**Features available:**
- View all users in a table format
- Add new users via web form
- Edit existing users
- Delete users with confirmation
- REST API endpoints for programmatic access

## 📋 Examples Overview

### 1. Simple Database Example (`go/`)
- **Purpose**: Demonstrates basic SQLite operations in Go
- **Features**: Create database, insert users, query and display data
- **Usage**: Command-line application
- **Similar to**: Python example in `app3/test/python/`

### 2. Web Application (`go-web/`)
- **Purpose**: Full web interface for database operations
- **Features**: CRUD operations, REST API, modern UI
- **Usage**: Web application with browser interface
- **Similar to**: Java Spring Boot example in `app1/test/java-web/`

## 🔧 Prerequisites

- **Go 1.21 or higher** (tested with Go 1.22.2)
- **GCC compiler** (required for SQLite CGO support)
- **Internet connection** (to download dependencies)
- **Modern web browser** (for web application)

## 🛠️ Installation

### Ubuntu/Debian
```bash
sudo apt update
sudo apt install golang-go gcc
```

### CentOS/RHEL/Fedora
```bash
sudo yum install golang gcc
# or
sudo dnf install golang gcc
```

### macOS
```bash
brew install go
xcode-select --install
```

## 🐳 Docker Support

Both examples include optimized Dockerfiles for containerized deployment:

### Simple Example
```bash
cd containers/app4/test/go
docker build -t go-database-example .
docker run go-database-example
```

### Web Application
```bash
cd containers/app4/test/go-web
docker build -t go-web-app .
docker run -p 8080:8080 go-web-app
# Access at http://localhost:8080
```

### Docker Compose (Optional)
Create a `docker-compose.yml` file for easy management:
```yaml
version: '3.8'
services:
  go-web-app:
    build: ./go-web
    ports:
      - "8080:8080"
    environment:
      - GIN_MODE=release
```

## 📚 Learning Path

1. **Start with Simple Example**: Understand basic Go database operations
   - Database connection and table creation
   - CRUD operations with SQLite
   - Error handling in Go
   - Struct definitions and methods

2. **Move to Web Application**: Learn web development with Gin framework
   - HTTP routing and middleware
   - Template rendering with Go templates
   - Form handling and validation
   - RESTful API design

3. **Explore Advanced Features**: 
   - Database transactions
   - Input validation and sanitization
   - Error handling and logging
   - Security best practices

4. **Deploy and Scale**: 
   - Docker containerization
   - Production considerations
   - Performance optimization

## 🔍 Key Features Demonstrated

### Go Language Features
- **Structs and methods**: User struct with database operations
- **Error handling**: Comprehensive error checking and logging
- **Database/SQL interface**: Standard library database/sql with SQLite
- **HTTP web framework**: Gin framework for routing and middleware
- **HTML templating**: Go's built-in template engine
- **CGO integration**: SQLite driver with C bindings

### Database Operations
- **SQLite database creation**: File-based database setup
- **CRUD operations**: Complete Create, Read, Update, Delete functionality
- **Parameterized queries**: SQL injection prevention
- **Transaction handling**: Data consistency and integrity
- **Connection management**: Proper database lifecycle management

### Web Development
- **RESTful API design**: JSON endpoints for programmatic access
- **Form handling and validation**: HTML forms with server-side validation
- **Template rendering**: Dynamic HTML generation
- **Static file serving**: CSS, JavaScript, and asset management
- **Error handling**: User-friendly error pages and API responses
- **Responsive design**: Bootstrap 5 for modern UI

## 🎯 Comparison with Other Examples

| Feature | Go (app4) | Java (app1) | Python (app3) |
|---------|-----------|-------------|---------------|
| **Language** | Go | Java | Python |
| **Framework** | Gin | Spring Boot | Flask |
| **Database** | SQLite | SQLite | SQLite |
| **UI Framework** | Bootstrap 5 | Bootstrap 5 | Bootstrap 5 |
| **API Style** | REST | REST | REST |
| **Templates** | Go Templates | Thymeleaf | Jinja2 |
| **Performance** | High (compiled) | High (JVM) | Medium (interpreted) |
| **Memory Usage** | Low | Medium | Low |
| **Deployment** | Single binary | JAR file | Python + dependencies |
| **Learning Curve** | Moderate | Steep | Easy |

## 🚀 API Endpoints

The web application provides the following REST API endpoints:

### Web UI Endpoints
- `GET /` - Main dashboard with user list
- `GET /add` - Add user form
- `POST /add` - Create new user
- `GET /edit/:id` - Edit user form
- `POST /edit/:id` - Update user
- `POST /delete/:id` - Delete user

### REST API Endpoints
- `GET /api/users` - Get all users (JSON)
- `POST /api/users` - Create new user (JSON)

### Example API Usage
```bash
# Get all users
curl http://localhost:8080/api/users

# Create a new user
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Alice Johnson","email":"alice@example.com"}'
```

## 🤝 Contributing

Feel free to contribute by:
- Adding new Go examples
- Improving existing code
- Enhancing documentation
- Adding new features
- Reporting bugs or issues
- Suggesting improvements

## 🐛 Troubleshooting

### Common Issues

**1. "Command 'go' not found"**
```bash
# Install Go on Ubuntu/Debian
sudo apt update && sudo apt install golang-go gcc

# Install Go on macOS
brew install go
```

**2. "CGO_ENABLED=0" errors**
```bash
# Ensure GCC is installed
sudo apt install gcc

# Or disable CGO (not recommended for SQLite)
export CGO_ENABLED=0
```

**3. Template rendering issues**
- Ensure templates are in the correct directory
- Check template syntax for Go template engine
- Verify template file permissions

**4. Database connection errors**
- Check file permissions for database directory
- Ensure SQLite is properly installed
- Verify database file path

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- [Gin Web Framework](https://github.com/gin-gonic/gin) for the excellent HTTP framework
- [SQLite](https://www.sqlite.org/) for the lightweight database
- [Bootstrap](https://getbootstrap.com/) for the UI components
- [Font Awesome](https://fontawesome.com/) for the icons
