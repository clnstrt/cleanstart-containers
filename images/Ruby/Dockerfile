FROM ruby:3.2-alpine

# Install system dependencies
RUN apk add --no-cache \
    build-base \
    sqlite-dev \
    sqlite \
    git

# Set working directory
WORKDIR /app

# Copy the hello world program
COPY hello_world.rb .

# Create a non-root user
RUN addgroup -g 1001 -S rubyapp && \
    adduser -u 1001 -S rubyapp -G rubyapp

# Change ownership of the app directory
RUN chown -R rubyapp:rubyapp /app

# Switch to non-root user
USER rubyapp

# Expose default port
EXPOSE 4567

# Run the hello world program
CMD ["ruby", "hello_world.rb"]
