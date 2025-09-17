# 🚀 SQLite3 Hello World

Welcome to the SQLite3 Hello World example! This simple example demonstrates how to get started with SQLite3 database operations.

## 📋 What is SQLite3?

SQLite3 is a lightweight, serverless, self-contained SQL database engine. It provides:

- **Zero Configuration**: No server setup required
- **Cross-Platform**: Works on all operating systems
- **ACID Compliant**: Full transaction support
- **Embedded**: Single file database
- **Fast**: Optimized for performance

## 🚀 Quick Start

### Prerequisites

- Python 3.6+
- SQLite3 (usually included with Python)

### Running the Hello World

1. **Run the Python script:**
   ```bash
   python hello_world.py
   ```

2. **Or run with Docker:**
   ```bash
   docker run -it --rm -v $(pwd):/app cleanstart/sqlite3:latest python /app/hello_world.py
   ```

## 📊 What the Hello World Does

The `hello_world.py` script demonstrates:

1. **Database Creation**: Creates a SQLite3 database file
2. **Table Creation**: Creates tables with proper schema
3. **Data Insertion**: Inserts sample data
4. **Data Querying**: Retrieves and displays data
5. **Data Updates**: Modifies existing records
6. **Data Deletion**: Removes records
7. **Advanced Operations**: Complex queries and relationships

## 🗄️ Database Schema

The hello world creates two tables:

### Greetings Table
```sql
CREATE TABLE greetings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    message TEXT NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### Users Table
```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    age INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

## 📈 Sample Data

The script creates sample data:

```python
greetings = [
    "Hello, SQLite3!",
    "Welcome to the database world!",
    "SQLite3 is awesome!",
    "Database operations are fun!",
    "CleanStart Containers rock!"
]
```

## 🔍 Sample Queries

The script demonstrates various SQL operations:

```sql
-- Insert data
INSERT INTO greetings (message) VALUES ('Hello, SQLite3!');

-- Query all data
SELECT * FROM greetings ORDER BY timestamp;

-- Update data
UPDATE greetings SET message = 'Updated message!' WHERE id = 1;

-- Delete data
DELETE FROM greetings WHERE id = 5;

-- Complex query
SELECT name, email, age 
FROM users 
WHERE age > 25 
ORDER BY age DESC;
```

## 🛠️ Key Features Demonstrated

- **CRUD Operations**: Create, Read, Update, Delete
- **Transactions**: ACID compliance
- **Constraints**: Primary keys, unique constraints
- **Data Types**: INTEGER, TEXT, DATETIME
- **Auto-increment**: Primary key generation
- **Timestamps**: Automatic timestamp insertion

## 📚 Next Steps

1. **Explore Basic Examples**: Check out `basic-examples/` for more SQL examples
2. **Web Application**: See `web-app/` for Flask integration
3. **Advanced Queries**: Try complex joins and aggregations
4. **Performance**: Learn about indexing and optimization

## 🔧 Configuration

The hello world uses default SQLite3 settings:

- **Database File**: `hello_world.db`
- **Journal Mode**: Default (DELETE)
- **Synchronous**: Default (FULL)
- **Cache Size**: Default (2000 pages)

## 🆘 Troubleshooting

### Common Issues

1. **Permission Denied**: Check file permissions in the directory
2. **Database Locked**: Close other connections to the database
3. **Syntax Error**: Check SQL syntax in queries

### Debug Commands

```bash
# Check if SQLite3 is installed
sqlite3 --version

# Open database interactively
sqlite3 hello_world.db

# List tables
.tables

# Show schema
.schema

# Exit SQLite3
.quit
```

## 📖 Learn More

- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [Python SQLite3 Tutorial](https://docs.python.org/3/library/sqlite3.html)
- [SQLite Browser](https://sqlitebrowser.org/)

## 🎯 Use Cases

SQLite3 is perfect for:

- **Development**: Local development databases
- **Testing**: Unit test databases
- **Prototyping**: Quick database prototypes
- **Mobile Apps**: Embedded mobile databases
- **Desktop Apps**: Local application data
- **Web Apps**: Small to medium web applications

---

**Happy Database Operations with SQLite3!** 🗄️
