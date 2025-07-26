const express = require('express');
const path = require('path');
const os = require('os');

const app = express();
const PORT = process.env.PORT || 3000;

// Counter for tracking requests
let requestCount = 0;

// Serve static files
app.use(express.static(path.join(__dirname, '.')));

// API endpoint to get server information
app.get('/api/info', (req, res) => {
    requestCount++;
    
    const serverInfo = {
        hostname: os.hostname(),
        port: PORT,
        requestCount: requestCount,
        timestamp: new Date().toISOString(),
        platform: os.platform(),
        arch: os.arch(),
        nodeVersion: process.version,
        uptime: process.uptime()
    };
    
    console.log(`Request #${requestCount} - Hostname: ${serverInfo.hostname}`);
    res.json(serverInfo);
});

// Health check endpoint
app.get('/health', (req, res) => {
    res.status(200).json({ 
        status: 'healthy', 
        hostname: os.hostname(),
        timestamp: new Date().toISOString()
    });
});

// Serve index.html for root path
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

// Start the server
app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`);
    console.log(`📍 Hostname: ${os.hostname()}`);
    console.log(`🌐 Access the site at: http://localhost:${PORT}`);
    console.log(`❤️  Health check at: http://localhost:${PORT}/health`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
    console.log('SIGTERM received, shutting down gracefully...');
    process.exit(0);
});

process.on('SIGINT', () => {
    console.log('SIGINT received, shutting down gracefully...');
    process.exit(0);
});
