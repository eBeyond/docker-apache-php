FROM php:7-apache
ENV PORT 8080
RUN pecl install redis \
    && docker-php-ext-enable redis
CMD sed -i "s/80/$PORT/g" /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf && docker-php-entrypoint apache2-foreground
