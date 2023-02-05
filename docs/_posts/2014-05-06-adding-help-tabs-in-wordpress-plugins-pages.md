---
title: Adding Help Tabs In Wordpress Plugins Pages
date: 2014-05-06 00:00:00
featured_image: https://images.unsplash.com/photo-1413847394921-b259543f4872?q=5
excerpt: Wordpress 3.3 introduces the ability to create custom help tabs in plugin pages. You can use these tabs for plugin documentation to allow users to quickly understand your plugin function. I will show you how to add a help tab to your plugin configuration page.
---

![](https://images.unsplash.com/photo-1413847394921-b259543f4872?q=5)

Wordpress 3.3 introduces the ability to create custom help tabs in plugin pages. You can use these tabs for plugin documentation to allow users to quickly understand your plugin function. I will show you how to add a help tab to your plugin configuration page.

Some wordpress action hooks have names that contain variable element such as page name. This allows plugin developers to execute a function when specific page is rendered. The `load-<pagename>` hook is used to register functions to be executed when specific administration page is rendered.

The wordpress screen object contains data about the page that is currently displayed. This object contain some methods used to add content to the page like `add_help_tab()` and `set_help_sidebar()`.

Let's explore how to use the previous action hook and previous object to add help tab. But first we need to register administration page using `add_options_page()` function and store the returned value of the function call to variable or class property like the following.

```php
/*
  Plugin Name: my Plugin
  Plugin URI: http://clivern.com/
  Description: Plugin description
  Version: 1.0
  Author: Clivern
  Author URI: http://clivern.com
  License: MIT
 */

class myPlugin {

 private $myplugin_menu_item;
 static  $instance;

 static function GetInstance() {
  if (!isset(self::$instance)) {
   self::$instance = new self();
  }
  return self::$instance;
 }

 public function build_plugin() {
  add_action('admin_menu', array(
      $this,
      'menu'
  ));
 }

 public function menu() {
  $this->myplugin_menu_item = add_options_page('My Plugin', 'My Plugin', 'manage_options', 'my_plugin', array(
      $this,
      'render_page'
  ));
 }

 public function render_page() {
  ?>
  <div class='wrap'>
   <h2>My Plugin</h2>
   <p>Page Content</p>
  </div>
  <?php
 }

}

$myPlugin = myPlugin::GetInstance();
$myPlugin -> build_plugin();
```

Then we need to register an action that called when plugin options page is rendered.

```php
/* .... */
public function menu() {
 $this->myplugin_menu_item = add_options_page('My Plugin', 'My Plugin', 'manage_options', 'my_plugin', array(
     $this,
     'render_page'
 ));
 add_action('load-'.$this->myplugin_menu_item, array(
     $this,
     'help_tab'
 ));
}
/* .... */
```

Finally we get screen object using `get_current_screen()` and add help tab to current page using `add_help_tab()` method. It accepts an array of options as its parameter. These options include an unique id for the tab, name displayed on the tab and the name of the function that will render the tab contents. If you like to add sidebar to the help tab, you can use `set_help_sidebar()` method of the screen object. it accepts a single parameter which is the HTML content to be displayed.

```php
/* .... */
public function help_tab() {
 $screen = get_current_screen();
 if ($screen->id != $this->myplugin_menu_item)
  return;
 $screen->add_help_tab(array(
     'id' => 'help_tab_overview-id',
     'title' => 'Overview',
     'content' => '<p>An overview of plugin function</p>'
 ));
 $screen->add_help_tab(array(
     'id' => 'help_tab_faq-id',
     'title' => 'FAQ',
     'content' => '<p>A list of plugin faq</p>'
 ));
 $screen->set_help_sidebar('<p>External Links</p>');
}
/* .... */
```

when you visit your plugin administration page, You should see the help tab appear at the top of the page.

Our working plugin code should be like the following code.

```php
/*
  Plugin Name: my Plugin
  Plugin URI: http://clivern.com/
  Description: Plugin description
  Version: 1.0
  Author: Clivern
  Author URI: http://clivern.com
  License: MIT
 */

class myPlugin {

 private $myplugin_menu_item;
 static  $instance;

 static function GetInstance() {
  if (!isset(self::$instance)) {
   self::$instance = new self();
  }
  return self::$instance;
 }

 public function build_plugin() {
  add_action('admin_menu', array(
      $this,
      'menu'
  ));
 }

 public function help_tab() {
  $screen = get_current_screen();
  if ($screen->id != $this->myplugin_menu_item)
   return;
  $screen->add_help_tab(array(
      'id' => 'help_tab_overview-id',
      'title' => 'Overview',
      'content' => '<p>An overview of plugin function</p>'
  ));
  $screen->add_help_tab(array(
      'id' => 'help_tab_faq-id',
      'title' => 'FAQ',
      'content' => '<p>A list of plugin faq</p>'
  ));
  $screen->set_help_sidebar('<p>External Links</p>');
 }

 public function menu() {
  $this->myplugin_menu_item = add_options_page('My Plugin', 'My Plugin', 'manage_options', 'my_plugin', array(
      $this,
      'render_page'
  ));
  add_action('load-' . $this->myplugin_menu_item, array(
      $this,
      'help_tab'
  ));
 }

 public function render_page() {
  ?>
  <div class='wrap'>
   <h2>My Plugin</h2>
   <p>Page Content</p>
  </div>
  <?php
 }
}

$myPlugin = myPlugin::GetInstance();
$myPlugin->build_plugin();
```