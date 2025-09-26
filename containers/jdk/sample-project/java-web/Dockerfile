FROM cleanstart/jdk:latest-dev

USER root
# Switch to root to set permissions

# Set working directory and ensure proper ownership
WORKDIR /app

# Switch back to clnstrt user

# Copy source files
COPY  src/ ./src/

# Compile the Java application
RUN javac -d . src/main/SimpleHttpServer.java

# Expose port 8080
EXPOSE 8080

# Override the entrypoint completely and run the application
ENTRYPOINT ["/usr/bin/java", "SimpleHttpServer"]
