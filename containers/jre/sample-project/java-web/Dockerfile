FROM ubuntu/jdk:21-24.04_stable

WORKDIR /app

# Copy source files
COPY src/ ./src/

# Compile the Java application
RUN javac -d . src/main/SimpleHttpServer.java

# Expose port 8080
EXPOSE 8080

# Run the application
ENTRYPOINT ["/usr/bin/java", "SimpleHttpServer"]
