FROM ruby:3.2-alpine

# Install system dependencies
RUN apk add --no-cache \
    build-base \
    sqlite-dev \
    sqlite \
    git

# Set working directory
WORKDIR /app

# Create a non-root user
RUN addgroup -g 1001 -S rubyapp && \
    adduser -u 1001 -S rubyapp -G rubyapp

# Switch to non-root user
USER rubyapp

# Expose default port
EXPOSE 4567

# Default command
CMD ["ruby", "--version"]
