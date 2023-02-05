---
title: Working With WordPress Shortcodes
date: 2014-03-01 00:00:00
featured_image: https://images.unsplash.com/photo-1603145066679-c172b5914220?q=5
excerpt: Shortcodes enable developers to embed content that would require alot of complicated tasks. With shortcodes ,you can enhance your posts with few characters.
---

![](https://images.unsplash.com/photo-1603145066679-c172b5914220?q=5)

Shortcodes enable developers to embed content that would require alot of complicated tasks. With shortcodes ,you can enhance your posts with few characters.

### Creating Shortcodes

The simplest form of shortcodes is to replace often-used sentences with something shorter and easy to remember. For example ,when you type `[wp]` ,it replaced with `<a href='http://wordpress.org'>WordPress</a>`.

```php
//Register new shortcode [wp]
add_shortcode('wp', 'wp_sc_callback');

//The callback function that replace [wp]
function wp_sc_callback(){
   return '<a href="http://wordpress.org">WordPress</a>';
}
```

What if you have many links to use ?Well ,The first option would be to create shortcodes for each link or you can create shortcode that accepts link name as parameter like that.

```php
//Register new shortcode [links type="x"]
add_shortcode('links', 'lks_sc_callback');

//The callback function that replace [links type="x"]
function lks_sc_callback($attr){
  switch ($attr['type']) {
   case 'wp':
      return '<a href="http://wordpress.org">WordPress</a>';
    break;

   case 'clivern':
      return '<a href="http://clivern.com">Clivern</a>';
    break;
  }
}
```

The most common use of shortcodes is to wrap content by html tags and append shortcode attributes as html tag attributes. In this case you need to provide `$content` parameter to shortcode callback function. Here's an example.

```php
//Register new shortcode [pre lang="x"] [/pre]
add_shortcode('pre', 'pre_sc_callback');

//The callback function that replace [pre lang="x"] [pre]
function pre_sc_callback($attr,$content){
  return "<pre class='{$attr['lang']}'><code>{$content}</code></pre>";
}
```

There are other interesting functions that you can make use of in your next plugin.

`$shortcode_tags`: All shortcodes registered saved in this global array.

```php
function sc_callback(){
  global $shortcode_tags;
  var_dump($shortcode_tags);
}
```

This should return at least this array.

```php
array (size=6)
  'embed' => string '__return_false' (length=14)
  'wp_caption' => string 'img_caption_shortcode' (length=21)
  'caption' => string 'img_caption_shortcode' (length=21)
  'gallery' => string 'gallery_shortcode' (length=17)
  'audio' => string 'wp_audio_shortcode' (length=18)
  'video' => string 'wp_video_shortcode' (length=18)
```

`remove_shortcode()`: This function used to unregister a shortcode.

```php
//remove embed shortcode
remove_shortcode('embed');
```

`remove_all_shortcodes()`: Similarly but it unregister all the shortcodes.

```php
//remove all registered shortcodes
remove_all_shortcodes();
```

`strip_shortcodes()`: It strips registered shortcodes from string content.

```php
//define custom text
$custom_text = "custom text with [embed][/embed] shortcode";
//strip shortcodes from this text
$custom_text = strip_shortcodes($custom_text);
var_dump($custom_text);
/* this should return: string 'custom text with  shortcode' (length=27)*/
```

`shortcode_atts()`: It simply compare user attributes with default attributes values and use defaults in case user not provide value for attribute.

```php
function sc_callback($attr){
 //define supported attributes and their defaults
 $defaults=array (
    'title'=>'default value',
    'class'=> 'default value',
     /* ...... */
 );
 //set default values if attribute omitted
 $values = shortcode_atts($defaults, $attr);
 //then work with values array
}
```

`do_shortcode()`: It simply process shortcodes to content provided. Wordpress process shortcodes by default to posts and pages. Some developers use this function to allow wordpress to process shortcodes exist in widgets or comments.

```php
add_filter('comment_text', 'comments_sc_callback');

function comments_sc_callback($comment){
    global $shortcode_tags;

   //backup shortcodes in another variable
   $original_shortcodes = $shortcode_tags;
   remove_all_shortcodes();
   //register only the following shortcodes for comments
   add_shortcode('wp','wp_sc_callback');
   //process shortcodes to comment
   $comment = do_shortcode($comment);
   //return shortcodes again
   $shortcode_tags = $original_shortcodes;
   return $comment;
}

function wp_sc_callback(){
   return "<a href='http://worddpress.org'>Wordpress</a>";
}
```

As you can see, I register filter for comment text. Then in this filter ,I make backup of shortcodes ,then clear all sortcodes and process custom shortcodes to comments text. Finally i returned shortcodes again from backup. You must remember that wordpress don't provide shortcodes for comments and widgets by default because of security considerations. I think no one can trust commenters.

### Recursive Shortcodes

Used when content enclosed in shortcodes may contain othershortcodes. simply nested shortcodes like that.

```html
[p]powered [b]by[/b] wordpress[/p]
```

Let's process this content.

```php
//register [p] shortcode
add_shortcode('p', 'p_sc_callback');
//register [b] shortcode
add_shortcode('b', 'b_sc_callback');

//callback function for [p] shortcode
function p_sc_callback($attr,$content){
  return '<p>'.  do_shortcode($content) . '</p>';
}
//callback function for [b] shortcode
function b_sc_callback($attr,$content){
  return '<b>'.  do_shortcode($content) . '</b>';
}
```