FROM php:cli-alpine

ENV APP_DIR "/data"

# Memory Limit
RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini

# Time Zone
RUN echo "date.timezone=${PHP_TIMEZONE:-UTC}" > $PHP_INI_DIR/conf.d/date_timezone.ini

# Allow Composer to be run as root
ENV COMPOSER_ALLOW_SUPERUSER 1

# Disable composer timeout
ENV COMPOSER_PROCESS_TIMEOUT 0

# Setup the Composer installer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &&\
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" &&\
    php composer-setup.php &&\
    php -r "unlink('composer-setup.php');"

RUN mv composer.phar /bin/composer

# install phpdbg
RUN apk add --no-cache \
    php7-phpdbg \
    bash

RUN docker-php-ext-install \
    pdo pdo_mysql \
    pcntl

# Set up the volumes and working directory
VOLUME ["$APP_DIR"]
WORKDIR "$APP_DIR"
EXPOSE 80
CMD ["php", "bin/console", "server:run", "0.0.0.0:80"]
