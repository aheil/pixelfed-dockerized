#!/bin/bash

# Exit on error
set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[SETUP]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Set correct permissions first
print_status "Setting permissions..."
chown -R www-data:www-data /var/www/pixelfed
chmod -R 755 /var/www/pixelfed
find /var/www/pixelfed -type f -exec chmod 644 {} \;

# Configure git to trust the repository directory
print_status "Configuring git safe directory..."
git config --global --add safe.directory /var/www/pixelfed

# Clone Pixelfed repository if not already cloned
if [ ! -d "/var/www/pixelfed/.git" ]; then
    print_status "Cloning Pixelfed repository..."
    git clone -b dev https://github.com/pixelfed/pixelfed.git /var/www/pixelfed
fi

# Create storage directory and set permissions
mkdir -p /var/www/pixelfed/storage
chown -R www-data:www-data /var/www/pixelfed/storage
chmod -R 775 /var/www/pixelfed/storage

# Create .env file for Pixelfed
print_status "Creating Pixelfed .env file..."
cat > /var/www/pixelfed/.env << EOL
APP_NAME="${APP_NAME}"
APP_ENV=${APP_ENV}
APP_DEBUG=${APP_DEBUG}
APP_URL=${APP_URL}
APP_KEY=${APP_KEY}

DB_CONNECTION=mysql
DB_HOST=${DB_HOST}
DB_PORT=${DB_PORT}
DB_DATABASE=${DB_DATABASE}
DB_USERNAME=${DB_USERNAME}
DB_PASSWORD=${DB_PASSWORD}

REDIS_HOST=${REDIS_HOST}
REDIS_PASSWORD=${REDIS_PASSWORD}
REDIS_PORT=${REDIS_PORT}

MAIL_MAILER=${MAIL_MAILER}
MAIL_HOST=${MAIL_HOST}
MAIL_PORT=${MAIL_PORT}
MAIL_USERNAME=${MAIL_USERNAME}
MAIL_PASSWORD=${MAIL_PASSWORD}
MAIL_ENCRYPTION=${MAIL_ENCRYPTION}
MAIL_FROM_ADDRESS=${MAIL_FROM_ADDRESS}
MAIL_FROM_NAME="${MAIL_FROM_NAME}"

ACTIVITY_PUB=${ACTIVITY_PUB}
AP_REMOTE_FOLLOW=${AP_REMOTE_FOLLOW}
IMAGE_DRIVER=${IMAGE_DRIVER}
EOL

# Install dependencies
print_status "Installing dependencies..."
composer install --no-ansi --no-interaction --optimize-autoloader --ignore-platform-req=ext-pcntl

# Generate application key if not set
if [ -z "$APP_KEY" ]; then
    print_status "Generating application key..."
    php artisan key:generate
fi

# Run database migrations
print_status "Running database migrations..."
php artisan migrate --force

# Start PHP-FPM
print_status "Starting PHP-FPM..."
exec php-fpm -d expose_php=0 