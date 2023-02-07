---
title: Leveraging Consul’s DNS Interface
date: 2019-05-08 00:00:00
featured_image: https://images.unsplash.com/photo-1505482109018-88cdc2e3d1bc?q=75&fm=jpg&w=1000&fit=max
excerpt: Consul DNS interface allows applications to make use of service discovery without any integration with Consul. For example, instead of making HTTP API requests to Consul, a host can use the DNS server directly via name lookups like clivern.service.us.consul.
---

![](https://images.unsplash.com/photo-1505482109018-88cdc2e3d1bc?q=75&fm=jpg&w=1000&fit=max)

Consul DNS interface allows applications to make use of service discovery without any integration with Consul. For example, instead of making HTTP API requests to Consul, a host can use the DNS server directly via name lookups like clivern.service.us.consul.

This query automatically translates to a lookup of nodes that provide the clivern service, are located in the us datacenter, and have no failing health checks. It's that simple! We will use systemd-resolved to send queries for the consul domain to Consul.

Configure /etc/systemd/resolved.conf to contain the following:

```
DNS=127.0.0.1
Domains=~consul
```

So for this to work either Consul must be configured to listen on port 53 instead of 8600 or you can use iptables to map port 53 to 8600. The following iptables commands are sufficient to do the port mapping.

```
$ iptables -t nat -A OUTPUT -d localhost -p udp -m udp --dport 53 -j REDIRECT --to-ports 8600

$ iptables -t nat -A OUTPUT -d localhost -p tcp -m tcp --dport 53 -j REDIRECT --to-ports 8600
```

Then Restart systemd-resolved

```
$ systemctl restart systemd-resolved
$ systemd-resolve --status
```

After you register a service

```
curl -X PUT \
    -d '{
        "ID": "clivern",
        "Name": "Clivern",
        "Port": 80,
        "Address": "clivern.com",
        "Tags":
            [
                "primary",
                "v1"
            ],
        "Check": {
            "Args": [
                "curl",
                "http://clivern.com"
            ],
            "Interval": "10s"
        }
    }' "http://localhost:8500/v1/agent/service/register"
```

you will be able to use the host directly

```
$ ping clivern.service.{DATACENTER}.consul
```