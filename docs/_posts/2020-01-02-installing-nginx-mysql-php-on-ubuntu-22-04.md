---
title: Installing Nginx, MySQL, PHP on Ubuntu 22.04
date: 2020-01-02 00:00:00
featured_image: https://images.unsplash.com/photo-1442328166075-47fe7153c128
excerpt: In this guide you will learn how to install Nginx, MySQL 8.0 and PHP 8.1 and PHP-FPM on Ubuntu 22.04.
---

![](https://images.unsplash.com/photo-1442328166075-47fe7153c128)

In this guide you will learn how to install Nginx, MySQL 8.0 and PHP 8.1 and PHP-FPM on Ubuntu 22.04.

### Getting Started

- Update and upgrade the packages and reboot the server.

```bash
$ apt-get update
$ apt-get upgrade -y
$ apt-get autoremove -y

$ reboot
```

- Install required packages.

```bash
$ apt-get install unzip zip
```

### Installing Nginx

- Install nginx.

```bash
$ apt-get install nginx -y
```

- Remove default site.

```bash
$ unlink /etc/nginx/sites-enabled/default
```

```bash
$ sudo nginx -t
$ systemctl reload nginx
```

### Installing MySQL Server

- Install MySQL server.

```bash
$ apt-get install mysql-server
```

- Setup root password to be `R2ZBmTR6nED6a71AxeTO2DSc`

```bash
$ mysql

$ mysql># SELECT user,authentication_string,plugin,host FROM mysql.user;
$ mysql># ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'R2ZBmTR6nED6a71AxeTO2DSc';
$ mysql># FLUSH PRIVILEGES;
$ mysql># SELECT user,authentication_string,plugin,host FROM mysql.user;
```

- Create Application database, user and password.

```bash
$ mysql># CREATE DATABASE appdb;
$ mysql># CREATE USER 'appuser'@'127.0.0.1' IDENTIFIED WITH mysql_native_password BY 'R2ZBmTR6nED6a71AxeTO2DSc';
$ mysql># GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, INDEX, DROP, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES ON appdb.* TO 'appuser'@'127.0.0.1';
$ mysql># FLUSH PRIVILEGES;
```

- Test newly created user.

```sql
$ mysql -h 127.0.0.1 -u appuser -pR2ZBmTR6nED6a71AxeTO2DSc

$ mysql># show databases;
+--------------------+
| Database           |
+--------------------+
| appdb              |
| information_schema |
| performance_schema |
+--------------------+
```

### Installing PHP and PHP-FPM

- Install php and php-fpm version `8.1`

```bash
$ apt-get install php8.1-fpm php8.1-common php8.1-mysql \
    php8.1-xml php8.1-xmlrpc php8.1-curl php8.1-gd \
    php8.1-imagick php8.1-cli php8.1-dev php8.1-imap \
    php8.1-mbstring php8.1-soap php8.1-zip php8.1-bcmath -y
```

- Check php-fpm status

```bash
$ service php8.1-fpm status
```

### Configure Your PHP Application

Let's assume we have php project running under `/var/www/project`.

```bash
$ mkdir -p /var/www/project/public
```

- Create a php file to show the php info

```bash
$ touch /var/www/project/public/index.php
```

```php
<?php

phpinfo();
```

- Create the nginx site.

```bash
$ nano /etc/nginx/sites-available/project.tld
```

```conf
server {
    listen 80;
    server_name domain.tld www.domain.tld;
    root /var/www/project/public;

    location / {
        # try to serve file directly, fallback to index.php
        try_files $uri /index.php$is_args$args;
    }

    # optionally disable falling back to PHP script for the asset directories;
    # nginx will return a 404 error when files are not found instead of passing the
    # request to Symfony (improves performance but Symfony's 404 page is not displayed)
    # location /bundles {
    #     try_files $uri =404;
    # }

    location ~ ^/index\.php(/|$) {
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;

        # optionally set the value of the environment variables used in the application
        # fastcgi_param APP_ENV prod;

        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        fastcgi_param DOCUMENT_ROOT $realpath_root;
        # Prevents URIs that include the front controller. This will 404:
        # http://domain.tld/index.php/some-path
        # Remove the internal directive to allow URIs like this
        internal;
    }

    # return 404 for all other php files not matching the front controller
    # this prevents access to other php files you don't want to be accessible.
    location ~ \.php$ {
        return 404;
    }

    error_log /var/log/nginx/project_error.log;
    access_log /var/log/nginx/project_access.log;
}
```

```bash
$ ln -s /etc/nginx/sites-available/project.tld /etc/nginx/sites-enabled/project.tld
```

- Validate nginx configs and reload configs.

```bash
$ sudo nginx -t
$ systemctl reload nginx
```

Visiting the URL `http://domain.tld/` should open a php info page.

Please check this project [https://github.com/Clivern/Oxygen](https://github.com/Clivern/Oxygen). It automates the above steps!
