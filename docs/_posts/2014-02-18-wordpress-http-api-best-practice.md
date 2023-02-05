---
title: WordPress HTTP API Best Practice
date: 2014-02-18 00:00:00
featured_image: https://images.unsplash.com/photo-1573713104157-0831ea0b10dc?q=5
excerpt: After you fine tuned wordpress HTTP API ,it is the time to put your codes in a larger practice. I thick the best practice on HTTP API is wordpress plugin upgrades. Agreat trait of wordpress is that you can create plugins for public use and host them on wordpress servers. In this case you don't have to think about plugin upgrades because twice daily, wordpress sends requests to `api.wordpress.org` to check latest updates (visit <a href="http://codex.wordpress.org/WordPress.org_API">More Details</a>) .One of these requests a list of all plugins currently installed. The API server replies with a list of new versions and informations about them if available.
---

![](https://images.unsplash.com/photo-1573713104157-0831ea0b10dc?q=5)

After you fine tuned wordpress HTTP API ,it is the time to put your codes in a larger practice. I thick the best practice on HTTP API is wordpress plugin upgrades. Agreat trait of wordpress is that you can create plugins for public use and host them on wordpress servers. In this case you don't have to think about plugin upgrades because twice daily, wordpress sends requests to `api.wordpress.org` to check latest updates (visit [More Details](http://codex.wordpress.org/WordPress.org_API)) .One of these requests a list of all plugins currently installed. The API server replies with a list of new versions and informations about them if available.

For instance: if you have one plugin installed and active .the request sent as POST to `http://api.wordpress.org/plugins/update-check/1.1/` would be something like that

```php
$request=array(
    'plugins' => array(
        'my_plugin/my_plugin.php'=>array(
            'Name'=>'My Plugin',
            'PluginURL'=>'http://example.com',
            'Version'=>'1.0',
            'Author'=>'ted',
            //....and so on
        )
    ),
    'active' => array(
        0 => 'my_plugin/my_plugin.php',
    )
);
```

If plugin hosted on `wordpress.org`, the server will respond with something like that

```php
$response=array(
        'my_plugin/my_plugin.php'=>array(
            'id'=>'2569',
            'slug'=>'my_plugin',
            'new_version'=>'1.0',
            'url'=>'http://....',
            'package'=>'http://downloads.wordpress.org/plugin/../my_plugin.zip'
            //....and so on
        )
);
```

<p>Then the request and response stored in a site transient named `update_plugins`</p>
<h3>Building an Alternative API</h3>
<p>Clients may require plugins for their own use ,or you may code plugins and sell them for some bux .Actually i prefer to create remote xml file for each of your plugins and make your plugins check latest version every 12 hours .The remote xml file could be hosted on your website and will be something like that .</p>

```xml
<?xml version="1.0" encoding="UTF-8"?>
<notifier>
 <latest>1.0</latest>
 <changelog>
<![CDATA[
<h4>Version 1.0</h4>
<ul>
<li>This is a line in the changelog</li>
<li>This is another line in the changelog</li>
</ul>
]]]]><![CDATA[>
 </changelog>
</notifier>
```

Then your plugin will check for latest version each 12 hours, compare with current version and display notice to administrator if plugin need to be updated .check the following code .

```php
class MY_PLUGIN_UPDATE_NOTICE
{

    private $current_version;
    private $plugin_text_domain;
    private $remote_xml_url;
    private $plugin_capability = 'manage_options';
    private $plugin_options = array('lastcheck' => '1392390971', 'latestversion' => '', 'interval' => '43200');

    public function __construct($plugin_text_domain, $current_version, $remote_xml_url)
    {
        $this->current_version                 = $current_version;
        $this->remote_xml_url                  = $remote_xml_url;
        $this->plugin_text_domain              = $plugin_text_domain;
        $this->plugin_options['latestversion'] = $current_version;
        $this->GetOptions();
        add_action('admin_init', array(
            $this,
            'PluginUpdates'
        ));
    }

    private function GetOptions()
    {
        if (get_option('my_plugin_latest_version_data') === false) {
            add_option('my_plugin_latest_version_data', $this->plugin_options);
        } else {
            $this->plugin_options = get_option('my_plugin_latest_version_data');
        }
    }

    private function UpdateOptions()
    {
        return update_option('my_plugin_latest_version_data', $this->plugin_options);
    }

    public function PluginUpdates()
    {
        if ((string) $this->plugin_options['latestversion'] > (string) $this->current_version) {
            if (!current_user_can($this->plugin_capability))
                return;
            add_action('admin_notices', array(
                $this,
                'PluginUpdatesNotice'
            ));
            return;
        }
        $now = time();
        if (($now - $this->plugin_options['lastcheck']) < $this->plugin_options['interval'])
            return;
        if (!function_exists('simplexml_load_string'))
            return;
        if (function_exists('curl_init')) {
            $ch = curl_init($this->remote_xml_url);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_HEADER, 0);
            curl_setopt($ch, CURLOPT_TIMEOUT, 10);
            $response = curl_exec($ch);
            curl_close($ch);
        } else {
            $response = file_get_contents($this->remote_xml_url);
        }
        if (strpos((string) $response, '<notifier>') === false) {
            $this->plugin_options['lastcheck'] = $now;
            $this->UpdateOptions();
        } else {
            $body                                  = simplexml_load_string($response);
            $this->plugin_options['lastcheck']     = $now;
            $this->plugin_options['latestversion'] = (string) $body->latest;
            $this->UpdateOptions();
        }
    }

    public function PluginUpdatesNotice()
    {
?>
     <div class='error'><p><strong> <?php
        _e('A new version of my plugin is available! Please update now.', $this->plugin_text_domain);
?> </strong></p></div>
        <?php
    }

}
```

To implement this class in your plugin ,just create object like that

```php
$my_plugin_update =new MY_PLUGIN_UPDATE_NOTICE('my_plugin_text_domain','1.0','http://mysite.com/my_plugin.xml')
```

Another method that may be cumbersome is to create a complete self hosted API that allow your clients to download new updates without leaving their blog like wordpress.org. This solution may be crazy if your plugin for pulic use. why! just upload to wordpress.org. In case you plugin for private use you may need this solution.