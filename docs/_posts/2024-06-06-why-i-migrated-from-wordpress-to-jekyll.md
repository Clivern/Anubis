---
title: Finally Moved Clivern from WordPress to Jekyll
date: 2024-06-06 00:00:00
featured_image: https://images.unsplash.com/photo-1510074377623-8cf13fb86c08?q=90&fm=jpg&w=1000&fit=max
excerpt: Today I just finished migrating my personal website from WordPress to Jekyll after running it for over 10 years (since 2010). It was a long journey - first hosted on GoDaddy's shared hosting with PHP 5.3, then upgraded to PHP 5.6. I moved it to DigitalOcean to get on PHP 7, and about 3 years ago, shifted it to Google Cloud. Today, I updated the DNS to GitHub Pages and took down the Google Cloud Server.
---

![](https://images.unsplash.com/photo-1510074377623-8cf13fb86c08?q=90&fm=jpg&w=1000&fit=max)

Today I just finished migrating my personal website from WordPress to Jekyll after running it for over 10 years (since 2010). It was a long journey - first hosted on GoDaddy's shared hosting with PHP 5.3, then upgraded to PHP 5.6. I moved it to DigitalOcean to get on PHP 7, and about 3 years ago, shifted it to Google Cloud. Today, I updated the DNS to GitHub Pages and took down the Google Cloud Server.

### Why I Made the Switch

- Upgrading the OS, PHP, WordPress plugins/themes was a pain if it's not your full-time gig. I had built the WP theme and some plugins myself, so every migration meant fixing stuff. Plus, some changes weren't even in a git repo - I did them directly on the server. Messy!
- Publishing blog posts got annoying on WP compared to Jekyll. Sure, WP has a nice editor, but I had styling issues that needed tons of newlines to keep the spacing right.
- I've used Jekyll before and really dig how it connects to git. Every time I push, the new post just goes live. And writing in Markdown is so much cleaner.


### How I Did the Migration

- Exported all posts to an XML file first.
- Built a parser with AI's help to convert each entry into a Markdown file.
- Tried making a parser for direct HTML->Markdown conversion too, but my custom WP shortcodes made that tough.
- Ended up doing most of the conversion manually with some online HTML->Markdown tools.
- Had to keep the same URLs, or I'd lose all my Google listings and backlinks. Set up Jekyll to match the old URLs for posts/pages. Ran both sites together for a bit before fully switching. Wrote a script to check the new site against the old sitemap to catch any broken links.


And that's how I finally made my personal site a lot cleaner and more git-friendly! No more WP headaches.
