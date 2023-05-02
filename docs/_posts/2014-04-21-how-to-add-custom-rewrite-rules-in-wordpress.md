---
title: How To Add Custom Rewrite Rules In WordPress
date: 2014-04-21 00:00:00
featured_image: https://images.unsplash.com/photo-1530172888244-f3520bbeaa55
excerpt: Wordpress rewrite API used to convert URLs from something programmatically convenient to something user and search engine friendly. This article will give you some background information about wordpress URL rewriting principles and API.
---

![](https://images.unsplash.com/photo-1530172888244-f3520bbeaa55)

Wordpress rewrite API used to convert URLs from something programmatically convenient to something user and search engine friendly. This article will give you some background information about wordpress URL rewriting principles and API.

### Wordpress URL Rewriting

After installing wordpress, It creates `.htaccess` file in its root directory and contain the following.

```apache
# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress
```

This `.htaccess` directive tells the webserver the following:

- If a client requests `index.php`, Send him to this file and stop matching to other rewrite rules.
- If a request is not to a file.
- ..and if a request is not to a directory.
- Then rewrite URL to `index.php` and don't apply any other rules.

So a typical wordpress URL like `example.com/page/2/` doesn't match any actual path on the webserver but wordpress will read this URL as `example.com/index.php?paged=2`. Also when you visit `example.com/hello-world/`, Wordpress will read this URL as `example.com/index.php?p=1`. How wordpress translates URLs into query variables! Let's explore one of the trickest objects in wordpress.

The `$wp_rewrite` object contains a list of all registered rewrite rules and all informations related to permalink structures. Let's dump this object to know what i mean.

```php
object(WP_Rewrite)[84]
  public 'permalink_structure' => string '/%postname%/' (length=12)
  .......
  public 'rewritecode' =>
    array (size=14)
      0 => string '%year%' (length=6)
      1 => string '%monthnum%' (length=10)
      2 => string '%day%' (length=5)
      ....
  public 'rewritereplace' =>
    array (size=14)
      0 => string '([0-9]{4})' (length=10)
      1 => string '([0-9]{1,2})' (length=12)
      2 => string '([0-9]{1,2})' (length=12)
      ....
  public 'queryreplace' =>
    array (size=14)
      0 => string 'year=' (length=5)
      1 => string 'monthnum=' (length=9)
      2 => string 'day=' (length=4)
      ....
```

As you can see, It contains a list of all registered rewrite rules. Each rewrite rule has `rewritecode`, `rewritereplace` and `queryreplace`. For example when wordpress detect `example.com/year/2014/` pattern, it changes it according to the replacement into `example.com/index.php?year=2014`. After wordpress treanslates the URL into query variables, It collects all these variables to form MySQL statement, get post data, load required theme and display the requested page.

### Wordpress Rewrite API

Imagine you need to integrate custom page in which you can list your products. How can we do this?..First we need to create a new rewrite rule so wordpress can translate `example.com/products/2/` to `example.com/index.php?pagename=products&product_id=2`. We can use `add_rewrite_rule()` function which accepts 3 parameters. The first parameter is the URL pattern. The second parameter is the URL replacement and the third parameter is the priority. Let's explore how to create this rule.

```php
function products_plugin_activate() {
  products_plugin_rules();
  flush_rewrite_rules();
}

function products_plugin_deactivate() {
  flush_rewrite_rules();
}

function products_plugin_rules() {
  add_rewrite_rule('products/?([^/]*)', 'index.php?pagename=products&product_id=$matches[1]', 'top');
}

function products_plugin_query_vars($vars) {
  $vars[] = 'product_id';
  return $vars;
}

//register activation function
register_activation_hook(__FILE__, 'products_plugin_activate');
//register deactivation function
register_deactivation_hook(__FILE__, 'products_plugin_deactivate');
//add rewrite rules in case another plugin flushes rules
add_action('init', 'products_plugin_rules');
//add plugin query vars (product_id) to wordpress
add_filter('query_vars', 'products_plugin_query_vars');
```

As you can see

- I used `flush_rewrite_rule()` in plugin activation and deactivation. This makes wordpress refresh and rebuild the rewrite rules list.
- I added rewrite rules in plugin activation.
- Also i added the rewrite rules on `init` in case another pugin flushes rules.
- I added `product_id` query variable to wordpress using `query_vars` filter hook.

Now wordpress will redirect all requests to `example.com/products/` to `example.com/index.php?pagename=products` and request to `example.com/products/value/` to `example.com/index.php?pagename=products&product_id=value`. Let's integrate our custom pages with these query variables.

```php
function products_plugin_display() {
  $products_page = get_query_var('pagename');
  $product_id = get_query_var('product_id');
  if ('products' == $products_page && '' == $product_id):
    //show all products
    exit;
  elseif ('products' == $products_page && '' != $product_id):
    //show product page
    exit;
  endif;
}

//register plugin custom pages display
add_filter('template_redirect', 'products_plugin_display');
```

As you can see, I used `template_redirect` action hook to send client to the custom page and **don't forget** to use `exit()` to prevent wordpress from handling page display. Let's review our functional plugin.

```php
/*
   Plugin Name: Products Plugin
   Plugin URI: http://clivern.com/
   Description: Register URL rules for our products
   Version: 1.0
   Author: Clivern
   Author URI: http://clivern.com
   License: MIT
  */
function products_plugin_activate() {
  products_plugin_rules();
  flush_rewrite_rules();
}

function products_plugin_deactivate() {
  flush_rewrite_rules();
}

function products_plugin_rules() {
  add_rewrite_rule('products/?([^/]*)', 'index.php?pagename=products&product_id=$matches[1]', 'top');
}

function products_plugin_query_vars($vars) {
  $vars[] = 'product_id';
  return $vars;
}

function products_plugin_display() {
  $products_page = get_query_var('pagename');
  $product_id = get_query_var('product_id');
  if ('products' == $products_page && '' == $product_id):
    //show all products
    exit;
  elseif ('products' == $products_page && '' != $product_id):
    //show product page
    exit;
  endif;
}

//register activation function
register_activation_hook(__FILE__, 'products_plugin_activate');
//register deactivation function
register_deactivation_hook(__FILE__, 'products_plugin_deactivate');
//add rewrite rules in case another plugin flushes rules
add_action('init', 'products_plugin_rules');
//add plugin query vars (product_id) to wordpress
add_filter('query_vars', 'products_plugin_query_vars');
//register plugin custom pages display
add_filter('template_redirect', 'products_plugin_display');
```