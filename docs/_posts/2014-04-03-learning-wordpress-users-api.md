---
title: Learning Wordpress Users API
date: 2014-04-03 00:00:00
featured_image: https://images.unsplash.com/photo-1515933883823-cc5d063841b6?q=90&fm=jpg&w=1000&fit=max
excerpt: Wordpress powers many large websites with thousands of users like blogs, applications, social networks and much more. You will deal with many cases in which you need to work with users and fortunately wordpress has many functions to handle users.
---

![](https://images.unsplash.com/photo-1515933883823-cc5d063841b6?q=90&fm=jpg&w=1000&fit=max)

Wordpress powers many large websites with thousands of users like blogs, applications, social networks and much more. You will deal with many cases in which you need to work with users and fortunately wordpress has many functions to handle users.

### Retrieving Users

`get_users($arg)`: this function used to retrieve users based on arguments passed to the function. The arguments is optional and give you many criterias to limit returned users. If `$arg` array omitted, function will retrieve all users.

- `blog_id`: Used to get users of specific blog. It is useful for multisite installs and defaults to current blog ID.
- `role`: The users roles and defaults to empty string which will retrieve all roles.
- `meta_key`: Retrieve users with supplied meta key.
- `meta_value`: Retrieve users with supplied meta value.
- `meta_compare`: Compare meta value against some values (=, !=, >, <, >=, <=).
- `include`: An array of users IDs to include in query.
- `exclude`: An array of users IDs to exclude from query.
- `search`: A string used to search for users. by default wordpress search in `user_login`, `user_nicename`, `user_email`, `user_url` and `display_name` columns.
- `search_columns`: An array of search columns.
- `orderby`: The column to order the users by. By default wordpress uses `login` column. You can also order by `user_nicename`, `user_email`, `user_url`, `user_registered`, `display_name` and `post_count`.
- `order`: Whether to order users in descending order (`DESC`) or in ascending order (`ASC`). By default wordpress use `ASC`.
- `offset`: Number of users to skip before retrieving users.
- `number`: Used to limit returned users.
- `count_total`: A boolean value to check whether you need to count users or not. By default it is set to `false`.
- `fields`: By default it is set to `all` which means wordpress will retrieve all columns of users.
- `who`: Which users to query. Currently only `authors` is supported. Default is `all` users.

Let's create function that will dump users in complex array format regardless of `stdClass`.

```php
function dump_users(array $arg) {
  $users = get_users($arg);
  $parsed_users = array();
  foreach ($users as $key => $user_data) {
   $parsed_users[$key] = array(
       'data' => array(
           'ID' => $user_data->data->ID,
           'user_login' => $user_data->data->user_login,
           'user_pass' => $user_data->data->user_pass,
           'user_nicename' => $user_data->data->user_nicename,
           'user_email' => $user_data->data->user_email,
           'user_url' => $user_data->data->user_url,
           'user_registered' => $user_data->data->user_registered,
           'user_activation_key' => $user_data->data->user_activation_key,
           'user_status' => $user_data->data->user_status,
           'display_name' => $user_data->data->display_name
       ),
       'caps' => $user_data->caps,
       'roles' => $user_data->roles,
       'allcaps' => $user_data->allcaps
   );
  }
  return $parsed_users;
 }
```

`get_users_of_blog($blog_id)`: this function used to retrieve all users according to blog ID. It accepts only one parameter `$blog_id`. This parameter is used in case of multisite and if omitted the function will return users of current blog.

`count_users()`: this function counts users of the blog and number of users for each role. Let's explore function output.

```php
var_dump(count_users());

 /* Outputs
 array (size=2)
  'total_users' => int 1
  'avail_roles' =>
    array (size=1)
      'administrator' => int 1
  */
```

### Creating Users

`wp_insert_user($userdata)`: this function inserts new users and has single parameter `$userdata` (array of user's data). If user ID defined in `$userdata` array, Function will update user's data.The `$userdata` array can contain the following fields

- `ID`: An integer that will be used for updating an existing user. You should use this only if you are updating an existing user.
- `user_pass`: A password for the new user account.
- `user_login`: A username for the new user account.
- `user_nicename`: A string that contains a URL-friendly name for the user. The default is the user's username.
- `user_url`: The URL for user's web site.
- `user_email`: The user's email address.
- `display_name`: The name to display for the user. Defaults to user's username.
- `nickname`: The user's nickname, defaults to the user's username.
- `first_name`: The user's first name.
- `last_name`: The user's last name.
- `description`: A biographical informations about the user.
- `rich_editing`: whether to enable the rich editor. defaults to `true`.
- `user_registered`: The date the user registered. Format is 'Y-m-d H:i:s'.
- `role`: The user's role.
- `admin_color`: Color schema for administration panel.
- `comment_shortcuts`: Whether to use keyboard shortcuts when moderating comments. Defaults to `false`.

Let's lead with an example.

```php
function clivern_insert_user(){
  if(username_exists('clivern'))
   return;
  $clivern = wp_insert_user(array(
      'user_pass'=>'@1256hj',
      'user_login'=>'Clivern',
      'user_email'=>'hello@clivern.com',
      'description'=>'some text here',
      'role'=>'author',
      'user_url'=>'http://clivern.com'
  ));
  if(is_wp_error($clivern))
   echo $result->get_error_message();
}
add_action('admin_init','clivern_insert_user');
```

`wp_create_user($username,$password,$email)`: this function is similar to previous function except it allows you to quickly create new users. Here's an example.

```php
function clivern_insert_user(){
  if(username_exists('john'))
   return;
  $user = wp_create_user('john', 'hydkch', 'john@gmail.com');
  if(is_wp_error($user))
   echo $result->get_error_message();
 }
 add_action('admin_init', 'clivern_insert_user');
```

### Updating Users

`wp_update_user($userdata)`: this function used to update user data. It accepts only one parameter `$userdata` which is similar to that of `wp_insert_user()` function and you should provide user ID. Here's an example.

```php
function clivern_insert_user(){
  $userdata = get_user_by_email('hello@clivern.com');
  if(!$userdata)
   return;
  $clivern = wp_update_user(array(
      'ID'=> $userdata->ID,
      'user_pass'=>'@1256hj',
      'user_login'=>'Clivern',
      'user_email'=>'hi@clivern.com',
      'description'=>'some text here',
      'role'=>'author',
      'user_url'=>'http://clivern.com'
  ));
  if(is_wp_error($clivern))
    echo $result->get_error_message();
}

add_action('admin_init', 'clivern_insert_user');
```

### Deleting Users

`wp_delete_user($user_id,$reassign)`: this function used to delete users and re-assign their posts and links to another user. If `$reassign` parameter omitted, Wordpress will delete posts and links own by user.

### Retrieving Current User

`wp_get_current_user()`: this function used to retrieve data for the currently logged in user. Here's an example.

```php
function clivern_get_user_data(){
  var_dump(wp_get_current_user());
 }
 add_action('admin_init','clivern_get_user_data');
```

`get_currentuserinfo()`: similar to `wp_get_current_user()` except that it sets `$current_user` global variable from which you can access returned data. Here's an example.

```php
function clivern_get_user_data(){
  global $current_user;
  get_currentuserinfo();
  var_dump($current_user);
}
add_action('init','clivern_get_user_data');
```