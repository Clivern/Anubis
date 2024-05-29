---
title: How To Internationalize Your Wordpress Plugin
date: 2013-11-07 00:00:00
featured_image: https://images.unsplash.com/photo-1615405988866-94a0a4b0eac1?q=90&fm=jpg&w=1000&fit=max
excerpt: Internationalization is the process of preparing your wordpress plugins for use in many languages. although <a href="http://wordpress.org">wordpress</a> uses english as its default language, it is used all over the world and many of its users don't read or write in english. also as a developer, you may need to reach a large scale of users and provide a simple tool for users to add their languages.
---

![](https://images.unsplash.com/photo-1615405988866-94a0a4b0eac1?q=90&fm=jpg&w=1000&fit=max)

Internationalization is the process of preparing your wordpress plugins for use in many languages. although <a href="http://wordpress.org">wordpress</a> uses english as its default language, it is used all over the world and many of its users don't read or write in english. also as a developer, you may need to reach a large scale of users and provide a simple tool for users to add their languages.

[Wordpress platform](http://wordpress.org) provide a bunch of built in translation functions so all you need is to follow simple steps during development process.

### Make Your Plugin Ready For Translation:

The first step in internationalizing your plugin is to make wordpress load translation files of your plugin related to user language if file exist.

```php
load_plugin_textdomain($domain, $abs_rel_path, $plugin_rel_path);
```

- `$domain` is an unique string represent your plugin domain.
- `$abs_rel_path` is the abs path to translation files and you should set to false.
- `$plugin_rel_path` is the relative path to translation files.

For example: if your plugin folder name is (smart-seo-plugin) and contain (includes, languages and assets) as sub-folders you code will look like this

```php
/*
 * this function loads my plugin translation files
 */
function smart_seo_load_translation_files() {
  load_plugin_textdomain('smart-seo-plugin-text', false, 'smart-seo-plugin/languages');
}

//add action to load my plugin files
add_action('plugins_loaded', 'smart_seo_load_translation_files');
```

### Wordpress Translation Functions:

As i said before <a href="http://wordpress.org">Wordpress platform</a> provide a bunch of built in translation functions. so everytime you add text in your plugin, you should wrap this text in one of these functions. most of these functions has two variables (the text you need to be translated and your plugin domain). let's list these functions and when you shoud use each one.

##### The `__()` Function

It makes text ready for translation and return it to be used in your code.

```php
$wp_footer = __('WordPress is a great blogging platform.', 'smart-seo-plugin-text');
```

##### The `_e()` Function

Same as `__()` but it output text to browser.

```php
_e('WPMU is a greet website.', 'smart-seo-plugin-text');
```

##### The `esc_attr__()` Function

It escapes HTML attributes so text passed to it will not break plugin security.

```php
echo '<a href="http://clivern.com/support/" title="' . esc_attr__('Need Support', 'smart-seo-plugin-text') . '">' . __('Support', 'smart-seo-plugin-text') . '</a>';
```

##### The `esc_attr_e()` Function

It escapes HTML attributes and output text to browser .it is perfect if you like to use inline php code within HTML code.

```html
<a href="http://clivern.com/support" title="<?php esc_attr_e('Need Support', 'smart-seo-plugin-text'); ?>"><?php _e('Support', 'smart-seo-plugin-text'); ?></a>
```

##### The `esc_html__()` Function

It is used to escape HTML code .if you provide a form with textarea .you will to wrap default value of textarea with this function.

```php
echo '<textarea name="smseo-text" id="smseo-text">' . esc_html__('Please input keywords', 'smart-seo-plugin-text') . '</textarea>';
```

##### The `esc_html_e()` Function

It behaves the same as  `esc_html__()` except that it output the translated text to browser.

```html
<textarea name="smseo-text" id="smseo-text"><?php esc_html_e('Please input keywords', 'smart-seo-plugin-text'); ?></textarea>
```

##### The `_x()` Function</h5>

It is used to provide a context for each occurance of specific text .for example: Post-may be used as noun or verb .so you should mark the difference between the two by a context.

```php
//post used as noun
$post_as_noun=_x('Post', 'noun', 'smart-seo-plugin-text');
//post used as verb
$post_as_verb=_x('Post', 'verb', 'smart-seo-plugin-text');
```

##### The `_ex()` Function

Same as `_x()` but it output translated text to browser.

```php
//post used as noun
_ex('Post', 'noun', 'smart-seo-plugin-text');
//post used as verb
_ex('Post', 'verb', 'smart-seo-plugin-text');
```

##### The `esc_attr_x()` Function

It provides a context for text ,escape it for use in html attributes and return translated text for use in you code .it doesn't have another function to output text to browser.

```php
echo '<a href="' . admin_url('dashboard.php') . '" title="' . esc_attr_x('Administration', 'admin link', 'smart-seo-plugin-text') . '">' . _x('Administration', 'admin link', 'smart-seo-plugin-text') . '</a>';
```

##### The `esc_html_x()` Function

It is used for translation ,escaping HTML and provide a context for translators .suppose you created a form contain textarea for user favorite food ,so you need to show none as default value.

```php
echo '<textarea name="smseo-text" id="smseo-text">' . esc_html_x('None', 'favorite food', 'smart-seo-plugin-text') . '</textarea>';
```

##### The `_n()` Function

Sometimes you don't know how many items will be returned from your code .so you will provide this function with both singular and plural form of text and it will figure out which form should be used.

```php
printf(_n('you inserted %s keyword.','you inserted %s keywords.',$keywords_count,'smart-seo-plugin-text'), $keywords_count);
```

##### The `_nx()` Function

It is the same as `_n()` except that it provides a context for the text.

```php
printf(_n('%s post', '%s posts', $post_count, 'post count', 'smart-seo-plugin-text'), $post_count);
```

### Creating Translation Files:

Many translation tools spread over the web and are free to download. one of most common tools for wordpress developers is [Poedit](http://poedit.net). it has simple interface and enable you to create a POT file for your plugin.
