---
title: Build Realtime Apps With Redis PubSub
date: 2017-09-02 00:00:00
featured_image: https://images.unsplash.com/photo-1471313902629-21dffc56c966?q=5
excerpt: Last week I worked with Pusher. Pusher is really amazing product to build scalable realtime apps. Also there is slanger and Poxa, Both are open source implementation compatible with Pusher libraries. But today we will use PHP, NodeJs, SocketIO and Redis Pub/Sub To work with realtime messaging.
---

![](https://images.unsplash.com/photo-1471313902629-21dffc56c966?q=5)

Last week I worked with <a href="https://pusher.com/" target="_blank">Pusher</a>. Pusher is really amazing product to build scalable realtime apps. Also there is <a href="https://github.com/stevegraham/slanger" target="_blank">slanger</a> and <a href="https://github.com/edgurgel/poxa" target="_blank">Poxa</a>, Both are open source implementation compatible with Pusher libraries. But today we will use PHP, NodeJs, <a href="https://socket.io/" target="_blank">SocketIO</a> and <a href="https://redis.io/topics/pubsub" target="_blank">Redis Pub/Sub</a> To work with realtime messaging.

##### Redis Server

First make sure that your redis server is running and you can access it whether through localhost (`127.0.0.1`) at port `6379` or public host `Server IP`. In order to check if Redis is working properly is sending a PING command using redis-cli:

```bash
$ redis-cli ping
PONG
```

##### WebSocket With NodeJs

We will need the following packages to build WebSockets App in NodeJs. Let's create a package file `package.json`.

```json
{
  "name": "RedisPubSub",
  "version": "1.0.0",
  "description": "Redis PubSub, NodeJS, and Socket.io",
  "main": "index.js",
  "scripts": {},
  "repository": {
    "type": "git",
    "url": "git+https://github.com/clivern/Redis-PubSub.git"
  },
  "keywords": [
    "Redis",
    "NodeJS",
    "Socket.io"
  ],
  "author": "",
  "license": "MIT",
  "bugs": {
    "url": "https://github.com/clivern/Redis-PubSub/issues"
  },
  "homepage": "https://github.com/clivern/Redis-PubSub",
  "dependencies": {
    "express": "^4.14.0",
    "redis": "^2.6.3",
    "socket.io": "^1.5.1"
  }
}
```

Then create our `index.js` file.

```js
var express = require('express');
var app = express();
var http = require('http').Server(app);
var redis = require('redis');
var client = redis.createClient("redis://127.0.0.1:6379");

var io = require('socket.io')(http)

app.use('/', express.static('www'));

http.listen(8000, function(){
  console.log('listening on *:8000');
});

client.on('message', function(chan, msg) {
	console.log(chan);
	console.log(msg);
  io.sockets.emit(chan, msg);
});

client.subscribe('foo');
```

Then let's install our packages & run the nodejs server.

```bash
$ npm install
$ node index.js
```

##### Publish & Receive Messages

Let's Create Two Clients, one for web application frontend and another for application backend (for example it uses PHP).

**Frontend Client**

Frontend client is completely based on the NodeJs server to talk to the Redis server. and it uses socket.Io to communicate with `NodeJs` Server.

```html
<html>
  <head>
    <title>PubSub</title>
    <script src="https://cdn.socket.io/socket.io-1.4.5.js"></script>
    <script type="text/javascript">
      function fetch() {
        var sock = io("http://localhost:8000");
        sock.on('foo', function(msg) {
          console.log(msg);
        });
      }
    </script>
  </head>
  <body onload="fetch()">
  </body>
</html>
```

**Backend Client**

Backend client will interact directly with redis server, To build our PHP client we will need to install redis package with composer:

```bash
$ composer require predis/predis
```

Then start to use this package within our application like the following:

```php
include_once dirname(__FILE__) . "/vendor/autoload.php";

$redis = new Predis\Client([
    'scheme' => 'tcp',
    'host' => '127.0.0.1',
    'port' => 6379
]);

$redis->publish('foo', 'hello, world!');
```

##### Need More!

It is just the beginning :D, If you want to build your own realtime messaging solution, Please check the following Docs:

* [Redis Pub/Sub Docs.](https://redis.io/topics/pubsub)
* [Redis NodeJs Package.](https://www.npmjs.com/package/redis)
* [Socket.Io Docs.](https://socket.io/docs/)
* [PHP Pub/Sub Client](https://github.com/phpredis/phpredis#pubsub)

**[Please click here to check the complete code we written so far.](https://github.com/Clivern/Redis-PubSub)**