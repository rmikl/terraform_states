# instance the provider
provider "libvirt" {
  uri = "qemu:///system"
}

variable memory {
  type        = string
  default     = "4096"
}


variable ssh_timeout {
  type        = string
  default     = "5m"
}

variable ssh_user {
  type        = string
  default     = "root"
}

variable ssh_port {
  type        = number
  default     = 22
}

variable ssh_priv_key_location {
  type        = string
  default     = "/home/robert/.ssh/id_rsa"
}

variable ssh_type {
  type        = string
  default     = "ssh"
}

variable ssh_agent {
  type        = bool
  default     = false
}

variable ips {
  type        = map
  default     = {
    docker_host = "192.168.123.2"

  }
}

variable hostnames {
  type        = map
  default     = {
    docker_host = "docker-host"

  }
}


