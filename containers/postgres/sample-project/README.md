# 🚀 PostgreSQL Sample Project

A complete **PostgreSQL Web Application** demonstrating database operations with CleanStart containers.

## 🌟 Features

- **Web Application**: Flask app with user management and post system
- **Docker Ready**: Easy deployment with Docker Compose
- **CleanStart Integration**: Uses CleanStart PostgreSQL container

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed

### Step 1: Pull CleanStart PostgreSQL Image

```bash
# Pull the CleanStart PostgreSQL image
docker pull cleanstart/postgres:latest
```

**Why this command?** This ensures you have the latest CleanStart PostgreSQL image locally before running the application.

### Step 2: Start the Application

```bash
# Start the full application with CleanStart PostgreSQL
docker-compose up --build -d
```

**Why this command?**
- `--build`: Rebuilds the web application container to ensure latest code
- `-d`: Runs containers in detached mode (background)
- Uses CleanStart PostgreSQL container as specified in docker-compose.yml

### Step 3: Access the Web Interface

**Open your browser and visit:**
- **Main page**: `http://localhost:5000`
- **Users page**: `http://localhost:5000/users`
- **Add User**: `http://localhost:5000/add_user`

**Why these URLs?** The web application runs on port 5000, and these are the main routes for testing database operations.

### Step 4: Stop the Application

```bash
# Stop all containers and clean up
docker-compose down
```

**Why this command?** Gracefully stops all containers and removes the network, freeing up system resources.

## 📁 Project Structure

```
sample-project/
├── app.py                    # Flask web application
├── Dockerfile                # Web app container definition
├── docker-compose.yml        # Complete application setup
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