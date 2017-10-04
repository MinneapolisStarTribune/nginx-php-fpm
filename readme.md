# nginx-php-fpm Docker container

This container provides a basic development environment for PHP. It uses Supervisor to control PHP-FPM and nginx behind the scenes.

To add your application, make sure your source directory is added a volume to `/srv/www`. nginx has been configured to serve the `/srv/www/public` directory by default.

Because it uses the php image as a basis, see [that image's documentation](https://hub.docker.com/_/php/) for instructions on how to add extensions to your own version of this container.

This container includes some common conveniences. They are:

* mysql-client
* wget
* phpunit
* pdo_mysql PHP extension
* mcrypt PHP extension
* sockets PHP extension