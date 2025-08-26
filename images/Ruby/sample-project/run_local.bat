@echo off
echo Starting Ruby User Management Application...

REM Check if Ruby is installed
ruby --version >nul 2>&1
if errorlevel 1 (
    echo Error: Ruby is not installed. Please install Ruby 3.2 or higher.
    pause
    exit /b 1
)

REM Check if Bundler is installed
bundle --version >nul 2>&1
if errorlevel 1 (
    echo Installing Bundler...
    gem install bundler
)

REM Install dependencies locally
echo Installing dependencies...
bundle config set --local path 'vendor/bundle'
bundle install

REM Run the application
echo Starting the application on http://localhost:4567
echo Press Ctrl+C to stop
bundle exec ruby app.rb

pause
