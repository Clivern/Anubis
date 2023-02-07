---
title: Custom Queries with WordPress WP_Query
date: 2014-09-20 00:00:00
featured_image: https://images.unsplash.com/photo-1568941132351-ee4fff172b42?q=75&fm=jpg&w=1000&fit=max
excerpt: WP_Query is the heart of WordPress. It gives you a lot of control over the website content as well as holding important informations for debugging. It makes building complicated queries a lot easier by passing criteria as an associative array. Understanding WP_Query is a must for theme developers.
---

![](https://images.unsplash.com/photo-1568941132351-ee4fff172b42?q=75&fm=jpg&w=1000&fit=max)

`WP_Query` is the heart of WordPress. It gives you a lot of control over the website content as well as holding important informations for debugging. It makes building complicated queries a lot easier by passing criteria as an associative array. Understanding `WP_Query` is a must for theme developers.

### Simplified Overview

Every request made to wordpress goes through the `index.php` file which sets up the database connection and load other files needed for wordpress to work. Then wordpress gets the query parameters from the URL, the wordpress itself and plugins. After the query parameters have been set and passed to `WP_Query`, WordPress decides which template file to use and this decision based on the query parameters and template files available in the current active theme.

### The Loop

Now wordpress loaded one of our template files and will go through the loop. Let's explore how the loop appear in the template.

```php
if ( have_posts() ):
	// Start the Loop.
	while ( have_posts() ): the_post();

		/*
		 * Include the post format-specific template for the content.
		 */
		get_template_part( 'content', get_post_format() );

	endwhile;
	// add stuff here like post navigation.

else:
	// If no content, include the "No posts found" template.
	get_template_part( 'content', 'none' );

endif;
```

As you can see:

- `have_posts()`: Checks if posts found to render.
- `the_post()`: Sets the post data to be accessed later through template tags, the `$post` global variable and moves to the next post.
- `get_template_part()`: Loads another file in the theme to be used to show the post data.


### Custom Queries

Sometimes we need to modify the default query to exclude posts, exclude categories...etc. Also we may need to run multiple loops. Sometimes theme developers create another loop to get related posts. anyway to customize the query, you can use the following methods:

#### `query_posts()`

This function modifies the main query so use with caution. If you like to set up a new query, use the next methods as they are more efficient. Imagine you like to hard code posts per page and ignore the value that admin placed in dashboard.

```php
$args = array(
	'posts_per_page' => '10'
	);
query_posts($args);

if ( have_posts() ):
	// Start the Loop.
	while ( have_posts() ): the_post();

		//do stuff

	endwhile;
	// add stuff here like post navigation.

else:
	// No posts found

endif;
```

If you like to explore many query parameters, you can check `wp-includes/query.php` to get the complete list.


#### `get_posts()`

This function returns an array of posts according to passed query parameters. You can then loop through the result in another way different from normal template tags. Imagine that we need to show some of the posts that belong to current post author. This code should be placed in `single.php` file inside the loop.

```php
$cats = get_the_category($post->ID);
$cat_ids = array();
//loop through categories and store in an array
foreach ($cats as $cat):
	$cat_ids[] = $cat->term_id;
endforeach;
//set up the query parameters
$args = array(
	'author' => $post->post_author,
	'post_type' => 'post',
	'category__in' => $cat_ids,
	'post__not_in' => array($post->ID),
	);
//retrieve posts related to author
$author_related_posts = get_posts( $args );
if(!empty($author_related_posts)):
	?>
	<div class='author-related-posts'>
		<ul>
			<?php foreach ($author_related_posts as $author_related_post): ?>
				<li><a href="<?php echo esc_url(get_permalink($author_related_post->ID)); ?>"><?php echo $author_related_post->post_title; ?></a></li>
			<?php endforeach; ?>
		</ul>
	</div>
	<?php
endif;
```

You may noticed that i excluded current post id from retrieved posts.

#### `WP_Query` Object

Another method is to create a new instance of `WP_Query` class. It is similar to `get_posts()` except that you need to call template tags as methods of the new instance. Also you should reset query to default by using `wp_reset_postdata()`. Let's build the previous query with this method. This code should also be placed in `single.php` file inside the loop.

```php
//get categories of current post
$cats = get_the_category($post->ID);
$cat_ids = array();
//loop through categories and store in an array
foreach ($cats as $cat):
	$cat_ids[] = $cat->term_id;
endforeach;
//set up the query parameters
$args = array(
	'author' => $post->post_author,
	'post_type' => 'post',
	'category__in' => $cat_ids,
	'post__not_in' => array($post->ID),
	);
$author_related_posts = new WP_Query( $args );
if($author_related_posts->have_posts()):
	?>
	<div class="author-related-posts">
		<ul>
			<?php
			while ($author_related_posts->have_posts()): $author_related_posts->the_post();
				the_title( '<li><a href="' . esc_url( get_permalink() ) . '">', '</a></li>' );
			endwhile;
			?>
		</ul>
	</div>
	<?php
endif;
//reset to default post data
wp_reset_postdata();
```