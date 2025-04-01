# Pixelfed Dockerized

This repository provides a complete Docker setup for running [Pixelfed](https://pixelfed.org/), a free and ethical photo sharing platform. This setup includes all necessary services and configurations to run Pixelfed in a production environment.

## About Pixelfed

Pixelfed is a free and open-source photo sharing platform, part of the Fediverse network. It's designed as an ethical alternative to Instagram, focusing on privacy and user control. For more information about Pixelfed and its features, visit the [official Pixelfed website](https://pixelfed.org/).

## Features

- Complete Docker-based setup
- Nginx web server with SSL support
- PHP-FPM optimized for Pixelfed
- MariaDB database
- Redis for caching
- Automated setup and configuration
- Production-ready defaults
- Easy deployment and updates

## Architecture

This setup uses the following components:
- Nginx as the web server
- PHP-FPM 8.3 with all required extensions
- MariaDB 10.11 for the database
- Redis 7.2 for caching
- Automated SSL certificate generation
- Docker volumes for persistent data storage

## Documentation

For detailed information about Pixelfed's requirements and configuration options, please refer to:
- [Official Pixelfed Documentation](https://docs.pixelfed.org/)
- [Pixelfed Installation Guide](https://docs.pixelfed.org/running-pixelfed/)
- [Pixelfed GitHub Repository](https://github.com/pixelfed/pixelfed)

## Disclaimer

⚠️ **Development Version Notice**

This Docker setup is currently in development and should be considered a beta version. It is **not** officially affiliated with or endorsed by the Pixelfed development team. This is a community-driven project with the sole purpose of making Pixelfed more accessible to users who prefer containerized deployments.

### Community Project

This project is:
- Created and maintained by community members
- Not officially associated with Pixelfed development
- Provided as-is without any guarantees
- Open to community [contributions](CONTRIBUTING.md) and feedback

### Goals

The main objectives of this project are to:
- Simplify Pixelfed deployment using Docker
- Lower the technical barrier for self-hosting Pixelfed
- Provide a standardized container setup for the community
- Enable easy updates and maintenance

### Status

While we strive to maintain best practices and security standards, please:
- Use this setup with caution in production environments
- Report any issues you encounter
- Consider contributing to improve the project
- Stay updated with official Pixelfed releases

For production deployments, always refer to the official Pixelfed documentation and make informed decisions based on your specific needs.

# Run & Setup

## Prerequisites
- Docker Engine 24.0.0 or later
- Docker Compose v2.0.0 or later
- Git

## Initial Setup

1. Clone this repository:
   ```bash
   git clone https://github.com/aheil/pixelfed-dockerized.git
   cd pixelfed-dockerized
   ```

2. Create and configure your `.env` file:
   ```bash
   cp .env.example .env
   ```
   Edit `.env` and set at least these required variables:
   ```
   APP_KEY=base64:your_random_32_character_key_here
   APP_URL=your_domain_or_localhost
   DB_PASSWORD=your_secure_password_here
   DB_ROOT_PASSWORD=your_secure_root_password_here
   ```

3. Generate SSL certificates (for HTTPS):
   ```bash
   ./scripts/generate-ssl.sh
   ```

## Running the Application

1. Build the Docker images:
   ```bash
   ./scripts/build.sh
   ```

2. Start all services:
   ```bash
   docker-compose up -d
   ```

3. Monitor the logs:
   ```bash
   docker-compose logs -f
   ```

## Common Tasks

### Database Migrations
To run database migrations:
```bash
docker-compose exec php-fpm-pixelfed php artisan migrate
```

### Cache Management
Clear application cache:
```bash
docker-compose exec php-fpm-pixelfed php artisan cache:clear
```

Clear config cache:
```bash
docker-compose exec php-fpm-pixelfed php artisan config:clear
```

### Storage Setup
Create storage link:
```bash
docker-compose exec php-fpm-pixelfed php artisan storage:link
```

### Maintenance Mode
Enable maintenance mode:
```bash
docker-compose exec php-fpm-pixelfed php artisan down
```

Disable maintenance mode:
```bash
docker-compose exec php-fpm-pixelfed php artisan up
```

## Stopping the Application

To stop all services:
```bash
docker-compose down
```

To stop all services and remove volumes (warning: this will delete all data):
```bash
docker-compose down -v
```

## Updating

1. Pull the latest changes:
   ```bash
   git pull origin main
   ```

2. Rebuild the images:
   ```bash
   ./scripts/build.sh
   ```

3. Restart the services:
   ```bash
   docker-compose down
   docker-compose up -d
   ```

4. Run database migrations:
   ```bash
   docker-compose exec php-fpm-pixelfed php artisan migrate
   ```

# Containers

The following containers are defined in `docker-compose.yml`:

## nginx
- Purpose: Web server that handles HTTP requests and serves the Pixelfed application
- Image: Custom Nginx image based on Alpine
- Ports:
  - `${NGINX_PORT}:80` (HTTP)
  - `${NGINX_SSL_PORT}:443` (HTTPS)
- Volumes:
  - `./data/nginx/conf.d:/etc/nginx/conf.d` - Nginx configuration
  - `./data/nginx/ssl:/etc/nginx/ssl` - SSL certificates
  - `./data/pixelfed:/var/www/pixelfed` - Pixelfed application files
- Dependencies: Requires php-fpm-pixelfed service

## php-fpm-pixelfed
- Purpose: PHP FastCGI Process Manager that runs the Pixelfed application
- Image: Custom PHP-FPM image with required extensions
- Key Features:
  - PHP 8.3.17 with essential extensions (GD, Redis, PDO MySQL, etc.)
  - Composer for dependency management
  - Git for repository management
- Volumes:
  - `./data/pixelfed:/var/www/pixelfed` - Pixelfed application files
- Dependencies: Requires mariadb and redis services

## mariadb
- Purpose: Database server for Pixelfed
- Image: Official MariaDB image
- Version: 10.11
- Environment Variables:
  - Database name, user, and passwords configured via .env
- Volumes:
  - `./data/mariadb:/var/lib/mysql` - Persistent database storage
- Ports:
  - `${DB_PORT}:3306` - Database access

## redis
- Purpose: In-memory cache for improved performance
- Image: Official Redis image
- Version: 7.2
- Features:
  - Optional password protection
  - Persistent data storage
- Volumes:
  - `./data/redis:/data` - Redis data persistence
- Ports:
  - `${REDIS_PORT}:6379` - Redis access

All containers are connected through a dedicated Docker network `pixelfed-network` to ensure secure communication between services.

# Build & Publish

This project uses Docker for containerization and provides scripts for building and publishing the images.

## Building Images

To build all required Docker images, run:

```bash
./scripts/build.sh
```

This will build the following images:
- `nginx` - Nginx web server configured for Pixelfed
- `php-fpm` - PHP-FPM with all required extensions for Pixelfed

## Publishing Images

To publish the images to Docker Hub, you'll need:
1. A Docker Hub account
2. The following environment variables in your `.env` file:
   ```
   DOCKER_USERNAME=your_dockerhub_username
   ```

Then run:
```bash
./scripts/push.sh
```

If you haven't logged into Docker Hub, the script will prompt you for your password. For security reasons, the password is not stored in the `.env` file.

### Image Versions

The following versions are used by default:
- PHP: 8.3.17
- Nginx: 1.25.4
- Redis: 7.2
- MariaDB: 10.11

You can modify these versions in your `.env` file:
