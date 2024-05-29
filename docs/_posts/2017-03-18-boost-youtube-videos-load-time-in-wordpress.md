---
title: Boost Youtube Videos Load Time In WordPress
date: 2017-03-18 00:00:00
featured_image: https://images.unsplash.com/photo-1568941136405-b1d44d9aefb9?q=90&fm=jpg&w=1000&fit=max
excerpt: Although it easy to embed youtube videos but you will be surprised of the increase in loading time of your webpage.
---

![](https://images.unsplash.com/photo-1568941136405-b1d44d9aefb9?q=90&fm=jpg&w=1000&fit=max)

Although it easy to embed youtube videos but you will be surprised of the increase in loading time of your webpage.

So i created a wordpress plugin that will show a thumbnail image of a YouTube video and the actual video player is loaded only when the user manually clicks the thumbnail. You will find a significant change in loading time especially if your webpage contain many youtube videos. [You can check & download the plugin at github.](https://github.com/Clivern/fast-yt-videos)

Also You can check the code here:

```php
<?php
/*
  Plugin Name: Fast Youtube Videos
  Plugin URI: http://clivern.com
  Description: WordPress Plugin to Increase Loading Time of Youtube Videos
  Version: 1.0.0
  Author: Clivern
  Author URI: http://clivern.com
  License: GPL
 */

/**
 * If this file is called directly, abort.
 */
if ( !defined('WPINC') )
{
    die;
}

/*
 * To Use this plugin just insert
 *  <div class="cliv-youtube-player" data-id="GAFZcYlO5S0"></div>
 *  in your post content
 */
class CliverFastYTVideos
{
	function init()
	{
            add_action('wp_head', array(
                 &$this,
                 'headerPrint'
            ));
            add_action('wp_footer', array(
                 &$this,
                 'footerPrint'
            ));
            add_filter('the_content', array(
        	 &$this,
        	 'filterContent'
            ));
	}

    /**
     * Print code in header
     *
     * @since 1.0
     * @access public
     */
    public function headerPrint()
    {
        ?>
		<style>
		    .cliv-youtube-player {
		        position: relative;
		        padding-bottom: 56.23%;
		        /* Use 75% for 4:3 videos */
		        height: 0;
		        overflow: hidden;
		        max-width: 100%;
		        background: #000;
		        margin: 5px;
		    }

		    .cliv-youtube-player iframe {
		        position: absolute;
		        top: 0;
		        left: 0;
		        width: 100%;
		        height: 100%;
		        z-index: 100;
		        background: transparent;
		    }

		    .cliv-youtube-player img {
		        bottom: 0;
		        display: block;
		        left: 0;
		        margin: auto;
		        max-width: 100%;
		        width: 100%;
		        position: absolute;
		        right: 0;
		        top: 0;
		        border: none;
		        height: auto;
		        cursor: pointer;
		        -webkit-transition: .4s all;
		        -moz-transition: .4s all;
		        transition: .4s all;
		    }

		    .cliv-youtube-player img:hover {
		        -webkit-filter: brightness(75%);
		    }

		    .cliv-youtube-player .play {
		        height: 72px;
		        width: 72px;
		        left: 50%;
		        top: 50%;
		        margin-left: -36px;
		        margin-top: -36px;
		        position: absolute;
		        background: url("//i.imgur.com/TxzC70f.png") no-repeat;
		        cursor: pointer;
		    }

		</style>
        <?php
    }

    /**
     * Print code in footer
     *
     * @since 1.0
     * @access public
     */
    public function footerPrint()
    {
        ?>
        <script type="text/javascript">
		    document.addEventListener("DOMContentLoaded",
		        function() {
		            var div, n,
		                v = document.getElementsByClassName("cliv-youtube-player");
		            for (n = 0; n < v.length; n++) {
		                div = document.createElement("div");
		                console.log(v[n].dataset.id);
		                if ( (v[n].dataset.id.indexOf('?') > -1) && (v[n].dataset.id.indexOf('=') > -1) ){
		                	var id_arr = v[n].dataset.id.split('?');
		                	v[n].dataset.id = id_arr[0];
		                }
		                div.setAttribute("data-id", v[n].dataset.id);
		                div.innerHTML = labnolThumb(v[n].dataset.id);
		                div.onclick = labnolIframe;
		                v[n].appendChild(div);
		            }
		        });

		    function labnolThumb(id) {
		        var thumb = '<img src="https://i.ytimg.com/vi/ID/hqdefault.jpg">',
		            play = '<div class="play"></div>';
		        return thumb.replace("ID", id) + play;
		    }

		    function labnolIframe() {
		        var iframe = document.createElement("iframe");
		        var embed = "https://www.youtube.com/embed/ID?autoplay=1";
		        iframe.setAttribute("src", embed.replace("ID", this.dataset.id));
		        iframe.setAttribute("frameborder", "0");
		        iframe.setAttribute("allowfullscreen", "1");
		        this.parentNode.replaceChild(iframe, this);
		    }
        </script>
        <?php
    }

    public function filterContent($content)
    {
    	$content = preg_replace('/<iframe.*?src=".*?youtube.com\/embed\/(.*?)".*?<\/iframe>/si','<div class="cliv-youtube-player" data-id="$1"></div>', $content);
    	return $content;
    }
}


$clivern_fast_yy_video = new CliverFastYTVideos();
$clivern_fast_yy_video->init();
```
