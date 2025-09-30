FROM cleanstart/jre:latest-dev

USER root

# Set working directory and ensure proper ownership
WORKDIR /app

# Switch back to clnstrt user
<<<<<<< HEAD
    
# Copy source files
COPY src/ ./src/

# Compile the Java application
RUN javac -d . src/main/SimpleHttpServer.java

=======

# Copy source files
COPY src/ ./src/

# Compile the Java application
RUN javac -d . src/main/SimpleHttpServer.java

>>>>>>> b24d9df4bb837add6d9657256fdfea46c1591f84
# Expose port 8080
EXPOSE 8080

# Override the entrypoint completely and run the application
<<<<<<< HEAD
ENTRYPOINT ["/usr/bin/java", "SimpleHttpServer"]
=======
ENTRYPOINT ["/usr/bin/java", "SimpleHttpServer"]
>>>>>>> b24d9df4bb837add6d9657256fdfea46c1591f84
