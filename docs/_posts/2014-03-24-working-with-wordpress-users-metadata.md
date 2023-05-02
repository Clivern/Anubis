---
title: Working With WordPress Users Metadata
date: 2014-03-24 00:00:00
featured_image: https://images.unsplash.com/photo-1530172888244-f3520bbeaa55
excerpt: Wordpress users metadata used to store additional data related to users. We will discuss how to set, retrieve, update and delete metadata.
---

![](https://images.unsplash.com/photo-1530172888244-f3520bbeaa55)

Wordpress users metadata used to store additional data related to users. We will discuss how to set, retrieve, update and delete metadata.

### Saving User Metadata

To save user metadata, Use `add_user_meta()` function. This function has the following syntax.

```php
//save user metadata syntax
add_user_meta($user_id, $meta_key, $meta_value, $unique);
```

As you can see, This function accepts 4 parameters:

- `$user_id`: Each metadata value attached to user by its id.
- `$meta_key`: Metadata name.
- `$meta_value`: Metadata value.
- `$unique`: A boolean value to identify if metadata key accept multiple values. By default, it is set to false.

Let's create metadata, One with unique value and another that accepts multiple values.

```php
//add unique metadata
add_user_meta(1, 'clivern_plugin_song', 'Fireworks', true);
//add metadata that accept duplicate values
add_user_meta(1, 'clivern_plugin_books', 'PHP Ninga', false);
add_user_meta(1, 'clivern_plugin_books', 'JS Ninga', false);
```

### Updating User Metadata

To update user metadata, Use `update_user_meta()` function. This function has the following syntax.

```php
//update user metadata syntax
update_user_meta($user_id, $meta_key, $meta_value, $prev_value);
```

This function has 4 parameters:

- `$user_id`: The user id.
- `$meta_key`: Metadata name to be updated.
- `$meta_value`: Metadata new value.
- `$prev_value`:previous value of metadata. It is optional so if supplied, only metadata with that value will be updated otherwise all metadata with supplied `$meta_key` will be updated.

Let's update previously created metadata.

```php
//set your song to home town glory
update_user_meta(1, 'clivern_plugin_song', 'Home Town Glory');
//change php ninga book to wordpress ninga book
update_user_meta(1, 'clivern_plugin_books', 'WordPress Ninga', 'PHP Ninga');
```

### Retrieving User Metadata

To retrieve user metadata, Use `get_user_meta()` function. This function has the following syntax.

```php
//retrieve user metadata
$metadata_value = get_user_meta($user_id, $meta_key, $single);
```

This function has 3 parameters:

- `$user_id`: The user id.
- `$meta_key`: Metadata name. If omitted, function will return array of all metadata for supplied user id.
- `$single`: A boolean value to identify whether you want the return value to be string or an array.

Let's retrieve previously created metadata.

```php
//retrieve user song
$song = get_user_meta(1, 'clivern_plugin_song', true);
//retrieve user books
$books = get_user_meta(1, 'clivern_plugin_books', false);

var_dump($song);
/*
 * outputs
 * string 'Home Town Glory' (length=15)
 */

var_dump($books);
/**
  * outputs
  * array (size=2)
  *   0 => string 'WordPress Ninga' (length=15)
  *   1 => string 'JS Ninga' (length=8)
  */
```

### Deleting User Metadata

To dump user metadata, Use `delete_user_meta()` function. This function has the following syntax.

```php
//dump user metadata
delete_user_meta($user_id, $meta_key, $meta_value);
```

You should be familiar with the first two parameters. The third parameter used to supply metadata value to delete in case of duplicate metadata. Let's dump previously created metadata.

```php
//dump song
delete_user_meta(1, 'clivern_plugin_song');
//dump all books
delete_user_meta(1, 'clivern_plugin_books');
```