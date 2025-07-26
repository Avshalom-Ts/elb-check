# Load Balancer Test Site

A simple static site to test load balancer implementation by displaying server hostname and request information.

## Features

- 🖥️ **Hostname Display**: Shows the current server's hostname
- 📊 **Request Counter**: Tracks the number of requests to each server
- 🔄 **Auto-refresh**: Updates information every 5 seconds
- 💖 **Health Check**: Provides health check endpoint for load balancers
- 🎨 **Beautiful UI**: Modern, responsive design with glassmorphism effects

## Quick Start

### 1. Install Dependencies

```bash
npm install
```

### 2. Run Single Server

```bash
npm start
```

The server will start on port 3000 by default. Visit `http://localhost:3000` to see the site.

### 3. Run Multiple Servers for Load Balancer Testing

```bash
node test-multiple-servers.js
```

This will start three server instances on ports 3001, 3002, and 3003.

## API Endpoints

- **`GET /`** - Main page showing hostname and server info
- **`GET /api/info`** - JSON endpoint returning server information
- **`GET /health`** - Health check endpoint for load balancers

## Server Information Displayed

- **Hostname**: Operating system hostname
- **Port**: Server port number
- **Request Count**: Number of requests handled by this server instance
- **Timestamp**: Last update time
- **Platform & Architecture**: System information

## Load Balancer Configuration

When setting up your load balancer, configure it to distribute traffic between:

- `http://localhost:3001`
- `http://localhost:3002`
- `http://localhost:3003`

### Health Check Configuration

Use the `/health` endpoint for load balancer health checks:

- **Health Check URL**: `/health`
- **Expected Response**: HTTP 200 with JSON status
- **Check Interval**: 30 seconds (recommended)

## Environment Variables

- **`PORT`** - Server port (default: 3000)

## Example Load Balancer Test

1. Start multiple servers: `node test-multiple-servers.js`
2. Configure your load balancer to point to the three server instances
3. Visit your load balancer URL
4. Refresh the page multiple times and observe the hostname changing
5. Watch the request counters increment on different servers

## Docker Support

To run in Docker:

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

Build and run:

```bash
docker build -t elb-check .
docker run -p 3000:3000 elb-check
```

## Troubleshooting

- **Port already in use**: Change the PORT environment variable
- **Cannot connect**: Check firewall settings and ensure the server is running
- **Load balancer not working**: Verify all server instances are healthy using `/health` endpoint
repo to test Load Balancer implementation
