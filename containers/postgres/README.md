# PostgreSQL Docker Image

A powerful, open source object-relational database system with advanced features and standards compliance.

## Pull Image
```bash
docker pull cleanstart/postgres:latest
```

## Run Container
```bash
# Basic run with default settings
docker run -d --name postgres-container -e POSTGRES_PASSWORD=mypassword cleanstart/postgres:latest

# Run with custom port and database
docker run -d --name postgres-container -p 5432:5432 -e POSTGRES_PASSWORD=mypassword -e POSTGRES_DB=mydb cleanstart/postgres:latest

# Run with volume mount for data persistence
docker run -d --name postgres-container -v postgres_data:/var/lib/postgresql/data -e POSTGRES_PASSWORD=mypassword cleanstart/postgres:latest
```

## Check Version
```bash
docker run --rm cleanstart/postgres:latest psql --version
```

## Check Image Size
```bash
docker images cleanstart/postgres:latest
```

## Test Container
```bash
# Test PostgreSQL connection
docker run --rm cleanstart/postgres:latest psql --version

# Run SQL commands
docker run --rm -v $(pwd):/app cleanstart/postgres:latest psql -f /app/hello_world.sql
```

## Sample Projects
For detailed usage examples and demonstrations, see the `sample-project/` directory.
