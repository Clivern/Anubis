#!/bin/bash

function launch_locust () {
    mkdir load_testing
    cd load_testing
    python3 -m venv venv
    source venv/bin/activate
    pip install locust
    echo "from locust import HttpUser, task

class HelloWorldUser(HttpUser):
    @task
    def home(self):
        self.client.get(\"/\")" > locustfile.py

    locust
}
