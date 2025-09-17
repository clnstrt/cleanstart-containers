# 🚀 SQLite3 Sample Projects

This directory contains sample projects demonstrating SQLite3 database operations, management, and integration capabilities.

## 📁 Sample Projects

### 1. Basic Operations (`basic-operations/`)
- **Database Creation**: Creating and managing SQLite databases
- **Table Operations**: Creating, modifying, and querying tables
- **Data Manipulation**: INSERT, UPDATE, DELETE operations

### 2. Advanced Features (`advanced-features/`)
- **Indexes and Views**: Creating indexes and views
- **Triggers**: Database triggers and automation
- **Transactions**: Transaction management and ACID properties

### 3. Web Applications (`web-applications/`)
- **Python Flask App**: Web application with SQLite backend
- **Node.js Express App**: REST API with SQLite database
- **PHP Application**: Simple PHP application with SQLite

### 4. Data Analysis (`data-analysis/`)
- **CSV Import/Export**: Working with CSV files
- **JSON Operations**: JSON data handling
- **Analytics Queries**: Complex analytical queries

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose
- Basic SQL knowledge
- Text editor or IDE

### Running SQLite Locally

1. **Clone and Navigate**:
```bash
cd containers/sqlite3/sample-project
```

2. **Start SQLite Container**:
```bash
docker run --rm -it -v $(pwd):/app cleanstart/sqlite3:latest bash
```

3. **Create Your First Database**:
```bash
sqlite3 /app/data/myapp.db
```

4. **Run Sample Scripts**:
```bash
sqlite3 /app/data/myapp.db < basic-operations/create_tables.sql
```

### Running Web Applications

1. **Start Python Flask App**:
```bash
cd web-applications/python-flask
docker-compose up -d
```

2. **Access the Application**:
```bash
curl http://localhost:5000/api/users
```

3. **Start Node.js Express App**:
```bash
cd web-applications/node-express
docker-compose up -d
```

## 📚 SQLite Examples

### Basic Database Operations
```sql
-- Create a new database
.open /app/data/myapp.db

-- Create a table
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Insert data
INSERT INTO users (name, email) VALUES 
    ('John Doe', 'john@example.com'),
    ('Jane Smith', 'jane@example.com');

-- Query data
SELECT * FROM users;
SELECT name, email FROM users WHERE id = 1;

-- Update data
UPDATE users SET email = 'john.doe@example.com' WHERE id = 1;

-- Delete data
DELETE FROM users WHERE id = 2;
```

### Advanced Features
```sql
-- Create an index
CREATE INDEX idx_users_email ON users(email);

-- Create a view
CREATE VIEW active_users AS
SELECT id, name, email 
FROM users 
WHERE created_at > datetime('now', '-30 days');

-- Create a trigger
CREATE TRIGGER update_timestamp 
AFTER UPDATE ON users
BEGIN
    UPDATE users SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Use transactions
BEGIN TRANSACTION;
INSERT INTO users (name, email) VALUES ('Bob Wilson', 'bob@example.com');
UPDATE users SET name = 'Robert Wilson' WHERE email = 'bob@example.com';
COMMIT;
```

### Data Analysis Queries
```sql
-- Aggregation queries
SELECT 
    COUNT(*) as total_users,
    COUNT(DISTINCT email) as unique_emails,
    MIN(created_at) as first_user,
    MAX(created_at) as latest_user
FROM users;

-- Group by queries
SELECT 
    DATE(created_at) as date,
    COUNT(*) as new_users
FROM users
GROUP BY DATE(created_at)
ORDER BY date DESC;

-- Complex joins (if you have multiple tables)
SELECT 
    u.name,
    u.email,
    COUNT(o.id) as order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name, u.email;
```

## 🧪 Testing SQLite

### Database Testing
```bash
# Test database creation
sqlite3 /app/data/test.db "CREATE TABLE test (id INTEGER, name TEXT);"

# Test data insertion
sqlite3 /app/data/test.db "INSERT INTO test VALUES (1, 'Hello');"

# Test data query
sqlite3 /app/data/test.db "SELECT * FROM test;"

# Test database integrity
sqlite3 /app/data/test.db "PRAGMA integrity_check;"
```

### Performance Testing
```bash
# Test with large dataset
sqlite3 /app/data/performance.db < performance-test.sql

# Check query performance
sqlite3 /app/data/performance.db "EXPLAIN QUERY PLAN SELECT * FROM large_table WHERE id = 1000;"
```

## 🔧 Configuration

### SQLite Configuration
```sql
-- Set pragma options
PRAGMA journal_mode = WAL;
PRAGMA synchronous = NORMAL;
PRAGMA cache_size = 1000;
PRAGMA temp_store = MEMORY;
PRAGMA mmap_size = 268435456;
```

### Connection Settings
```bash
# Environment variables
export SQLITE_DATABASE_PATH=/app/data/myapp.db
export SQLITE_LOG_LEVEL=info
export SQLITE_TIMEOUT=30
```

## 📊 Monitoring

### Database Statistics
```sql
-- Database size
SELECT page_count * page_size as size FROM pragma_page_count(), pragma_page_size();

-- Table information
SELECT name, sql FROM sqlite_master WHERE type='table';

-- Index information
SELECT name, sql FROM sqlite_master WHERE type='index';
```

### Performance Monitoring
```sql
-- Query execution time
.timer on
SELECT * FROM large_table WHERE id = 1000;

-- Explain query plan
EXPLAIN QUERY PLAN SELECT * FROM users WHERE email = 'john@example.com';
```

## 🛠️ Troubleshooting

### Common Issues
1. **Database Locked**: Check for concurrent access
2. **Disk Space**: Monitor database file size
3. **Performance**: Optimize queries and indexes

### Debug Commands
```bash
# Check database file
ls -la /app/data/*.db

# Verify database integrity
sqlite3 /app/data/myapp.db "PRAGMA integrity_check;"

# Check database schema
sqlite3 /app/data/myapp.db ".schema"
```

## 📚 Resources

- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [SQLite Tutorial](https://www.sqlitetutorial.net/)
- [CleanStart Website](https://www.cleanstart.com/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Adding new SQLite examples
- Improving documentation
- Reporting issues
- Suggesting new features

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
