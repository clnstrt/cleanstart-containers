FROM ruby:3.2-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libsqlite3-dev \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Gemfile and install dependencies
COPY Gemfile Gemfile.lock* ./
RUN bundle install --jobs 4 --retry 3

# Copy application code
COPY . .

# Create a non-root user
RUN useradd -m -u 1001 rubyapp && \
    chown -R rubyapp:rubyapp /app

# Switch to non-root user
USER rubyapp

# Expose port
EXPOSE 4567

# Start the application
CMD ["ruby", "app.rb"]
