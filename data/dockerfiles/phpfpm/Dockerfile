FROM php:8.3.17-fpm-alpine3.21

LABEL org.opencontainers.image.authors="Andreas Heil @aheil@chaos.social"

# Install dependencies for PHP extensions
RUN apk add --no-cache \
  git \
  curl-dev \
  libpng-dev \
  # Additional dependencies for other extensions
  linux-headers \
  oniguruma-dev \
  libxml2-dev \
  # GD dependencies
  freetype-dev \
  libjpeg-turbo-dev \
  libwebp-dev \
  zlib-dev \
  # ICU dependencies for intl
  icu-dev \
  # Dependencies for zip
  libzip-dev \
  # MySQL dependencies
  mariadb-dev \
  # Dependencies for PECL and Redis
  ${PHPIZE_DEPS} \
  # Shell
  bash

# Install Redis extension via PECL
RUN pecl install redis && docker-php-ext-enable redis

# Configure and install GD extension with required features, install required extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
  && docker-php-ext-install -j$(nproc) \
  bcmath \
  ctype \
  curl \
  exif \
  gd \
  intl \
  xml \
  zip \
  pdo \
  pdo_mysql

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/pixelfed

# Copy entrypoint script
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]