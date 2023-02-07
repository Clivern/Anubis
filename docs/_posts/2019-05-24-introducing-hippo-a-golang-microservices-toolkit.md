---
title: Introducing Hippo A Golang Microservices Toolkit
date: 2019-05-24 00:00:00
featured_image: https://images.unsplash.com/photo-1516711923969-3fdc2fb85645?q=75&fm=jpg&w=1000&fit=max
excerpt: It all began when I started to build some web services in golang. and everytime I have to create the whole architecture from scratch than solving whatever problem I was trying to solve.
---

![](https://images.unsplash.com/photo-1516711923969-3fdc2fb85645?q=75&fm=jpg&w=1000&fit=max)

It all began when I started to build some web services in golang. and everytime I have to create the whole architecture from scratch than solving whatever problem I was trying to solve.

So why don't we use one of the available frameworks?

[Go](https://en.wikipedia.org/wiki/Go_(programming_language)) is different compared to many other programming languages. It is built for the modern web and it has a built-in standard libraries to accomplish most web programming tasks.

To make this argument clear, let's have a look at HTTP handler for vanilla [Golang](https://en.wikipedia.org/wiki/Go_(programming_language)), Python (Flask), PHP (Laravel) and Java (Spark)

```
func handler(w http.ResponseWriter, r *http.Request) {
     fmt.Fprint(w, "Hello world!")
}
```

```
import static spark.Spark.*;

public class HelloWorld {
    public static void main(String[] args) {
        get("/hello", (req, res) -> "Hello World");
    }
}
```

```
@app.route('/'):
def handler():
    return "Hello world!"
```

```
use Illuminate\Http\Request;

Route::get('/', function (Request $request) {
    //
});
```

Also comparing HTTP request on Golang vs PHP

```
// Get cURL resource
$curl = curl_init();
curl_setopt_array($curl, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_URL => 'http://clivern.com',
    CURLOPT_POST => 1,
    CURLOPT_POSTFIELDS => [
        item1 => 'value',
        item2 => 'value2'
    ]
]);
// Send the request & save response to $resp
$resp = curl_exec($curl);
// Close request to clear up some resources
curl_close($curl);
```

```
import (
    "http"
)

response, _, err := http.Get("http://clivern.com/")
```

It is understandable why frameworks are needed for some programming languages. In Golang, you can achieve a lot with standard libraries in a simple way compared to PHP, Python ...etc. Actually Most Go web frameworks go all the way to abstract the native standard libraries calls and limit your ability to customize stuff under the hood.

> _Everything should be made as simple as possible, but not simpler._
>
>  _Albert Einstein_

So use frameworks but wisely. don't select a fully fledged framework and what you need is a simple package or even spending some time to check a standard package API.

that's why I started to [build Hippo](https://github.com/Clivern/Hippo), It provides libraries to implement components for service discovery, async jobs, authentication, authorization, logging, caching, metrics, tracing, rate-limiting…etc
Trying to use a few dependencies and make use of the standard libraries as much as possible to reduce the footprint. Also I am trying to expose everything under the hood so you can interact directly with the standard libraries and customize it.

Example Usage of Hippo

```
import (
    "github.com/clivern/hippo"
)
```

HTTP Requests Component

```
httpClient := hippo.NewHTTPClient()

// Get Request
response, err := httpClient.Get(
    "https://httpbin.org/get",
    map[string]string{"url_arg_key": "url_arg_value"},
    map[string]string{"header_key": "header_value"},
)

// Delete Request
response, err := httpClient.Delete(
    "https://httpbin.org/delete",
    map[string]string{"url_arg_key": "url_arg_value"},
    map[string]string{"header_key": "header_value"},
)

// Post Request
response, err := httpClient.Post(
    "https://httpbin.org/post",
    `{"RequestBodyKey":"RequestBodyValue"}`,
    map[string]string{"url_arg_key": "url_arg_value"},
    map[string]string{"header_key": "header_value"},
)

// Put Request
response, err := httpClient.Put(
    "https://httpbin.org/put",
    `{"RequestBodyKey":"RequestBodyValue"}`,
    map[string]string{"url_arg_key": "url_arg_value"},
    map[string]string{"header_key": "header_value"},
)

// ....

statusCode := httpClient.GetStatusCode(response)
responseBody, err := httpClient.ToString(response)
```

Cache/Redis Component

```
driver := hippo.NewRedisDriver("localhost:6379", "password", 0)

// connect to redis server
ok, err := driver.Connect()
// ping check
ok, err = driver.Ping()

// set an item
ok, err = driver.Set("app_name", "Hippo", 0)
// check if exists
ok, err = driver.Exists("app_name")
// get value
value, err := driver.Get("app_name")
// delete an item
count, err := driver.Del("app_name")

// hash set
ok, err = driver.HSet("configs", "app_name", "Hippo")
// check if item on a hash
ok, err = driver.HExists("configs", "app_name")
// get item from a hash
value, err = driver.HGet("configs", "app_name")
// hash length
count, err = driver.HLen("configs")
// delete item from a hash
count, err = driver.HDel("configs", "app_name")
// clear the hash
count, err = driver.HTruncate("configs")

// Pub/Sub
driver.Publish("hippo", "Hello")
driver.Subscribe("hippo", func(message Message) error {
    // message.Channel
    // message.Payload
    return nil
})
```

Time Series/Graphite Component

```
import "time"


metric := hippo.NewMetric("hippo1.up", "23", time.Now().Unix()) // Type is hippo.Metric

metrics := NewMetrics("hippo2.up", "35", time.Now().Unix()) // type is []hippo.Metric
metrics = append(metrics, NewMetric("hippo2.down", "40", time.Now().Unix()))
metrics = append(metrics, NewMetric("hippo2.error", "70", time.Now().Unix()))

// NewGraphite(protocol string, host string, port int, prefix string)
// protocol can be tcp, udp or nop
// prefix is a metric prefix
graphite := hippo.NewGraphite("tcp", "127.0.0.1", 2003, "")
error := graphite.Connect()

if error == nil{
    // send one by one
    graphite.SendMetric(metric)

    // bulk send
    graphite.SendMetrics(metrics)
}
```

System Stats Component

```
correlation := hippo.NewCorrelation()
correlation.UUIDv4()
```

Workers Pool Component

```
import "fmt"

tasks := []*hippo.Task{
    hippo.NewTask(func() (string, error) {
        fmt.Println("Task #1")
        return "Result 1", nil
    }),
    hippo.NewTask(func() (string, error) {
        fmt.Println("Task #2")
        return "Result 2", nil
    }),
    hippo.NewTask(func() (string, error) {
        fmt.Println("Task #3")
        return "Result 3", nil
    }),
}

// hippo.NewWorkersPool(tasks []*Task, concurrency int) *WorkersPool
p := hippo.NewWorkersPool(tasks, 2)
p.Run()

var numErrors int
for _, task := range p.Tasks {
    if task.Err != nil {
        fmt.Println(task.Err)
        numErrors++
    } else {
        fmt.Println(task.Result)
    }
    if numErrors >= 10 {
        fmt.Println("Too many errors.")
        break
    }
}
```

Health Checker Component

````
import "fmt"

healthChecker := hippo.NewHealthChecker()
healthChecker.AddCheck("ping_check", func() (bool, error){
    return true, nil
})
healthChecker.AddCheck("db_check", func() (bool, error){
    return false, fmt.Errorf("Database Down")
})
healthChecker.RunChecks()

fmt.Println(healthChecker.ChecksStatus())
// Output -> DOWN
fmt.Println(healthChecker.ChecksReport())
// Output -> [{"id":"ping_check","status":"UP","error":"","result":true},{"id":"db_check","status":"DOWN","error":"Database Down","result":false}] <nil>
```
```golang
import "fmt"

healthChecker := hippo.NewHealthChecker()

healthChecker.AddCheck("url_check", func() (bool, error){
    return hippo.HTTPCheck("httpbin_service", "https://httpbin.org/status/503", map[string]string{}, map[string]string{})
})
healthChecker.AddCheck("redis_check", func() (bool, error){
    return hippo.RedisCheck("redis_service", "localhost:6379", "", 0)
})
healthChecker.RunChecks()

fmt.Println(healthChecker.ChecksStatus())
// Outputs -> DOWN
fmt.Println(healthChecker.ChecksReport())
````

API Rate Limiting

```
import "time"

// Create a limiter with a specific identifier(IP address or access token or username....etc)
// NewCallerLimiter(identifier string, eventsRate rate.Limit, tokenBurst int) *rate.Limiter
limiter := hippo.NewCallerLimiter("10.10.10.10", 100, 1)
if limiter.Allow() == false {
    // Don't allow access
} else {
    // Allow Access
}


// auto clean old clients (should run as background process)
// CleanupCallers(cleanAfter time.Duration)
go func(){
    for {
        time.Sleep(60 * time.Second)
        hippo.CleanupCallers(60)
    }
}()
```

Logger Component

```
logger, _ := hippo.NewLogger("debug", "json", []string{"stdout", "/var/log/error.log"})

logger.Info("Hello World!")
logger.Debug("Hello World!")
logger.Warn("Hello World!")
logger.Error("Hello World!")

defer logger.Sync()
```

If you would like to help, [check the package on github!](https://github.com/Clivern/Hippo)

**Good Reads:**

* [Go at Google: Language Design in the Service of Software Engineering](https://talks.golang.org/2012/splash.article)
* [The Go type system for newcomers](https://rakyll.org/typesystem/)
