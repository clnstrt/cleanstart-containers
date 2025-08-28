#!/bin/bash

# Ruby Sample Project Local Setup Script
echo "🚀 Setting up Ruby Sample Project locally..."

# Check if Ruby is installed
if ! command -v ruby &> /dev/null; then
    echo "❌ Ruby is not installed. Please install Ruby 3.3+ first."
    echo "   Ubuntu/Debian: sudo apt install ruby ruby-bundler"
    echo "   macOS: brew install ruby"
    echo "   Windows: Download from https://rubyinstaller.org/"
    exit 1
fi

# Check if Bundler is installed
if ! command -v bundle &> /dev/null; then
    echo "❌ Bundler is not installed. Installing..."
    gem install bundler
fi

echo "✅ Ruby version: $(ruby --version)"
echo "✅ Bundler version: $(bundle --version)"

# Install dependencies
echo "📦 Installing dependencies..."
bundle install

if [ $? -eq 0 ]; then
    echo "✅ Dependencies installed successfully!"
    echo ""
    echo "🎉 Setup complete! To run the application:"
    echo "   ruby app.rb"
    echo "   Then visit: http://localhost:4567"
else
    echo "❌ Failed to install dependencies"
    exit 1
fi
