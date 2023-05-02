---
title: How To Create Custom Tables In WordPress
date: 2014-02-18 00:00:00
featured_image: https://images.unsplash.com/photo-1530172888244-f3520bbeaa55
excerpt: WordPress creates 11 tables to store settings, users data, posts data, comments data, links and terms. In many cases wordpress tables can fit perfectly our plugin data but sometimes you need to create custom tables. WordPress provides a handful function that can create your custom tables and update their structure easily.
---

![](https://images.unsplash.com/photo-1530172888244-f3520bbeaa55)

WordPress creates 11 tables to store settings, users data, posts data, comments data, links and terms. In many cases wordpress tables can fit perfectly our plugin data but sometimes you need to create custom tables. WordPress provides a handful function that can create your custom tables and update their structure easily.

### Creating A Custom Table

Imagine an ecommerce plugin that create custom front end page to show your products. This plugin might need to create custom table for products data. The SQL statement to create such table as follow.

```sql
CREATE TABLE `products` (
   `id` int(11) not null auto_increment,
   `name` varchar(60) not null,
   `price` int(11) not null,
   `created_at` datetime not null,
   `updated_at` datetime not null,
   `items` int(11) not null,
   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;
```

Wordpress can create this table by passing this SQL statement to `dbDelta()` function. You need to manually include this function file in your plugin because wordpress don't load it by default.

```php
$sql = "CREATE TABLE `{$wpdb->prefix}products` (
   `id` int(11) not null auto_increment,
   `name` varchar(60) not null,
   `price` int(11) not null,
   `created_at` datetime not null,
   `updated_at` datetime not null,
   `items` int(11) not null,
   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;";
//load upgrade file
require_once (ABSPATH . 'wp-admin/includes/upgrade.php');
//execute SQL statement
dbDelta($sql);
```

### Updating A Table Structure

The `dbDelta()` function can update table structure with the same syntax used before. This function compare table structure and modifies it as required.

```php
$sql = "CREATE TABLE `{$wpdb->prefix}products` (
   `id` int(11) not null auto_increment,
   `name` varchar(60) not null,
   `price` int(11) not null,
   `created_at` datetime not null,
   `updated_at` datetime not null,
   `items` int(11) not null,
   `sales` int(11) not null,
   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;";
require_once (ABSPATH . 'wp-admin/includes/upgrade.php');
dbDelta($sql);
```

The `dbDelta()` function will add `sales` column.

### Important Notes

Because wordpress doesn't load this function by default, You shouldn't include it to load all the time but you can create separate file in which you include this function and run all SQL statements. Then include this file in plugin activation function. After your custom tables created, You can access them using the global `$wpdb` object.

```php
register_activation_hook(__FILE__,
 'plugin_activate'
);
function plugin_activate(){
 global $wpdb;
 //Build custom tables
 include_once __DIR__.'/db_structure.php';
}
```

```php
/* db_structure.php file */
// If this file is called directly, abort.
if ( !defined('WPINC') )
{
   die;
}

$sql = "CREATE TABLE `{$wpdb->prefix}products` (
  `id` int(11) not null auto_increment,
  `name` varchar(60) not null,
  `price` int(11) not null,
  `created_at` datetime not null,
  `updated_at` datetime not null,
  `items` int(11) not null,
   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;";

require_once (ABSPATH . 'wp-admin/includes/upgrade.php');
dbDelta($sql);
```