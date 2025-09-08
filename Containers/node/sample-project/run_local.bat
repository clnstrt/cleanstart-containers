@echo off
echo Starting Node.js User Management Application...

REM Check if Node.js is installed
node --version >nul 2>&1
if errorlevel 1 (
    echo Error: Node.js is not installed. Please install Node.js 18 or higher.
    pause
    exit /b 1
)

REM Check if npm is installed
npm --version >nul 2>&1
if errorlevel 1 (
    echo Error: npm is not installed. Please install npm.
    pause
    exit /b 1
)

REM Install dependencies
echo Installing dependencies...
npm install

REM Run the application
echo Starting the application on http://localhost:3000
echo Press Ctrl+C to stop
npm start

pause
