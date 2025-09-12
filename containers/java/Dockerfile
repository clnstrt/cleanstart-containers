FROM cleanstart/jdk:latest-dev

# Set working directory
WORKDIR /app

# Copy the hello world program
COPY HelloWorld.java .

# Create a non-root user
RUN addgroup -g 1001 -S javaapp && \
    adduser -u 1001 -S javaapp -G javaapp

# Change ownership of the app directory
RUN chown -R javaapp:javaapp /app

# Switch to non-root user
USER javaapp

# Compile and run the hello world program
CMD ["sh", "-c", "javac HelloWorld.java && java HelloWorld"]
