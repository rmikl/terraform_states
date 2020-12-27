######ANSIBLE SLAVE DEFINITION BEGIN DEBIAN
resource "libvirt_pool" "debian" {
  name = "ansble_slave_debian"
  type = "dir"
  path = "/data/terraform/volume-pools/ansible-slave-debian-pool"
}

resource "libvirt_volume" "ansible-slave-debian-qcow2" {
  name   = "ansible-slave-debian-qcow2"
  pool   = libvirt_pool.debian.name
  source = "/data/kvm/iso/debian-10-openstack-amd64.qcow2"
  format = "qcow2"
}

# Create the machine
resource "libvirt_domain" "domain-ansible-debian-slave" {
  name   = var.hostnames["ansble_slave_debian"]
  memory = "512"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_id = libvirt_network.ansible_network.id
    hostname = var.hostnames["ansble_slave_debian"]
    addresses = [var.ips["ansble_slave_debian"]]
    wait_for_lease = true
  }

  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.ansible-slave-debian-qcow2.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ansible-slave-debian",
      "sudo apt update",
      "sudo apt install python3 python3-pip -y",
      "python3 --version",
    ]
    connection {
      type = var.ssh_type
      user = var.ssh_user
      host = var.ips["ansble_slave_debian"]
      port = var.ssh_port
      agent = var.ssh_agent
      timeout = var.ssh_timeout
      private_key = file(var.ssh_priv_key_location)
    } 
  }
}

########ANSIBLE SLAVE DEFINITION END DEBIAN
