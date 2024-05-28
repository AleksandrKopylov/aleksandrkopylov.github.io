FROM php:8.3-fpm-alpine 

RUN apk update && apk upgrade \
    && apk add --no-cache --virtual .build-deps ${PHPIZE_DEPS} g++ make autoconf \
    && apk add --no-cache git mysql-client curl libmcrypt jpeg-dev libpng-dev freetype-dev libjpeg-turbo-dev libmcrypt-dev openssh-client icu-dev oniguruma-dev \
    openssh-client freetype-dev linux-headers\
    && docker-php-ext-configure pcntl --enable-pcntl\
    && docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg\
    && docker-php-ext-install pdo pdo_mysql intl bcmath sockets pcntl gd\
    && apk del .build-deps \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/apk/*

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY --from=composer /usr/bin/composer /usr/bin/composer

WORKDIR /app

RUN echo 'memory_limit = 2048M' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini;

CMD php-fpm

EXPOSE 9000