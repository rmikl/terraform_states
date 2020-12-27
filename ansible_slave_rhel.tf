######ANSIBLE SLAVE DEFINITION BEGIN RHEL
resource "libvirt_pool" "rhel" {
  name = "ansble_slave_rhel"
  type = "dir"
  path = "/data/terraform/volume-pools/ansible-slave-rhel-pool"
}

resource "libvirt_volume" "ansible-slave-rhel-qcow2" {
  name   = "ansible-slave-rhel-qcow2"
  pool   = libvirt_pool.rhel.name
  source = "/data/kvm/iso/rhel-8.3-x86_64-kvm.qcow2"
  format = "qcow2"
}

# Create the machine
resource "libvirt_domain" "domain-ansible-rhel-slave" {
  name   = var.hostnames["ansble_slave_rhel"]
  memory = "512"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_id = libvirt_network.ansible_network.id
    hostname = var.hostnames["ansble_slave_rhel"]
    addresses = [var.ips["ansble_slave_rhel"]]
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
    volume_id = libvirt_volume.ansible-slave-rhel-qcow2.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

#send file with credentials for rhel
#file format:
# USERNAME PASSWORD
  provisioner "file" {
    source      = "/home/robert/userdata"
    destination = "/root/userdata"
    
    connection {
      type = var.ssh_type
      user = var.ssh_user
      host = var.ips["ansble_slave_rhel"]
      port = var.ssh_port
      agent = var.ssh_agent
      timeout = var.ssh_timeout
      private_key = file(var.ssh_priv_key_location)
    } 
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ansible-slave-rhel",
      "sudo subscription-manager register --username `sudo awk '{print $1}' /root/userdata` --password `sudo awk '{print $2}' /root/userdata` --auto-attach",
      "rm -f /root/userdata",
      "sudo dnf update -y",
      "sudo dnf install python3 python3-pip -y",
      "python3 --version",
    ]
    connection {
      type = var.ssh_type
      user = var.ssh_user
      host = var.ips["ansble_slave_rhel"]
      port = var.ssh_port
      agent = var.ssh_agent
      timeout = var.ssh_timeout
      private_key = file(var.ssh_priv_key_location)
    }  
  }
}