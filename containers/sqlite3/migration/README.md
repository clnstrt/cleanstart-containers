**SQLite3 Migration Project**

This project demonstrates running and testing SQLite3 on two different Docker images:

- **v1** → based on `alpine/curl:latest` with SQLite manually installed  
- **v2** → based on `cleanstart/sqlite3:latest-dev` (Cleanstart image)

You can use these steps to compare and validate functionality between the two images.

---

## Project Structure

sqlite3/
├── Dockerfile.v1
├── Dockerfile.v2
└── README.md

### Dockerfile.v1

```bash
# Use alpine with curl as the base
FROM alpine/curl:latest

# Install sqlite3 in addition to curl
RUN apk add --no-cache sqlite

# Set working directory
WORKDIR /app/sqlite3

# Start sqlite3 when container runs
CMD ["sqlite3"]
```

###Dockerfile.v2

```bash
# Use the cleanstart sqlite3 image
FROM cleanstart/sqlite3:latest-dev

# Set working directory inside the container
WORKDIR /app/sqlite3

# Start sqlite3 with default database
CMD ["sqlite3"]
```

**Steps to Run**

**1. Build Images**

```bash
# Build v1 (alpine + curl + sqlite3)
docker build -t sqlite3-v1 -f Dockerfile.v1 .

# Build v2 (cleanstart sqlite3 image)
docker build -t sqlite3-v2 -f Dockerfile.v2 .
```

**2. Run Containers**

```bash
# Run v1 container (interactive mode)
docker run -it --name sqlite3-v1-container sqlite3-v1

# Run v2 container (interactive mode)
docker run -it --name sqlite3-v2-container sqlite3-v2
```

Both will drop you into the sqlite> prompt.

**3. Create a Database & Table**
Inside either container:

```bash
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE
);
```

**4. Insert Sample Data**

```bash
INSERT INTO users (name, email) VALUES ('Alice', 'alice@example.com');
INSERT INTO users (name, email) VALUES ('Bob', 'bob@example.com');
```

**5. Query the Data**

```bash
SELECT * FROM users;
```

**Expected output:**

1|Alice|alice@example.com
2|Bob|bob@example.com

**6. Exiting SQLite3**

```bash
.exit
```

**Notes:**

v1 image is lightweight but requires adding SQLite manually.

v2 image (cleanstart/sqlite3:latest-dev) is preconfigured with SQLite3.

Both can be used to test database creation, insertion, and querying for migration validation.



