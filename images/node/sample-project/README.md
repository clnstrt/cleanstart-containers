# Node.js User Management Application

A simple web application built with Node.js and Express for managing users with SQLite database.

## Features

- **User Management**: Create, read, and delete users
- **Web Interface**: Clean Bootstrap-based UI
- **REST API**: Full CRUD operations via API endpoints
- **SQLite Database**: Lightweight database storage
- **Health Check**: Docker health monitoring endpoint
- **Docker Support**: Containerized application

## Technology Stack

- **Node.js 18+**: JavaScript runtime
- **Express**: Web framework
- **SQLite**: Database
- **EJS**: Template engine
- **Bootstrap 5**: UI framework

## Quick Start

### Prerequisites

- Node.js 18 or higher
- npm (comes with Node.js)

### Local Development

1. **Install dependencies**:
   ```bash
   npm install
   ```

2. **Run the application**:
   ```bash
   npm start
   ```

3. **Access the application**:
   - Web interface: http://localhost:3000
   - Health check: http://localhost:3000/health

### Development Mode

For development with auto-reload:
```bash
npm run dev
```

### Using Docker

1. **Build the image**:
   ```bash
   docker build -t nodejs-user-app .
   ```

2. **Run the container**:
   ```bash
   docker run -p 3000:3000 nodejs-user-app
   ```

3. **Access the application**:
   - Web interface: http://localhost:3000
   - Health check: http://localhost:3000/health

## API Endpoints

### Web Interface
- `GET /` - Display all users
- `GET /add` - Show add user form
- `POST /add` - Create a new user
- `POST /delete/:id` - Delete a user
- `POST /reset` - Reset database (delete all users)

### REST API
- `GET /api/users` - Get all users (JSON)
- `POST /api/users` - Create a new user (JSON)
- `GET /api/users/:id` - Get a specific user (JSON)
- `DELETE /api/users/:id` - Delete a user (JSON)
- `GET /health` - Health check (JSON)

### API Examples

**Get all users**:
```bash
curl http://localhost:3000/api/users
```

**Create a user**:
```bash
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe","email":"john@example.com"}'
```

**Get a specific user**:
```bash
curl http://localhost:3000/api/users/1
```

**Delete a user**:
```bash
curl -X DELETE http://localhost:3000/api/users/1
```

**Health check**:
```bash
curl http://localhost:3000/health
```

## Database Schema

```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Development

### Project Structure
```
sample-project/
├── app.js              # Main application file
├── package.json        # Node.js dependencies
├── Dockerfile          # Docker configuration
├── README.md           # This file
├── test_app.js         # Test script
├── views/              # EJS templates
│   ├── layout.ejs      # Base layout
│   ├── index.ejs       # User list page
│   └── add_user.ejs    # Add user form
└── users.db            # SQLite database (created automatically)
```

### Environment Variables
- `PORT`: Server port (default: 3000)
- `NODE_ENV`: Environment (development/production)

### Scripts
- `npm start`: Start the application
- `npm run dev`: Start with nodemon for development
- `npm test`: Run tests

## Testing

The application includes basic error handling and validation:
- Email uniqueness validation
- Required field validation
- SQL injection prevention
- Error responses for API endpoints

Run the test script:
```bash
npm test
```

## Security Features

- SQL injection prevention using parameterized queries
- Input validation and sanitization
- Non-root user in Docker container
- Health check endpoint for monitoring

## Comparison with Other Languages

This Node.js application provides the same functionality as the Python (Flask), Java (Spring Boot), and Ruby (Sinatra) versions:
- Similar web interface
- Identical API endpoints
- Same database schema
- Docker containerization
- Health monitoring

## License

This project is part of the cleanstart-containers collection.
