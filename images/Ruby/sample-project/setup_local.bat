@echo off
REM Ruby Sample Project Local Setup Script for Windows

echo 🚀 Setting up Ruby Sample Project locally...

REM Check if Ruby is installed
ruby --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Ruby is not installed. Please install Ruby 3.3+ first.
    echo    Download from https://rubyinstaller.org/
    pause
    exit /b 1
)

REM Check if Bundler is installed
bundle --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Bundler is not installed. Installing...
    gem install bundler
)

echo ✅ Ruby version:
ruby --version
echo ✅ Bundler version:
bundle --version

REM Install dependencies
echo 📦 Installing dependencies...
bundle install

if %errorlevel% equ 0 (
    echo ✅ Dependencies installed successfully!
    echo.
    echo 🎉 Setup complete! To run the application:
    echo    ruby app.rb
    echo    Then visit: http://localhost:4567
) else (
    echo ❌ Failed to install dependencies
    pause
    exit /b 1
)

pause
