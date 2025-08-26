# Ruby User Management Application

A simple web application built with Ruby and Sinatra for managing users with SQLite database.

## Features

- **User Management**: Create, read, and delete users
- **Web Interface**: Clean Bootstrap-based UI
- **REST API**: Full CRUD operations via API endpoints
- **SQLite Database**: Lightweight database storage
- **Health Check**: Docker health monitoring endpoint
- **Docker Support**: Containerized application

## Technology Stack

- **Ruby 3.2**: Programming language
- **Sinatra**: Lightweight web framework
- **SQLite**: Database
- **Bootstrap 5**: UI framework
- **Thin**: Web server

## Quick Start

### Prerequisites

- Ruby 3.2 or higher
- Bundler gem
- Docker (optional, but recommended)

### Option 1: Using Docker (Recommended - No Setup Required)

**On Windows (PowerShell):**
```powershell
.\run_local.ps1
```

**On Linux/macOS:**
```bash
docker build -t ruby-user-app .
docker run -p 4567:4567 ruby-user-app
```

### Option 2: Local Development

**On Linux/macOS:**
```bash
chmod +x run_local.sh
./run_local.sh
```

**On Windows:**
```cmd
run_local.bat
```

### Option 3: Manual Setup

1. **Install Ruby development headers** (required for native extensions):
   ```bash
   sudo apt-get update
   sudo apt-get install -y ruby-dev build-essential
   ```

2. **Install dependencies**:
   ```bash
   bundle config set --local path 'vendor/bundle'
   bundle install
   ```

3. **Run the application**:
   ```bash
   bundle exec ruby app.rb
   ```

4. **Access the application**:
   - Web interface: http://localhost:4567
   - Health check: http://localhost:4567/health

## Troubleshooting

### Permission Issues with Bundle Install

If you encounter permission errors when running `bundle install`, use one of these solutions:

1. **Use local installation** (recommended):
   ```bash
   bundle config set --local path 'vendor/bundle'
   bundle install
   ```

2. **Use the provided scripts**:
   - `run_local.sh` (Linux/macOS)
   - `run_local.bat` (Windows)
   - `run_local.ps1` (PowerShell)

3. **Use Docker** (avoids all permission issues):
   ```bash
   docker build -t ruby-user-app .
   docker run -p 4567:4567 ruby-user-app
   ```

### Missing Ruby Development Headers

If you see errors like "mkmf.rb can't find header files for ruby", install the development headers:

```bash
sudo apt-get update
sudo apt-get install -y ruby-dev build-essential
```

### WSL Environment

If you're using WSL with PowerShell, you may need to:

1. Open a WSL terminal directly
2. Navigate to the project directory
3. Use the Linux commands above

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
curl http://localhost:4567/api/users
```

**Create a user**:
```bash
curl -X POST http://localhost:4567/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe","email":"john@example.com"}'
```

**Get a specific user**:
```bash
curl http://localhost:4567/api/users/1
```

**Delete a user**:
```bash
curl -X DELETE http://localhost:4567/api/users/1
```

**Health check**:
```bash
curl http://localhost:4567/health
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
├── app.rb              # Main application file
├── Gemfile             # Ruby dependencies
├── Dockerfile          # Docker configuration
├── README.md           # This file
├── run_local.sh        # Linux/macOS runner script
├── run_local.bat       # Windows runner script
├── run_local.ps1       # PowerShell runner script
├── test_app.rb         # Test script
├── views/              # HTML templates
│   ├── layout.erb      # Base layout
│   ├── index.erb       # User list page
│   └── add_user.erb    # Add user form
└── users.db            # SQLite database (created automatically)
```

### Environment Variables
- `PORT`: Server port (default: 4567)
- `RACK_ENV`: Environment (development/production)

### Development Server
For development with auto-reload:
```bash
bundle exec rerun ruby app.rb
```

## Testing

The application includes basic error handling and validation:
- Email uniqueness validation
- Required field validation
- SQL injection prevention
- Error responses for API endpoints

Run the test script:
```bash
ruby test_app.rb
```

## Security Features

- SQL injection prevention using parameterized queries
- Input validation and sanitization
- Non-root user in Docker container
- Health check endpoint for monitoring

## Comparison with Other Languages

This Ruby application provides the same functionality as the Python (Flask) and Java (Spring Boot) versions:
- Similar web interface
- Identical API endpoints
- Same database schema
- Docker containerization
- Health monitoring

## License

This project is part of the cleanstart-containers collection.
