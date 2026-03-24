terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_image" "ubuntu_ssh" {
  name = "linuxserver/openssh-server:latest" 
  keep_locally = true
}

# Criando o nosso "Servidor Remoto"
resource "docker_container" "remote_server" {
  name  = "my_remote_server"
  image = docker_image.ubuntu_ssh.image_id
  privileged = true

  env = [
    "PUID=1000",
    "PGID=1000",
    "TZ=Europe/Lisbon",
    "PASSWORD_ACCESS=true",
    "USER_PASSWORD=root",
    "SUDO_ACCESS=true",     # Isso resolve o erro do "sudoers" anterior
    "USER_NAME=linuxserver.io"
  ]

  ports {
    internal = 2222   # Note: This image uses 2222 internally by default
    external = 2222
  }

  # Porta para o seu App (API)
  ports {
    internal = 3000
    external = 3000
  }

  # Porta para o Mongo Express
  ports {
    internal = 8081
    external = 8081
  }
}

output "server_ip" {
  value = "localhost"
}