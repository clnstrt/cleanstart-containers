@echo off
REM CleanStart Go Kubernetes Sample - Windows Undeployment Script

echo CleanStart Go Kubernetes Sample - Undeployment
echo ==============================================
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

echo [INFO] Removing CleanStart Go Kubernetes Sample...

REM Remove using kustomize
kubectl delete -k .

if %errorlevel% equ 0 (
    echo [SUCCESS] Undeployment completed successfully!
    echo.
    echo [INFO] Waiting for cleanup...
    timeout /t 10 /nobreak >nul
    
    echo [INFO] Final Status Check:
    kubectl get all -n go-sample 2>nul
    if %errorlevel% neq 0 (
        echo [SUCCESS] All resources have been removed
    ) else (
        echo [WARNING] Some resources may still exist
    )
) else (
    echo [ERROR] Undeployment failed!
)

echo.
pause
