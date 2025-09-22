# CRUD Sample Application

A Flask-based web application demonstrating CRUD operations with SQLite database.

## Features

- Full CRUD operations (Create, Read, Update, Delete users)
- Web interface with Bootstrap 5
- REST API endpoints
- SQLite database
- Docker support with cleanstart base image

## Quick Start

### Docker (Recommended)
```bash
docker build -t crud-sample-app .
docker run -d -p 5000:5000 --name crud-app crud-sample-app
```

### Docker Compose
```bash
docker-compose up -d
```

### Local Development
```bash
pip install -r requirements.txt
python app.py
```

## Access

- **Web Interface**: http://localhost:5000
- **Health Check**: http://localhost:5000/health
- **API**: http://localhost:5000/api/users

## API Examples

```bash
# Create user
curl -X POST http://localhost:5000/api/users \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe", "email": "john@example.com", "age": 30}'

# Get all users
curl http://localhost:5000/users

# Update user
curl -X PUT http://localhost:5000/api/users/1 \
  -H "Content-Type: application/json" \
  -d '{"name": "Jane Doe", "email": "jane@example.com"}'

# Delete user
curl -X DELETE http://localhost:5000/api/users/1
```

## Project Structure

```
sample-project/
├── app.py              # Main Flask application
├── requirements.txt    # Python dependencies
├── Dockerfile         # Docker configuration
├── docker-compose.yml # Docker Compose setup
├── models/            # Database models
│   ├── database.py    # Database configuration
│   └── user.py       # User model
└── templates/         # HTML templates
    ├── base.html
    ├── index.html
    ├── create_user.html
    └── edit_user.html
```

## Environment Variables

- `FLASK_ENV`: Flask environment (default: production)
- `PORT`: Application port (default: 5000)
- `DATABASE_PATH`: SQLite database path (default: users.db)
- `SECRET_KEY`: Flask secret key

## Database Schema

```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    age INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```
