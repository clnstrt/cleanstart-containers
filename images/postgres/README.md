# PostgreSQL Hello World

This is a simple PostgreSQL sample project that demonstrates basic database operations.

## What it does

- Creates a `users` table with basic fields
- Inserts sample data
- Displays welcome messages
- Shows how to query data

## Quick Start

### Using Docker

1. **Build the image:**
   ```bash
   docker build -t postgres-hello-world images/postgres/
   ```

2. **Run the container:**
   ```bash
   docker run -d --name postgres-demo -p 5432:5432 postgres-hello-world
   ```

3. **Connect to the database:**
   ```bash
   docker exec -it postgres-demo psql -U postgres -d helloworld
   ```

4. **Test the database:**
   ```sql
   -- View all users
   SELECT * FROM users;
   
   -- Count users
   SELECT COUNT(*) FROM users;
   
   -- Add a new user
   INSERT INTO users (name, email) VALUES ('Test User', 'test@example.com');
   ```

### Using Local PostgreSQL

1. **Install PostgreSQL** (if not already installed)
2. **Run the script:**
   ```bash
   psql -U postgres -f images/postgres/hello_world.sql
   ```

## Database Schema

The `users` table has the following structure:

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Environment Variables

- `POSTGRES_DB`: Database name (default: helloworld)
- `POSTGRES_USER`: Username (default: postgres)
- `POSTGRES_PASSWORD`: Password (default: password)

## Sample Data

The script automatically inserts these users:
- John Doe (john@example.com)
- Jane Smith (jane@example.com)
- Bob Johnson (bob@example.com)

## Useful Commands

```bash
# Connect to database
psql -U postgres -d helloworld

# List all tables
\dt

# Describe a table
\d users

# Exit psql
\q
```

## Health Check

To verify the database is running:
```bash
docker exec postgres-demo pg_isready -U postgres
```

Enjoy exploring PostgreSQL! 🐘
