const fs = require('fs');
const path = require('path');
const os = require('os');

// Build configuration
const BUILD_DIR = 'build';
const SOURCE_FILES = ['index.html'];

console.log('🏗️  Building project for IIS deployment...\n');

// Create build directory
if (!fs.existsSync(BUILD_DIR)) {
    fs.mkdirSync(BUILD_DIR, { recursive: true });
    console.log(`✅ Created build directory: ${BUILD_DIR}`);
} else {
    console.log(`📁 Build directory exists: ${BUILD_DIR}`);
}

// Function to copy files
function copyFile(src, dest) {
    try {
        fs.copyFileSync(src, dest);
        console.log(`📄 Copied: ${src} → ${dest}`);
    } catch (error) {
        console.error(`❌ Error copying ${src}:`, error.message);
    }
}

// Copy static files
SOURCE_FILES.forEach(file => {
    const srcPath = path.join(__dirname, file);
    const destPath = path.join(__dirname, BUILD_DIR, file);
    
    if (fs.existsSync(srcPath)) {
        copyFile(srcPath, destPath);
    } else {
        console.warn(`⚠️  Source file not found: ${srcPath}`);
    }
});

// Create a static version of index.html with hostname embedded
function createStaticVersion() {
    const indexPath = path.join(__dirname, 'index.html');
    const staticIndexPath = path.join(__dirname, BUILD_DIR, 'index.html');
    
    if (!fs.existsSync(indexPath)) {
        console.error('❌ index.html not found');
        return;
    }
    
    let content = fs.readFileSync(indexPath, 'utf8');
    
    // Replace the dynamic JavaScript with static content
    const staticHostname = os.hostname();
    const currentTime = new Date().toLocaleString();
    
    // Create static version with embedded hostname
    const staticContent = content.replace(
        /async function fetchServerInfo\(\) \{[\s\S]*?function refreshData\(\)/,
        `function fetchServerInfo() {
            // Static version for IIS deployment
            document.getElementById('hostname').textContent = '${staticHostname}';
            document.getElementById('port').textContent = 'IIS Server';
            document.getElementById('requestCount').textContent = 'Static Build';
            document.getElementById('timestamp').textContent = 'Built: ${currentTime}';
        }
        
        function refreshData()`
    );
    
    fs.writeFileSync(staticIndexPath, staticContent);
    console.log('✅ Created static version with embedded hostname');
}

// Create web.config for IIS
function createWebConfig() {
    const webConfigContent = `<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <system.webServer>
    <!-- Enable static file serving -->
    <staticContent>
      <mimeMap fileExtension=".json" mimeType="application/json" />
      <mimeMap fileExtension=".woff" mimeType="application/font-woff" />
      <mimeMap fileExtension=".woff2" mimeType="application/font-woff2" />
    </staticContent>
    
    <!-- Default document -->
    <defaultDocument>
      <files>
        <clear />
        <add value="index.html" />
      </files>
    </defaultDocument>
    
    <!-- URL Rewrite rules for SPA-like behavior -->
    <rewrite>
      <rules>
        <rule name="StaticInfo" stopProcessing="true">
          <match url="^api/info$" />
          <action type="Rewrite" url="/api-info.json" />
        </rule>
        <rule name="HealthCheck" stopProcessing="true">
          <match url="^health$" />
          <action type="Rewrite" url="/health.json" />
        </rule>
      </rules>
    </rewrite>
    
    <!-- Custom headers -->
    <httpProtocol>
      <customHeaders>
        <add name="Cache-Control" value="no-cache, no-store, must-revalidate" />
        <add name="Pragma" value="no-cache" />
        <add name="Expires" value="0" />
      </customHeaders>
    </httpProtocol>
    
    <!-- Error pages -->
    <httpErrors errorMode="Custom">
      <error statusCode="404" path="/index.html" responseMode="ExecuteURL" />
    </httpErrors>
  </system.webServer>
</configuration>`;
    
    const webConfigPath = path.join(__dirname, BUILD_DIR, 'web.config');
    fs.writeFileSync(webConfigPath, webConfigContent);
    console.log('✅ Created web.config for IIS');
}

// Create static API responses
function createStaticApiResponses() {
    const hostname = os.hostname();
    const buildTime = new Date().toISOString();
    
    // Create api-info.json
    const apiInfo = {
        hostname: hostname,
        port: 'IIS',
        requestCount: 'Static Build',
        timestamp: buildTime,
        platform: os.platform(),
        arch: os.arch(),
        buildTime: buildTime,
        serverType: 'IIS Static'
    };
    
    const apiInfoPath = path.join(__dirname, BUILD_DIR, 'api-info.json');
    fs.writeFileSync(apiInfoPath, JSON.stringify(apiInfo, null, 2));
    console.log('✅ Created static API info response');
    
    // Create health.json
    const healthInfo = {
        status: 'healthy',
        hostname: hostname,
        timestamp: buildTime,
        serverType: 'IIS Static'
    };
    
    const healthPath = path.join(__dirname, BUILD_DIR, 'health.json');
    fs.writeFileSync(healthPath, JSON.stringify(healthInfo, null, 2));
    console.log('✅ Created static health check response');
}

// Create deployment instructions
function createDeploymentInstructions() {
    const instructions = `# IIS Deployment Instructions

## Files in this build:
- index.html - Main application page
- web.config - IIS configuration
- api-info.json - Static API response for /api/info
- health.json - Static health check response for /health

## Deployment Steps:

1. **Copy files to IIS web root:**
   Copy all files from this build folder to your IIS website directory
   (e.g., C:\\inetpub\\wwwroot\\elb-check\\)

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

Built on: ${new Date().toLocaleString()}
Build hostname: ${os.hostname()}
`;
    
    const instructionsPath = path.join(__dirname, BUILD_DIR, 'DEPLOYMENT.md');
    fs.writeFileSync(instructionsPath, instructions);
    console.log('✅ Created deployment instructions');
}

// Execute build steps
try {
    createStaticVersion();
    createWebConfig();
    createStaticApiResponses();
    createDeploymentInstructions();
    
    console.log('\n🎉 Build completed successfully!');
    console.log(`📦 Build output: ${path.resolve(BUILD_DIR)}`);
    console.log('\n📋 Next steps:');
    console.log('   1. Copy the build folder contents to your IIS web directory');
    console.log('   2. Configure IIS application/virtual directory');
    console.log('   3. Ensure URL Rewrite Module is installed');
    console.log('   4. Test the deployment');
    console.log('\n📖 See DEPLOYMENT.md in the build folder for detailed instructions');
    
} catch (error) {
    console.error('❌ Build failed:', error.message);
    process.exit(1);
}
