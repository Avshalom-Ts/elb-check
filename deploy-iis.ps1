# IIS Deployment PowerShell Script
# Run this script as Administrator to deploy to IIS

param(
    [string]$SiteName = "elb-check",
    [string]$AppPoolName = "elb-check-pool",
    [string]$PhysicalPath = "C:\inetpub\wwwroot\elb-check",
    [int]$Port = 8080
)

Write-Host "🚀 IIS Deployment Script for Load Balancer Test" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green

# Check if running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

# Import WebAdministration module
Write-Host "📦 Importing WebAdministration module..." -ForegroundColor Cyan
try {
    Import-Module WebAdministration -ErrorAction Stop
    Write-Host "✅ WebAdministration module loaded" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to load WebAdministration module. Please install IIS Management Tools." -ForegroundColor Red
    exit 1
}

# Create physical directory
Write-Host "📁 Creating physical directory: $PhysicalPath" -ForegroundColor Cyan
if (!(Test-Path $PhysicalPath)) {
    New-Item -ItemType Directory -Path $PhysicalPath -Force | Out-Null
    Write-Host "✅ Directory created: $PhysicalPath" -ForegroundColor Green
} else {
    Write-Host "📁 Directory already exists: $PhysicalPath" -ForegroundColor Yellow
}

# Copy build files
Write-Host "📋 Copying build files..." -ForegroundColor Cyan
$BuildPath = Join-Path $PSScriptRoot "build\*"
if (Test-Path (Join-Path $PSScriptRoot "build")) {
    Copy-Item -Path $BuildPath -Destination $PhysicalPath -Recurse -Force
    Write-Host "✅ Build files copied to $PhysicalPath" -ForegroundColor Green
} else {
    Write-Host "❌ Build folder not found. Please run 'npm run build' first." -ForegroundColor Red
    exit 1
}

# Create Application Pool
Write-Host "🏊 Creating Application Pool: $AppPoolName" -ForegroundColor Cyan
if (Get-IISAppPool -Name $AppPoolName -ErrorAction SilentlyContinue) {
    Write-Host "🏊 Application Pool already exists: $AppPoolName" -ForegroundColor Yellow
    Stop-WebAppPool -Name $AppPoolName -ErrorAction SilentlyContinue
    Start-WebAppPool -Name $AppPoolName
} else {
    New-WebAppPool -Name $AppPoolName
    Set-ItemProperty -Path "IIS:\AppPools\$AppPoolName" -Name processModel.identityType -Value ApplicationPoolIdentity
    Set-ItemProperty -Path "IIS:\AppPools\$AppPoolName" -Name managedRuntimeVersion -Value ""
    Write-Host "✅ Application Pool created: $AppPoolName" -ForegroundColor Green
}

# Create Website
Write-Host "🌐 Creating Website: $SiteName" -ForegroundColor Cyan
if (Get-Website -Name $SiteName -ErrorAction SilentlyContinue) {
    Write-Host "🌐 Website already exists: $SiteName" -ForegroundColor Yellow
    Remove-Website -Name $SiteName
}

New-Website -Name $SiteName -PhysicalPath $PhysicalPath -Port $Port -ApplicationPool $AppPoolName
Write-Host "✅ Website created: $SiteName on port $Port" -ForegroundColor Green

# Set permissions
Write-Host "🔐 Setting permissions..." -ForegroundColor Cyan
$acl = Get-Acl $PhysicalPath
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("IIS_IUSRS", "ReadAndExecute", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.SetAccessRule($accessRule)
Set-Acl -Path $PhysicalPath -AclObject $acl
Write-Host "✅ Permissions set for IIS_IUSRS" -ForegroundColor Green

# Start the website
Write-Host "▶️  Starting website..." -ForegroundColor Cyan
Start-Website -Name $SiteName
Write-Host "✅ Website started successfully" -ForegroundColor Green

Write-Host ""
Write-Host "🎉 Deployment completed successfully!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host "📍 Website URL: http://localhost:$Port" -ForegroundColor Cyan
Write-Host "🏥 Health Check: http://localhost:$Port/health" -ForegroundColor Cyan
Write-Host "📊 API Info: http://localhost:$Port/api/info" -ForegroundColor Cyan
Write-Host ""
Write-Host "🔧 To deploy to multiple servers for load balancer testing:" -ForegroundColor Yellow
Write-Host "   1. Run this script on each server with different ports:"
Write-Host "      .\deploy-iis.ps1 -Port 8081 -SiteName 'elb-check-1'"
Write-Host "      .\deploy-iis.ps1 -Port 8082 -SiteName 'elb-check-2'"
Write-Host "      .\deploy-iis.ps1 -Port 8083 -SiteName 'elb-check-3'"
Write-Host "   2. Configure your load balancer to distribute between these URLs"
Write-Host ""
Write-Host "📋 Management Commands:" -ForegroundColor Yellow
Write-Host "   Stop:    Stop-Website -Name '$SiteName'"
Write-Host "   Start:   Start-Website -Name '$SiteName'"
Write-Host "   Remove:  Remove-Website -Name '$SiteName'; Remove-WebAppPool -Name '$AppPoolName'"
