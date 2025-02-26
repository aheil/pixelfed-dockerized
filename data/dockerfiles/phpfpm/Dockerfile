FROM php:8.3.17-fpm-alpine3.21

LABEL org.opencontainers.image.authors="Andreas Heil @aheil@chaos.social"

# Install dependencies for PHP extensions
# curl-dev because of: configure: error: Package requirements (libcurl >= 7.29.0) were not met:
RUN apk add --no-cache \
  curl-dev \
  libpng-dev \
  gnu-libiconv-dev

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so

# Install and enable PHP extensions (https://docs.pixelfed.org/running-pixelfed/prerequisites.html#php-fpm)
RUN docker-php-ext-install \
  bcmath \
  ctype \
  curl \
  exif \
  gd \
  iconv
#intl \
#  json \
#  mbstring \
#  openssl \
#  redis \
#  tokenizer \
#  xml \
#  zip

CMD ["php-fpm"]