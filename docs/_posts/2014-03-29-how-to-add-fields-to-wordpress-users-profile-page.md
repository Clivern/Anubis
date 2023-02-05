---
title: How To Add Fields To WordPress Users Profile Page
date: 2014-03-29 00:00:00
featured_image: https://images.unsplash.com/photo-1642629428981-fa0d8f2700af?q=5
excerpt: We discussed before wordpress users metadata and how it is flexible. Now we will explore how to use metadata in storing a per-user settings and how to add fields to user profile page to update metadata value.
---

![](https://images.unsplash.com/photo-1642629428981-fa0d8f2700af?q=5)

We discussed before wordpress users metadata and how it is flexible. Now we will explore how to use metadata in storing a per-user settings and how to add fields to user profile page to update metadata value.

By default, wordpress trigger several actions to which you can hook to add content to profile page.

- `personal_options`: Add content at end of personal options section in profile page.
- `profile_personal_options`: Add content after personal options section in profile page.
- `show_user_profile`: Add content before update button in profile page.

Also wordpress trigger `personal_options_update` action hook on profile settings update to which you can hook to save user inputs in metadata value.

Now let's create drop-down list that will appear in user profile page from which user can select his language.

```php
function clivern_add_drop_down(){
  //get user id
  $user_id = get_current_user_id();
  //get user locale with user id
  $user_locale = get_user_meta($user_id,'clivern_user_local',true);
  if(!$user_locale){
   //add default locale
   add_user_meta($user_id, 'clivern_user_local', 'en_US');
   $user_locale = 'en_US';
  }
  ?>
<tr>
 <th scope="row">Language</th>
 <td>
  <select name="clivern_user_locale">
   <option value="en_US" <?php selected('en_US',$user_locale); ?>>English</option>
   <option value="de_DE" <?php selected('de_DE',$user_locale); ?>>Dutch</option>
  </select>
 </td>
</tr>
<?php
 }
 add_action('personal_options','clivern_add_drop_down');
```

Well, Let's create function that will be executed when user hit update button. This function will update current metadata value with user submitted value.

```php
function clivern_drop_down_update(){
  if(!isset($_POST['clivern_user_locale']))
   return;
  //get user id
  $user_id = get_current_user_id();
  //validate submitted value otherwise set to default
  $user_locale = in_array($_POST['clivern_user_locale'], array('en_US','de_DE')) ? $_POST['clivern_user_locale']: 'en_US';
  //update user locale
  update_user_meta($user_id, 'clivern_user_local', $user_locale);
 }
 add_action('personal_options_update','clivern_drop_down_update');
```

Wordpress trigger `locale` action hook to check for locale value so let's hook to this action to change locale on a per-user settings.

```php
function clivern_change_locale(){
  //get user id
  $user_id = get_current_user_id();
  //get user locale with user id
  $user_locale = get_user_meta($user_id,'clivern_user_local',true);
  if(!$user_locale){
   //add default locale
   $user_locale = 'en_US';
  }
  //set locale
  return $user_locale;
 }
 add_filter('locale','clivern_change_locale');
```

What we need to do is to collect all these snippets together to create working plugin that will translate wordpress on a per-user settings.

```php
/*
  Plugin Name: Language Switcher
  Plugin URI: http://clivern.com/
  Description: Change Wordpress Language
  Version: 1.0
  Author: Clivern
  Author URI: http://clivern.com
  License: MIT
  */
 function clivern_add_drop_down(){
  //get user id
  $user_id = get_current_user_id();
  //get user locale with user id
  $user_locale = get_user_meta($user_id,'clivern_user_local',true);
  if(!$user_locale){
   //add default locale
   add_user_meta($user_id, 'clivern_user_local', 'en_US');
   $user_locale = 'en_US';
  }
  ?>
<tr>
 <th scope="row">Language</th>
 <td>
  <select name="clivern_user_locale">
   <option value="en_US" <?php selected('en_US',$user_locale); ?>>English</option>
   <option value="de_DE" <?php selected('de_DE',$user_locale); ?>>Dutch</option>
  </select>
 </td>
</tr>
<?php
 }
 add_action('personal_options','clivern_add_drop_down');

 function clivern_drop_down_update(){
  if(!isset($_POST['clivern_user_locale']))
   return;
  //get user id
  $user_id = get_current_user_id();
  //validate submitted value otherwise set to default
  $user_locale = in_array($_POST['clivern_user_locale'], array('en_US','de_DE')) ? $_POST['clivern_user_locale']: 'en_US';
  //update user locale
  update_user_meta($user_id, 'clivern_user_local', $user_locale);
 }
 add_action('personal_options_update','clivern_drop_down_update');

 function clivern_change_locale(){
  //get user id
  $user_id = get_current_user_id();
  //get user locale with user id
  $user_locale = get_user_meta($user_id,'clivern_user_local',true);
  if(!$user_locale){
   //add default locale
   $user_locale = 'en_US';
  }
  //set locale
  return $user_locale;
 }
 add_filter('locale','clivern_change_locale');
```