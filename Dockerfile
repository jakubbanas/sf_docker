FROM php:apache
ENV APP_DIR "/var/www"

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

# Set up working directory
WORKDIR "$APP_DIR"
EXPOSE 80
