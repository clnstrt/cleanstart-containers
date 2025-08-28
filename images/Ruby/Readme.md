# Ruby Examples

This directory contains Ruby examples for the cleanstart-containers project.

## Next Steps for Sample Project Testing

You have already pulled the Ruby image from Docker Hub and run the container. Now you can test the complete sample project to verify the image functionality.

## Available Examples

### sample-project
A complete web application built with Ruby and Sinatra that demonstrates:
- User management with SQLite database
- Web interface with Bootstrap
- REST API endpoints
- Docker containerization
- Health monitoring

## Sample Project Testing Results

The Ruby sample project has been thoroughly tested and verified to work perfectly:

### ✅ Verified Features
- **Web Interface**: Bootstrap-based UI accessible at `http://localhost:4567`
- **Health Check**: Endpoint at `http://localhost:4567/health` returns status
- **REST API**: Full CRUD operations for user management
- **Database**: SQLite with proper schema and operations
- **Docker Support**: Containerized application working flawlessly
- **Security**: Non-root user implementation in container

### ✅ API Endpoints Tested
- `GET /health` - Health check endpoint
- `GET /api/users` - List all users
- `POST /api/users` - Create new user
- `GET /` - Web interface for user management

### ✅ User Experience Flow
1. User pulls `cleanstart/ruby` from Docker Hub ✅
2. User runs the container to get started ✅
3. User navigates to sample project from GitHub ✅
4. User runs the application using provided scripts ✅
5. Application works perfectly with all features ✅

## Quick Start

### Option 1: Using Docker (Recommended)
```bash
# Navigate to sample project
cd sample-project

# Run with PowerShell (Windows)
PowerShell -ExecutionPolicy Bypass -File run_local.ps1

# Run with bash (Linux/macOS)
chmod +x run_local.sh
./run_local.sh

# Run with batch (Windows)
run_local.bat
```

### Option 2: Manual Setup
1. Navigate to the sample project:
   ```bash
   cd sample-project
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Run the application:
   ```bash
   ruby app.rb
   ```

4. Access the web interface at http://localhost:4567

## Docker Support

All Ruby examples include Docker support for easy deployment:

```bash
# Run the container
docker run -p 4567:4567 ruby-app
```

## Technology Stack

- **Ruby 3.2**: Modern Ruby version
- **Sinatra**: Lightweight web framework
- **SQLite**: Embedded database
- **Bootstrap**: UI framework
- **Docker**: Containerization

## Testing and Validation

The Ruby sample project has been tested and validated to ensure:
- ✅ All API endpoints work correctly
- ✅ Database operations function properly
- ✅ Web interface is responsive and user-friendly
- ✅ Docker containerization works seamlessly
- ✅ Health monitoring is functional
- ✅ Security best practices are implemented

## Comparison with Other Languages

The Ruby examples provide equivalent functionality to the Python and Java versions:
- Same web interface design
- Identical API endpoints
- Consistent database schema
- Docker containerization
- Health check endpoints

## Troubleshooting

If you encounter any issues:
1. Ensure Docker is running
2. Check that port 4567 is available
3. Use the provided run scripts for automatic setup
4. Verify all dependencies are installed correctly
