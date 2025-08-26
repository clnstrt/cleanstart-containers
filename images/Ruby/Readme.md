# Ruby Examples

This directory contains Ruby examples for the cleanstart-containers project.

## Available Examples

### sample-project
A complete web application built with Ruby and Sinatra that demonstrates:
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
# Build the image
docker build -t ruby-app .

# Run the container
docker run -p 4567:4567 ruby-app
```

## Technology Stack

- **Ruby 3.2**: Modern Ruby version
- **Sinatra**: Lightweight web framework
- **SQLite**: Embedded database
- **Bootstrap**: UI framework
- **Docker**: Containerization

## Comparison with Other Languages

The Ruby examples provide equivalent functionality to the Python and Java versions:
- Same web interface design
- Identical API endpoints
- Consistent database schema
- Docker containerization
- Health check endpoints
