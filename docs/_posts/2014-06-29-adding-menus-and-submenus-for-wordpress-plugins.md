---
title: Adding Menus and Submenus for Wordpress Plugins
date: 2014-06-29 00:00:00
featured_image: https://images.unsplash.com/photo-1530172888244-f3520bbeaa55
excerpt: Integrating your plugin in wordpress is the first step in building plugins. There are many different ways to integrate your plugins including adding menus and submenus, adding metaboxes and adding widgets. Let's explore how to add menus and submenus for wordpress plugins.
---

![](https://images.unsplash.com/photo-1530172888244-f3520bbeaa55)

Integrating your plugin in wordpress is the first step in building plugins. There are many different ways to integrate your plugins including adding menus and submenus, adding metaboxes and adding widgets. Let's explore how to add menus and submenus for wordpress plugins.

### Adding a Menu

In order to add a new top-level menu to wordpress administration dashboard, You can use `add_menu_page()` function. This function has the following syntax.

```php
//add plugin menu
 add_menu_page($page_title, $menu_title, $capability, $menu_slug, $function, $icon_url, $position);
```

As you can see, The function accepts the following parameters.

- `page_title`: The page title.
- `menu_title`: The menu title displayed on dashboard.
- `capability`: Minimum capability to view the menu.
- `menu_slug`: Unique name used as a slug for menu item.
- `function`: A callback function used to display page content.
- `icon_url`: URL to custom image used as icon.
- `position`: Location in the menu order.

Let's create a new menu for our plugin.

```php
 function clivern_plugin_top_menu(){
   add_menu_page('My Plugin', 'My Plugin', 'manage_options', __FILE__, 'clivern_render_plugin_page', plugins_url('/img/icon.png',__DIR__));
 }
 add_action('admin_menu','clivern_plugin_top_menu');
```

As you can see, we used `admin_menu` action hook to trigger you menu code. Also we used `manage_options` to be the minimum capability required. It is worth noting that you should always store the return value of `add_menu_page()` call in a variable because you may need to customize the plugin page using this variable like adding help tab. That's why we prefer to create plugin with php classes.

```php
class MyPlugin{

      private $my_plugin_screen_name;
      private static $instance;
       /*......*/

      static function GetInstance()
      {

          if (!isset(self::$instance))
          {
              self::$instance = new self();
          }
          return self::$instance;
      }

      public function PluginMenu()
      {
       $this->my_plugin_screen_name = add_menu_page(
                                        'My Plugin',
                                        'My Plugin',
                                        'manage_options',
                                        __FILE__,
                                        array($this, 'RenderPage'),
                                        plugins_url('/img/icon.png',__DIR__)
                                        );
      }

      public function RenderPage(){
       ?>
       <div class='wrap'>
        <h2></h2>
       </div>
       <?php
      }

      public function InitPlugin()
      {
           add_action('admin_menu', array($this, 'PluginMenu'));
      }

 }

$MyPlugin = MyPlugin::GetInstance();
$MyPlugin->InitPlugin();
```

### Adding a Submenu

There are two types of submenus, menu items listed below your top-level menu and menu item listed below existing default menus in wordpress. To add submenus under your top-level menu, You can use `add_submenu_page()` function. This function has the following syntax.

```php
//add submenu
add_submenu_page($parent_slug, $page_title, $menu_title, $capability, $menu_slug, $function);
```

As you can see, this function accepts the following parameters.

- `parent_slug`: Slug of the parent menu item.
- `page_title`: The page title.
- `menu_title`: The submenu title displayed on dashboard.
- `capability`: Minimum capability to view the submenu.
- `menu_slug`: Unique name used as a slug for submenu item.
- `function`: A callback function used to display page content.

Let's add submenu to previously created top-level menu.

```php
 function clivern_plugin_top_menu(){
   add_menu_page('My Plugin', 'My Plugin', 'manage_options', __FILE__, 'clivern_render_plugin_page', plugins_url('/img/icon.png',__DIR__));
   add_submenu_page(__FILE__, 'Custom', 'Custom', 'manage_options', __FILE__.'/custom', 'clivern_render_custom_page');
   add_submenu_page(__FILE__, 'About', 'About', 'manage_options', __FILE__.'/about', 'clivern_render_about_page');
 }
 function clivern_render_plugin_page(){
  ?>
   <div class='wrap'>
    <h2></h2>
   </div>
  <?php
 }
 function clivern_render_custom_page(){
   ?>
   <div class='wrap'>
    <h2></h2>
   </div>
   <?php
 }
 function clivern_render_about_page(){
   ?>
   <div class='wrap'>
    <h2></h2>
   </div>
   <?php
 }

add_action('admin_menu','clivern_plugin_top_menu');
```

As you can see, The previous code creates two submenus to the top-level menu. Each of these submenus has a custom callback function to render page content.

We discussed how to add submenus to your custom top-level menu. It's time to explore how to add submenus to existing default menus in wordpress. Here's a list of all available functions in wordpress.

- `add_dashboard_page`: Add a submenu to the dashboard top-level menu.
- `add_posts_page`: Add a submenu to the posts top-level menu.
- `add_media_page`: Add a submenu to the media top-level menu.
- `add_links_page`: Add a submenu to the links top-level menu.
- `add_pages_page`: Add a submenu to the pages top-level menu.
- `add_comments_page`: Add a submenu to the comments top-level menu.
- `add_theme_page`: Add a submenu to the themes top-level menu.
- `add_plugins_page`: Add a submenu to the plugins top-level menu.
- `add_users_page`: Add a submenu to the users top-level menu.
- `add_management_page`: Add a submenu to the tools top-level menu.
- `add_options_page`: Add a submenu to the settings top-level menu.

All these functions have the same syntax so let's explore the most commonly used one.

```php
//add options page
add_options_page($page_title, $menu_title, $capability, $menu_slug, $function);
```

As you can see, this function accepts the following parameters.

- `page_title`: The page title.
- `menu_title`: The submenu item title.
- `capability`: Minimum capability to view the submenu.
- `menu_slug`: Unique name used as a slug for submenu item.
- `function`: A callback function used to display page content.

Consider the following example

```php
function clivern_plugin_options_page(){
  add_options_page('My Plugin', 'My Plugin', 'manage_options', __FILE__, 'clivern_plugin_render_options_page');
 }
 function clivern_plugin_render_options_page(){
   ?>
   <div class='wrap'>
    <h2></h2>
   </div>
   <?php
 }
 add_action('admin_menu','clivern_plugin_options_page');
```

As you can see, the previous code creates a submenu under settings top-level menu, set page title to `My Plugin`, set minimum capability to `manage_options` and set the callback function (`clivern_plugin_render_options_page`) to be called when the submenu item clicked.