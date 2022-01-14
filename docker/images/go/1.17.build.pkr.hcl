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
  image  = "golang:1.17"
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
  name = "golang.1.17.build"

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
      tags       = ["1.17.build"]
    }

    post-processor "docker-push" {
      login          = true
      login_username = var.username
      login_password = var.password
    }
  }
}