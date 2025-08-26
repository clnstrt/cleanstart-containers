# Java Database Web Application

A modern web interface for SQLite database operations built with **Spring Boot** and **Bootstrap**.

## 🚀 Quick Start - Run Locally

### Prerequisites
- **Java 17 or higher** (JDK, not just JRE) - Required for text blocks feature
- **Maven** (for dependency management)
- **Internet connection** (to download dependencies)

### Step 1: Install Java 17
```bash
# Install Java 17
sudo apt update
sudo apt install openjdk-17-jdk

# Verify Java installation
java -version
# Should show: openjdk version "17.x.x"
```

### Step 2: Install Maven
```bash
# Install Maven
sudo apt install maven

# Verify Maven installation
mvn -version
# Should show: Apache Maven 3.x.x
```

### Step 3: Navigate to Java Web Directory
```bash
cd containers/database-examples/java-web
```

### Step 4: Build and Run the Application
```bash
# Clean and run the application
mvn clean
mvn spring-boot:run
```

### Step 5: Access the Web Application
Open your browser and go to: **http://localhost:8080**

## 🎯 Quick One-Liner Commands

Here's a complete sequence to run everything:
```bash
# Install dependencies and run
sudo apt update && sudo apt install openjdk-17-jdk maven
cd containers/database-examples/java-web
mvn clean spring-boot:run
# Then open http://localhost:8080 in your browser
```

## 📋 Expected Output

### Maven Build Output
You should see output like this:
```
[INFO] Scanning for projects...
[INFO] Downloading dependencies...
[INFO] Compiling 4 source files...
[INFO] BUILD SUCCESS
```

### Spring Boot Startup Output
```
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v3.1.5)

2024-01-01 12:00:00.000  INFO 12345 --- [           main] c.e.DatabaseWebApplication               : Starting DatabaseWebApplication using Java 17
2024-01-01 12:00:00.000  INFO 12345 --- [           main] c.e.DatabaseWebApplication               : Started DatabaseWebApplication in 2.5 seconds (JVM running for 3.2)
```

### Application Access
Once started, you can access the application at: **http://localhost:8080**

## 🔧 Detailed Setup Instructions

### Check Java Installation
```bash
# Verify Java is installed
java -version

# Verify Maven is installed
mvn -version

# Should show something like:
# openjdk version "17.0.26" 2024-01-16
# Apache Maven 3.8.6
```

### Install Dependencies (if needed)

#### Install Java 17+
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install openjdk-17-jdk

# CentOS/RHEL/Fedora
sudo yum install java-17-openjdk-devel
# or
sudo dnf install java-17-openjdk-devel

# macOS
brew install openjdk@17
```

#### Install Maven
```bash
# Ubuntu/Debian
sudo apt install maven

# CentOS/RHEL/Fedora
sudo yum install maven
# or
sudo dnf install maven

# macOS
brew install maven
```

### Run the Application
```bash
# Navigate to the project directory
cd containers/database-examples/java-web

# Clean and build the project
mvn clean compile

# Run the application
mvn spring-boot:run

# Access the application at: http://localhost:8080
```

## 🌐 What You'll See on Localhost

Once you open **http://localhost:8080**, you'll see:

### Home Page Features:
- **Users Table**: Display all users with ID, name, email, and creation date
- **Add User Button**: Add new users to the database
- **Delete Buttons**: Remove users from the database
- **Reset Database Button**: Clear all data and recreate sample users
- **API Testing Section**: Interactive buttons to test REST API endpoints

### Add User Page:
- **Form**: Add new users with name and email validation
- **Quick Add Buttons**: Pre-filled example users for easy testing

## 🔌 API Endpoints

### Web Interface
- `GET /` - Home page with users table
- `GET /add` - Add user form
- `POST /add` - Add new user
- `POST /delete/{id}` - Delete user by ID
- `POST /reset` - Reset database with sample data

### REST API
- `GET /api/users` - Get all users (JSON)
- `POST /api/users` - Add new user (JSON)
- `DELETE /api/users/{id}` - Delete user by ID (JSON)

### API Testing Examples

#### Get all users:
```bash
curl http://localhost:8080/api/users
```

#### Add a new user:
```bash
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com"}'
```

#### Delete a user:
```bash
curl -X DELETE http://localhost:8080/api/users/1
```

## 🗄️ Database Schema

The application uses the same SQLite database structure:

```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 📁 Project Structure

```
java-web/
├── pom.xml                                    # Maven configuration
├── README.md                                  # This file
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── example/
│   │   │           ├── DatabaseWebApplication.java  # Main application
│   │   │           ├── User.java                    # User model
│   │   │           ├── DatabaseService.java         # Database operations
│   │   │           └── UserController.java          # Web controller
│   │   └── resources/
│   │       ├── application.properties               # Configuration
│   │       └── templates/
│   │           ├── index.html                       # Home page
│   │           └── add-user.html                    # Add user form
│   └── test/                                        # Test files
└── target/                                          # Compiled files
```

## 🚨 Troubleshooting

### Common Issues

1. **Java not found or wrong version**
   ```bash
   # Check if Java is installed
   java -version
   
   # Install Java 17 if missing or wrong version
   sudo apt install openjdk-17-jdk  # Ubuntu/Debian
   brew install openjdk@17          # macOS
   
   # Set Java 17 as default (if multiple versions installed)
   sudo update-alternatives --config java
   sudo update-alternatives --config javac
   ```

2. **Text blocks compilation error**
   ```bash
   # This error occurs if using Java < 17
   # Solution: Install Java 17
   sudo apt install openjdk-17-jdk
   java -version  # Should show Java 17
   ```

3. **Maven not found**
   ```bash
   # Check if Maven is installed
   mvn -version
   
   # Install if missing
   sudo apt install maven  # Ubuntu/Debian
   brew install maven      # macOS
   ```

4. **Port 8080 already in use**
   ```bash
   # Kill process using port 8080
   lsof -ti:8080 | xargs kill -9
   
   # Or change port in application.properties
   # Change server.port=8080 to server.port=8081
   
   # Or use different port when running
   mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8081
   # Then access at: http://localhost:8081
   ```

5. **Build errors**
   ```bash
   # Clean and rebuild
   mvn clean compile
   
   # Or force update dependencies
   mvn clean compile -U
   
   # If you get compilation errors, make sure you're using Java 17
   java -version
   ```

### Verification Commands
```bash
# Test Java installation (should be Java 17+)
java -version
mvn -version

# Test the application
mvn spring-boot:run

# Check if application is running
curl http://localhost:8080/api/users

# Check if port 8080 is in use
lsof -i :8080
```

## 🎯 Key Features
- **Spring Boot 3.1.5**: Modern Java web framework
- **Java 17**: Latest LTS version with text blocks support
- **SQLite Database**: File-based database operations
- **Bootstrap UI**: Responsive, modern web interface
- **REST API**: JSON endpoints for programmatic access
- **Thymeleaf Templates**: Server-side templating
- **Maven**: Dependency management and build tool
- **Port 8080**: Default web server port

## 📚 Learning Points
- **Spring Boot 3**: Web application development
- **Java 17 Features**: Text blocks, modern Java syntax
- **Database Integration**: SQLite with JDBC
- **Web Development**: HTML, CSS, JavaScript
- **API Development**: RESTful endpoints
- **Maven**: Project management and dependencies
- **Port Management**: Web server configuration

## 🔗 Related Examples
This Java web application complements the other examples:
- `../python/` - Python SQLite example
- `../javascript/` - Node.js SQLite example
- `../java/` - Java command-line example
- `../c/` - C SQLite API example
- `../web-app/` - Flask web interface

All examples use the same database schema and operations!

## 📖 Additional Resources
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Maven Documentation](https://maven.apache.org/guides/)
- [Thymeleaf Documentation](https://www.thymeleaf.org/documentation.html)
- [Bootstrap Documentation](https://getbootstrap.com/docs/)
