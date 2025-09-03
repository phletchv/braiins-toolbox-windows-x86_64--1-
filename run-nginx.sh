#!/bin/bash

# Braiins Toolbox - Nginx Web Application Runner
# This script runs an nginx container with the specified configuration

set -e

CONTAINER_NAME="mywebapp"
IMAGE_NAME="nginx"

echo "Starting nginx web application container..."
echo "Container name: $CONTAINER_NAME"
echo "Image: $IMAGE_NAME"
echo "Restart policy: always"
echo "Mode: detached"

# Run the nginx container
docker run --name "$CONTAINER_NAME" --restart always -d "$IMAGE_NAME"

echo "Container '$CONTAINER_NAME' started successfully!"
echo "To view logs: docker logs $CONTAINER_NAME"
echo "To stop: docker stop $CONTAINER_NAME"
echo "To remove: docker rm $CONTAINER_NAME"