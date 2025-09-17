# Flask User Management Application

A comprehensive Flask web application demonstrating user CRUD operations with SQLite database, complete with testing suite and Docker support.

## Features

- **User Management**: Create, read, update, and delete users
- **Web Interface**: HTML forms for user interaction
- **REST API**: JSON API endpoints for programmatic access
- **Database**: SQLite database with automatic initialization
- **Testing**: Comprehensive unit and integration tests
- **Docker Support**: Containerized application with optimized Dockerfile
- **Health Checks**: Built-in health monitoring endpoint

## Quick Start

### Using Docker (Recommended)

```bash
# Build the Docker image
docker build -t flask-user-management .

# Run the container
docker run -p 5000:5000 flask-user-management

# Access the application
open http://localhost:5000
```

### Local Development

```bash
# Install dependencies
pip install -r requirements.txt

# Run the application
python app.py

# Access the application
open http://localhost:5000
```

## Testing

### Run All Tests

```bash
# Make the test runner executable and run all tests
chmod +x test_runner.sh
./test_runner.sh
```

### Run Specific Tests

```bash
# Unit tests only
python -m pytest test_app.py -v

# Integration tests only
python integration_test.py

# Specific test
python run_tests.py test_index_page
```

### Test Coverage

The test suite includes:
- **Unit Tests**: Individual function and endpoint testing
- **Integration Tests**: Full application workflow testing
- **API Tests**: REST endpoint validation
- **Form Tests**: HTML form submission testing
- **Database Tests**: SQLite database operations
- **Docker Tests**: Container build and runtime testing

## API Endpoints

### Web Interface
- `GET /` - Home page with user list
- `GET /add` - Add user form
- `POST /add` - Submit new user

### REST API
- `GET /api/users` - Get all users
- `POST /api/users` - Create new user
- `GET /api/users/<id>` - Get specific user
- `DELETE /api/users/<id>` - Delete user
- `GET /health` - Health check

### Example API Usage

```bash
# Create a user
curl -X POST http://localhost:5000/api/users \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe", "email": "john@example.com"}'

# Get all users
curl http://localhost:5000/api/users

# Get specific user
curl http://localhost:5000/api/users/1

# Delete user
curl -X DELETE http://localhost:5000/api/users/1
```

## Project Structure

```
sample-project/
├── app.py                 # Main Flask application
├── requirements.txt       # Python dependencies
├── Dockerfile            # Docker configuration
├── test_app.py           # Unit tests
├── integration_test.py   # Integration tests
├── run_tests.py          # Test runner script
├── test_runner.sh        # Comprehensive test script
├── pytest.ini           # Pytest configuration
├── templates/            # HTML templates
│   ├── index.html
│   └── add_user.html
└── README.md            # This file
```

## Development

### Adding New Features

1. Write tests first (TDD approach)
2. Implement the feature
3. Run tests to ensure everything works
4. Update documentation

### Database Schema

The application uses SQLite with the following schema:

```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 📚 Resources

- [Flask Documentation](https://flask.palletsprojects.com/)
- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [Pytest Documentation](https://docs.pytest.org/)
- [Docker Documentation](https://docs.docker.com/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation
- Adding more tests

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
