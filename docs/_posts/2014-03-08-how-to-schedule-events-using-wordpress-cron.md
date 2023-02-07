---
title: How To Schedule Events Using WordPress Cron
date: 2014-03-08 00:00:00
featured_image: https://images.unsplash.com/photo-1487360920430-e18a62e59ad2?q=75&fm=jpg&w=1000&fit=max
excerpt: Cron API is a great feature of wordpress. It allows wordpress to execute certain functions on a schedule. By default, wordpress schedule events to check for new versions and to check for plugins and themes updates. Every time your blog requested by visitor or search engine bot. Wordpress check if there are any cron jobs to run.
---

![](https://images.unsplash.com/photo-1487360920430-e18a62e59ad2?q=75&fm=jpg&w=1000&fit=max)

Cron API is a great feature of wordpress. It allows wordpress to execute certain functions on a schedule. By default, wordpress schedule events to check for new versions and to check for plugins and themes updates. Every time your blog requested by visitor or search engine bot. Wordpress check if there are any cron jobs to run.

### Scheduling a Single Event

Single events would run once and need to be rescheduled to run again. To create single cron job, Use `wp_schedule_single_event()` function.

```php
add_action('init','cliv_create_single_schedule');
add_action('cliv_single_cron_job','cliv_single_cron_function');

function cliv_single_cron_function(){
  //send email
  wp_mail('hello@clivern.com', 'Clivern', 'Well Done!');
}

function cliv_create_single_schedule(){
  //check if event scheduled before
  if(!wp_next_scheduled('cliv_single_cron_job'))
  //shedule event to run after 1 hour
  wp_schedule_single_event (time()+3600, 'cliv_single_cron_job');
}
```

As you can see, The `wp_next_scheduled()` verify that cron job hasn't been scheduled before. If it returns `false`, The `wp_schedule_single_event()` executed and schedule cron event to be run after 1 hours. Then i created the hook that will run when event come.

### Scheduling a Recurring event

A recurring event means that it will be executed every specific interval. WordPress provide three intervals to select from ( `hourly`, `daily` and `twicedaily` ). Scheduling recurring events is similar to that of single event except that we will use `wp_schedule_event()` instead of `wp_schedule_single_event()`. Then we pass interval as second parameter. Here's an example.

```php
add_action('init','cliv_create_recurring_schedule');
add_action('cliv_recurring_cron_job','cliv_recurring_cron_function');

function cliv_recurring_cron_function(){
  //send email
  wp_mail('hello@clivern.com', 'Clivern', 'Well Done!');
}

function cliv_create_recurring_schedule(){
  //check if event scheduled before
  if(!wp_next_scheduled('cliv_recurring_cron_job'))
  //shedule event to run after every hour
  wp_schedule_event (time(), 'hourly', 'cliv_recurring_cron_job');
}
```

### Unscheduling Event

To unschedule cron events, Use the `wp_unschedule_event()` function. This function accepts three parameters. The first parameter is the timestamp of the next schedule. The second parameter is the action hook to unschedule while the third parameter is array of arguments to be passed to hook callback function. Let's unschedule last created cron job.

```php
$event_timestamp = wp_next_scheduled('cliv_recurring_cron_job');
wp_unschedule_event($event_timestamp, 'cliv_recurring_cron_job');
```

### Creating Custom Intervals

As i said before, Wordpress has three intervals to run your cron jobs (hourly, daily and twicedaily). To create custom interval for your cron jobs, You are free to use `cron_schedules` filter hook like that.

```php
add_filter('cron_schedules','cliv_cron_add_threedays');

function cliv_cron_add_threedays($schedules){
  $schedules['threedays'] = array(
    'interval' => 259200,
    'display'=> 'Three Days'
  );

  return $schedules;
}
```

As you can see, I provide the interval name (threedays) and the interval in seconds. Now you can use a newly created interval for your schedules easily like that.

```php
//shedule event to run after three days
wp_schedule_event (time(), 'threedays', 'cliv_cron_job_hook');
```

Well, I hope you already fine tuned wordpress cron API. I think you should always check all scheduled jobs because sometimes plugin developers forget to unschedule events in plugins. If plugin deactivated ,its code will be unavailable. However wordpress will try to execute event. So here's a simple wordpress plugin that displays all cron jobs scheduled in wordpress.

```php
 /*
  Plugin Name: Crons
  Plugin URI: http://clivern.com/
  Description: Shows all scheduled events
  Version: 1.0
  Author: Clivern
  Author URI: http://clivern.com
  License: MIT
  */
  class CLIVERN_CRON
  {
      public function Run(){
          /**
           * init activation function
           */
          register_activation_hook($this->root_file, array(
              $this,
              'PActivation'
          ));
          /**
           * init deactivation function
           */
          register_deactivation_hook($this->root_file, array(
              $this,
              'PDeactivation'
          ));
          /**
           * add menu page
           */
          add_action('admin_menu', array(
              $this,
              'PMenu'
          ));
      }


      /**
       * Perform plugin activation task
       */
      public function Pactivate()
      {

          //check blog version
          if (version_compare(get_bloginfo('version'), '3.5', '<'))
          {
              //blog version is too low you should update your blog
              wp_die('WordPress Blog Version Must Be Higher Than 3.5 So Please Update Your Blog', 'Cron');
          }
          else
          {
              //do activation stuff here
          }
      }

      /**
       * Perform plugin deactivation task
       */
      public function PDeactivation()
      {
          //silence is golden
      }

      /**
       * add page to settings menu
       */
      public function PMenu()
      {
          //insert submenu for bits in settings top menu
          add_options_page('Cron','Cron', 'manage_options', 'clivern_cron', array(
              $this,
              'PView'
          ));
      }

      /**
       * Cron backend view
       */
      public function PView()
      {
       global $date_format;
       $crons = _get_cron_array();
      ?>
      <div class='wrap'>
      <h2>Cron</h2>
      <br/>
      <table class="wp-list-table widefat fixed" cellspacing="0">
	<thead>
         <tr>
          <th scope='col'>Next Schedule</th>
          <th scope='col'>Hook Name</th>
          <th scope='col'>Interval</th>
         </tr>
        </thead>
	<tfoot>
         <tr>
          <th scope='col'>Next Schedule</th>
          <th scope='col'>Hook Name</th>
          <th scope='col'>Interval</th>
         </tr>
        </tfoot>
        <tbody>
         <?php foreach ($crons as $timestamp => $hookdata){ ?>
         <?php foreach ($hookdata as $hook => $data){ ?>
         <?php foreach ($data as $event){ ?>
         <tr>
          <th scope='row'><?php echo date_i18n($date_format, wp_next_scheduled($hook)); ?></th>
          <th scope='row'><?php echo $hook; ?></th>
          <th scope='row'><?php echo $event['schedule'].'( '.$event['interval']/(3600).' Hours )'; ?></th>
         </tr>
         <?php } ?>
         <?php } ?>
         <?php } ?>
        </tbody>
      </table>
      </div>
      <?php
      }
  }
  $Cron_Plugin = new CLIVERN_CRON();
  $Cron_Plugin->Run();
```