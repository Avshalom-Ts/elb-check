@echo off
echo ========================================
echo   IIS Load Balancer Test Deployment
echo ========================================
echo.

echo Building project...
call npm run build
if errorlevel 1 (
    echo Build failed!
    pause
    exit /b 1
)

echo.
echo Build completed successfully!
echo.
echo To deploy to IIS, run ONE of these options:
echo.
echo OPTION 1 - Automatic IIS deployment (requires Administrator):
echo   Right-click this file and "Run as Administrator"
echo   OR
echo   Open PowerShell as Administrator and run:
echo   .\deploy-iis.ps1
echo.
echo OPTION 2 - Manual deployment:
echo   1. Copy the 'build' folder contents to your IIS website directory
echo   2. Create an IIS Application/Virtual Directory pointing to that folder
echo   3. Ensure URL Rewrite Module 2.1 is installed
echo.
echo OPTION 3 - Multiple servers for load balancer testing:
echo   Deploy to different ports on each server:
echo   Server 1: .\deploy-iis.ps1 -Port 8081 -SiteName "elb-check-1"
echo   Server 2: .\deploy-iis.ps1 -Port 8082 -SiteName "elb-check-2"
echo   Server 3: .\deploy-iis.ps1 -Port 8083 -SiteName "elb-check-3"
echo.
echo Build files are ready in the 'build' folder.
echo See DEPLOYMENT.md in the build folder for detailed instructions.
echo.

:: Check if running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running as Administrator - Starting automatic deployment...
    echo.
    powershell -ExecutionPolicy Bypass -File deploy-iis.ps1
    if errorlevel 1 (
        echo Deployment failed!
    ) else (
        echo.
        echo Deployment completed! Visit http://localhost:8080
    )
) else (
    echo Not running as Administrator - Manual deployment required.
    echo See instructions above.
)

echo.
pause
