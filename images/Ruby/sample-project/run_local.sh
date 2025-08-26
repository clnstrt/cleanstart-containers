#!/bin/bash

# Ruby User Management Application - Local Runner
echo "Starting Ruby User Management Application..."

# Check if Ruby is installed
if ! command -v ruby &> /dev/null; then
    echo "Error: Ruby is not installed. Please install Ruby 3.2 or higher."
    exit 1
fi

# Check if Bundler is installed
if ! command -v bundle &> /dev/null; then
    echo "Installing Bundler..."
    gem install bundler
fi

# Check if ruby-dev is installed (needed for native extensions)
if ! dpkg -l | grep -q ruby-dev; then
    echo "Installing Ruby development headers..."
    sudo apt-get update
    sudo apt-get install -y ruby-dev build-essential
fi

# Install dependencies locally
echo "Installing dependencies..."
bundle config set --local path 'vendor/bundle'
bundle install

# Run the application
echo "Starting the application on http://localhost:4567"
echo "Press Ctrl+C to stop"
bundle exec ruby app.rb
