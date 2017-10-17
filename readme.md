# nginx-php-fpm Docker container

This container provides a basic development environment for PHP. It uses Supervisor to control PHP-FPM and nginx behind the scenes.

To add your application, make sure your source directory is mounted as a volume to `/srv/www`. nginx has been configured to serve the `/srv/www/public` directory by default.

Because it uses the php image as a basis, see [that image's documentation](https://hub.docker.com/_/php/) for instructions on how to add extensions to your own version of this container.

This container includes some common conveniences. They are:

* mysql-client
* wget
* phpunit
* pdo_mysql PHP extension
* mcrypt PHP extension
* sockets PHP extension

## Using the prebuilt image

To use the prebuilt image of this, just do:

```
docker pull startribune/nginx-php-fpm
```

## Exposing an app without using docker-compose

If you have a PHP application that you want to expose using this container, you can run it without having to write a Dockerfile or use docker-compose.

```
docker run --name my-php-app --mount type=bind,target=/srv/www/public,src=/Users/myuser/Documents/my-php-app -p 8080:80 nginx-php-fpm
```

Breaking the above command down, you have the following pieces:

```
docker run
```

This is how you initiate the run. Optionally, you could add the `-d` flag after this to run it in the background.

```
--name my-php-app
```

This is the name by which you want to refer to the running Docker container.

```
--mount type=bind,target=/srv/www/public,src=/Users/myuser/Documents/my-php-app
```

This mounts your app's source code directory into the appropriate directory in the container. Change `src` to be your source code directory. It must be an absolute path.

```
-p 8080:80
```

This tells Docker to expose port 80 of the container on port 8080 of your host machine, so you can reach it at http://localhost:8080/.

```
nginx-php-fpm
```

This tells Docker to run this container.
