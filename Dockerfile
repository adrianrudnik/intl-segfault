FROM php:8.2.8-apache

RUN set -ex \
    && apt-get update \
    && apt-get -y install locales 7zip zip git unzip libcurl4-gnutls-dev libicu-dev libzip-dev \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \
    && export EXTRA_CFLAGS="-I/usr/src/php" \
    && docker-php-ext-install -j$(nproc) \
        ctype \
        curl \
        intl \
        opcache \
        zip

RUN set -ex \
    && curl -sSL https://getcomposer.org/download/2.5.8/composer.phar -o /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer

RUN set -ex \
    && cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

COPY composer.json composer.json
COPY composer.lock composer.lock

RUN set -ex \
    && composer install

COPY index.php index.php
