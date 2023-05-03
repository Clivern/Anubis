---
title: Working with Nginx Ingress Controller
date: 2021-08-02 00:00:00
featured_image: https://images.unsplash.com/photo-1607505158943-d53d69b8e780
excerpt: A Kubernetes Ingress is a robust way to expose your services outside the cluster. It lets you consolidate your routing rules to a single resource, and gives you powerful options for configuring these rules.
---

![](https://images.unsplash.com/photo-1607505158943-d53d69b8e780)

A Kubernetes Ingress is a robust way to expose your services outside the cluster. It lets you consolidate your routing rules to a single resource, and gives you powerful options for configuring these rules.

- To Install `nginx` ingress do the following. for a list of supported versions list, [please check this table](https://github.com/kubernetes/ingress-nginx#support-versions-table)

```bash
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.0/deploy/static/provider/cloud/deploy.yaml

$ kubectl get pods -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx --watch

$ kubectl get pods -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx

$ kubectl get svc --namespace=ingress-nginx
```

- Then Run a sample application

```yaml
# mammal_with_nginx_ingress.yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mammal-deployment
spec:
  replicas: 4
  selector:
    matchLabels:
      app: mammal
  template:
    metadata:
      labels:
        app: mammal
      name: mammal
    spec:
      containers:
        -
          image: "clivern/mammal:v1.3.0"
          name: mammal-app
          env:
          - name: MAMMAL_APP_MODE
            value: prod
          ports:
          - containerPort: 8000
          readinessProbe:
            httpGet:
              path: /_ready
              port: 8000
            initialDelaySeconds: 5
            periodSeconds: 10
          livenessProbe:
            httpGet:
              path: /_health
              port: 8000
            initialDelaySeconds: 10
            periodSeconds: 5


---
apiVersion: v1
kind: Service
metadata:
  name: mammal-svc
  labels:
    app: mammal
spec:
  ports:
    -
      port: 80
      targetPort: 8000
  selector:
    app: mammal
  type: LoadBalancer


---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    # test.com/mammal rewrites to test.com/
    # test.com/mammal/ rewrites to test.com/
    # test.com/mammal/_heath rewrites to test.com/_heath
    nginx.ingress.kubernetes.io/rewrite-target: /$2
    nginx.ingress.kubernetes.io/use-regex: "true"
  name: mammal-ing1
spec:
  ingressClassName: nginx
  rules:
  - host: test.com
    http:
      paths:
      - path: /mammal(/|$)(.*)
        pathType: Prefix
        backend:
          service:
            name: mammal-svc
            port:
              number: 80
```

```bash
$ kubectl apply -f mammal_with_nginx_ingress.yaml
```

- Get the Nginx Ingress external IP address `X.X.X.X` and update the hosts file to send `test.com` to that IP.

```bash
$ kubectl get svc --namespace=ingress-nginx

NAME                                 TYPE           CLUSTER-IP       EXTERNAL-IP       PORT(S)                      AGE
ingress-nginx-controller             LoadBalancer   Y.Y.Y.Y          X.X.X.X           80:31783/TCP,443:32756/TCP   16m
ingress-nginx-controller-admission   ClusterIP      U.U.U.U          &lt;none>            443/TCP                      16m
```

- Call the sample application mammal

```bash
$ curl test.com/mammal/_health -v

*   Trying X.X.X.X:80...
* Connected to test.com (X.X.X.X) port 80 (#0)
> GET /mammal/_health HTTP/1.1
> Host: test.com
> User-Agent: curl/7.79.1
> Accept: */*
>
* Mark bundle as not supporting multiuse
&lt; HTTP/1.1 200 OK
&lt; Date: Mon, 01 Aug 2022 23:30:22 GMT
&lt; Content-Type: application/json; charset=UTF-8
&lt; Content-Length: 21
&lt; Connection: keep-alive
&lt; X-Request-Id: eaf6f788f04656e41dd052f3521e824b
&lt;

{"status":"i am ok"}
```