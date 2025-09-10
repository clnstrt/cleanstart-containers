# 🐍 Python Sample Projects

This directory contains sample projects for testing the `cleanstart/python` Docker image that you already pulled from Docker Hub. These examples demonstrate Python applications for web development, data processing, and automation.

## 🚀 Quick Start

### Prerequisites
- Docker installed and running
- Port 5000 available (optional)

### Setup
```bash
# Navigate to this directory
cd containers/python/sample-project

# Test the image (you already pulled cleanstart/python:latest from Docker Hub)
docker run --rm cleanstart/python:latest python --version
```

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

## 🤝 Contributing

To add new Python applications:
1. Create Python file in appropriate directory
2. Add documentation
3. Test with Python
