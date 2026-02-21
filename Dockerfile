FROM php:fpm-alpine

RUN apk update && apk add --no-cache \
    freetype-dev \
    git \
    libjpeg-turbo-dev \
    libpng-dev \
    libstdc++ \
    libzip-dev \
    openssh-client \
    openssl-dev \
    unzip \
    && apk add --no-cache --virtual build-dependencies $PHPIZE_DEPS \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) bcmath gd mysqli pcntl pdo_mysql zip

COPY --from=ghcr.io/php/pie:bin /pie /usr/bin/pie

RUN pie install phpredis/phpredis \
    && docker-php-ext-enable redis \
    && apk del build-dependencies \
    && curl -O https://getcomposer.org/composer-stable.phar \
    && mv composer-stable.phar /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer
