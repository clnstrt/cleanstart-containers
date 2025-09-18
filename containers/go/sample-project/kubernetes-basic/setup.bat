@echo off
REM CleanStart Go Kubernetes Sample - Windows Setup Script
REM This script sets up the environment for Windows users

echo CleanStart Go Kubernetes Sample - Windows Setup
echo ================================================
echo.

REM Check if kubectl is available
kubectl version --client >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] kubectl is not installed or not in PATH
    echo Please install kubectl: https://kubernetes.io/docs/tasks/tools/
    pause
    exit /b 1
)
echo [SUCCESS] kubectl is available

REM Check cluster connectivity
kubectl cluster-info >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Cannot connect to Kubernetes cluster
    echo Please ensure your kubeconfig is properly configured
    pause
    exit /b 1
)
echo [SUCCESS] Connected to Kubernetes cluster

REM Check if Docker is available (optional)
docker --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [SUCCESS] Docker is available
) else (
    echo [WARNING] Docker is not available (optional for local development)
)

echo.
echo [INFO] Prerequisites check completed successfully!
echo.
echo Next Steps:
echo 1. Deploy the application:
echo    kubectl apply -k .
echo.
echo 2. Check the status:
echo    kubectl get all -n go-sample
echo.
echo 3. Access the application:
echo    kubectl port-forward service/go-sample-service 8080:80 -n go-sample
echo    Then visit: http://localhost:8080
echo.
echo 4. Clean up when done:
echo    kubectl delete -k .
echo.
pause
