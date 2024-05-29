---
title: How to Install Apache Tomcat 8 on Ubuntu 16.04
date: 2017-04-30 00:00:00
featured_image: https://images.unsplash.com/photo-1460038917749-83f4ed4a27da?q=90&fm=jpg&w=1000&fit=max
excerpt: Tomcat is an open source web server used to serve Java Web Applications and provides a Java HTTP web server environment in which Java code can run. To install Tomcat Server Just run the following bash script with a non-root user with sudo privileges configured on a server running Ubuntu 16.04.
---

![](https://images.unsplash.com/photo-1460038917749-83f4ed4a27da?q=90&fm=jpg&w=1000&fit=max)

Tomcat is an open source web server used to serve Java Web Applications and provides a Java HTTP web server environment in which Java code can run. To install Tomcat Server Just run the following bash script with a non-root user with sudo privileges configured on a server running Ubuntu 16.04.

```bash
#!/bin/bash
sudo apt-get update
sudo apt-get install default-jdk
sudo apt-get install unzipa
cd /opt
curl -O http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.5.15/bin/apache-tomcat-8.5.15.zip
sudo unzip apache-tomcat-8.5.15.zip
sudo mv apache-tomcat-8.5.15 tomcat

sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

sudo chgrp -R tomcat /opt/tomcat
sudo chown -R tomcat /opt/tomcat
sudo chmod -R 755 /opt/tomcat

sudo echo "[Unit]
Description=Apache Tomcat Web Server
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=15
Restart=always

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/tomcat.service

sudo ufw allow 8080
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl status tomcat
```

Then visit `http://server_ip:8080` and you find it WORKS!

Also Check This [Snippet on Github Gists](https://gist.github.com/Clivern/b7ecd618969c06e31d5792b8868a2bce)
