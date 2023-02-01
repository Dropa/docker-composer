FROM php:8.2-alpine

LABEL maintainer="Sami Hellsten"

RUN apk add --no-cache --virtual .persistent-deps \
    zip \
    unzip \
    git \
    patch \
    libpng-dev && \
    docker-php-ext-install gd

RUN echo "memory_limit = -1" > /usr/local/etc/php/conf.d/memory-limit.ini \
    && echo "date.timezone = UTC" >> /usr/local/etc/php/conf.d/date-timezone.ini

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/bin/composer \
    && chmod +x /usr/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV PATH "$PATH:/root/.composer/vendor/bin"

WORKDIR /app

CMD ["composer"]
