# Node.js Examples

This directory contains Node.js examples for the cleanstart-containers project.

## Available Examples

### sample-project
A complete web application built with Node.js and Express that demonstrates:
- User management with SQLite database
- Web interface with Bootstrap
- REST API endpoints
- Docker containerization
- Health monitoring

## Quick Start

1. Navigate to the sample project:
   ```bash
   cd sample-project
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Run the application:
   ```bash
   npm start
   ```

4. Access the web interface at http://localhost:3000

## Docker Support

All Node.js examples include Docker support for easy deployment:

```bash
# Build the image
docker build -t nodejs-app .

# Run the container
docker run -p 3000:3000 nodejs-app
```

## Technology Stack

- **Node.js 18+**: Modern JavaScript runtime
- **Express**: Web framework
- **SQLite**: Embedded database
- **Bootstrap**: UI framework
- **Docker**: Containerization

## Comparison with Other Languages

The Node.js examples provide equivalent functionality to the Python, Java, and Ruby versions:
- Same web interface design
- Identical API endpoints
- Consistent database schema
- Docker containerization
- Health check endpoints
