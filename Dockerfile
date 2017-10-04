FROM php:7.1-fpm

RUN echo "deb http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list && \
    echo "deb-src http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62

RUN apt-get update \
    && apt-get install -y libmcrypt-dev mysql-client wget \
    && docker-php-ext-install mcrypt pdo_mysql

RUN docker-php-ext-install sockets

# Install phpunit
RUN wget https://phar.phpunit.de/phpunit-6.0.phar \
    && chmod +x phpunit-6.0.phar \
    && mv phpunit-6.0.phar /usr/local/bin/phpunit

RUN apt-get install -y nginx

ADD conf/nginx-vhost.conf /etc/nginx/conf.d/

RUN rm /etc/nginx/conf.d/default.conf

RUN mkdir -p /etc/ssl/nginx

RUN openssl req -new -nodes -x509 -subj "/C=US/ST=Minnesota/L=Minneapolis/O=ST/CN=localhost" -days 3650 -keyout /etc/ssl/nginx/server.key -out /etc/ssl/nginx/server.crt -extensions v3_ca

RUN apt-get install -y supervisor

ADD conf/supervisord.conf /etc/supervisord.conf

WORKDIR /srv/www

CMD /usr/bin/supervisord -n -c /etc/supervisord.conf