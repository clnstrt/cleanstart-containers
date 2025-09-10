# 🚀 Go Web Application

A simple **User Management System** built with Go.

## 📂 Project Structure
```bash
go-web/
├── main.go          # Application entry point
├── go.mod           # Dependencies
├── go.sum           # Dependency checksums
├── templates/       # HTML templates
│   ├── index.html   # Main page
│   ├── add_user.html
│   └── edit_user.html
├── users.db         # SQLite database
├── Dockerfile       # Build instructions
└── docker-compose.yml #For service up an down
```

## ⚡ Quick Start

# Build the Docker image
```bash
docker build -t go-web-app .
```

# Run the container
```bash
docker run -p 8080:8080 go-web-app
```

# To up the service of application so you dont need to do manual process again So we can use docker compose yaml file so we can up the servcies
```bash
docker compose up
```

## 🌐 Access the App
http://localhost:8080

## 🎮 Features
- Add new users  
- View all users  
- Edit user details  
- Delete users  
