// $ packer build -var 'username=$' -var 'password=$' .

packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "elixir" {
  image  = "elixir:1.13"
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
  name = "elixir-1.13"

  sources = [
    "source.docker.elixir",
  ]

  provisioner "shell" {
    environment_vars = []

    inline = [
      "echo $(date) > .build"
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "clivern/elixir"
      tags       = ["1.13", "prod"]
    }

    post-processor "docker-push" {
      login          = true
      login_username = var.username
      login_password = var.password
    }
  }
}
