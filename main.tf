# instance the provider
provider "libvirt" {
  uri = "qemu:///system"
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
    ansible_master = "192.168.123.2"
    ansble_slave_ubuntu  = "192.168.123.3"
    ansble_slave_centos  = "192.168.123.4"
    ansble_slave_debian = "192.168.123.5"
    ansble_slave_rhel = "192.168.123.6"
  }
}

variable hostnames {
  type        = map
  default     = {
    ansible_master = "ansible-master"
    ansble_slave_ubuntu  = "ansble-slave-ubuntu"
    ansble_slave_centos  = "ansble-slave-centos"
    ansble_slave_debian = "ansble-slave-debian"
    ansble_slave_rhel = "ansble-slave-rhel"
  }
}


