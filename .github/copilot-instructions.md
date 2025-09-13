# Braiins Toolbox - Docker Nginx Web Application

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Overview
Braiins Toolbox is a Docker-based nginx web application that displays mining pool configuration and container status. The application serves a custom HTML page with mining pool details from configuration files. It supports three deployment methods with automatic restart capabilities.

## Working Effectively

### Prerequisites Validation
- Verify Docker is installed: `docker --version` (should show Docker version 28.0.4+)
- Verify Docker Compose is available: `docker compose version` (should show Docker Compose version v2.38.2+)
- **CRITICAL**: Docker Compose v1 (`docker-compose`) is NOT available - always use `docker compose` (v2 syntax)

### Deployment Methods (Choose One)

#### Method 1: Docker Compose (RECOMMENDED - includes port mapping)
```bash
cd [repo-root]
docker compose up -d
```
- **Timing**: 5-10 seconds for startup (first run includes image download)
- **Access**: Application available at http://localhost:80
- **Includes**: Port mapping (80:80) and volume mounting for custom HTML content

#### Method 2: Shell Script (Linux/macOS)
```bash
cd [repo-root]
chmod +x run-nginx.sh
./run-nginx.sh
```
- **Timing**: 2-5 seconds for startup
- **Note**: No port mapping - container runs on internal port 80 only
- **Access**: Container accessible internally only unless port mapping added manually

#### Method 3: Direct Docker Command
```bash
docker run --name mywebapp --restart always -d nginx
```
- **Timing**: 2-5 seconds for startup
- **Note**: No port mapping - container runs on internal port 80 only
- **Access**: Container accessible internally only unless port mapping added manually

### Container Management
```bash
# View running containers
docker ps

# View container logs
docker logs mywebapp

# Stop container (takes ~10 seconds)
docker stop mywebapp

# Remove container
docker rm mywebapp

# Force remove (stop and remove in one command)
docker rm -f mywebapp

# Stop and cleanup Docker Compose deployment (takes ~10 seconds)
docker compose down
```

### Troubleshooting Container Name Conflicts
If you get "container name already exists" error:
```bash
docker rm -f mywebapp
```

## Validation Requirements

### Manual Validation Steps
**ALWAYS** run through these validation scenarios after making changes:

1. **Deploy and Access Test**:
   ```bash
   cd [repo-root]
   docker compose up -d
   curl -s http://localhost | head -10
   ```
   - Verify HTML content is returned
   - Check for "Braiins Toolbox" title in response

2. **Web Application UI Test**:
   - Navigate to http://localhost in browser
   - Verify page displays "🚀 Braiins Toolbox" header
   - Verify "✅ Nginx container is running successfully!" status
   - Verify mining pool configuration section shows:
     - Pool Name: Hiveon Pool
     - URL: stratum+tcp://eth-us-east1.hiveon.net:4444
     - User: 0x8AF9F8d7f71f0625794544DC3aaF36d2c75b60F0
     - Status: ✅ Enabled

3. **Container Health Check**:
   ```bash
   docker ps
   # Verify container "mywebapp" is running with nginx image
   
   docker logs mywebapp
   # Verify nginx startup logs show "Configuration complete; ready for start up"
   ```

4. **Cleanup Test**:
   ```bash
   docker compose down
   # Should complete in ~10 seconds
   ```

### Expected Timing and Timeouts
- **Docker Compose startup**: 5-10 seconds. Set timeout to 30+ seconds.
- **Shell script startup**: 2-5 seconds. Set timeout to 15+ seconds.
- **Container shutdown**: ~10 seconds. Set timeout to 30+ seconds.
- **Image download** (first run): May take 1-2 minutes depending on connection. Set timeout to 180+ seconds.

**NEVER CANCEL**: Container operations may take longer on slower systems. Always wait for completion.

## Key Project Components

### Repository Structure
```
[repo-root]/
├── README.md              # Main documentation
├── docker-compose.yml     # Docker Compose configuration with port mapping
├── run-nginx.sh          # Linux/macOS deployment script
├── run-nginx.bat         # Windows deployment script  
├── .gitignore           # Git ignore rules
├── pools.json           # Root-level pool configuration
├── hiveon-config.json   # Mining configuration with overclock settings
└── html/
    ├── index.html       # Custom web application page
    └── pools.json       # HTML-directory pool configuration
```

### Configuration Files
- **html/index.html**: Custom web page with mining pool display and container status
- **pools.json**: Pool configuration data (both root and html/ versions)
- **hiveon-config.json**: Detailed mining preferences including overclock settings
- **docker-compose.yml**: Includes volume mounting: `./html:/usr/share/nginx/html:ro`

### Scripts
- **run-nginx.sh**: Linux/macOS shell script with container naming and restart policy
- **run-nginx.bat**: Windows batch script equivalent
- Both scripts create container named "mywebapp" with "always" restart policy

## Common Issues and Solutions

### Port Access Issues
- If using shell scripts or direct Docker commands, add port mapping: `-p 80:80`
- Docker Compose method automatically includes port mapping

### Configuration Changes
- HTML content changes: Requires Docker Compose method or manual volume mounting
- Container configuration changes: Modify docker-compose.yml
- Script modifications: Update run-nginx.sh or run-nginx.bat

### Deployment Method Selection
- **Use Docker Compose** for development and testing (includes port mapping and volume mounting)
- **Use shell scripts** for quick container deployment without web access
- **Use direct Docker commands** for minimal deployments or CI/CD integration

## No Build Process Required
This repository does NOT require building:
- No compilation steps needed
- No package managers (npm, pip, etc.)
- No linting or testing tools configured
- Static HTML and configuration files only
- Container uses pre-built nginx image

## Development Workflow
1. Make changes to HTML or configuration files
2. If using Docker Compose: `docker compose down && docker compose up -d`
3. If using scripts: `docker rm -f mywebapp && ./run-nginx.sh`
4. Validate using manual validation steps above
5. Take screenshot if UI changes made