---
title: WordPress Options API
date: 2014-04-21 00:00:00
featured_image: https://images.unsplash.com/photo-1530172888244-f3520bbeaa55
excerpt: Wordpress provides a set of functions that enable easy access to plugin options. By default wordpress and plugins options are stored in `wp_options` table. Let's explore these functions.
---

![](https://images.unsplash.com/photo-1530172888244-f3520bbeaa55)

Wordpress provides a set of functions that enable easy access to plugin options. By default wordpress and plugins options are stored in `wp_options` table. Let's explore these functions.

### Adding Options

You can add plugin options using `add_option` function. It accepts four parameters:

- The first parameter is the option name or key.
- The second parameter is the option value.
- The third parameter is optional and it was deprecated so you should set it to empty.
- The fourth parameter is also optional and it determines whether wordpress autoload the option during loading. By default wordpress autoload all options during loading but setting this parameter to `'no'` can convert this and the option will not be loaded during loading.

Let's start by saving your first plugin options.

```php
//always put your plugin options in array
add_option('myplugin_settings', array(
   'option1'=>'value',
   'option2'=>'value'
));

//another option but disable autoload
add_option('myplugin_another_options','value','','no');
```

### Retrieving Options

To get option value, you can use `get_option` function. It accepts only one parameter and it is the option name. This function returns `false` if option doesn't exist.

```php
$pluginsettings = get_option('myplugin_settings');
$another_settings = get_option('myplugin_another_options');
```

### Updating Options

To update an option, you can use `update_option` function. It accepts two parameters. The first parameter is the option name and the second parameter is the new value. This function creates option if it doesn't exist.

```php
update_option('myplugin_settings',array(
   'option1'=>'updated value',
   'option2'=>'updated value'
));
```

### Deleting Options

To delete option, you can use `delete_option` function. It accepts a string representing option name. It returns `false` if option doesn't exist and `true` otherwise.

```php
delete_option('myplugin_settings');
delete_option('myplugin_another_options');
```