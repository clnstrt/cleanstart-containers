# 🚀 PostgreSQL Sample Project

A complete **PostgreSQL Web Application** demonstrating database operations with CleanStart containers.

## 🌟 Features

- **Hello World SQL**: Basic PostgreSQL operations and sample data
- **Web Application**: Flask app with user management and post system
- **Docker Ready**: Easy deployment with Docker Compose
- **CleanStart Integration**: Uses CleanStart PostgreSQL container

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed

### Option 1: Hello World SQL Script

```bash
# Start CleanStart PostgreSQL using docker-compose
docker-compose up db -d

# Wait for database to start (CleanStart PostgreSQL may need more time)
sleep 30

# Check if container is running
docker ps | grep postgres-sample-db

# If container is running, copy and run the script
docker cp hello_world.sql postgres-sample-db:/tmp/hello_world.sql
docker-compose exec db psql -U postgres -d helloworld -f /tmp/hello_world.sql

# Clean up
docker-compose down
```

**Note:** CleanStart PostgreSQL container is the only supported image for this project.

**Expected Output:**
```
NOTICE:  Hello, World!
NOTICE:  Welcome to PostgreSQL!
NOTICE:  Database initialized successfully!
 id |    name     |      email       |         created_at         
----+-------------+------------------+----------------------------
  1 | John Doe    | john@example.com | 2025-09-17 08:06:55.333217
  2 | Jane Smith  | jane@example.com | 2025-09-17 08:06:55.333217
  3 | Bob Johnson | bob@example.com  | 2025-09-17 08:06:55.333217
 total_users 
-------------
           3
```

### Option 2: Complete Web Application

```bash
# Start the full application (uses CleanStart PostgreSQL)
docker-compose up --build -d
```

**Access the web interface:**
- Open browser: `http://localhost:5000`
- Users page: `http://localhost:5000/users`
- Add User: `http://localhost:5000/add_user`

**Note:** Both the hello world script and web application use CleanStart PostgreSQL container.

### Stop the Application

```bash
docker-compose down
```

## 📁 Project Structure

```
sample-project/
├── app.py                    # Flask web application
├── Dockerfile                # Web app container definition
├── docker-compose.yml        # Complete application setup
├── hello_world.sql           # Hello world SQL script
├── requirements.txt          # Python dependencies
└── templates/                # HTML templates
    ├── add_post.html
    ├── add_user.html
    ├── base.html
    ├── index.html
    └── users.html
```

## 🔧 Configuration

- **Database**: `helloworld`
- **User**: `postgres`
- **Password**: `password`
- **Port**: `5433` (external), `5000` (web app)

## 🔧 Troubleshooting

### CleanStart PostgreSQL Container Issues

If the CleanStart PostgreSQL container keeps restarting:

1. **Check container logs:**
   ```bash
   docker-compose logs db
   ```

2. **Verify CleanStart PostgreSQL image:**
   ```bash
   docker pull cleanstart/postgres:latest
   docker run --rm cleanstart/postgres:latest --version
   ```

3. **Contact CleanStart support** if the container continues to have startup issues.

## 📚 Resources

- [CleanStart PostgreSQL Container](https://hub.docker.com/r/cleanstart/postgres)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Flask Documentation](https://flask.palletsprojects.com/)

## 🤝 Contributing

Feel free to contribute by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License

This project is open source and available under the [MIT License](LICENSE).