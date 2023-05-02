---
title: How To Make HTTP Requests with WordPress
date: 2014-02-18 00:00:00
featured_image: https://images.unsplash.com/photo-1519592695728-f8ec824b232b
excerpt: In the modern web "means 2.0", Web applications communicate with each other to gather and share data in between .Your wordpress blog is no exception that's why wordpress implemented a smart and powerful class WP_Http since version 2.7.0 .This class supports all methods you need to use.
---

![](https://images.unsplash.com/photo-1519592695728-f8ec824b232b)

In the modern web "means 2.0", Web applications communicate with each other to gather and share data in between. Your WordPress blog is no exception, that's why WordPress implemented a smart and powerful class `WP_Http` since version 2.7.0. This class supports all methods you need to use.

### Make Your First Request

You can make HTTP requests within WordPress by using one of these functions.

- `wp_remote_get($url, $args)`: Perform request with GET method
- `wp_remote_post($url, $args)`: Perform request with POST method
- `wp_remote_head($url, $args)`: Perform request HEAD method
- `wp_remote_request($url, $args)`: Perform request and take method as argument

As you see, the first parameter is a string representing a valid site URL, and the second parameter is an optional array of parameters to override the defaults. The syntax of these functions is as follows:

```php
var_dump(wp_remote_get('http://wordpress.org'));
var_dump(wp_remote_post('http://wordpress.org'));
var_dump(wp_remote_head('http://wordpress.org'));
//same requests but with different method
var_dump(wp_remote_request('http://wordpress.org'),array('method'=>'GET'));
var_dump(wp_remote_request('http://wordpress.org'),array('method'=>'POST'));
var_dump(wp_remote_request('http://wordpress.org'),array('method'=>'HEAD'));
```

The default parameters are the following array:

```php
$defaults = array(
   'method' => 'GET',
   'timeout' => 5,
   'redirection' => 5,
   'httpversion' => '1.0',
   'user-agent' => 'WordPress/version;URL',
   'reject_unsafe_urls' => false,
   'blocking' => true,
   'headers' => array(),
   'cookies' => array(),
   'body' => null,
   'compress' => false,
   'decompress' => true,
   'sslverify' => true,
   'stream' => false,
   'filename' => null,
   'limit_response_size' => null,
);
```

These functions return an array of response data if the request succeeds and a `WP_Error` object on failure. You can test the response using `is_wp_error`. Consider the following example:

```php
$response=  wp_remote_get('http://dsc');
if(is_wp_error($response)){
 echo 'Error Found ( '.$response->get_error_message().' )';
}
```

### Other Useful Functions

Actually wordpress like paradise for developers. along with functions that perform HTTP requests, you can use following functions to quickly access parts of returned array.

- `wp_remote_retrieve_body($response)`: Returns body of the response.
- `wp_remote_retrieve_header($response, $header)`: Returns just one particular header from server response.
- `wp_remote_retrieve_response_code($response)`: Returns just the response code for example 200 (<a href="http://httpstatus.es" rel="nofollow">List of response codes</a>).
- `wp_remote_retrieve_response_message($response)`: Returns just response message for example ok.
- `wp_remote_retrieve_headers($response)`: Returns all headers from server response.

For example if you like to check if a link exists and don't return a 404 message.

```php
function CheckURL($url){
 $response = wp_remote_get($url);
  if(is_wp_error($response))
     //request can't performed
     return 1;
  if(wp_remote_retrieve_response_code($response) == '404')
     //request succeed and link not found
     return 2;
   //request succeed and link exist
   return 3;
}
```