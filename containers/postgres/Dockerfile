FROM cleanstart/postgres:latest-dev

# Set environment variables
ENV POSTGRES_DB=helloworld
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=password

# Set working directory
WORKDIR /docker-entrypoint-initdb.d

# Copy the hello world script
COPY hello_world.sql .

# Expose PostgreSQL port
EXPOSE 5432

# The default postgres image will automatically run the scripts in /docker-entrypoint-initdb.d
# and then start the PostgreSQL server
