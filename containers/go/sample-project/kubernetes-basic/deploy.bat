@echo off
REM CleanStart Go Kubernetes Sample - Windows Deployment Script

echo CleanStart Go Kubernetes Sample - Deployment
echo ============================================
echo.

REM Check if kubectl is available
kubectl version --client >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] kubectl is not installed or not in PATH
    pause
    exit /b 1
)

REM Check cluster connectivity
kubectl cluster-info >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Cannot connect to Kubernetes cluster
    pause
    exit /b 1
)

echo [INFO] Deploying CleanStart Go Kubernetes Sample...

REM Deploy using kustomize
kubectl apply -k .

if %errorlevel% equ 0 (
    echo [SUCCESS] Deployment completed successfully!
    echo.
    echo [INFO] Waiting for deployment to be ready...
    kubectl wait --for=condition=available --timeout=300s deployment/go-sample-deployment -n go-sample
    
    echo.
    echo [INFO] Deployment Status:
    kubectl get all -n go-sample
    
    echo.
    echo [INFO] Access Information:
    echo To access the application locally, run:
    echo kubectl port-forward service/go-sample-service 8080:80 -n go-sample
    echo.
    echo Then visit: http://localhost:8080
    echo.
    echo Available endpoints:
    echo - http://localhost:8080/ (root)
    echo - http://localhost:8080/health (health check)
    echo - http://localhost:8080/info (application info)
    echo - http://localhost:8080/ready (readiness probe)
    echo - http://localhost:8080/live (liveness probe)
) else (
    echo [ERROR] Deployment failed!
)

echo.
pause
