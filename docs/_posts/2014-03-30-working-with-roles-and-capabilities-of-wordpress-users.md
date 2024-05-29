---
title: Working With Roles and Capabilities of WordPress Users
date: 2014-03-30 00:00:00
featured_image: https://images.unsplash.com/photo-1585352489367-8ad9a2b1adad?q=90&fm=jpg&w=1000&fit=max
excerpt: Wordpress ships with a powerful roles and capabilities system which control users permissions. Roles enable plugin developers to group users, each group has its own permissions. Understanding roles and capabilities is important aspect of plugin development.
---

![](https://images.unsplash.com/photo-1585352489367-8ad9a2b1adad?q=90&fm=jpg&w=1000&fit=max)

Wordpress ships with a powerful roles and capabilities system which control users permissions. Roles enable plugin developers to group users, each group has its own permissions. Understanding roles and capabilities is important aspect of plugin development.

### Roles and Capabilities

Wordpress ships with five roles (adminstrator, editor, author, cotributor, subscriber). By default wordpress group blog users by these roles which means when you attempt to create new user, wordpress ask you for user role. Roles are a set of capabilities that define what that role can do or can't do. adminstrators can't necessarily do more than authors although they have higher role because higher role is not necessarily have higher capability.

### User Permissions

When you check if user can `manage_options`, you are checking if user role grant `manage_options` capability to that user. Let's explore functions that wordpress offer to check user permissions.

`current_user_can()`: this function used to check if current logged in user has permission to perform specific capabililty. You can use the function to check for wordpress built in capabilities and custom capabilities implemented by plugins. Here's the function syntax.

```php
current_user_can($capability);
```

The function returns true if user has permission and false if user not logged in or don't have permission.

`current_user_can_for_blog()`: this function is similar to `current_user_can()` except it is specific for use with wordpress multisite install. Here's the syntax.

```php
current_user_can_for_blog( $blog_id, $capability );
```

`author_can()`: this function used to check if post author can perform specific task on this post. The function used only for post author not other users. Here's the syntax.

```php
author_can( $post, $capability );
```

The function accepts two parameters, The first parameter is the post ID or post object and the second parameter is the capability.

`user_can()`: this function used to check if provided user has specific capability. It is used to check capability of specific user not current logged in user. Here's the syntax.

```php
user_can( $user, $capability );
```

Also the function accepts user ID or user objects and capability.
