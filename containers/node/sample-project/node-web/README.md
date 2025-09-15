# 🚀 Node.js Web Application

A complete Node.js web application built with Express and EJS templates that demonstrates user management with a web interface and REST API endpoints.

## Quick Start

### Prerequisites
- Docker installed
- CleanStart Node.js image pulled

### Run the Application
```bash
# Build and run with Docker
docker build -t node-web-app .
docker run -p 3000:3000 node-web-app
```

### Access the Application
- **Web Interface**: http://localhost:3000
- **REST API**: http://localhost:3000/api/users
- **Health Check**: http://localhost:3000/health

## Features
- User management with in-memory storage
- EJS-based web interface
- REST API endpoints for CRUD operations
- Docker containerization
- Health monitoring

## API Endpoints
- `GET /` - Home page with user list
- `GET /add-user` - Add user form
- `POST /add-user` - Create new user
- `GET /api/users` - List all users (JSON)
- `POST /api/users` - Create new user (JSON)
- `GET /health` - Health check endpoint

## 📚 Resources
- [CleanStart Website](https://cleanstart.com/)
- [Express.js Documentation](https://expressjs.com/)
- [EJS Documentation](https://ejs.co/)
