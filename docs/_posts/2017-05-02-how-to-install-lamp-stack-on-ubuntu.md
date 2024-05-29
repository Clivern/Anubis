---
title: How To Install LAMP Stack on Ubuntu
date: 2017-05-02 00:00:00
featured_image: https://images.unsplash.com/photo-1607950026157-44cab229b733?q=90&fm=jpg&w=1000&fit=max
excerpt: LAMP stack is a group of open source software and it stands for Linux, Apache, MySQL, and PHP. To install them Just run the following bash script with a non-root user with sudo privileges configured on a server running Ubuntu.
---

![](https://images.unsplash.com/photo-1607950026157-44cab229b733?q=90&fm=jpg&w=1000&fit=max)

LAMP stack is a group of open source software and it stands for Linux, Apache, MySQL, and PHP. To install them Just run the following bash script with a non-root user with sudo privileges configured on a server running Ubuntu.


```bash
#!/bin/bash
sudo apt-get update
sudo apt-get install apache2
sudo apt-get install mysql-server php5-mysql
sudo mysql_install_db
sudo mysql_secure_installation
sudo apt-get install php5 libapache2-mod-php5 php5-mcrypt php5-gd php5-curl php5-cli
sed -i -e "s/index.html index.cgi index.pl index.php/index.php index.html index.cgi index.pl/" /etc/apache2/mods-enabled/dir.conf
sudo service apache2 restart
sudo apt-get install php5-cli
echo "<?php phpinfo();" > /var/www/html/info.php
```

or the following to install PHP5.6

```bash
#!/bin/bash
sudo apt-get update
sudo apt-get install apache2
sudo apt-get install mysql-server php5.6-mysql
sudo mysql_install_db
sudo mysql_secure_installation
sudo apt-get install php5.6 libapache2-mod-php5.6 php5.6-mcrypt php5.6-gd php5.6-curl php5.6-cli
sed -i -e "s/index.html index.cgi index.pl index.php/index.php index.html index.cgi index.pl/" /etc/apache2/mods-enabled/dir.conf
sudo service apache2 restart
sudo apt-get install php5.6-cli
echo "<?php phpinfo();" > /var/www/html/info.php
```
