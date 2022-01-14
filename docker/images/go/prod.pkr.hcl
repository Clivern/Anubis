// $ packer build -var 'username=$' -var 'password=$' .

packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "golang" {
  image  = "ubuntu:22.04"
  commit = true
}

variable "username" {
  type    = string
  default = ""
}

variable "password" {
  type    = string
  default = ""
}

build {
  name = "golang.prod"

  sources = [
    "source.docker.golang",
  ]

  provisioner "shell" {
    environment_vars = []

    inline = [
      "apt-get update",
      "apt-get upgrade -y",
      "echo $(date) > .build"
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "clivern/golang"
      tags       = ["prod"]
    }

    post-processor "docker-push" {
      login          = true
      login_username = var.username
      login_password = var.password
    }
  }
}