# PostgreSQL Sample Web Application

A complete web application that demonstrates PostgreSQL database integration with Flask. This project shows how to build a simple blog/forum application with user management and post creation.

## Features

- **User Management**: Add and view users
- **Post Management**: Create and view posts
- **Database Integration**: Full PostgreSQL integration with Flask
- **Modern UI**: Bootstrap-based responsive design
- **Health Checks**: Built-in health monitoring
- **Docker Support**: Complete containerization

## Project Structure

```
sample-project/
├── app.py                 # Main Flask application
├── requirements.txt       # Python dependencies
├── Dockerfile            # Docker configuration
├── README.md             # This file
└── templates/            # HTML templates
    ├── base.html         # Base template
    ├── index.html        # Home page
    ├── users.html        # Users list
    ├── add_user.html     # Add user form
    └── add_post.html     # Add post form
```

## Database Schema

### Users Table
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Posts Table
```sql
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    user_id INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Quick Start

### Using Docker Compose (Recommended)

1. **Create docker-compose.yml:**
   ```yaml
   version: '3.8'
   services:
     db:
       image: postgres:15-alpine
       environment:
         POSTGRES_DB: helloworld
         POSTGRES_USER: postgres
         POSTGRES_PASSWORD: password
       ports:
         - "5432:5432"
       volumes:
         - postgres_data:/var/lib/postgresql/data
     
     web:
       build: .
       ports:
         - "5000:5000"
       environment:
         DB_HOST: db
         DB_NAME: helloworld
         DB_USER: postgres
         DB_PASSWORD: password
       depends_on:
         - db
   
   volumes:
     postgres_data:
   ```

2. **Run the application:**
   ```bash
   docker-compose up --build
   ```

3. **Access the application:**
   - Web App: http://localhost:5000
   - Database: localhost:5432

### Using Docker (Manual)

1. **Start PostgreSQL:**
   ```bash
   docker run -d --name postgres-db \
     -e POSTGRES_DB=helloworld \
     -e POSTGRES_USER=postgres \
     -e POSTGRES_PASSWORD=password \
     -p 5432:5432 \
     postgres:15-alpine
   ```

2. **Build and run the web app:**
   ```bash
   docker build -t postgres-web-app .
   docker run -d --name postgres-web \
     -e DB_HOST=host.docker.internal \
     -e DB_NAME=helloworld \
     -e DB_USER=postgres \
     -e DB_PASSWORD=password \
     -p 5000:5000 \
     postgres-web-app
   ```

### Local Development

1. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Set up PostgreSQL database:**
   ```bash
   # Create database
   createdb helloworld
   
   # Or connect to existing database
   psql -U postgres -d helloworld
   ```

3. **Set environment variables:**
   ```bash
   export DB_HOST=localhost
   export DB_NAME=helloworld
   export DB_USER=postgres
   export DB_PASSWORD=your_password
   ```

4. **Run the application:**
   ```bash
   python app.py
   ```

## API Endpoints

- `GET /` - Home page with all posts
- `GET /users` - List all users
- `GET /add_user` - Add user form
- `POST /add_user` - Create new user
- `GET /add_post` - Add post form
- `POST /add_post` - Create new post
- `GET /health` - Health check endpoint

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DB_HOST` | `localhost` | PostgreSQL host |
| `DB_NAME` | `helloworld` | Database name |
| `DB_USER` | `postgres` | Database username |
| `DB_PASSWORD` | `password` | Database password |
| `DB_PORT` | `5432` | Database port |
| `PORT` | `5000` | Web application port |

## Database Operations

### Connect to Database
```bash
# Using Docker
docker exec -it postgres-db psql -U postgres -d helloworld

# Using local PostgreSQL
psql -U postgres -d helloworld
```

### Useful SQL Queries
```sql
-- View all users
SELECT * FROM users;

-- View all posts with author names
SELECT p.title, p.content, u.name as author, p.created_at 
FROM posts p 
LEFT JOIN users u ON p.user_id = u.id;

-- Count posts by user
SELECT u.name, COUNT(p.id) as post_count 
FROM users u 
LEFT JOIN posts p ON u.id = p.user_id 
GROUP BY u.id, u.name;
```

## Health Check

The application includes a health check endpoint at `/health` that verifies database connectivity:

```bash
curl http://localhost:5000/health
```

Response:
```json
{
  "status": "healthy",
  "database": "connected"
}
```

## Troubleshooting

### Database Connection Issues
- Verify PostgreSQL is running
- Check environment variables
- Ensure database exists
- Verify network connectivity (if using Docker)

### Permission Issues
- Check database user permissions
- Verify file permissions in Docker container

### Port Conflicts
- Change ports in docker-compose.yml or Docker run commands
- Check if ports are already in use

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is open source and available under the MIT License.

---

**Enjoy building with PostgreSQL! 🐘**
