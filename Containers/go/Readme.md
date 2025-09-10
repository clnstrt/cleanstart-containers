# Go Description

This directory contains Go samples and examples for go cleanstart-containers project.

## Next Steps for Sample Project Testing

You should pull the Go image from Docker Hub and run the container. Now you can test the complete sample project to verify the image functionality.

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
1. User pulls `cleanstart/go` from Docker Hub
2. User builds the image with naming convention (for example -> latest-dev:latest/latest:latest)
3. Use the tags and run the image 
4. User runs the container to get started 
5. User navigates to sample project from GitHub 
6. User runs the application using Docker 
7. Application works perfectly with all features 

## Quick Start
Run the hello world file in go
Make sure that hello_world.go is in the directory and it has proper logic and code and execute the docker command 
```bash
docker run --rm -v $(pwd):/app -w /app cleanstart/go:latest run hello_world.go
```

### Option 1: Using Docker (Recommended)
```bash
# Navigate to sample project
cd sample-project/go-web

#Build the image from Dockerfile below are the steps

#Make Dockerfile
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

#Build the image
docker build -t latest-dev -f Dockerfile .


#Run the image
docker run --rm latest-dev:latest

# Run the application
docker run --rm -p 8080:8080 latest-dev:latest

# Access the application
Go to your localhost: http://localhost:8080
```

### Option 2: Local Development
```bash
# Navigate to sample project
cd sample-project/go-web

#Run the application
docker run --rm <image-tag>

# Access the application
open http://localhost:8080
```

## Docker Support

All Go examples include Docker support for easy deployment:

```bash
# Run the container with port expose command
docker run -p 8080:8080 go-web-app
```

## Technology Stack

- **Go**: Modern Go version with modules support
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
3. Check the container logs for any errors
4. Ensure the pure Go SQLite driver is being used (no CGO required)
