// $ packer build -var 'username=$' -var 'password=$' .

packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "erlang" {
  image  = "erlang:25"
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
  name = "erlang-25"

  sources = [
    "source.docker.erlang",
  ]

  provisioner "shell" {
    environment_vars = []

    inline = [
      "echo $(date) > .build"
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "clivern/erlang"
      tags       = ["25", "prod"]
    }

    post-processor "docker-push" {
      login          = true
      login_username = var.username
      login_password = var.password
    }
  }
}
