<% ' Get server information using ASP
Dim serverHostname, serverName, serverIP, serverSoftware
serverHostname = Request.ServerVariables("COMPUTERNAME")
serverName = Request.ServerVariables("SERVER_NAME")
serverIP = Request.ServerVariables("LOCAL_ADDR")
serverSoftware = Request.ServerVariables("SERVER_SOFTWARE")

If serverHostname = "" Then
    serverHostname = Request.ServerVariables("HTTP_HOST")
End If
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ELB Load Balancer Test - Machine Info (ASP)</title>
    <style>
        body {
            font-family: ' Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 20px; background:
    linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; min-height: 100vh; display: flex; flex-direction:
    column; align-items: center; justify-content: center; } .container { background: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(10px); border-radius: 20px; padding: 40px; box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
    border: 1px solid rgba(255, 255, 255, 0.18); text-align: center; max-width: 800px; width: 100%; } h1 { font-size:
    2.5em; margin-bottom: 30px; text-shadow: 2px 2px 4px rgba(0,0,0,0.3); } .info-section { background: rgba(255, 255,
    255, 0.1); margin: 20px 0; padding: 20px; border-radius: 10px; border-left: 4px solid #ffd700; } .hostname {
    font-size: 2em; font-weight: bold; color: #ffd700; margin: 10px 0; text-shadow: 1px 1px 2px rgba(0,0,0,0.5);
    word-break: break-all; } .info-item { margin: 15px 0; font-size: 1.1em; } .label { font-weight: bold; color:
    #ffd700; display: inline-block; width: 180px; text-align: left; } .value { color: #ffffff;
    font-family: 'Courier New' , monospace; } .refresh-btn { background: linear-gradient(45deg, #ffd700, #ffed4e);
    color: #333; border: none; padding: 15px 30px; border-radius: 25px; font-size: 1.1em; font-weight: bold; cursor:
    pointer; margin-top: 20px; transition: transform 0.2s; } .refresh-btn:hover { transform: scale(1.05); } .timestamp {
    margin-top: 30px; font-size: 0.9em; opacity: 0.8; } .warning { background: rgba(255, 193, 7, 0.2); border: 1px solid
    #ffc107; border-radius: 5px; padding: 10px; margin: 20px 0; font-size: 0.9em; } .server-info { background: rgba(0,
    255, 0, 0.1); border: 1px solid #00ff00; border-radius: 5px; padding: 10px; margin: 20px 0; font-size: 0.9em; }
    </style>
    </head>

    <body>
        <div class="container">
            <h1>🔄 ELB Load Balancer Test (ASP)</h1>

            <div class="warning">
                ⚠️ Testing Environment - Security features disabled for load balancer testing
            </div>

            <div class="server-info">
                ✅ Server-side processing enabled - Real hostname available!
            </div>

            <div class="info-section">
                <h2>🖥️ Real Server Information</h2>
                <div class="hostname">
                    <%=serverHostname%>
                </div>
                <div class="info-item">
                    <span class="label">Server Name:</span>
                    <span class="value">
                        <%=serverName%>
                    </span>
                </div>
                <div class="info-item">
                    <span class="label">Server IP:</span>
                    <span class="value">
                        <%=serverIP%>
                    </span>
                </div>
                <div class="info-item">
                    <span class="label">Server Software:</span>
                    <span class="value">
                        <%=serverSoftware%>
                    </span>
                </div>
                <div class="info-item">
                    <span class="label">Request Time:</span>
                    <span class="value">
                        <%=Now()%>
                    </span>
                </div>
            </div>

            <div class="info-section">
                <h2>📊 System Information</h2>
                <div class="info-item">
                    <span class="label">Browser:</span>
                    <span class="value" id="browser">Loading...</span>
                </div>
                <div class="info-item">
                    <span class="label">Platform:</span>
                    <span class="value" id="platform">Loading...</span>
                </div>
                <div class="info-item">
                    <span class="label">User Agent:</span>
                    <span class="value">
                        <%=Request.ServerVariables("HTTP_USER_AGENT")%>
                    </span>
                </div>
                <div class="info-item">
                    <span class="label">Client IP:</span>
                    <span class="value">
                        <%=Request.ServerVariables("REMOTE_ADDR")%>
                    </span>
                </div>
                <div class="info-item">
                    <span class="label">Screen Resolution:</span>
                    <span class="value" id="resolution">Loading...</span>
                </div>
                <div class="info-item">
                    <span class="label">Language:</span>
                    <span class="value" id="language">Loading...</span>
                </div>
            </div>

            <div class="info-section">
                <h2>🌐 Network Information</h2>
                <div class="info-item">
                    <span class="label">Current URL:</span>
                    <span class="value">
                        <%=Request.ServerVariables("URL")%>
                    </span>
                </div>
                <div class="info-item">
                    <span class="label">Query String:</span>
                    <span class="value">
                        <%=Request.ServerVariables("QUERY_STRING")%>
                    </span>
                </div>
                <div class="info-item">
                    <span class="label">Protocol:</span>
                    <span class="value">
                        <%=Request.ServerVariables("SERVER_PROTOCOL")%>
                    </span>
                </div>
                <div class="info-item">
                    <span class="label">Port:</span>
                    <span class="value">
                        <%=Request.ServerVariables("SERVER_PORT")%>
                    </span>
                </div>
                <div class="info-item">
                    <span class="label">Method:</span>
                    <span class="value">
                        <%=Request.ServerVariables("REQUEST_METHOD")%>
                    </span>
                </div>
            </div>

            <div class="info-section">
                <h2>🕒 Session Information</h2>
                <div class="info-item">
                    <span class="label">Session ID:</span>
                    <span class="value" id="sessionId">Loading...</span>
                </div>
                <div class="info-item">
                    <span class="label">Random Number:</span>
                    <span class="value" id="randomNumber">Loading...</span>
                </div>
            </div>

            <button class="refresh-btn" onclick="window.location.reload()">🔄 Refresh Page</button>

            <div class="timestamp">
                Server Time: <%=Now()%> | Page processed server-side
            </div>
        </div>

        <script>
            // Generate client-side info
            const sessionId = 'session-' + Date.now() + '-' + Math.random().toString(36).substr(2, 9);

            function getBrowserInfo() {
                const ua = navigator.userAgent;
                if (ua.includes('Chrome')) return 'Chrome';
                if (ua.includes('Firefox')) return 'Firefox';
                if (ua.includes('Safari')) return 'Safari';
                if (ua.includes('Edge')) return 'Edge';
                if (ua.includes('Opera')) return 'Opera';
                return 'Unknown Browser';
            }

            function updateClientInfo() {
                // Update client-side information
                document.getElementById('browser').textContent = getBrowserInfo();
                document.getElementById('platform').textContent = navigator.platform || 'Unknown';
                document.getElementById('resolution').textContent = `${screen.width}x${screen.height}`;
                document.getElementById('language').textContent = navigator.language || 'Unknown';
                document.getElementById('sessionId').textContent = sessionId;
                document.getElementById('randomNumber').textContent = Math.floor(Math.random() * 1000000);
            }

            // Initial load
            document.addEventListener('DOMContentLoaded', updateClientInfo);

            console.log('ELB Load Balancer Test Page (ASP) Loaded');
            console.log('Session ID:', sessionId);
            console.log('Server Hostname: <%=serverHostname%>');
        </script>
    </body>

    </html>