---
title: How To Install Dependencies With  PHP Composer
date: 2014-03-09 00:00:00
featured_image: https://images.unsplash.com/photo-1525913085971-c8a7102bf82a?q=5
excerpt: Composer is a dependency management tool for PHP developers. It allows you to define all libraries that your application depends on and automatically download these libraries with a simple command. Composer solve many problems, you know if your application depends on many libraries and these libraries depend on other libraries like frameworks ,It will be cumbersome to make all these libraries up to date.
---

![](https://images.unsplash.com/photo-1525913085971-c8a7102bf82a?q=5)

Composer is a dependency management tool for PHP developers. It allows you to define all libraries that your application depends on and automatically download these libraries with a simple command. Composer solve many problems, you know if your application depends on many libraries and these libraries depend on other libraries like frameworks ,It will be cumbersome to make all these libraries up to date.

### Installation

Composer requires `PHP 5.3.2+`. Any incompatibilities found, Installer will warn you. I think it is best to have **a global install of composer**.

To install composer hit your browser with [composer.org](https://getcomposer.org/doc/00-intro.md#installation-nix), choose your platform and move through installation steps.

### Basic Usage

The first thing you need to specify is the packages your project depends on and this done by creating `composer.json` in project root directory like that.

```json
{
    "require": {
        "monolog/monolog": "1.2.*"
    }
}
```

As you can see ,I pass package name and version to `require` key. If you like to use different packages, feel free to check [packagist](https://packagist.org).

Actually package name consists of a vendor name and project name. Also you can provide package version with some logic, In previous example we require version `1.2.*` and it will match `1.2.0` ,`1.2.1` ,`1.2.2` ... .You can use comparison operators (`>=1.0` , `>1.0` , `<1.0` , `<=1.0` or `!=1.0`).

Then to fetch defined dependencies ,just run `install` command in your terminal.

```php
$php composer install
Loading composer repositories with package information
Installing dependencies (including require-dev)
  - Installing monolog/monolog (1.2.1)
    Downloading: 100%

Writing lock file
Generating autoload files
```

Composer writes the exact versions installed in `composer.lock` file. Let's look at this file.

```json
{
    "_readme": [
        "This file locks the dependencies of your project to a known state",
        "Read more about it at http://getcomposer.org/doc/01-basic-usage.md#composer-lock-the-lock-file"
    ],
    "hash": "468cfdb8c781c89b4dba2c86f5a62268",
    "packages": [
        {
            "name": "monolog/monolog",
            "version": "1.2.1",
            "source": {
                "type": "git",
                "url": "https://github.com/Seldaek/monolog.git",
                "reference": "d16496318c3e08e3bccfc3866e104e49cf25488a"
            },
            "dist": {
                "type": "zip",
                "url": "https://api.github.com/repos/Seldaek/monolog/zipball/d16496318c3e08e3bccfc3866e104e49cf25488a",
                "reference": "d16496318c3e08e3bccfc3866e104e49cf25488a",
                "shasum": ""
            },
            "require": {
                "php": ">=5.3.0"
            },
            "require-dev": {
                "mlehner/gelf-php": "1.0.*"
            },
            "suggest": {
                "ext-amqp": "Allow sending log messages to an AMQP server (1.0+ required)",
                "ext-mongo": "Allow sending log messages to a MongoDB server",
                "mlehner/gelf-php": "Allow sending log messages to a GrayLog2 server"
            },
            "type": "library",
            "extra": {
                "branch-alias": {
                    "dev-master": "1.3.x-dev"
                }
            },
            "autoload": {
                "psr-0": {
                    "Monolog": "src/"
                }
            },
            "notification-url": "https://packagist.org/downloads/",
            "license": [
                "MIT"
            ],
            "authors": [
                {
                    "name": "Jordi Boggiano",
                    "email": "j.boggiano@seld.be",
                    "homepage": "http://seld.be",
                    "role": "Developer"
                }
            ],
            "description": "Logging for PHP 5.3",
            "homepage": "http://github.com/Seldaek/monolog",
            "keywords": [
                "log",
                "logging"
            ],
            "time": "2012-08-29 11:53:20"
        }
    ],
    "packages-dev": [

    ],
    "aliases": [

    ],
    "minimum-stability": "stable",
    "stability-flags": [

    ],
    "platform": [

    ],
    "platform-dev": [

    ]
}
```

Composer lock file is very important, Imagine you work on application that depends on one library. When you run composer to install these library, it downloaded last version say (1.1) and create lock file with this version. If version 1.2 released for these library and you run composer file again without putting lock file in the same directory, composer will download latest version (1.2) not (1.1) but if lock file exist,composer will ignore `composer.json` file and work with `composer.lock` file. So always commit your applications with `composer.lock` file so other developers in the team runs on the same versions.

To update to newer versions, Use update command.

```php
$php composer update
```

If you need to update one dependency, You can run this command.

```php
$php composer update monolog/monolog
```

### Auto Loading

composer generates `autoload.php` file. You can include this file and it will load your dependencies.

```php
// autoload.php @generated by Composer
require_once __DIR__ . '/composer' . '/autoload_real.php';
return ComposerAutoloaderInitb014aa43586d16e51775b8b02c8f5ecc::getLoader();
```

This makes things easy, You can immediately work with your third party libraries immediately. Let's dig with monolog.

```php
require_once __DIR__ . '/vendor/autoload.php';
use Monolog\Logger;
use Monolog\Handler\StreamHandler;

// create a log channel
$log = new Logger('test');
$log->pushHandler(new StreamHandler('test.log', Logger::WARNING));

// add records to the log
$log->addWarning('Foo');
$log->addError('Bar');
```

Well, Let's check test.log file. You should see this.

```log
[2014-03-09 16:48:53] test.WARNING: Foo [] []
[2014-03-09 16:48:53] test.ERROR: Bar [] []
```