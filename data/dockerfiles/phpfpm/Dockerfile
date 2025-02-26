FROM php:8.3.17-fpm-alpine3.21

LABEL org.opencontainers.image.authors="Andreas Heil @aheil@chaos.social"

# Install dependencies for PHP extensions
RUN apk add --no-cache \
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
  # Dependencies for PECL and Redis
  ${PHPIZE_DEPS}

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
  zip

CMD ["php-fpm"]