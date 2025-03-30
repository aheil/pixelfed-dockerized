#!/bin/bash

# Exit on error
set -e

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Get the project root directory (one level up from scripts)
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

# Load environment variables from project root
source "$PROJECT_ROOT/.ENV"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[BUILD]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if DOCKER_USERNAME is set
if [ -z "$DOCKER_USERNAME" ]; then
    print_error "DOCKER_USERNAME is not set in .env file"
    exit 1
fi

# Build images with version tags
print_status "Building PHP-FPM image..."
docker build -t ${DOCKER_USERNAME}/${PHPFDM_IMAGE_NAME}:latest \
    -t ${DOCKER_USERNAME}/${PHPFDM_IMAGE_NAME}:${PHP_VERSION} \
    -f "$PROJECT_ROOT/data/dockerfiles/phpfpm/Dockerfile" \
    "$PROJECT_ROOT/data/dockerfiles/phpfpm"

print_status "Building Nginx image..."
docker build -t ${DOCKER_USERNAME}/${NGINX_IMAGE_NAME}:latest \
    -t ${DOCKER_USERNAME}/${NGINX_IMAGE_NAME}:${NGINX_VERSION} \
    -f "$PROJECT_ROOT/data/dockerfiles/nginx/Dockerfile" \
    "$PROJECT_ROOT/data/dockerfiles/nginx"

print_status "Building Redis image..."
docker build -t ${DOCKER_USERNAME}/${REDIS_IMAGE_NAME}:latest \
    -t ${DOCKER_USERNAME}/${REDIS_IMAGE_NAME}:${REDIS_VERSION} \
    -f "$PROJECT_ROOT/data/dockerfiles/redis/Dockerfile" \
    "$PROJECT_ROOT/data/dockerfiles/redis"

print_status "All images built successfully!" 