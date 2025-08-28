@echo off
REM Python Sample Project Local Setup Script for Windows

echo 🚀 Setting up Python Sample Project locally...

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python is not installed. Please install Python 3.12+ first.
    echo    Download from https://www.python.org/downloads/
    pause
    exit /b 1
)

REM Check if pip is installed
pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ pip is not installed. Please install pip first.
    pause
    exit /b 1
)

echo ✅ Python version:
python --version
echo ✅ pip version:
pip --version

REM Create virtual environment
echo 📦 Creating virtual environment...
python -m venv venv

REM Activate virtual environment
echo 🔧 Activating virtual environment...
call venv\Scripts\activate.bat

REM Install dependencies
echo 📦 Installing dependencies...
pip install -r requirements.txt

if %errorlevel% equ 0 (
    echo ✅ Dependencies installed successfully!
    echo.
    echo 🎉 Setup complete! To run the application:
    echo    venv\Scripts\activate.bat  # Activate virtual environment
    echo    python app.py
    echo    Then visit: http://localhost:5000
    echo.
    echo 💡 To deactivate virtual environment later:
    echo    deactivate
) else (
    echo ❌ Failed to install dependencies
    pause
    exit /b 1
)

pause
