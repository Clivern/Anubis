---
title: How to Secure WordPress Plugins
date: 2014-08-01 00:00:00
featured_image: https://images.unsplash.com/photo-1489440756412-01ddd309b1a1?q=75&fm=jpg&w=1000&fit=max
excerpt: Securing your wordpress plugin isn't a difficult task or cumbersome because wordpress implements several tools to make your code safe and secure. We will exploore how to secure your plugins from internet pirates.
---

![](https://images.unsplash.com/photo-1489440756412-01ddd309b1a1?q=75&fm=jpg&w=1000&fit=max)

Securing your wordpress plugin isn't a difficult task or cumbersome because wordpress implements several tools to make your code safe and secure. We will exploore how to secure your plugins from internet pirates.

### Access Permissions

You probably noticed that when you created menu item for your plugin, you provided access permission like `manage_options`. This permission allow only administrators to access plugin page. but sometimes we submit form or perform ajax request to another url and forget to check permissions. Consider the following feeble code.

```php
if(!isset($_GET['action']))
  return;

if($_GET['action'] == 'get')
{
  //return data for ajax request
}
elseif($_GET['action'] == 'set')
{
  //check user submitted data and submit to db
}
```

Since we need to restrict access for only administrators, you need to check for users permission.

```php
if(!isset($_GET['action']) || !current_user_can('manage_options'))
  return;

if($_GET['action'] == 'get')
{
  //return data for ajax request
}
elseif($_GET['action'] == 'set')
{
  //check user submitted data and submit to db
}
```

Brillient but still feeble, you should note that `current_user_can()` function is a pluggable function and plugins load first then pluggable function so it seems we checked too early. we need to hook our check to action hook executed after pluggable functions load (eg. `init` hook).

```php
function myplugin_ajax_requests(){
  if(!isset($_GET['action']) || !current_user_can('manage_options'))
    return;

  if($_GET['action'] == 'get')
  {
      //return data for ajax request
  }
  elseif($_GET['action'] == 'set')
  {
      //check user submitted data and submit to db
  }
}
add_action('init', 'myplugin_ajax_requests');
```

The golden rule is to always guarantee that sensitive actions are restricted to users with specific rights.

### Nonces

We explored how to check user permissions to prevent your blog from un authorized users. Now we will explore how to prevent users from performing sensitive actions without attention. Imagine someone submit a comment or send a message containing a link that would delete a post on your blog (without nonces, you can guessed these links). If you logged in and clicked this link, the post will be deleted. We call this CSRF (Cross Site Request Forgery).

WordPress nonces is a handy tool to prevent these attacks. It is a random string which is specific to one object (like post, plugin, link...), one user, one action (like delete, save, update) and for specific time (24 hours). The benefit of using nonces is that it cannot be guessed by a malicious user. For example the link to delete the page with `id=5` could be something such as `page.php?page=5&action=trash&_wpnonce=g58f65d8fc`. The previous nonce is valid for 24 hours and only if used to delete page with `id=5` by authorized user. WordPress verifies all these data before trashing page.

#### Creating Nonces

WordPress provides two functions to create nonces, one for URLs and another for forms. explore their syntax and usage.

```php
//Add nonce to url
wp_nonce_url($actionurl, $action, $name);
```

```php
//Add nonce to form
wp_nonce_field($action, $name, $referer, $echo);
```

As you can see, the `wp_nonce_url()` accepts the following parameters:

- `$actionurl`: A URL to which you want to append a nonce.</li>
- `$action`: Optional string with which you make the nonce specific to one object and one action and default is `-1`.</li>
- `$name`: Optional string for nonce name and default is `_wpnonce`.</li>

While the `wp_nonce_field()` accepts the following parameters:

- `$action`: Optional string with which you make the nonce specific to one object and one action and default is `-1`.</li>
- `$name`: Optional string for nonce name and default is `_wpnonce`.</li>
- `$referer`: Whether to set the referer field for validation, optional and default is `true`.</li>
- `$echo`: Whether to display or return hidden form field, optional and default is `true`.</li>

Consider the following example.

```php
$item_id = 5;
$delete_url = add_query_arg(array(
       'item_id' => $item_id,
       'action' => 'delete'
));
echo "<a href='".wp_nonce_url($delete_url, 'myplugin_delete_item'.$item_id)."'>Item Five </a>";
```

The previous example will create link like that `..&item_id=5&action=delete&_wpnonce=e9805789cb`.

Another example for securing forms.

```php
<?php $item_id = 5; ?>
<form action="" method="post">
 <input type="hidden" name="action" value="edit">
 <input type="hidden" name="item_id" value="<?php echo $item_id; ?>">
 <?php wp_nonce_field('myplugin_edit_item'.$item_id); ?>
</form>
```

#### Verifying Nonces

To verify nonces, we can use `check_admin_referer()` function. It accepts only one parameter which is the action passed to `wp_nonce_url()` or `wp_nonce_field()`. This function redirect user to error page if nonce is invalid.

Now to validate previous link and form we can check for action and item id using `$_REQUEST` to get both `$_GET` and `$_POST` arrays and then pass the action to `check_admin_referer()` function.

```php
function myplugin_perform_action(){
  if(!current_user_can('manage_options'))
    wp_die ( 'Insufficient Access Priv', 'My Plugin' );

  $action = $_REQUEST['action'];
  $item_id = $_REQUEST['item_id'];
  check_admin_referer('myplugin_'.$action.'_item'.$item_id);

  if($action == 'delete')
  {
    //delete item using item id
  }
  elseif ($action == 'edit')
  {
    //check for user submitted data and edit
  }
}
add_action('admin_init','myplugin_perform_action');
```