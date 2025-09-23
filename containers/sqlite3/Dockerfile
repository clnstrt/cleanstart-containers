# Use the cleanstart image as the base
FROM cleanstart/sqlite3:latest-dev

# Set the working directory inside the container
WORKDIR /app/sqlite3

# Copy the entire project directory into the container
# The 'sqlite3' directory is the build context, so COPY paths start from there.
COPY . .