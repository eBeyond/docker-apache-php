FROM php:7-apache
ENV PORT 8080
RUN apt-get update -y && apt-get install -y sendmail libpng-dev
RUN a2enmod rewrite
RUN apt-get update && \
    apt-get install -y \
	libcurl4-openssl-dev \
	libgd-dev \
	libfreetype6-dev \
	libldap2-dev \
	libjpeg62-turbo-dev \
	libmcrypt-dev \
	libpng-dev \
	libtidy-dev \
	libxslt-dev \
	zlib1g-dev \
	libzip-dev \
	libicu-dev \
	libgeoip-dev \
	--no-install-recommends && \
	rm -rf /var/lib/apt/lists/*
RUN pecl install redis \
    && docker-php-ext-enable redis \
    && docker-php-ext-install pdo pdo_mysql mysqli \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install geoip-1.1.1 \
    && docker-php-ext-enable geoip
COPY apache2/apache2.conf /etc/apache2/
RUN sed -i "s/80/$PORT/g" /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf
EXPOSE 8080
CMD docker-php-entrypoint apache2-foreground
