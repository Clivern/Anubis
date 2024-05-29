---
title: PHP Packages and Namespaces
date: 2014-02-19 00:00:00
featured_image: https://images.unsplash.com/photo-1511468102400-883d6ea28755?q=90&fm=jpg&w=1000&fit=max
excerpt: Package is a set of PHP classes grouped in some manner .Many developers use file system to organise their applications because PHP has no native concept of a package until PHP 5.3 .With PHP 5.3 ,namespaces become part of PHP .I know that most of us think many times before using namespaces in any commercial code .you know ,not all servers support PHP 5.3 but this will be for a while.
---

![](https://images.unsplash.com/photo-1511468102400-883d6ea28755?q=90&fm=jpg&w=1000&fit=max)

Package is a set of PHP classes grouped in some manner .Many developers use file system to organise their applications because PHP has no native concept of a package until PHP 5.3 .With PHP 5.3 ,namespaces become part of PHP .I know that most of us think many times before using namespaces in any commercial code .you know ,not all servers support PHP 5.3 but this will be for a while.

### Creating Namespaces

Namespaces like a box in which you can place your classes ,variables and functions .And then you can simply import namespace or reference to it from outside. Consider the following example:

```php
 namespace utils;

 class fileManager {

  static function hello() {
   print 'Hello World';
  }

 }
```

For furthur organisation to your projects ,you can use nested namespaces .To do this ,use a backslash to divide each part like following:

```php
 namespace com\myapp\util\routing;

 class fileManager {

  static function hello() {
   print 'Hello World';
  }

 }
```

### Accessing Namespaces

If you are calling the class from within the namespace, you should call it directly

```php
 namespace com\myapp\util\routing;

 class fileManager {

  static function hello() {
   print 'Hello World';
  }

 }
 //access from inside namespace
fileManager::hello();
```

If you need to access class from outside namespace ,you could do the following

```php
 //tut-1.php file
 namespace com\myapp\util\routing;

 class fileManager {

  static function hello() {
   print 'Hello World';
  }

 }

 //tut-2.php file
 require_once 'tut-1.php';
 com\myapp\utils\routing\fileManager::hello();
```

If you need to access class from outside but inside another namespace, you could do this

```php
 //tut-2.php file
 namespace com\myapp\util;
 require_once 'tut-1.php';
 //relative call
 routing\fileManager::hello();
 //absolute call
 \com\myapp\util\routing\fileManager::hello();
```

As you can see in previous example ,I add leading backslash to tell PHP to begin search from root and not relative to current namespace.

If there is many namespaces to use in current file or current namespace ,you don't have to use nested syntax for each call .But , you can use `use` keyword to import other namespaces like that

```php
 namespace com\myapp\util;
 use com\myapp\util\routing\fileManager;
 require_once 'tut-1.php';
 fileManager::hello();
```

It is worth noting that ,any possibilities that your class name may collide .You could use `as` keyword.

```php
 //tut-1.php file
 namespace com\myapp\util\routing;

 class fileManager {

  static function hello() {
   print 'Hello World';
  }

 }

//tut-2.php file
namespace com\myapp\util;
use com\myapp\util\routing\fileManager as GfileManager;
require_once 'tut-1.php';

 class fileManager {

  static function hello() {
   print 'Hello Worlde';
  }

 }

 GfileManager::hello();
 fileManager::hello();
```

If you need to access class in a non-namespaced file from within namespaced file, you could use the following code.

```php
 //tut-1.php file
 class fileManager {

  static function hello() {
   print 'Hello World';
  }

 }

//tut-2.php file
namespace com\myapp\util;
require_once 'tut-1.php';

 class fileManager {

  static function hello() {
   print 'Hello World';
  }

 }

 //access local class
 fileManager::hello();
 //access global class
 \fileManager::hello();
```

You could also combine multiple namespaces in the same file by wrapping namespace body by braces like that

```php
 namespace com\myapp\util1 {

  class fileManager {

   static function hello() {
    print __NAMESPACE__;
   }

  }

 }

 namespace com\myapp\util2 {

  class fileManager {

   static function hello() {
    print __NAMESPACE__;
   }

  }
 //access file manager in current namespace
 fileManager::hello();
 //access another namespace
 \com\myapp\util1\fileManager::hello();
 }
```

Another something about namespaces and it is worh using is `__NAMESPACE__` constant .This constant output the current namespace you called from.
