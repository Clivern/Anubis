---
title: Kubernetes Services in a Nutshell
date: 2020-05-30 00:00:00
featured_image: https://images.unsplash.com/photo-1641999459215-3bb5378bedbe?q=5
excerpt: Service is a resource you create to make a single, constant point of entry to a group of pods providing the same service. Each service has an IP address and port that never change while the service exists. Clients can open connections to that IP and port, and those connections are then routed to one of the pods backing that service. This way, clients of a service don’t need to know the location of individual pods providing the service, allowing those pods to be moved around the cluster at any time.
---

![](https://images.unsplash.com/photo-1641999459215-3bb5378bedbe?q=5)

Service is a resource you create to make a single, constant point of entry to a group of pods providing the same service. Each service has an IP address and port that never change while the service exists. Clients can open connections to that IP and port, and those connections are then routed to one of the pods backing that service. This way, clients of a service don’t need to know the location of individual pods providing the service, allowing those pods to be moved around the cluster at any time.

Creating deployment and service

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: toad-deployment
spec:
  replicas: 4
  selector:
    matchLabels:
      app: toad
  template:
    metadata:
      labels:
        app: toad
      name: toad
    spec:
      containers:
        -
          image: "clivern/toad:release-0.2.4"
          name: toad-app

---
apiVersion: v1
kind: Service
metadata:
  name: toad-svc
  labels:
    app: toad
spec:
  ports:
    -
      port: 80
      targetPort: 8080
  selector:
    app: toad
```


```bash
$ kubectl create -f toad.yaml
```

You’re defining a `service` called `toad-svc`, which will accept connections on port `80` and route each connection to port `8080` of one of the pods matching the `app=toad` label selector.

You can list all service resources in your namespace and see that an internal cluster IP has been assigned to your service:

```bash
$ kubectl get svc
```

The `kubectl exec` command allows you to remotely run arbitrary commands inside an existing container of a pod.

```bash
$ kubectl get pods
$ kubectl exec ${podName} bash
```

If you want all requests made by a certain client to be redirected to the same pod every time, you can set the service’s `sessionAffinity` property to `ClientIP` (instead of `None`, which is the default).

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: toad-svc
  labels:
    app: toad
spec:
  ports:
    -
      port: 80
      targetPort: 8080
  selector:
    app: toad
  sessionAffinity: ClientIP
```

This makes the service proxy redirect all requests originating from the same client IP to the same pod.

Services can also support multiple ports

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: toad
spec:
  ports:
    -
      name: http
      port: 80
      targetPort: 8080 // Port 80 is mapped to the pods’ port 8080.
    -
      name: https
      port: 443
      targetPort: 8443 // Port 443 is mapped to the pods’ port 8443.
  selector:
    app: toad
```

To use named ports, you can specify port names in a pod definition

```yaml
---
kind: Pod
spec:
  containers:
    -
      name: toad
      ports:
        -
          containerPort: 8080
          name: http
        -
          containerPort: 8443
          name: https
```

You can then refer to those ports by name in the service spec

```yaml
---
apiVersion: v1
kind: Service
spec:
  ports:
    -
      name: http
      port: 80
      targetPort: http
    -
      name: https
      port: 443
      targetPort: https
```

The biggest benefit of doing so is that it enables you to change port numbers later without having to change the service spec.

Discovering services through environment variables

```bash
$ kubectl exec ${podName} env

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=toad-3inly
KUBERNETES_SERVICE_HOST=10.111.240.1 KUBERNETES_SERVICE_PORT=443
...
TOAD_SVC_SERVICE_HOST=10.111.249.153
TOAD_SVC_SERVICE_PORT=80
```

**NOTE:** Dashes in the service name are converted to underscores and all letters are uppercased when the service name is used as the prefix in the environment variable’s name

Discovering services through DNS by opening a connection to this FQDN `backend-database.default.svc.cluster.local`. `backend-database` corresponds to the service name, `default` stands for the namespace the service is defined in, and `svc.cluster.local` is a configurable cluster domain suffix used in all cluster local service names.

**NOTE:** The client must still know the service’s port number. If the service is using a standard port (for example, 80 for HTTP), that shouldn’t be a problem. If not, the client can get the port number from the environment variable.

**NOTE:** The service’s cluster IP is a virtual IP, and only has meaning when combined with the service port. So curling the service works, but pinging doesn’t

Services don’t link to pods directly. Instead, a resource sits in between (the Endpoints resource). You may have already noticed endpoints if you used the kubectl describe command on your service.

```bash
$ kubectl describe svc ${serviceName}
```

An Endpoints resource is a list of IP addresses and ports exposing a service. The Endpoints resource is like any other Kubernetes resource, so you can display its basic info with kubectl get:


```bash
$ kubectl get endpoints ${endpointName}
```

Although the pod selector is defined in the service spec, it’s not used directly when redirecting incoming connections. Instead, the selector is used to build a list of IPs and ports, which is then stored in the Endpoints resource. When a client connects to a service, the service proxy selects one of those IP and port pairs and redirects the incoming connection to the server listening at that location.

If you create a service without a pod selector, Kubernetes won’t even create the Endpoints resource (after all, without a selector, it can’t know which pods to include in the service). It’s up to you to create the Endpoints resource to specify the list of endpoints for the service.

This service has no selector defined.


```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: external-service
spec:
  ports:
    -
      port: 80
```

Because you created the service without a selector, the corresponding Endpoints resource hasn’t been created automatically, so it’s up to you to create it.

```yaml
---
apiVersion: v1
kind: Endpoints
metadata:
  name: external-service
subsets:
  -
    addresses:
      -
        ip: "11.11.11.11"
      -
        ip: "22.22.22.22"
    ports:
      -
        port: 80
```

The Endpoints object needs to have the same name as the service and contain the list of target IP addresses and ports for the service. After both the Service and the Endpoints resource are posted to the server, the service is ready to be used like any regular service with a pod selector. Containers created after the service is created will include the environment variables for the service, and all connections to its IP:port pair will be load balanced between the service’s endpoints.

To create a service that serves as an alias for an external service, you create a Service resource with the type field set to `ExternalName`. For example, let’s imagine there’s a public API available at `api.somecompany.com`.

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: external-service
spec:
  externalName: someapi.somecompany.com
  ports:
    -
      port: 80
  type: ExternalName
```

After the service is created, pods can connect to the external service through the `external-service.default.svc.cluster.local` domain name

You have a few ways to make a service accessible externally:

- Setting the service type to `NodePort` — For a `NodePort` service, each cluster node opens a port on the node itself (hence the name) and redirects traffic received on that port to the underlying service. The service isn’t accessible only at the internal cluster IP and port, but also through a dedicated port on all nodes.
- Setting the service type to `LoadBalancer`, an extension of the `NodePort` type—This makes the service accessible through a dedicated load balancer, provisioned from the cloud infrastructure Kubernetes is running on. The load balancer redirects traffic to the node port across all the nodes. Clients connect to the service through the load balancer IP.
- Creating an Ingress resource, a radically different mechanism for exposing multiple services through a single IP address—It operates at the HTTP level (network layer 7) and can thus offer more features than layer 4 services can.

Creating A `NodePort` Service:

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: toad-nodeport
spec:
  ports:
    -
      nodePort: 30123 // the service will be accessible through port 30123 of each of your cluster nodes.
      port: 80 // This is the port of the service’s internal cluster IP.
      targetPort: 8080 // This is the target port of the backing pods.
  selector:
    app: toad
  type: NodePort
```

```bash
$ kubectl get svc toad-nodeport

NAME             CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
toad-nodeport   10.111.254.223   <nodes>       80:30123/TCP   2m
```

The service is accessible at the following addresses:

- `10.11.254.223:80`
- `<1st node'sIP>:30123`
- `<2nd node'sIP>:30123`, and so on.

Creating A `LoadBalancer` Service:

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: toad-deployment
spec:
  replicas: 4
  selector:
    matchLabels:
      app: toad
  template:
    metadata:
      labels:
        app: toad
      name: toad
    spec:
      containers:
        -
          image: "clivern/toad:release-0.2.4"
          name: toad-app

---
apiVersion: v1
kind: Service
metadata:
  name: toad-svc
  labels:
    app: toad
spec:
  ports:
    -
      port: 80
      targetPort: 8080
  selector:
    app: toad
  type: LoadBalancer
```

After you create the service, it takes time for the cloud infrastructure to create the load balancer and write its IP address into the Service object. Once it does that, the IP address will be listed as the external IP address of your service:

```bash
$ kubectl get svc toad-svc

NAME                 CLUSTER-IP       EXTERNAL-IP      PORT(S)          AGE
toad-svc            10.111.241.153    130.211.53.173   80:32143/TCP      1m
```


In this case, the load balancer is available at IP `130.211.53.173`, so you can now access the service at that IP address:

```bash
$ curl http://130.211.53.173

You've hit toad-xueq1
```


Exposing services externally through an Ingress resource:

**Note:** Why Ingress are Needed? One important reason is that each LoadBalancer service requires its own load balancer with its own public IP address, whereas an Ingress only requires one, even when providing access to dozens of services. When a client sends an HTTP request to the Ingress, the host and path in the request determine which service the request is forwarded

Creating an Ingress resource

```yaml
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: toad
spec:
  rules:
    -
      host: toad.example.com
      http:
        paths:
          -
            backend:
              serviceName: toad-nodeport
              servicePort: 80
            path: /
```

This defines an Ingress with a single rule, which makes sure all HTTP requests received by the Ingress controller, in which the host `toad.example.com` is requested, will be sent to the `toad-nodeport` service on port 80.

To access your service through `http://toad.example.com`, you’ll need to make sure the domain name resolves to the IP of the Ingress controller.

To look up the IP, you need to list Ingresses:

```bash
$ kubectl get ingresses

NAME      HOSTS               ADDRESS          PORTS     AGE
toad     toad.example.com   192.168.99.100   80        29m
```

Exposing multiple services through the same Ingress

```yaml
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: toad
spec:
  rules:
    -
      host: toad.example.com
      http:
        paths:
          -
            backend:
              serviceName: toad  // Requests to toad.example.com/toad will be routed to the toad service.
              servicePort: 80
            path: /toad
          -
            backend:
              serviceName: bar // Requests to toad.example.com/bar will be routed to the bar service.
              servicePort: 80
            path: /foo
```

You can use an Ingress to map to different services based on the host in the HTTP request instead of (only) the path

```yaml
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: toad
spec:
  rules:
    -
      host: foo.example.com
      http:
        paths:
          -
            backend:
              serviceName: foo
              servicePort: 80
            path: /
    -
      host: bar.example.com
      http:
        paths:
          -
            backend:
              serviceName: bar
              servicePort: 80
            path: /
```

Requests received by the controller will be forwarded to either service foo or bar, depending on the Host header in the request.

**Pssst....!** If you want to create a kubernetes cluster for a project or for fun, Head over to digitalocean via this link [https://m.do.co/c/7f92efa0b9c1](https://m.do.co/c/7f92efa0b9c1) to get $100 free credits and support clivern.com tutorials and open source projects.

#### References:

- [How to Set Up an Nginx Ingress on DigitalOcean Kubernetes](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes)
- [Kubernetes Services](https://kubernetes.io/docs/concepts/services-networking/service/)
