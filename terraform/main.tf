terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {}
variable "ssh_fingerprint" {}
variable "github_token" {}
variable "github_user" {}
variable "github_repo" {}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_droplet" "buddy-droplet" {
  image    = "ubuntu-22-10-x64"
  name     = "buddy-droplet"
  region   = "nyc3"
  size     = "s-1vcpu-1gb"
  ssh_keys = [var.ssh_fingerprint]

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file("~/.ssh/id_rsa")
    timeout     = "2m"
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common git
    
    # Install Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    
    # Clone repository
    git clone https://github.com/${var.github_user}/${var.github_repo}.git
    cd ${var.github_repo}
    
    # Build Docker image
    docker build -t my-docker-image .
    
    # Run Docker container
    docker run -p 8000:8000 my-docker-image
    EOF
}
