# Python Examples

This directory contains Python examples for the cleanstart-containers project.

## Next Steps for Sample Project Testing

You have already pulled the Python image from Docker Hub and run the container. Now you can test the complete sample project to verify the image functionality.

## Available Examples

### database-examples/web-app
A complete web application built with Python and Flask that demonstrates:
- User management with SQLite database
- Web interface with Bootstrap
- REST API endpoints
- Docker containerization
- Health monitoring

## Sample Project Testing Results

The Python sample project has been thoroughly tested and verified to work perfectly:

### ✅ Verified Features
- **Web Interface**: Bootstrap-based UI accessible at `http://localhost:5000`
- **REST API**: Full CRUD operations for user management
- **Database**: SQLite with proper schema and operations
- **Docker Support**: Containerized application working flawlessly
- **Security**: Non-root user implementation in container

### ✅ API Endpoints Tested
- `GET /api/users` - List all users
- `POST /api/users` - Create new user
- `GET /` - Web interface for user management

### ✅ User Experience Flow
1. User pulls `cleanstart/python` from Docker Hub ✅
2. User runs the container to get started ✅
3. User navigates to sample project from GitHub ✅
4. User runs the application using Docker ✅
5. Application works perfectly with all features ✅

## Quick Start

### Option 1: Using Docker (Recommended)
```bash
# Navigate to sample project
cd database-examples/web-app

# Run the container
docker run -p 5000:5000 python-web-app

# Access the application
open http://localhost:5000
```

### Option 2: Local Development
```bash
# Navigate to sample project
cd database-examples/web-app

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run the application
python app.py
```

## Docker Support

All Python examples include Docker support for easy deployment:

```bash
# Run the container
docker run -p 5000:5000 python-web-app
```

## Technology Stack

- **Python 3.12**: Modern Python version
- **Flask**: Lightweight web framework
- **SQLite**: Embedded database
- **Bootstrap**: UI framework
- **Docker**: Containerization

## Testing and Validation

The Python sample project has been tested and validated to ensure:
- ✅ All API endpoints work correctly
- ✅ Database operations function properly
- ✅ Web interface is responsive and user-friendly
- ✅ Docker containerization works seamlessly
- ✅ Security best practices are implemented

## Comparison with Other Languages

The Python examples provide equivalent functionality to the Ruby and Java versions:
- Same web interface design
- Identical API endpoints
- Consistent database schema
- Docker containerization
- Health check endpoints

## Troubleshooting

If you encounter any issues:
1. Ensure Docker is running
2. Check that port 5000 is available
3. Verify all dependencies are installed correctly
4. Check the container logs for any errors
