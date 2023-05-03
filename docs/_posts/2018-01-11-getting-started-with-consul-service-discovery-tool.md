---
title: Getting Started With Consul Service Discovery Tool
date: 2018-01-11 00:00:00
featured_image: https://images.unsplash.com/photo-1593177962005-042a7a503d10
excerpt: Consul is a tool for discovering and configuring services in your infrastructure. It provides several key features like service discovery, health checking, KV store and multi datacenter support.
---

![](https://images.unsplash.com/photo-1593177962005-042a7a503d10)

Consul is a tool for discovering and configuring services in your infrastructure. It provides several key features like service discovery, health checking, KV store and multi datacenter support.

Consul is designed to be friendly to both the DevOps community and application developers, making it perfect for modern, elastic infrastructures.

##### Install Consul & Build Servers

First lets create four servers and install apache on three of them or any other services since we will do a service check in this article.

Let's say we have the four servers as follow:

- Server Name is `consul-01` and has a public IP `111.111.111.111`
- Server Name is `consul-02` and has a public IP `222.222.222.222`
- Server Name is `consul-03` and has a public IP `333.333.333.333`
- Server Name is `consul-04` and has a public IP `444.444.444.444`

Now we need to install consul on all these servers:

```bash
apt-get update
apt-get install unzip
cd /usr/local/bin
wget https://releases.hashicorp.com/consul/1.0.2/consul_1.0.2_linux_amd64.zip
unzip *.zip
rm *.zip
```

Feel free to use the appropriate consul version, Here we use `1.0.2`. Also consul use some ports so you need to open these ports or you can configure these ports but this out of the scope of this part right now. For now let's just open them and later we will talk about why these ports needed and how to configure:

```bash
sudo ufw allow 8300
sudo ufw allow 8301
sudo ufw allow 8302
sudo ufw allow 8400
sudo ufw allow 8500
sudo ufw allow 8600
```

Once you finihed, you can call `consul` command and get a help stuff:

```bash
$ consul
Usage: consul [--version] [--help] <command> [<args>]

Available commands are:
    agent          Runs a Consul agent
    catalog        Interact with the catalog
    .........
```

##### Service Definition

In order to know some of the powerful features of consul, We will define a service on `consul-01`, `consul-02` and `consul-03`. Which will will check if apache is up and running on all these servers. So let's create a config dir and define the service:

```bash
mkdir /tmp/consul_services
nano /tmp/consul_services/web.json
```

And the type the following in `web.json`:

```json
{
    "service": {
        "name": "web server",
        "port": 80,
        "tags": ["apache", "demonstration"],
        "check": {
            "script": "curl localhost:80 > /dev/null 2>&1",
            "interval": "10s"
        }
    }
}
```

##### Starting Consul

Now we finished so all we need is to start consul on the four servers. Just use any terminal like iTerm or Terminator and open seven different tabs

On Tab 1

```
# Open Consul-01
ssh root@111.111.111.111
```

On Tab 2

```
# Open Consul-01
ssh root@111.111.111.111
```

On Tab 3

```
# Open Consul-02
ssh root@222.222.222.222
```

On Tab 4

```
# Open Consul-02
ssh root@222.222.222.222
```

On Tab 5

```
# Open Consul-03
ssh root@333.333.333.333
```

On Tab 6

```bash
# Open Consul-03
ssh root@333.333.333.333
```

On Tab 7

```bash
# Open Consul-04
ssh root@444.444.444.444
```

Now we have all our servers open, Let's start consul one by one. The first server is our bootstrap server or a leader

On Tab 1, run the following and leave it running (Consul Server):

```bash
root@consul-01:~# consul agent -server -bootstrap -data-dir /tmp/consul -bind 111.111.111.111 -config-dir /tmp/consul_services -enable-script-checks
```

On Tab 3, run the following and leave it running (Consul Server):

```bash
root@consul-02:~# consul agent -server -data-dir /tmp/consul -bind 222.222.222.222 -join 111.111.111.111 -config-dir /tmp/consul_services -enable-script-checks
```

On Tab 5, run the following and leave it running (Consul Server):

```bash
root@consul-03:~# consul agent -server -data-dir /tmp/consul -bind 333.333.333.333 -join 111.111.111.111 -config-dir /tmp/consul_services -enable-script-checks
```

On Tab 7, run the following and leave it running (Consul Agent):

```bash
root@consul-04:~# consul agent -data-dir /tmp/consul -ui -client 444.444.444.444 -join 111.111.111.111
```

Then stop consul on server `consul-01` with `CTRL-C` and restart the service without the bootstrap option

```bash
root@consul-01:~# consul agent -server -data-dir /tmp/consul -bind 111.111.111.111 -config-dir /tmp/consul_services -enable-script-checks
```

Now we have everything up and running, Just check in any of the empty tabs like `Tab 2`:

```bash
root@consul-01:~# consul members
Node       Address               Status  Type    Build  Protocol  DC   Segment
consul-01  111.111.111.111:8301   alive   server  1.0.2  2         dc1  <all>
consul-02  222.222.222.222:8301   alive   server  1.0.2  2         dc1  <all>
consul-03  333.333.333.333:8301  alive   server  1.0.2  2         dc1  <all>
consul-04  10.17.0.8:8301        failed  client  1.0.2  2         dc1  <default>
```

and if you visit `http://444.444.444.444:8500/` from your browser

##### Running Consul as A Service

We are going to run consul as `systemctl` service and you should apply this to all previous servers using its custom command.

```bash
nano /etc/systemd/system/consul.service
```

Then insert the following:

```bash
[Unit]
Description=Consul
Documentation=https://www.consul.io/

[Service]
ExecStart=/usr/local/bin/consul agent -server -bootstrap -data-dir /tmp/consul -bind 111.111.111.111 -config-dir /tmp/consul_services -enable-script-checks
ExecReload=/bin/kill -HUP $MAINPID
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
```

Then let's start the service

```bash
$ systemctl daemon-reload
$ systemctl start consul.service
$ systemctl enable consul.service
```

As you can see doing this manually is time consuming so i created a chef cookbook to automate these steps and just run consul for you on any node. [Click here to check](https://github.com/Clivern/Consul-Cookbook)

##### Final Notes

I bind consul to the public IP which is not preferred at all, Always use a private IP. Also we run consul with the root user and communication not SSL But i believe i will write later how to use consul on production.

##### References

- [An Introduction to Using Consul.](https://www.digitalocean.com/community/tutorials/an-introduction-to-using-consul-a-service-discovery-system-on-ubuntu-14-04)
- [Consul Guide.](https://www.consul.io/docs/install/index.html)
