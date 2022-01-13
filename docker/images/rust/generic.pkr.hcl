// $ packer build -var 'username=$' -var 'password=$' .

packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "jammy" {
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
  name = "rust-generic"

  sources = [
    "source.docker.jammy",
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
      tags       = ["generic", "prod-generic", "prod"]
    }

    post-processor "docker-push" {
      login          = true
      login_username = var.username
      login_password = var.password
    }
  }
}
