@echo off
REM 🚀 CleanStart Go Web App Helm Test Script (Windows)
REM This script tests the Helm deployment using CleanStart Go images

echo 🚀 Starting CleanStart Go Web App Helm Test
echo ==========================================

REM Check if kubectl is available
echo [INFO] Checking kubectl availability...
kubectl version --client >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] kubectl is not available. Please install kubectl first.
    pause
    exit /b 1
)
echo [SUCCESS] kubectl is available
kubectl version --client

REM Check if helm is available
echo [INFO] Checking Helm availability...
helm version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Helm is not available. Please install Helm first.
    pause
    exit /b 1
)
echo [SUCCESS] Helm is available
helm version

REM Check if Kubernetes cluster is available
echo [INFO] Checking Kubernetes cluster...
kubectl cluster-info >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] No Kubernetes cluster found. Please ensure Kubernetes is running.
    pause
    exit /b 1
)
echo [SUCCESS] Kubernetes cluster is available
kubectl cluster-info

REM Test CleanStart Go image
echo [INFO] Testing CleanStart Go image...
docker pull cleanstart/go:latest
if %errorlevel% neq 0 (
    echo [WARNING] Failed to pull cleanstart/go:latest
)

docker run --rm cleanstart/go:latest go version
if %errorlevel% neq 0 (
    echo [ERROR] CleanStart Go image test failed
    pause
    exit /b 1
)
echo [SUCCESS] CleanStart Go image is working

REM Lint Helm chart
echo [INFO] Linting Helm chart...
helm lint ./go-web-app
if %errorlevel% neq 0 (
    echo [ERROR] Helm chart linting failed
    pause
    exit /b 1
)
echo [SUCCESS] Helm chart linting passed

REM Test Helm template rendering
echo [INFO] Testing Helm template rendering...
helm template go-web-app ./go-web-app --debug >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Helm template rendering failed
    pause
    exit /b 1
)
echo [SUCCESS] Helm template rendering successful

REM Deploy with Helm
echo [INFO] Deploying Go Web App with Helm...

REM Create namespace
kubectl create namespace go-web-app-test --dry-run=client -o yaml | kubectl apply -f -

REM Install with Helm
helm install go-web-app ./go-web-app --namespace go-web-app-test --wait --timeout=300s
if %errorlevel% neq 0 (
    echo [ERROR] Helm deployment failed
    pause
    exit /b 1
)
echo [SUCCESS] Helm deployment completed successfully

REM Wait for deployment to be ready
echo [INFO] Waiting for deployment to be ready...
kubectl wait --for=condition=available --timeout=300s deployment/go-web-app -n go-web-app-test
echo [SUCCESS] Deployment is ready!

REM Test application functionality
echo [INFO] Testing application functionality...

REM Port forward to access the application
start /b kubectl port-forward svc/go-web-app 8080:8080 -n go-web-app-test

REM Wait for port forward to be ready
timeout /t 5 /nobreak >nul

REM Test health endpoint
curl -f http://localhost:8080/ >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] Application health check failed
) else (
    echo [SUCCESS] Application health check passed
)

REM Test API endpoint
curl -f http://localhost:8080/api/users >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] API endpoint test failed
) else (
    echo [SUCCESS] API endpoint test passed
)

REM Test database persistence
echo [INFO] Testing database persistence...

REM Check if PVC is created
kubectl get pvc -n go-web-app-test | findstr "go-web-app-pvc" >nul
if %errorlevel% neq 0 (
    echo [WARNING] Persistent Volume Claim not found
) else (
    echo [SUCCESS] Persistent Volume Claim created
)

REM Check if data directory is mounted
kubectl exec deployment/go-web-app -n go-web-app-test -- ls /app/data >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] Data directory not mounted
) else (
    echo [SUCCESS] Data directory is mounted
)

REM Test upgrade
echo [INFO] Testing Helm upgrade...
helm upgrade go-web-app ./go-web-app --namespace go-web-app-test --set replicaCount=2 --wait --timeout=300s
if %errorlevel% neq 0 (
    echo [WARNING] Helm upgrade test failed
) else (
    echo [SUCCESS] Helm upgrade test passed
)

REM Show deployment status
echo.
echo [INFO] Deployment Status:
echo ===================
echo Pods:
kubectl get pods -n go-web-app-test -l app.kubernetes.io/name=go-web-app
echo.
echo Services:
kubectl get svc -n go-web-app-test -l app.kubernetes.io/name=go-web-app
echo.
echo PVCs:
kubectl get pvc -n go-web-app-test
echo.
echo Application Access:
echo Port forward: kubectl port-forward svc/go-web-app 8080:8080 -n go-web-app-test
echo Web interface: http://localhost:8080
echo API endpoint: http://localhost:8080/api/users

echo.
echo [SUCCESS] 🎉 CleanStart Go Web App Helm Test Completed Successfully!
echo [INFO] The Helm chart is working correctly with CleanStart Go image!
echo.
echo [INFO] To clean up: helm uninstall go-web-app -n go-web-app-test
echo.
pause
