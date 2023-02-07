---
title: How To Create Custom Roles For WordPress Users
date: 2014-04-02 00:00:00
featured_image: https://images.unsplash.com/photo-1530947443747-bcaaacd048d0?q=75&fm=jpg&w=1000&fit=max
excerpt: We discussed before how to work with wordpress built in roles and capabilities. Let's lead by creating custom roles and add capabilities to these roles.
---

![](https://images.unsplash.com/photo-1530947443747-bcaaacd048d0?q=75&fm=jpg&w=1000&fit=max)

We discussed before how to work with wordpress built in roles and capabilities. Let's lead by creating custom roles and add capabilities to these roles.

Wordpress allow creation of new roles by plugins and the best place to create custom roles and capabilities is on activation hook of your plugin. Imagine we need to create a freelancing plugin in which users should differ in their roles and capabilities so let's outline the custom roles that plugin will need:

- Administrator: Wordpress default role and it has all capabilities.
- Project Manager: It should have all capabilities over specific project.
- Developer: It should have capabilities to add tasks and read projects (`add_project_tasks` and `read_project`).
- Client: It should have capability to navigate project data (`read_project`).

Let's outline capabilities plugin might have:

- `create_projects`: capability to create new projects.
- `edit_project_settings`: capability to edit project settings.
- `add_project_tasks`: capability to add and edit tasks.
- `read_project`: capability to access project data.

After outlining roles and capabilities needed for plugin. Let's explore how to build these roles and capabilities.

### Creating a Role

You can use `add_role()` function to add new roles. The function returns role object if it added and null if role exist. Here's the syntax of the function.

```php
add_role($role, $display_name, $capabilities);
```

As you can see the function accepts 3 parameters:

- `$role`: the name of the role and it acts as a key.
- `$display_name`: a label for the role.
- `$capabilities`: array of capabilities to assign to role.

Here's how to add our plugin roles and capabilities.

```php
function freelance_plugin_activate(){
 /* add new capabilities to wordpress administrator role */
 //get role object
 $administrator_role =& get_role('administrator');
 //grant capabilities to role
 if(!empty($administrator_role)){
  $administrator_role->add_cap ('create_projects');
  $administrator_role->add_cap ('edit_project_settings');
  $administrator_role->add_cap ('add_project_tasks');
  $administrator_role->add_cap ('read_project');
 }

 /* add project manager role */
 add_role('project_manager', 'Project Manager',array(
     'edit_project_settings',
     'add_project_tasks',
     'read_project'
 ));
 /* add developer role */
 add_role('developer', 'Developer',array(
     'add_project_tasks',
     'read_project'
 ));
 /* add client role */
 add_role('client', 'Client',array(
     'read_project'
 ));
 }
register_activation_hook(__FILE__, 'freelance_plugin_activate');
```

### Adding and Deleting Capabilities

To add a capability to built in role like administrator, You must first get role object using `get_role()` and then use `add_cap()` method to grant capability to the role. Explore the following part of previous code.

```php
//get role object
$administrator_role =& get_role('administrator');
//grant capabilities to role
if(!empty($administrator_role)){
 $administrator_role->add_cap ('create_projects');
 $administrator_role->add_cap ('edit_project_settings');
 $administrator_role->add_cap ('add_project_tasks');
 $administrator_role->add_cap ('read_project');
}
```

To remove capability, also you need to get role object using `get_role()` and then use `remove_cap()` method. Here's how to remove previously added capabilities.

```php
//get role object
$administrator_role =& get_role('administrator');
//remove capabilities from role
if(!empty($administrator_role)){
 $administrator_role->remove_cap ('create_projects');
 $administrator_role->remove_cap ('edit_project_settings');
 $administrator_role->remove_cap ('add_project_tasks');
 $administrator_role->remove_cap ('read_project');
}
```

### Removing a Role

Removing a role is simple as adding new role. The `remove_role()` function can be used to remove roles. It accepts a single parameter which is the name of the role. Let's remove `project_manager` role.

```php
function freelance_plugin_delete_role(){
 //get users with role that will be deleted
 $project_managers =& get_users(array('role'=>'project_manager'));
 //loop through returned users to change role in subscriber
 if(count($project_managers) > 0){
  foreach ($project_managers as $key=>$project_manager){
   wp_update_user(array(
       'ID'=>$project_manager->ID,
       'role'=>'subscriber'
   ));
  }
 }
 //remove role it's safe now
 remove_role('project_manager');
}
add_action('admin_init','freelance_plugin_delete_role');
```

You should always check if any user uses role that you need to delete, Then change user role into another role.