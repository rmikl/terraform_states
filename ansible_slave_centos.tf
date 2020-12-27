#####ANSIBLE SLAVE DEFINITION BEGIN CENTOS
resource "libvirt_pool" "centos" {
  name = "ansble_slave_centos"
  type = "dir"
  path = "/data/terraform/volume-pools/ansible-slave-centos-pool"
}

resource "libvirt_volume" "ansible-slave-centos-qcow2" {
  name   = "ansible-slave-centos-qcow2"
  pool   = libvirt_pool.centos.name
  source = "/data/kvm/iso/CentOS-8-ec2-8.3.2011-20201204.2.x86_64.qcow2"
  format = "qcow2"
}

# Create the machine
resource "libvirt_domain" "domain-ansible-centos-slave" {
  name   = var.hostnames["ansble_slave_centos"]
  memory = "512"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_id = libvirt_network.ansible_network.id
    hostname = var.hostnames["ansble_slave_centos"]
    addresses = [var.ips["ansble_slave_centos"]]
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
    volume_id = libvirt_volume.ansible-slave-centos-qcow2.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ansible-slave-centos",
      "sudo dnf update -y",
      "sudo dnf install python3 python3-pip -y",
      "python3 --version",
    ]
    connection {
      type = var.ssh_type
      user = var.ssh_user
      host = var.ips["ansble_slave_centos"]
      port = var.ssh_port
      agent = var.ssh_agent
      timeout = var.ssh_timeout
      private_key = file(var.ssh_priv_key_location)
    } 
  }
}
