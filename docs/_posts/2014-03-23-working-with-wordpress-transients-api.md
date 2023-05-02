---
title: Working With WordPress Transients API
date: 2014-03-23 00:00:00
featured_image: https://images.unsplash.com/photo-1530172888244-f3520bbeaa55
excerpt: The wordpress transients API offers a simple and powerful way to store volatile data in database. It is similar to plugin options API but transients have an expiration time then it will expired and deleted.
---

![](https://images.unsplash.com/photo-1530172888244-f3520bbeaa55)

The wordpress transients API offers a simple and powerful way to store volatile data in database. It is similar to plugin options API but transients have an expiration time then it will expired and deleted.

### Why Transients

Transients similar to plugin options but they are volatile. Each time you want to store data for short time, You should use transients. For instance, tweets plugin check for latest tweet and save it as transient with exiration time until next check. Wordpress save transients in database by default but with caching plugins and memcached, Wordpress will store values in fast memory instead of database.

### Setting a Transient

To set a transient, You can use `set_transient()` function. This function accept three parameters. The first parameter is transient name, The second parameter is transient value and the third is expiry time.

```php
//set transient
set_transient('clivern_plugin_transname','transient value',300);
```

As you can see, created transient will expire within 5 minutes.

### Retrieving a Transient

To retrieve transient value, You can use `get_transient()` function. This function accepts only transient name. It returns transient value if it exist and still valid, a boolean false otherwise.

```php
//retrieve transient
$tweet = get_transient('clivern_plugin_transname');
```

### Deleting a Transient

To delete transient, Use function `delete_transient()`. This function returns true if successful, false otherwise.

```php
//delete transient
delete_transient('clivern_plugin_transname');
```