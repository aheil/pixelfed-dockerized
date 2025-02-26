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
  icu-dev

# Configure and install GD extension with required features
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
  && docker-php-ext-install -j$(nproc) \
  bcmath \
  ctype \
  curl \
  exif \
  gd \
  intl 
#  json \
#  mbstring \
#  openssl \
#  redis \
#  tokenizer \
#  xml \
#  zip

CMD ["php-fpm"]