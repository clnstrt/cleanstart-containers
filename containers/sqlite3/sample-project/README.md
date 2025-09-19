### Quick Start

Pull the Cleanstart Docker Image:

```bash
docker pull cleanstart/sqlite3:latest-dev
```

Run the Cleanstart Docker Image:

```bash
docker run --rm -it --entrypoint sh cleanstart/sqlite3:latest-dev
```


### Cleanstart Project

The Cleanstart Project is a sample project that demonstrates how to use the Cleanstart Docker Image to create a web application. The project is a simple web application that allows users to create, read, update, and delete records in a SQLite database.

The project is structured as follows:

- The `sql-scripts` directory contains the DB code for the web application.
- The `data` directory contains the SQLite database file.
- The `Dockerfile` is used to build the Docker image.

To build the Docker image, run the following command:

```bash
docker build --no-cache -t my-sqlite3 .
```

To start the Docker container, run the following command:

```bash
docker run --rm --user root --entrypoint /bin/sh -v "$(pwd)/data:/app/sqlite3/my-data" my-sql -c "
  /usr/bin/sqlite3 /app/sqlite3/my-data/mydatabase.db < /app/sqlite3/sql_scripts/01-create-tables.sql &&
  /usr/bin/sqlite3 /app/sqlite3/my-data/mydatabase.db < /app/sqlite3/sql_scripts/02-insert-sample-data.sql &&
  echo '-------------------' &&
  echo 'Executing queries' &&
  echo '-------------------' &&
  /usr/bin/sqlite3 /app/sqlite3/my-data/mydatabase.db < /app/sqlite3/sql_scripts/03-queries.sql
"
```
## Important Information
```bash
This is SQLite3 docker image project which is up and running and if you want to add the users and execute the docker run command we need to enter the user MANUALLY!

## Database

The SQLite database is stored in the `data`  and `my-data` directory. The database file is named `mydatabase.db`. The database is created when the Docker container starts.