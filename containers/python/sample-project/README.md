# Execute Python Web Application on CleanStart Container - Python

A modern web application for data processing and automation built with **Python**, **Flask**, and **SQLite**.

## Objective

The objective of this project is to utilize CleanStart Container Image - Python and build a lightweight, containerized web application in Python that provides data processing capabilities and automation tools.

## Summary

This project demonstrates how to combine Python, Flask, SQLite, and CleanStart to create a modern web application. It offers both web-based interfaces and API endpoints for data processing—supporting various Python applications—packaged in a Dockerized environment for easy deployment and scalability.

## Quick Start - Run Locally

### Prerequisites
Pull CleanStart Python image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/python:latest
```

### Step 1: Navigate to Python Directory
```bash
cd containers/python/sample-project
```

### Step 2: Run Python Application
```bash
# Run Python web app
docker run --rm -p 5000:5000 -v $(pwd)/python:/app \
  cleanstart/python:latest python /app/database_example.py

# Access at http://localhost:5000
```

### Step 3: Run Database Operations
```bash
# Run database example
docker run --rm -v $(pwd)/python:/app \
  cleanstart/python:latest python /app/database_example.py

# Check database file
docker run --rm -v $(pwd)/python:/app \
  cleanstart/python:latest ls -la /app/users.db
```

### Step 4: Run with Docker Compose
```bash
# Start Python application
docker-compose up -d

# Access application
curl http://localhost:5000
```

### Python Output
You should see output like this:
```
Collecting flask
  Downloading Flask-2.3.3-py3-none-any.whl
Successfully installed Flask-2.3.3 Werkzeug-2.3.7 click-8.1.7 itsdangerous-2.1.2 jinja2-3.1.2 markupsafe-2.1.3
Database created successfully
Table created successfully
User inserted successfully
User inserted successfully
User inserted successfully
All users:
ID: 1, Name: John Doe, Email: john@example.com
ID: 2, Name: Jane Smith, Email: jane@example.com
ID: 3, Name: Bob Johnson, Email: bob@example.com
Starting Python web server on http://localhost:5000
```

### Application Access
Once started, you can access the application at: **http://localhost:5000**

### Run Examples

#### Basic Python Application
```bash
# Run Python web app
docker run --rm -p 5000:5000 -v $(pwd)/python:/app \
  cleanstart/python:latest python /app/database_example.py

# Access at http://localhost:5000
```

#### Database Operations
```bash
# Run database example
docker run --rm -v $(pwd)/python:/app \
  cleanstart/python:latest python /app/database_example.py

# Check database file
docker run --rm -v $(pwd)/python:/app \
  cleanstart/python:latest ls -la /app/users.db
```

#### Using Docker Compose
```bash
# Start Python application
docker-compose up -d

# Access application
curl http://localhost:5000
```

## 📁 Project Structure

```
sample-project/
├── README.md                    # This file
├── python/                     # Python examples
│   ├── database_example.py     # Database operations
│   ├── users.db               # SQLite database
│   └── README.md              # Python guide
└── README.md                   # Main guide
```

## 🎯 Features

- Python web applications
- Database operations (SQLite)
- File processing
- Web scraping
- Data analysis
- Automation scripts
- RESTful APIs

## 📊 Output

Python applications generate:
- Web application responses
- Database files and records
- Processed data files
- Log files and reports

## 🔒 Security

- Non-root user execution
- Secure Python configurations
- Input validation
- Error handling

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [Python Official Documentation](https://docs.python.org/)
- [Flask Documentation](https://flask.palletsprojects.com/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
