#!/bin/bash

# Node.js User Management Application - Local Runner
echo "Starting Node.js User Management Application..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is not installed. Please install Node.js 18 or higher."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "Error: npm is not installed. Please install npm."
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "Warning: Node.js version $(node -v) detected. Version 18 or higher is recommended."
fi

# Install dependencies
echo "Installing dependencies..."
npm install

# Run the application
echo "Starting the application on http://localhost:3000"
echo "Press Ctrl+C to stop"
npm start
