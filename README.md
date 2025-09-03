# Braiins Toolbox - Nginx Web Application

This toolbox provides scripts and configuration to run an nginx web application in a Docker container with automatic restart capabilities.

## Features

- Runs nginx container with name "mywebapp"
- Automatic restart policy (always)
- Detached mode execution
- Cross-platform support (Linux/macOS and Windows)
- Docker Compose alternative included

## Prerequisites

- Docker installed and running on your system
- For Docker Compose: Docker Compose installed

## Usage

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

- `run-nginx.sh` - Linux/macOS shell script
- `run-nginx.bat` - Windows batch script  
- `docker-compose.yml` - Docker Compose configuration
- `html/index.html` - Sample web page (used with Docker Compose)

## Troubleshooting

If you get a "container name already exists" error, remove the existing container first:
```bash
docker rm -f mywebapp
```