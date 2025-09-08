# Go Examples

This directory contains Go examples for the cleanstart-containers project.

## Next Steps for Sample Project Testing

You have already pulled the Go image from Docker Hub and run the container. Now you can test the complete sample project to verify the image functionality.

## Available Examples

### sample-project/go-web
A complete web application built with Go and Gin that demonstrates:
- User management with SQLite database
- Web interface with HTML templates
- REST API endpoints
- Docker containerization
- Health monitoring

## Sample Project Testing Results

The Go sample project has been thoroughly tested and verified to work perfectly:

### ✅ Verified Features
- **Web Interface**: HTML template-based UI accessible at `http://localhost:8080`
- **REST API**: Full CRUD operations for user management
- **Database**: SQLite with proper schema and operations
- **Docker Support**: Containerized application working flawlessly
- **Security**: Non-root user implementation in container

### ✅ API Endpoints Tested
- `GET /api/users` - List all users
- `POST /api/users` - Create new user
- `GET /` - Web interface for user management

### ✅ User Experience Flow
1. User pulls `cleanstart/go` from Docker Hub ✅
2. User runs the container to get started ✅
3. User navigates to sample project from GitHub ✅
4. User runs the application using Docker ✅
5. Application works perfectly with all features ✅

## Quick Start

### Option 1: Using Docker (Recommended)
```bash
# Navigate to sample project
cd sample-project/go-web

# Run the container
docker run -p 8080:8080 go-web-app

# Access the application
open http://localhost:8080
```

### Option 2: Local Development
```bash
# Navigate to sample project
cd sample-project/go-web

# Prerequisites: Go 1.21+
# Install Go from https://golang.org/dl/

# Build and run the application
go mod tidy
go run main.go

# Access the application
open http://localhost:8080
```

## Docker Support

All Go examples include Docker support for easy deployment:

```bash
# Run the container
docker run -p 8080:8080 go-web-app
```

## Technology Stack

- **Go 1.22**: Modern Go version with modules support
- **Gin**: High-performance HTTP web framework
- **SQLite**: Embedded database (using modernc.org/sqlite pure Go driver)
- **HTML Templates**: Server-side templating
- **Docker**: Containerization

## Testing and Validation

The Go sample project has been tested and validated to ensure:
- ✅ All API endpoints work correctly
- ✅ Database operations function properly
- ✅ Web interface is responsive and user-friendly
- ✅ Docker containerization works seamlessly
- ✅ Security best practices are implemented
- ✅ Pure Go SQLite driver works without CGO

## Comparison with Other Languages

The Go examples provide equivalent functionality to the Python, Ruby, Java, and Node.js versions:
- Same web interface design
- Identical API endpoints
- Consistent database schema
- Docker containerization
- Health check endpoints

## Troubleshooting

If you encounter any issues:
1. Ensure Docker is running
2. Check that port 8080 is available
3. Verify Go 1.21+ is installed (for local development)
4. Check the container logs for any errors
5. Ensure the pure Go SQLite driver is being used (no CGO required)
