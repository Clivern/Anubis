// $ packer build -var 'username=$' -var 'password=$' .

packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "rust" {
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
  name = "rust.prod"

  sources = [
    "source.docker.rust",
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
      repository = "clivern/rust"
      tags       = ["prod"]
    }

    post-processor "docker-push" {
      login          = true
      login_username = var.username
      login_password = var.password
    }
  }
}
