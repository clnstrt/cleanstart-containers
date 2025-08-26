# Ruby User Management Application - PowerShell Runner
Write-Host "Starting Ruby User Management Application..." -ForegroundColor Green

# Check if Docker is available
if (Get-Command docker -ErrorAction SilentlyContinue) {
    Write-Host "Docker detected. Using Docker to run the application..." -ForegroundColor Yellow
    
    # Build the image if it doesn't exist
    Write-Host "Building Docker image..." -ForegroundColor Yellow
    docker build -t ruby-user-app .
    
    # Run the container
    Write-Host "Starting container..." -ForegroundColor Yellow
    docker run -d -p 4567:4567 --name ruby-app ruby-user-app
    
    # Wait a moment for the app to start
    Start-Sleep -Seconds 3
    
    # Test the application
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:4567/health" -UseBasicParsing
        Write-Host "Application is running successfully!" -ForegroundColor Green
        Write-Host "Web interface: http://localhost:4567" -ForegroundColor Cyan
        Write-Host "Health check: http://localhost:4567/health" -ForegroundColor Cyan
        Write-Host "Press any key to stop the container..." -ForegroundColor Yellow
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        
        # Stop and remove the container
        docker stop ruby-app
        docker rm ruby-app
        Write-Host "Container stopped and removed." -ForegroundColor Green
    }
    catch {
        Write-Host "Error: Could not connect to the application." -ForegroundColor Red
        Write-Host "Container logs:" -ForegroundColor Yellow
        docker logs ruby-app
    }
}
else {
    Write-Host "Docker not found. Please install Docker Desktop or use WSL to run the application locally." -ForegroundColor Red
    Write-Host "Alternative: Open WSL terminal and run: ./run_local.sh" -ForegroundColor Yellow
}
