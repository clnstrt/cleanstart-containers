# Cross-Language Database Program Overview

## Project Description

This project demonstrates how to perform basic SQLite database operations across multiple programming languages. Each implementation follows the same pattern and produces identical results, making it easy to compare database programming approaches across different languages.

## What This Program Does

All examples perform the same core operations:

1. **Create a SQLite database** (`users.db`)
2. **Create a users table** with fields: `id`, `name`, `email`
3. **Insert sample users** (John Doe, Jane Smith, Bob Johnson)
4. **Query all users** and display them
5. **Clean up resources** properly

## Database Schema

All implementations use the same database structure:

```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE
);
```

## Languages and Technologies

| Language | Database Interface | Key Features |
|----------|-------------------|--------------|
| **Python** | Built-in `sqlite3` module | Simple, no dependencies |
| **JavaScript** | `sqlite3` npm package | Async/await, promises |
| **Java** | JDBC with SQLite driver | PreparedStatement, try-with-resources |
| **C** | SQLite C API | Direct API, callback functions |

## Quick Start

### Option 1: Run All Examples (Recommended)
```bash
# Navigate to the database-examples directory
cd containers/database-examples

# Set up and run all examples
make run-all
```

### Option 2: Run Individual Examples

#### Python
```bash
cd python
python database_example.py
```

#### JavaScript (Node.js)
```bash
cd javascript
npm install
node database_example.js
```

#### Java
```bash
cd java
make java  # Downloads JDBC driver and compiles
java -cp ".:sqlite-jdbc-3.42.0.0.jar" DatabaseExample
```

#### C
```bash
cd c
make c  # Compiles the program
./database_example
```

## Expected Output

All examples should produce similar output:

```
Database created successfully
Table created successfully
User inserted successfully
User inserted successfully
User inserted successfully
All users:
ID: 1, Name: John Doe, Email: john@example.com
ID: 2, Name: Jane Smith, Email: jane@example.com
ID: 3, Name: Bob Johnson, Email: bob@example.com
Database connection closed
```

## System Requirements

### Python
- Python 3.x (sqlite3 module is built-in)

### JavaScript
- Node.js (version 12 or higher)
- npm (Node Package Manager)

### Java
- Java 8 or higher
- Internet connection (to download JDBC driver)

### C
- GCC compiler
- SQLite3 development library (`libsqlite3-dev`)

## Installation Guide

### Ubuntu/Debian
```bash
# Install SQLite development library for C
sudo apt-get update
sudo apt-get install libsqlite3-dev

# Install Node.js and npm
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Java (if not already installed)
sudo apt-get install openjdk-11-jdk
```

### macOS
```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install sqlite3 node java
```

### Windows
- Install Python from [python.org](https://python.org)
- Install Node.js from [nodejs.org](https://nodejs.org)
- Install Java JDK from [oracle.com](https://oracle.com/java/technologies/downloads/)
- For C compilation, consider using WSL or MinGW

## Key Learning Points

### Database Operations
- **Connection Management**: How to open, use, and close database connections
- **Table Creation**: Creating tables with proper constraints
- **Data Insertion**: Inserting records with parameterized queries
- **Data Retrieval**: Querying and processing result sets
- **Error Handling**: Proper exception/error handling for database operations

### Language-Specific Patterns
- **Python**: Simple, readable code with built-in database support
- **JavaScript**: Async/await patterns for non-blocking operations
- **Java**: JDBC patterns with prepared statements and resource management
- **C**: Low-level API usage with manual memory management

### Best Practices
- **SQL Injection Prevention**: Using parameterized queries
- **Resource Cleanup**: Properly closing connections and freeing resources
- **Error Handling**: Comprehensive error checking and reporting
- **Code Organization**: Modular functions for different operations

## Troubleshooting

### Common Issues

1. **SQLite not found (C)**
   ```bash
   sudo apt-get install libsqlite3-dev  # Ubuntu/Debian
   brew install sqlite3                 # macOS
   ```

2. **Node.js dependencies not found**
   ```bash
   cd javascript
   npm install
   ```

3. **Java JDBC driver not found**
   ```bash
   cd java
   make java  # This downloads the driver automatically
   ```

4. **Permission denied errors**
   ```bash
   chmod +x c/database_example  # Make C executable runnable
   ```

### Verification

To verify all examples work correctly:
```bash
make clean    # Remove all generated files
make run-all  # Run all examples
```

Each example should create its own `users.db` file and produce the expected output.

## Extending the Examples

These examples can be extended to include:
- **Update operations**: Modifying existing records
- **Delete operations**: Removing records
- **Complex queries**: JOINs, aggregations, etc.
- **Transaction management**: ACID compliance
- **Connection pooling**: For production applications
- **ORM patterns**: Object-relational mapping

## Contributing

Feel free to add examples in other languages or extend existing ones with additional features. Each language should maintain the same interface and produce identical results for consistency.
