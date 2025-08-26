# App3 - Python Flask Application

A containerized Python Flask web application demonstrating user management with SQLite database integration.

## 🚀 Quick Start

### Using Docker (Recommended)
```bash
# Build the container
docker build -t app3 .

# Run the application
docker run -p 5000:5000 app3

# Access the application
open http://localhost:5000
```

### Local Development
```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run the application
python app.py
```

## 📋 Features

- **User Management**: Add, view, and manage users
- **SQLite Database**: Persistent data storage
- **RESTful API**: JSON endpoints for user operations
- **Web Interface**: HTML templates for user interaction
- **Containerized**: Ready for Docker deployment

## 🏗️ Project Structure

```
app3/
├── Dockerfile          # Container configuration
├── README.md          # This file
├── requirements.txt   # Python dependencies
├── app.py            # Main Flask application
├── src/              # Source code directory
└── test/             # Test files and examples
    └── python/       # Python database examples
```

## 🔧 API Endpoints

### Web Interface
- `GET /` - Home page with user list
- `GET /add` - Add user form
- `POST /add` - Create new user

### JSON API
- `GET /api/users` - Get all users
- `POST /api/users` - Create new user
- `GET /api/users/<id>` - Get specific user
- `DELETE /api/users/<id>` - Delete user

## 📊 Database Schema

```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE
);
```

## 🛠️ Configuration

### Environment Variables
- `FLASK_ENV` - Set to 'development' for debug mode
- `DATABASE_URL` - SQLite database path (default: users.db)
- `PORT` - Application port (default: 5000)

### Database
The application uses SQLite by default. The database file (`users.db`) is created automatically on first run.

## 🧪 Testing

### Run Database Examples
```bash
cd test/python
python database_example.py
```

### Test Web Application
```bash
# Start the application
python app.py

# Test endpoints
curl http://localhost:5000/api/users
curl -X POST http://localhost:5000/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe","email":"john@example.com"}'
```

## 🐳 Docker

### Build Image
```bash
docker build -t app3 .
```

### Run Container
```bash
docker run -d -p 5000:5000 --name app3-container app3
```

### View Logs
```bash
docker logs app3-container
```

### Stop Container
```bash
docker stop app3-container
docker rm app3-container
```

## 🔍 Troubleshooting

### Common Issues

**Port already in use**
```bash
# Find process using port 5000
lsof -i :5000
# Kill the process or use different port
docker run -p 5001:5000 app3
```

**Database permission issues**
```bash
# Ensure write permissions
chmod 755 .
```

**Dependencies not found**
```bash
# Rebuild container
docker build --no-cache -t app3 .
```

## 📚 Dependencies

- **Flask** - Web framework
- **SQLite3** - Database (built-in)
- **Jinja2** - Template engine
- **Werkzeug** - WSGI utilities

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.
