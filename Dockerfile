FROM php:7-apache
RUN pecl install redis-4.1.1 \
    && docker-php-ext-enable redis