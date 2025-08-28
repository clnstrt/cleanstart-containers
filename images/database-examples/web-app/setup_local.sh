#!/bin/bash

# Python Sample Project Local Setup Script
echo "🚀 Setting up Python Sample Project locally..."

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3.12+ first."
    echo "   Ubuntu/Debian: sudo apt install python3 python3-pip python3-venv"
    echo "   macOS: brew install python@3.12"
    echo "   Windows: Download from https://www.python.org/downloads/"
    exit 1
fi

# Check if pip is installed
if ! command -v pip &> /dev/null; then
    echo "❌ pip is not installed. Please install pip first."
    exit 1
fi

echo "✅ Python version: $(python3 --version)"
echo "✅ pip version: $(pip --version)"

# Create virtual environment
echo "📦 Creating virtual environment..."
python3 -m venv venv

# Activate virtual environment
echo "🔧 Activating virtual environment..."
source venv/bin/activate

# Install dependencies
echo "📦 Installing dependencies..."
pip install -r requirements.txt

if [ $? -eq 0 ]; then
    echo "✅ Dependencies installed successfully!"
    echo ""
    echo "🎉 Setup complete! To run the application:"
    echo "   source venv/bin/activate  # Activate virtual environment"
    echo "   python app.py"
    echo "   Then visit: http://localhost:5000"
    echo ""
    echo "💡 To deactivate virtual environment later:"
    echo "   deactivate"
else
    echo "❌ Failed to install dependencies"
    exit 1
fi
