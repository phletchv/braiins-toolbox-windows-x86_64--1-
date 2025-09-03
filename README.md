# Braiins Toolbox - Mining Management Platform

This toolbox provides scripts and configuration for running a mining management web application with Hiveon OS connectivity features.

## Features

- Runs nginx container with name "mywebapp"
- Automatic restart policy (always)
- Detached mode execution
- Cross-platform support (Linux/macOS and Windows)
- Docker Compose alternative included
- **🆕 Hiveon OS Integration**
- **🆕 Pool Configuration Management**
- **🆕 Mining Connection Testing**
- **🆕 Automated Miner Configuration Generation**

## Hiveon OS Integration

### Configuration File
The `hiveon-config.json` file contains all settings for connecting to Hiveon OS:
- Pool configurations (multiple pools with failover)
- API endpoints and settings
- Miner configuration parameters
- Monitoring and alert settings
- Security configurations

### Connection Scripts

#### Linux/macOS
```bash
./connect-hiveon.sh [command]
```

Available commands:
- `config` - Show configuration summary
- `test` - Test all connections (pools and API)
- `test-pools` - Test pool connections only
- `test-api` - Test API connection only
- `generate` - Generate miner configuration file
- `validate` - Validate configuration file

#### Windows
```cmd
connect-hiveon.bat [command]
```

Available commands:
- `config` - Show configuration summary
- `validate` - Check if configuration file exists
- `test-simple` - Test basic connectivity
- `generate-simple` - Generate basic miner configuration

### Quick Start with Hiveon OS

1. **Edit Configuration**: Modify `hiveon-config.json` with your wallet address and preferences
2. **Test Connection**: Run `./connect-hiveon.sh test` to verify connectivity
3. **Generate Config**: Run `./connect-hiveon.sh generate` to create miner configuration
4. **Deploy**: Use the generated `miner-config-hiveon.conf` file with your mining setup

### Example Configuration
```json
{
  "pools": [
    {
      "name": "Hiveon Pool",
      "url": "stratum+tcp://eth-us-east1.hiveon.net:4444",
      "user": "YOUR_WALLET_ADDRESS.WORKER_NAME",
      "enabled": true
    }
  ]
}
```


## Prerequisites

- Docker installed and running on your system
- For Docker Compose: Docker Compose installed
- For full Hiveon OS features: `jq` (JSON processor) on Linux/macOS
- For Windows: PowerShell or Command Prompt

## Web Application Usage

### Option 1: Using Shell Scripts

#### Linux/macOS
```bash
./run-nginx.sh
```

#### Windows
```cmd
run-nginx.bat
```

### Option 2: Using Docker Compose
```bash
docker-compose up -d
```

### Option 3: Direct Docker Command
```bash
docker run --name mywebapp --restart always -d nginx
```

## What It Does

The scripts execute the following Docker command:
```bash
docker run --name mywebapp --restart always -d nginx
```

This command:
- Creates a new container named "mywebapp"
- Uses the official nginx image
- Sets restart policy to "always" (container restarts automatically if it stops)
- Runs in detached mode (background)

## Managing the Container

### View container logs
```bash
docker logs mywebapp
```

### Stop the container
```bash
docker stop mywebapp
```

### Remove the container
```bash
docker rm mywebapp
```

### Access the web application
Once running, the nginx server will be accessible at:
- http://localhost (when using Docker Compose with port mapping)
- Container internal port 80 (when using direct docker run)

## Files

- `run-nginx.sh` - Linux/macOS shell script for web application
- `run-nginx.bat` - Windows batch script for web application
- `docker-compose.yml` - Docker Compose configuration
- `html/index.html` - Mining management web interface
- **🆕 `hiveon-config.json`** - Hiveon OS connection configuration
- **🆕 `connect-hiveon.sh`** - Linux/macOS Hiveon OS connection script
- **🆕 `connect-hiveon.bat`** - Windows Hiveon OS connection script

## Troubleshooting

If you get a "container name already exists" error, remove the existing container first:
```bash
docker rm -f mywebapp
```