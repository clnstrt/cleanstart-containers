# Java Examples

This directory contains Java examples for the cleanstart-containers project.

## Next Steps for Sample Project Testing

You have already pulled the Java JDK and JRE images from Docker Hub and run the containers. Now you can test the complete sample project to verify the image functionality.

## Available Examples

### sample-project/java-web
A complete web application built with Java and Spring Boot that demonstrates:
- User management with SQLite database
- Web interface with Thymeleaf templates
- REST API endpoints
- Docker containerization
- Health monitoring

## Sample Project Testing Results

The Java sample project has been thoroughly tested and verified to work perfectly:

### ✅ Verified Features
- **Web Interface**: Thymeleaf-based UI accessible at `http://localhost:8080`
- **REST API**: Full CRUD operations for user management
- **Database**: SQLite with proper schema and operations
- **Docker Support**: Containerized application working flawlessly
- **Security**: Non-root user implementation in container

### ✅ API Endpoints Tested
- `GET /api/users` - List all users
- `POST /api/users` - Create new user
- `GET /` - Web interface for user management

### ✅ User Experience Flow
1. User pulls `cleanstart/jdk` and `cleanstart/jre` from Docker Hub ✅
2. User runs the containers to get started ✅
3. User navigates to sample project from GitHub ✅
4. User runs the application using Docker ✅
5. Application works perfectly with all features ✅

## Quick Start

### Option 1: Using Docker (Recommended)
```bash
# Navigate to sample project
cd sample-project/java-web

# Run the container
docker run -p 8080:8080 java-web-app

# Access the application
open http://localhost:8080
```

### Option 2: Local Development
```bash
# Navigate to sample project
cd sample-project/java-web

# Prerequisites: Java 17+ and Maven
# Install Java 17
sudo apt update && sudo apt install openjdk-17-jdk

# Install Maven
sudo apt install maven

# Build and run the application
mvn clean spring-boot:run

# Access the application
open http://localhost:8080
```

## Docker Support

All Java examples include Docker support for easy deployment:

```bash
# Run the container
docker run -p 8080:8080 java-web-app
```

## Technology Stack

- **Java 17**: Modern Java version with text blocks support
- **Spring Boot 3.1.5**: Enterprise-grade web framework
- **SQLite**: Embedded database
- **Thymeleaf**: Template engine
- **Maven**: Build tool and dependency management
- **Docker**: Containerization

## Testing and Validation

The Java sample project has been tested and validated to ensure:
- ✅ All API endpoints work correctly
- ✅ Database operations function properly
- ✅ Web interface is responsive and user-friendly
- ✅ Docker containerization works seamlessly
- ✅ Security best practices are implemented
- ✅ Maven build process works correctly

## Comparison with Other Languages

The Java examples provide equivalent functionality to the Python, Ruby, and Node.js versions:
- Same web interface design
- Identical API endpoints
- Consistent database schema
- Docker containerization
- Health check endpoints

## Troubleshooting

If you encounter any issues:
1. Ensure Docker is running
2. Check that port 8080 is available
3. Verify Java 17+ and Maven are installed (for local development)
4. Check the container logs for any errors
5. Ensure sufficient memory for Maven build process
