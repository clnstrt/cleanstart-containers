# PostgreSQL Examples

This directory contains PostgreSQL examples for the cleanstart-containers project.

## Next Steps for Sample Project Testing

You have already pulled the PostgreSQL image from Docker Hub and run the container. Now you can test the complete sample project to verify the image functionality.

## Available Examples

### sample-project
A complete web application built with Flask and PostgreSQL that demonstrates:
- User management with PostgreSQL database
- Post management with user relationships
- Web interface with HTML templates
- Docker Compose setup with database and web app
- Health monitoring

## Sample Project Testing Results

The PostgreSQL sample project has been thoroughly tested and verified to work perfectly:

### ✅ Verified Features
- **Web Interface**: HTML template-based UI accessible at `http://localhost:5000`
- **Database**: PostgreSQL with proper schema and relationships
- **Docker Support**: Containerized application with Docker Compose
- **Security**: Non-root user implementation in container
- **Health Check**: Database connectivity verification

### ✅ Endpoints Tested
- `GET /health` - Health check with database status
- `GET /` - Home page with posts listing
- `GET /users` - Users management page
- `GET /add_user` - Add user form
- `GET /add_post` - Add post form

### ✅ User Experience Flow
1. User pulls `cleanstart/postgres` from Docker Hub ✅
2. User runs the container to get started ✅
3. User navigates to sample project from GitHub ✅
4. User runs the application using Docker Compose ✅
5. Application works perfectly with all features ✅

## Quick Start

### Option 1: Using Docker Compose (Recommended)
```bash
# Navigate to sample project
cd sample-project

# Start the application
docker-compose up -d

# Access the application
open http://localhost:5000

# Check health
curl http://localhost:5000/health
```

### Option 2: Local Development
```bash
# Navigate to sample project
cd sample-project

# Prerequisites: Python 3.12+, PostgreSQL
# Install dependencies
pip install -r requirements.txt

# Set up PostgreSQL database
# Update environment variables in app.py

# Run the application
python app.py

# Access the application
open http://localhost:5000
```

## Docker Support

The PostgreSQL sample project includes comprehensive Docker support:

```bash
# Using Docker Compose (recommended)
docker-compose up -d

# Or run manually
docker run -p 5000:5000 postgres-web-app
```

## Technology Stack

- **PostgreSQL 15**: Robust relational database
- **Flask**: Python web framework
- **psycopg2**: PostgreSQL adapter for Python
- **HTML Templates**: Server-side templating
- **Docker Compose**: Multi-container orchestration

## Database Schema

The application creates two main tables:

```sql
-- Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Posts table with user relationship
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    user_id INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Testing and Validation

The PostgreSQL sample project has been tested and validated to ensure:
- ✅ Database connectivity works correctly
- ✅ Web interface is responsive and user-friendly
- ✅ Docker containerization works seamlessly
- ✅ Security best practices are implemented
- ✅ Health check endpoints function properly
- ✅ Multi-container setup with Docker Compose works

## Comparison with Other Languages

The PostgreSQL examples provide equivalent functionality to the Python, Ruby, Java, Go, and Node.js versions:
- Same web interface design
- Consistent database schema
- Docker containerization
- Health check endpoints
- User and post management

## Troubleshooting

If you encounter any issues:
1. Ensure Docker and Docker Compose are running
2. Check that ports 5000 and 5433 are available
3. Verify PostgreSQL dependencies are installed
4. Check the container logs for any errors
5. Ensure the database connection parameters are correct
