#!/bin/bash

# Exit on error
set -e

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Get the project root directory (one level up from scripts)
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[SSL]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Create SSL directory if it doesn't exist
SSL_DIR="$PROJECT_ROOT/data/nginx/ssl"
mkdir -p "$SSL_DIR"

# Generate SSL certificate and key
print_status "Generating self-signed SSL certificate..."
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$SSL_DIR/server.key" \
    -out "$SSL_DIR/server.crt" \
    -subj "/C=DE/ST=State/L=City/O=Organization/CN=pixelfed.example"

# Set proper permissions
chmod 600 "$SSL_DIR/server.key"
chmod 644 "$SSL_DIR/server.crt"

print_status "SSL certificate generated successfully!"
print_status "Certificate location: $SSL_DIR/server.crt"
print_status "Private key location: $SSL_DIR/server.key" 