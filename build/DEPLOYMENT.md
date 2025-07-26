# IIS Deployment Instructions

## Files in this build:
- index.html - Main application page
- web.config - IIS configuration
- api-info.json - Static API response for /api/info
- health.json - Static health check response for /health

## Deployment Steps:

1. **Copy files to IIS web root:**
   Copy all files from this build folder to your IIS website directory
   (e.g., C:\inetpub\wwwroot\elb-check\)

2. **Configure IIS Application:**
   - Open IIS Manager
   - Create a new Application or Virtual Directory
   - Point it to the folder containing these files
   - Ensure "Anonymous Authentication" is enabled

3. **Verify URL Rewrite Module:**
   - Install URL Rewrite Module 2.1 if not already installed
   - Download from: https://www.iis.net/downloads/microsoft/url-rewrite

4. **Test the deployment:**
   - Visit: http://your-server/elb-check/
   - Check health: http://your-server/elb-check/health
   - Check API: http://your-server/elb-check/api/info

## Load Balancer Configuration:

For load balancer testing, deploy this build to multiple IIS servers:
- Server 1: http://server1/elb-check/
- Server 2: http://server2/elb-check/  
- Server 3: http://server3/elb-check/

Each server will show its own hostname, allowing you to verify 
load balancer distribution.

## Customization:

To customize the hostname display:
1. Edit the hostname value in api-info.json
2. Update the hostname in health.json
3. The page will display the hostname from the JSON file

Built on: 26.7.2025, 12:17:25
Build hostname: AvshalomPc
