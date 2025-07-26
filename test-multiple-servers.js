const { spawn } = require('child_process');

// Configuration for different server instances
const servers = [
    { port: 3001, name: 'Server-A' },
    { port: 3002, name: 'Server-B' },
    { port: 3003, name: 'Server-C' }
];

console.log('🚀 Starting multiple server instances for load balancer testing...\n');

// Start each server instance
servers.forEach(server => {
    const serverProcess = spawn('node', ['server.js'], {
        env: { ...process.env, PORT: server.port },
        stdio: 'pipe'
    });
    
    console.log(`✅ ${server.name} starting on port ${server.port}`);
    
    serverProcess.stdout.on('data', (data) => {
        console.log(`[${server.name}:${server.port}] ${data.toString().trim()}`);
    });
    
    serverProcess.stderr.on('data', (data) => {
        console.error(`[${server.name}:${server.port}] ERROR: ${data.toString().trim()}`);
    });
    
    serverProcess.on('close', (code) => {
        console.log(`[${server.name}:${server.port}] Process exited with code ${code}`);
    });
});

console.log('\n📋 Server URLs:');
servers.forEach(server => {
    console.log(`   ${server.name}: http://localhost:${server.port}`);
});

console.log('\n🔍 Health check URLs:');
servers.forEach(server => {
    console.log(`   ${server.name}: http://localhost:${server.port}/health`);
});

console.log('\n💡 To test load balancing, configure your load balancer to distribute traffic between these ports.');
console.log('📌 Press Ctrl+C to stop all servers');

// Handle graceful shutdown
process.on('SIGINT', () => {
    console.log('\n🛑 Shutting down all servers...');
    process.exit(0);
});
