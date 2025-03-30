#!/bin/bash

# Exit on error
set -e

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Get the project root directory (one level up from scripts)
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )" 

# Load environment variables from project root
source "$PROJECT_ROOT/.env"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[PUSH]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if DOCKER_USERNAME is set
if [ -z "$DOCKER_USERNAME" ]; then
    print_error "DOCKER_USERNAME is not set in .env file"
    exit 1
fi

# Check if DOCKER_PASSWORD is set
if [ -z "$DOCKER_PASSWORD" ]; then
    print_error "DOCKER_PASSWORD is not set in .env file"
    exit 1
fi

# Login to DockerHub
print_status "Logging in to DockerHub..."
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

# Push images with version tags
print_status "Pushing PHP-FPM image..."
docker push ${DOCKER_USERNAME}/${PHPFDM_IMAGE_NAME}:latest
docker push ${DOCKER_USERNAME}/${PHPFDM_IMAGE_NAME}:${PHP_VERSION}

print_status "Pushing Nginx image..."
docker push ${DOCKER_USERNAME}/${NGINX_IMAGE_NAME}:latest
docker push ${DOCKER_USERNAME}/${NGINX_IMAGE_NAME}:${NGINX_VERSION}

print_status "Pushing Redis image..."
docker push ${DOCKER_USERNAME}/${REDIS_IMAGE_NAME}:latest
docker push ${DOCKER_USERNAME}/${REDIS_IMAGE_NAME}:${REDIS_VERSION}

print_status "All images pushed successfully!"

# Logout from DockerHub
print_status "Logging out from DockerHub..."
docker logout 