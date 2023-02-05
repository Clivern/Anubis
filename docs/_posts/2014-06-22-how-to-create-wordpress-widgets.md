---
title: How To Create Wordpress Widgets
date: 2014-06-22 00:00:00
featured_image: https://images.unsplash.com/photo-1503925802536-c9451dcd87b5?q=5
excerpt: Wordpress provides a great API to create and interact with widgets. Widgets are a great way to allow plugin users to build their blog sidebar easily. I will show you how to create widgets, add widget options and display it in the sidebar.
---

![](https://images.unsplash.com/photo-1503925802536-c9451dcd87b5?q=5)

Wordpress provides a great API to create and interact with widgets. Widgets are a great way to allow plugin users to build their blog sidebar easily. I will show you how to create widgets, add widget options and display it in the sidebar.

### Creating a Widget

In order to create a custom widget in wordpress, You need to extend `Wp_Widget` class and define your widget methods. Here's an overview of the class.

```php
class clivern_custom_widget extends WP_Widget
{
  function clivern_custom_widget(){
   //process widget
  }
  function form($instance){
    //show widget form in admin panel
  }
  function update($new_instance, $old_instance)
  {
    //update widget settings
  }
  function widget($args, $instance)
  {
    //display widget
  }
}
```

To register your widget, you can use `widgets_init` action hook. This hook invoked after default widgets have been registered. Then you use `register_widget()` function to register your widget. Now it's time to register our new widget. This widget will be used to show advertisements on our blog sidebar.

```php
function register_clivern_custom_widget(){
  register_widget('clivern_custom_widget');
}

add_action('widgets_init', 'register_clivern_custom_widget');
```

As you can see, the `register_widget()` function accepts one parameter (widget class name) so widget class should be look like this.

```php
class clivern_custom_widget extends WP_Widget
{
 //...
}
```

It is worth noting that widget class should be with unique name so you should always prefix this name with something unique like plugin name or brand name.

Let's build the method that will process our widget. This method must have the same name of the class.

```php
  function clivern_custom_widget(){
   //process widget
    $widget_options = array(
      'classname'=> 'clivern_custom_widget_classname',
      'description'=> 'A simple widget to show ads in blog sidebar.',
      );
    $this->WP_Widget('clivern_custom_widget', 'Ads Widget', $widget_options);
  }
```

As you can see, first we created an array to store widget options (`$widget_options`). These options include `classname` and `description`. The `classname` added to widget element in front end and `description` displayed under the widget on widgets page. Then we passed the widget id (`clivern_custom_widget`), the widget name (`Ads Widget`) and an array of options (`$widget_options`) you set earlier to the `Wp_Widget`.

Next we need to create widget form. Our widget will accept four values because it will be used to show four advertisements banners in blog sidebar.

```php
  function form($instance){
    //show widget form in admin panel
    $default_settings = array(
      'title' => 'Advertisements',
      'ads_box_1'=>'',
      'ads_box_2'=>'',
      'ads_box_3'=>'',
      'ads_box_4'=>'',
      );
    $instance = wp_parse_args(
      (array) $instance,
      $default_settings
      );
    $title = $instance['title'];
    $ads_box_1 = $instance['ads_box_1'];
    $ads_box_2 = $instance['ads_box_2'];
    $ads_box_3 = $instance['ads_box_3'];
    $ads_box_4 = $instance['ads_box_4'];
    ?>
    <p>Title: <input class="widefat"
      name="<?php echo $this->get_field_name('title') ?>"
      type="text" value="<?php echo esc_attr($title)?>"/>
    </p>
    <p>Ads Box 1: <textarea class="widefat"
      name="<?php echo $this->get_field_name('ads_box_1') ?>"
      ><?php echo esc_attr($ads_box_1) ?></textarea>
    </p>
    <p>Ads Box 2: <textarea class="widefat"
      name="<?php echo $this->get_field_name('ads_box_2') ?>"
      ><?php echo esc_attr($ads_box_2) ?></textarea>
    </p>
    <p>Ads Box 3: <textarea class="widefat"
      name="<?php echo $this->get_field_name('ads_box_3') ?>"
       ><?php echo esc_attr($ads_box_3) ?></textarea>
    </p>
    <p>Ads Box 4: <textarea class="widefat"
      name="<?php echo $this->get_field_name('ads_box_4') ?>"
       ><?php echo esc_attr($ads_box_4) ?></textarea>
     </p>
    <?php
  }
```

First we created array of defaults `$default_settings`. Then we passed these array and `$instance` array to `wp_parse_args()`. The `wp_parse_args()` compares the two arrays and return final values. Then we created form elemets for entering widget data. You shouldn't forget to escape saved data before displaying them in fields.

Then we need to build the method that will be invoked when settings updated.

```php
  function update($new_instance, $old_instance)
  {
    //update widget settings
    $instance = $old_instance;
    $instance['title'] = strip_tags($new_instance['title']);
    $instance['ads_box_1'] = $new_instance['ads_box_1'];
    $instance['ads_box_2'] = $new_instance['ads_box_2'];
    $instance['ads_box_3'] = $new_instance['ads_box_3'];
    $instance['ads_box_4'] = $new_instance['ads_box_4'];

    return $instance;
  }
```

The final part is to build your widget appearance in the front end so let's build `widget` method of the widget class.

```php
  function widget($args, $instance)
  {
    //display widget
    extract($args);

    echo $before_widget;

    $title = apply_filters('widget_title', $instance['title']);
    $ads_box_1 = empty($instance['ads_box_1']) ? '': $instance['ads_box_1'];
    $ads_box_2 = empty($instance['ads_box_2']) ? '': $instance['ads_box_2'];
    $ads_box_3 = empty($instance['ads_box_3']) ? '': $instance['ads_box_3'];
    $ads_box_4 = empty($instance['ads_box_4']) ? '': $instance['ads_box_4'];

    if(!empty($title)){ echo $befor_title . $title . $after_title; }
    echo '<ul class="cli_sb_ads_boxes">
    <li>'.$ads_box_1.'</li>
    <li>'.$ads_box_2.'</li>
    <li>'.$ads_box_3.'</li>
    <li>'.$ads_box_4.'</li>
    </ul>';

    echo $after_widget;
  }
```

First, we extracted the `$args` parameter. This variable holds another variables (`$before_widget` and `$after_widget`). You should always apply `widget_title` filter to widget title and output `$before_widget`, `$after_widget`, `$before_title` and `$after_title`. This enables other developers to modify your widget appearance.

Let's take a look at full widget code.

```php
function register_clivern_custom_widget(){
  register_widget('clivern_custom_widget');
}

add_action('widgets_init', 'register_clivern_custom_widget');

class clivern_custom_widget extends WP_Widget
{
  function clivern_custom_widget(){
   //process widget
    $widget_options = array(
      'classname'=> 'clivern_custom_widget_classname',
      'description'=> 'A simple widget to show ads in blog sidebar.',
      );
    $this->WP_Widget('clivern_custom_widget', 'Ads Widget', $widget_options);
  }

  function form($instance){
    //show widget form in admin panel
    $default_settings = array(
      'title' => 'Advertisements',
      'ads_box_1'=>'',
      'ads_box_2'=>'',
      'ads_box_3'=>'',
      'ads_box_4'=>'',
      );
    $instance = wp_parse_args(
      (array) $instance,
      $default_settings
      );
    $title = $instance['title'];
    $ads_box_1 = $instance['ads_box_1'];
    $ads_box_2 = $instance['ads_box_2'];
    $ads_box_3 = $instance['ads_box_3'];
    $ads_box_4 = $instance['ads_box_4'];
    ?>
    <p>Title: <input class="widefat"
      name="<?php echo $this->get_field_name('title') ?>"
      type="text" value="<?php echo esc_attr($title)?>"/>
    </p>
    <p>Ads Box 1: <textarea class="widefat"
      name="<?php echo $this->get_field_name('ads_box_1') ?>"
      ><?php echo esc_attr($ads_box_1) ?></textarea>
    </p>
    <p>Ads Box 2: <textarea class="widefat"
      name="<?php echo $this->get_field_name('ads_box_2') ?>"
      ><?php echo esc_attr($ads_box_2) ?></textarea>
    </p>
    <p>Ads Box 3: <textarea class="widefat"
      name="<?php echo $this->get_field_name('ads_box_3') ?>"
       ><?php echo esc_attr($ads_box_3) ?></textarea>
    </p>
    <p>Ads Box 4: <textarea class="widefat"
      name="<?php echo $this->get_field_name('ads_box_4') ?>"
       ><?php echo esc_attr($ads_box_4) ?></textarea>
     </p>
    <?php
  }

  function update($new_instance, $old_instance)
  {
    //update widget settings
    $instance = $old_instance;
    $instance['title'] = strip_tags($new_instance['title']);
    $instance['ads_box_1'] = $new_instance['ads_box_1'];
    $instance['ads_box_2'] = $new_instance['ads_box_2'];
    $instance['ads_box_3'] = $new_instance['ads_box_3'];
    $instance['ads_box_4'] = $new_instance['ads_box_4'];

    return $instance;
  }

  function widget($args, $instance)
  {
    //display widget
    extract($args);

    echo $before_widget;

    $title = apply_filters('widget_title', $instance['title']);
    $ads_box_1 = empty($instance['ads_box_1']) ? '': $instance['ads_box_1'];
    $ads_box_2 = empty($instance['ads_box_2']) ? '': $instance['ads_box_2'];
    $ads_box_3 = empty($instance['ads_box_3']) ? '': $instance['ads_box_3'];
    $ads_box_4 = empty($instance['ads_box_4']) ? '': $instance['ads_box_4'];

    if(!empty($title)){ echo $befor_title . $title . $after_title; }
    echo '<ul class="cli_sb_ads_boxes">
    <li>'.$ads_box_1.'</li>
    <li>'.$ads_box_2.'</li>
    <li>'.$ads_box_3.'</li>
    <li>'.$ads_box_4.'</li>
    </ul>';

    echo $after_widget;
  }
}
```