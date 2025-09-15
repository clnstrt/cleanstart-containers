# 🚀 PostgreSQL Sample Project

A complete **PostgreSQL Web Application** demonstrating database operations with a beautiful web interface. This project showcases PostgreSQL integration with Flask web framework, featuring user management, post creation, and real-time database operations.

## 🌟 Features

- **User Management**: Add, view, and manage users
- **Post System**: Create and view posts with user associations
- **Real-time Database**: Live database operations with PostgreSQL
- **Web Interface**: Beautiful, responsive web UI
- **Production Ready**: Health checks, auto-restart, and security features
- **Docker Support**: Easy deployment with Docker Compose

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Web browser (Chrome, Firefox, Safari, etc.)

### Step 1: Clone and Navigate
```bash
git clone <repository-url>
cd containers/postgres/sample-project
```

### Step 2: Run the Application
```bash
docker-compose -f docker-compose.working.yml up --build
```

### Step 3: Access the Application
Open your browser and go to: **http://localhost:5000**

### Step 4: Explore Features
- **Home**: `http://localhost:5000` - Welcome page
- **Users**: `http://localhost:5000/users` - View all users
- **Add User**: `http://localhost:5000/add_user` - Create new users
- **Posts**: `http://localhost:5000/posts` - View all posts
- **Add Post**: `http://localhost:5000/add_post` - Create new posts

### Step 5: Stop the Application
```bash
docker-compose -f docker-compose.working.yml down
```

## 🐳 Docker Commands

### Start the Application
```bash
docker-compose -f docker-compose.working.yml up --build
```

### Start in Background (Detached Mode)
```bash
docker-compose -f docker-compose.working.yml up -d --build
```

### View Logs
```bash
docker-compose -f docker-compose.working.yml logs -f
```

### Stop the Application
```bash
docker-compose -f docker-compose.working.yml down
```

### Stop and Remove Volumes (Clean Reset)
```bash
docker-compose -f docker-compose.working.yml down -v
```

## 🗄️ Database Access

### Connect to PostgreSQL Database
```bash
docker exec -it postgres-db-working psql -U postgres -d helloworld
```

### View Database Tables
```sql
\dt
```

### View Users Table
```sql
SELECT * FROM users;
```

### View Posts Table
```sql
SELECT * FROM posts;
```

### Exit Database
```sql
\q
```

## 📁 Project Structure

```
sample-project/
├── app.py                          # Main Flask application
├── requirements.txt                 # Python dependencies
├── Dockerfile                      # Web application container
├── docker-compose.working.yml      # Working Docker Compose setup
├── docker-compose.cleanstart.yml   # CleanStart PostgreSQL setup
├── hello_world.sql                 # Simple SQL demo script
├── templates/                      # HTML templates
│   ├── base.html
│   ├── index.html
│   ├── users.html
│   ├── add_user.html
│   └── add_post.html
└── README.md                       # This file
```

## 🔧 Configuration

### Environment Variables
- `DB_HOST`: Database host (default: db)
- `DB_NAME`: Database name (default: helloworld)
- `DB_USER`: Database user (default: postgres)
- `DB_PASSWORD`: Database password (default: password)
- `DB_PORT`: Database port (default: 5432)
- `FLASK_ENV`: Flask environment (default: production)

### Ports
- **5000**: Web application
- **5433**: PostgreSQL database (external access)

## 🛠️ Development

### Local Development Setup
1. Install Python 3.9+
2. Install PostgreSQL
3. Create virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # Linux/Mac
   # or
   venv\Scripts\activate     # Windows
   ```
4. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
5. Run the application:
   ```bash
   python app.py
   ```

### Adding New Features
1. Modify `app.py` for new routes
2. Update templates in `templates/` directory
3. Add new database tables in `init_database()` function
4. Test with Docker Compose

## 🐛 Troubleshooting

### Common Issues

#### Port Already in Use
```bash
# Check what's using port 5000
lsof -i :5000  # Linux/Mac
netstat -ano | findstr :5000  # Windows

# Use different port
docker-compose -f docker-compose.working.yml up --build -p 5001:5000
```

#### Database Connection Issues
```bash
# Check database container status
docker ps | grep postgres

# Check database logs
docker logs postgres-db-working

# Restart database
docker restart postgres-db-working
```

#### Application Won't Start
```bash
# Check all container logs
docker-compose -f docker-compose.working.yml logs

# Rebuild from scratch
docker-compose -f docker-compose.working.yml down -v
docker-compose -f docker-compose.working.yml up --build
```

### Health Checks
- **Database**: `pg_isready -U postgres`
- **Web App**: `curl -f http://localhost:5000/health`

## 🎯 Learning Objectives

This project demonstrates:
- **Database Design**: User and Post relationships
- **Web Development**: Flask framework usage
- **Database Operations**: CRUD operations (Create, Read, Update, Delete)
- **Containerization**: Docker and Docker Compose
- **Production Deployment**: Health checks, security, monitoring
- **API Design**: RESTful endpoints
- **Frontend Integration**: HTML templates with Flask

## 📚 Resources

- [Flask Documentation](https://flask.palletsprojects.com/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [CleanStart Containers](https://cleanstart.com/)

## 🤝 Contributing

Feel free to contribute by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation
- Adding new sample projects

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

**Happy Learning! 🚀**

*This sample project is designed for developers learning PostgreSQL, Flask, and Docker. Perfect for students, beginners, and anyone exploring modern web development with databases.*

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [PostgreSQL Official Documentation](https://www.postgresql.org/docs/)
- [PostgreSQL Tutorial](https://www.postgresqltutorial.com/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).

---

**Happy Database Learning! 🚀**

*This guide was created specifically for college students who are new to programming. If you found it helpful, share it with your classmates!*
