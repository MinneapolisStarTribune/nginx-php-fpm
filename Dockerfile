FROM php:7.1-fpm

RUN echo "deb http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list && \
    echo "deb-src http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62

RUN apt-get update \
    && apt-get install -y libmcrypt-dev mysql-client wget \
    && docker-php-ext-install mcrypt pdo_mysql

RUN docker-php-ext-install sockets

# Install git and PHP zip ext
RUN apt-get install -y zlibc zlib1g zlib1g-dev git \
    && docker-php-ext-install zip

# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

# Install phpunit
RUN wget https://phar.phpunit.de/phpunit-6.0.phar \
    && chmod +x phpunit-6.0.phar \
    && mv phpunit-6.0.phar /usr/local/bin/phpunit

RUN apt-get install -y nginx

ADD conf/nginx-vhost.conf /etc/nginx/conf.d/

RUN rm /etc/nginx/conf.d/default.conf

RUN apt-get install -y supervisor

ADD conf/supervisord.conf /etc/supervisord.conf

WORKDIR /srv/www

CMD /usr/bin/supervisord -n -c /etc/supervisord.conf
