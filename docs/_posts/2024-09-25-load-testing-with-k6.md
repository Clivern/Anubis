---
title: Load testing with k6
date: 2024-09-25 00:00:00
featured_image: https://images.unsplash.com/photo-1581255078657-13b74a0690c6
excerpt: A while ago, I came across this a nice load testing tool called k6. It's an open-source project developed by Grafana Labs that lets developers easily test the performance of their APIs, websites, and microservices.
---

![](https://images.unsplash.com/photo-1581255078657-13b74a0690c6)

A while ago, I came across this a nice load testing tool called [k6](https://k6.io/). It's an open-source project developed by Grafana Labs that lets developers easily test the performance of their `APIs`, websites, and microservices.

[k6](https://k6.io/) is a developer-friendly tool. You write your test scripts in JavaScript, which makes it super accessible if you're already familiar with web development. Plus, it's designed to be lightweight and efficient, so you can simulate a ton of virtual users without needing a massive infrastructure.

In this tutorial, I'm going to walk you through creating a sample load testing script with [k6](https://k6.io/). We'll set up a basic test that simulates multiple users hitting an `API` endpoint. The script will:

- Simulates 100 virtual users (`VUs`) accessing the `API` endpoint simultaneously.
- The load is applied for 30 seconds

The final test will checks for:

1. HTTP response status (expecting 200 OK)
2. Response time, categorized into three levels:
    - Ideal: < 200ms
    - Acceptable: < 500ms
    - Fine (but could be optimized): < 1000ms

```js
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
    vus: 100, // Number of virtual users
    duration: '30s', // Duration of the test
};

export default function () {
    const url = `${__ENV.API_URL}/`;
    const payload = JSON.stringify({key: 'value'});

    const params = {
        headers: {
            'Content-Type': 'application/json',
        },
    };

    // Make the POST request
    const response = http.post(url, payload, params);

    // Check the response status
    check(response, {
        'is status 200': (r) => r.status === 200,
        // Ideal response time.
        'response time < 200ms ~ (Ideal)': (r) => r.timings.duration < 200,
        // Acceptable response time.
        'response time < 500ms ~ (Acceptable)': (r) => r.timings.duration < 500,
        // fine response time but optimization is recommended.
        'response time < 1000ms ~ (Fine)': (r) => r.timings.duration < 1000,
    });

    sleep(1); // Sleep for 1 second between requests
}
```

To run the test, you need to define the `API_URL` and use `k6` to run the test script.

```bash
$ export API_URL=http://localhost:8000
$ k6 run stress_test.js
```

