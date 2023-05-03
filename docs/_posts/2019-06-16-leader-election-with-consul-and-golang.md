---
title: Leader Election with Consul and Golang
date: 2019-06-16 00:00:00
featured_image: https://images.unsplash.com/photo-1485102068545-7286b0d199d8
excerpt: Leader election is the process of designating a single node as the organizer of some task distributed among several nodes. The leader will be responsible for managing the others and coordinate the actions performed by other nodes. If for any reason the leader fails, other nodes will elect another leader and so on.  This can help to ensure that nodes don't conflict with each other.
---

![](https://images.unsplash.com/photo-1485102068545-7286b0d199d8)

Leader election is the process of designating a single node as the organizer of some task distributed among several nodes. The leader will be responsible for managing the others and coordinate the actions performed by other nodes. If for any reason the leader fails, other nodes will elect another leader and so on.  This can help to ensure that nodes don't conflict with each other.

Implementing the leader election algorithm with consul is quite easy:

- Register the node as a service on Consul.
- Create a session.
- Try to put a Lock on that session. If you succeed you are leader if not… well you are not the leader.
- Renew the session

**It is just a naive implementation So do NOT use this in production.**

**Step 1:** [Download Consul](https://www.consul.io/downloads.html) and run on dev mode

```bash
$ ./consul agent -dev
```

**Step 2:** Register the node as a service on Consul

```golang
import (
    "github.com/hashicorp/consul/api"
    "time"
    "fmt"
)

// configs to connect to consul
client, err := api.NewClient(&amp;api.Config{
    Address: "127.0.0.1:8500",
    Scheme:  "http",
})

if err != nil {
    panic(err)
}

err = client.Agent().ServiceRegister(&amp;api.AgentServiceRegistration{
    Address: "http://127.0.0.1:8080",
    ID:      "node01_monitoring", // Unique for each node
    Name:    "monitoring", // Can be service type
    Tags:    []string{"monitoring"},
    Check: &amp;api.AgentServiceCheck{
        HTTP:     "http://127.0.0.1:8080/_health",
        Interval: "10s",
    },
})

if err != nil {
    panic(err)
}
```

**Step 3:** Create a session

```golang
sessionID, _, err := client.Session().Create(&amp;api.SessionEntry{
    Name: "service/monitoring/leader", // distributed lock
    Behavior: "delete",
    TTL: "10s",
}, nil)

if err != nil {
    panic(err)
}
```

**Step 4:** Try to put a Lock on that session. If you succeed you are leader if not… well you are not the leader.

```golang
isLeader, _, err := client.KV().Acquire(&amp;api.KVPair{
    Key:     "service/monitoring/leader", // distributed lock
    Value:   []byte(sessionID),
    Session: sessionID,
}, nil)

if err != nil {
    panic(err)
}

fmt.Println(isLeader)
```

**Step 5:** Since we defined the time to live for each session (10s). If the leader fails to renew the session for that time, consul will mark the session as invalid and delete or release based on the defined behavior.

```golang
doneChan := make(chan struct{})
defer close(doneChan)

go func(){
    // RenewPeriodic is used to periodically invoke Session.Renew on a
    // session until a doneChan is closed. This is meant to be used in a long running
    // goroutine to ensure a session stays valid.
   client.Session().RenewPeriodic(
        "10s",
        sessionID,
        nil,
        doneChan,
    )
}()

time.Sleep(90 * time.Second)
```

Let's wrap things up:

```golang
package main

import (
    "github.com/hashicorp/consul/api"
    "time"
    "fmt"
)

func main() {
    // configs to connect to consul
    client, err := api.NewClient(&amp;api.Config{
        Address: "127.0.0.1:8500",
        Scheme:  "http",
    })

    if err != nil {
        panic(err)
    }

    err = client.Agent().ServiceRegister(&amp;api.AgentServiceRegistration{
        Address: "http://127.0.0.1:8080",
        ID:      "node01_monitoring", // Unique for each node
        Name:    "monitoring", // Can be service type
        Tags:    []string{"monitoring"},
        Check: &amp;api.AgentServiceCheck{
            HTTP:     "http://127.0.0.1:8080/_health",
            Interval: "10s",
        },
    })

    if err != nil {
        panic(err)
    }

    sessionID, _, err := client.Session().Create(&amp;api.SessionEntry{
        Name: "service/monitoring/leader", // distributed lock
        Behavior: "delete",
        TTL: "10s",
    }, nil)

    if err != nil {
        panic(err)
    }

    isLeader, _, err := client.KV().Acquire(&amp;api.KVPair{
        Key:     "service/monitoring/leader", // distributed lock
        Value:   []byte(sessionID),
        Session: sessionID,
    }, nil)

    if err != nil {
        panic(err)
    }

    fmt.Println(isLeader)

    doneChan := make(chan struct{})
    defer close(doneChan)

    go func(){
        // RenewPeriodic is used to periodically invoke Session.Renew on a
        // session until a doneChan is closed. This is meant to be used in a long running
        // goroutine to ensure a session stays valid.
       client.Session().RenewPeriodic(
            "10s",
            sessionID,
            nil,
            doneChan,
        )
    }()

    time.Sleep(90 * time.Second)
}
```

References:

- [Leader election.](https://en.wikipedia.org/wiki/Leader_election)
- [Leader Election pattern](https://docs.microsoft.com/en-us/azure/architecture/patterns/leader-election)
- [Application Leader Election with Sessions](https://learn.hashicorp.com/consul/developer-configuration/elections)
