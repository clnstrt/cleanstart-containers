# 🚀 Java Web Application

A complete Java web application built with Spring Boot that demonstrates user management with SQLite database, web interface with Thymeleaf templates, and REST API endpoints.

## Quick Start

### Prerequisites
- Docker installed
- CleanStart Java image pulled

### Run the Application
```bash
# Build and run with Docker
docker build -t java-web-app .
docker run -p 8080:8080 java-web-app
```

### Access the Application
- **Web Interface**: http://localhost:8080
- **REST API**: http://localhost:8080/api/users

## Features
- User management with SQLite database
- Thymeleaf-based web interface
- REST API endpoints for CRUD operations
- Docker containerization
- Health monitoring

## API Endpoints
- `GET /api/users` - List all users
- `POST /api/users` - Create new user
- `GET /` - Web interface for user management

## 📚 Resources
- [CleanStart Website](https://cleanstart.com/)
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)