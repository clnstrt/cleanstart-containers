**Postgres Migration Project**

This project demonstrates running Postgres on two Docker images:

**postgres:latest**

**cleanstart/postgres:latest-dev**

It includes basic CRUD operations to test functionality.

**1️⃣ init.sql**

This file initializes the database with a sample table and data:

```bash
-- init.sql
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(50) UNIQUE
);

INSERT INTO users (name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com');
```

Place this file in the same folder as the Dockerfiles.

**2️⃣ Postgres:latest Setup**

```bash
Dockerfile.v1
FROM postgres:latest

ENV POSTGRES_USER=komal
ENV POSTGRES_PASSWORD=komal123
ENV POSTGRES_DB=testdb

COPY init.sql /docker-entrypoint-initdb.d/

EXPOSE 5432
```

**Build Image**

```bash
docker build -t postgres-v1 -f Dockerfile.v1 .
```

**Run Container**

```bash
docker run -d --name pg-v1 -p 5432:5432 postgres-v1
```

**Connect to Database**

```bash
docker exec -it pg-v1 psql -U komal -d testdb
```

**CRUD Operations**

Create Table (if not using init.sql):

```bash
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(50) UNIQUE
);

Insert Data:

INSERT INTO users (name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com');
```

**Read Data:**

```bash
SELECT * FROM users;
```

**Update Data:**

```bash
UPDATE users
SET name = 'Charlie'
WHERE name = 'Alice';
```

**Delete Data:**

```bash
DELETE FROM users
WHERE name = 'Bob';
```

**Drop Table (Optional Cleanup):**

```bash
DROP TABLE users;
```

**3️⃣ cleanstart/postgres:latest-dev Setup**

Dockerfile.v2

```bash
FROM cleanstart/postgres:latest-dev

ENV POSTGRES_USER=komal
ENV POSTGRES_PASSWORD=komal123
ENV POSTGRES_DB=testdb

COPY init.sql /docker-entrypoint-initdb.d/

EXPOSE 5432
```

**Build Image**

```bash
docker build -t postgres-v2 -f Dockerfile.v2 .
```

**Run Container**

```bash
docker run -d --name pg-v2 -p 5433:5432 postgres-v2
```

**Connect to Database**

```bash
docker exec -it pg-v2 psql -U komal -d testdb
```

**CRUD Operations**

The same SQL commands work as for postgres:latest:

**Read Data:**

```bash
SELECT * FROM users;
```

**Insert Data:**

```bash
INSERT INTO users (name, email) VALUES ('Dave', 'dave@example.com');
```

**Update Data:**

```bash
UPDATE users SET name='David' WHERE name='Dave';
```

**Delete Data:**

```bash
DELETE FROM users WHERE name='David';
```

**Drop Table (Optional Cleanup):**

```bash
DROP TABLE users;
```

**4️⃣ Stop & Remove Containers**

```bash
docker stop pg-v1 pg-v2
docker rm pg-v1 pg-v2
```

This README guides you step by step to run both Postgres images and verify CRUD operations.