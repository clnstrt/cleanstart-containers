@echo off
REM MetalLB Sample Project Setup Script for Windows
REM This script sets up the MetalLB sample project environment

echo 🚀 Setting up MetalLB Sample Project
echo ====================================

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker is not installed. Please install Docker Desktop first.
    exit /b 1
)
echo [SUCCESS] Docker is installed

REM Check if Docker Compose is installed
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker Compose is not installed. Please install Docker Compose first.
    exit /b 1
)
echo [SUCCESS] Docker Compose is installed

REM Check if kubectl is installed
kubectl version --client >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] kubectl is not installed. Some features may not work.
    echo [INFO] To install kubectl, visit: https://kubernetes.io/docs/tasks/tools/
) else (
    echo [SUCCESS] kubectl is installed
)

REM Create necessary directories
echo [INFO] Creating directories...
if not exist "config" mkdir config
if not exist "manifests" mkdir manifests
if not exist "monitoring\grafana\dashboards" mkdir monitoring\grafana\dashboards
if not exist "monitoring\grafana\datasources" mkdir monitoring\grafana\datasources

echo [SUCCESS] Directories created

REM Create basic configuration files
echo [INFO] Creating configuration files...

REM Create nginx configuration for web service
(
echo events {
echo     worker_connections 1024;
echo }
echo.
echo http {
echo     upstream backend {
echo         server nginx-web:80;
echo     }
echo.
echo     server {
echo         listen 80;
echo         server_name _;
echo.
echo         location / {
echo             proxy_pass http://backend;
echo             proxy_set_header Host $host;
echo             proxy_set_header X-Real-IP $remote_addr;
echo             proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
echo             proxy_set_header X-Forwarded-Proto $scheme;
echo         }
echo     }
echo }
) > basic-layer2\nginx.conf

REM Create nginx configuration for API service
(
echo events {
echo     worker_connections 1024;
echo }
echo.
echo http {
echo     upstream api_backend {
echo         server nginx-api:80;
echo     }
echo.
echo     server {
echo         listen 80;
echo         server_name _;
echo.
echo         location /api/ {
echo             proxy_pass http://api_backend/;
echo             proxy_set_header Host $host;
echo             proxy_set_header X-Real-IP $remote_addr;
echo             proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
echo             proxy_set_header X-Forwarded-Proto $scheme;
echo         }
echo.
echo         location /health {
echo             return 200 '{"status":"healthy","service":"api"}';
echo             add_header Content-Type application/json;
echo         }
echo     }
echo }
) > multi-pool\api.conf

REM Create Prometheus configuration
(
echo global:
echo   scrape_interval: 15s
echo   evaluation_interval: 15s
echo.
echo rule_files:
echo   # - "first_rules.yml"
echo   # - "second_rules.yml"
echo.
echo scrape_configs:
echo   - job_name: 'prometheus'
echo     static_configs:
echo       - targets: ['localhost:9090']
echo.
echo   - job_name: 'metallb-controller'
echo     static_configs:
echo       - targets: ['metallb-controller:7472']
echo.
echo   - job_name: 'nginx-web'
echo     static_configs:
echo       - targets: ['nginx-web:80']
echo.
echo   - job_name: 'nginx-api'
echo     static_configs:
echo       - targets: ['nginx-api:80']
echo.
echo   - job_name: 'postgres-db'
echo     static_configs:
echo       - targets: ['postgres-db:5432']
) > monitoring\prometheus.yml

REM Create Grafana datasource configuration
(
echo apiVersion: 1
echo.
echo datasources:
echo   - name: Prometheus
echo     type: prometheus
echo     access: proxy
echo     url: http://prometheus:9090
echo     isDefault: true
) > monitoring\grafana\datasources\prometheus.yml

REM Create Grafana dashboard configuration
(
echo apiVersion: 1
echo.
echo providers:
echo   - name: 'default'
echo     orgId: 1
echo     folder: ''
echo     type: file
echo     disableDeletion: false
echo     updateIntervalSeconds: 10
echo     allowUiUpdates: true
echo     options:
echo       path: /etc/grafana/provisioning/dashboards
) > monitoring\grafana\dashboards\dashboard.yml

echo [SUCCESS] Configuration files created

REM Pull required images
echo [INFO] Pulling required Docker images...
docker pull cleanstart/metallb-controller:latest
docker pull nginx:1.21
docker pull postgres:13
docker pull prom/prometheus:latest
docker pull grafana/grafana:latest

echo [SUCCESS] Docker images pulled

REM Create a simple test script
(
echo @echo off
echo echo 🧪 Testing MetalLB Sample Project Setup
echo echo =======================================
echo echo.
echo echo Testing Docker Compose...
echo docker-compose ps | findstr "Up" >nul
echo if %%errorlevel%% equ 0 (
echo     echo ✅ Docker Compose services are running
echo ^) else (
echo     echo ❌ Docker Compose services are not running
echo     echo Run: docker-compose up -d
echo ^)
echo echo.
echo echo Testing web service...
echo curl -s http://localhost:8080 | findstr "Welcome to nginx" >nul
echo if %%errorlevel%% equ 0 (
echo     echo ✅ Web service is accessible
echo ^) else (
echo     echo ❌ Web service is not accessible
echo ^)
echo echo.
echo echo Testing API service...
echo curl -s http://localhost:8081/health | findstr "healthy" >nul
echo if %%errorlevel%% equ 0 (
echo     echo ✅ API service is accessible
echo ^) else (
echo     echo ❌ API service is not accessible
echo ^)
echo echo.
echo echo 🎯 Access URLs:
echo echo   Web Service: http://localhost:8080
echo echo   API Service: http://localhost:8081
echo echo   Prometheus: http://localhost:9090
echo echo   Grafana: http://localhost:3000 ^(admin/admin^)
echo echo   Database: localhost:5432 ^(testuser/testpass^)
) > test-setup.bat

echo [SUCCESS] Test script created

echo.
echo 🎉 Setup completed successfully!
echo.
echo 📋 Next Steps:
echo 1. Start the services: docker-compose up -d
echo 2. Test the setup: test-setup.bat
echo 3. Explore the sample projects in the subdirectories
echo.
echo 🔗 Access URLs (after starting services):
echo   Web Service: http://localhost:8080
echo   API Service: http://localhost:8081
echo   Prometheus: http://localhost:9090
echo   Grafana: http://localhost:3000 (admin/admin)
echo   Database: localhost:5432 (testuser/testpass)
echo.
echo 📚 Sample Projects:
echo   Basic Layer 2: .\basic-layer2\
echo   BGP Setup: .\bgp-setup\
echo   Multi-Pool: .\multi-pool\
echo.
echo [SUCCESS] Happy Load Balancing! ⚖️
