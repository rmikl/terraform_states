######ANSIBLE SLAVE DEFINITION BEGIN UBUNTU
resource "libvirt_pool" "ubuntu" {
  name = "ansble_slave_ubuntu"
  type = "dir"
  path = "/data/terraform/volume-pools/ansible-slave-ubuntu-pool"
}

resource "libvirt_volume" "ansible-slave-ubuntu-qcow2" {
  name   = "ansible-slave-ubuntu-qcow2"
  pool   = libvirt_pool.ubuntu.name
  source = "/data/kvm/iso/ubuntu-20.10-server-cloudimg-amd64-disk-kvm.img"
  format = "qcow2"
  #size = 10737418240
}

# Create the machine
resource "libvirt_domain" "domain-ansible-ubuntu-slave" {
  name   = "ansible-slave-ubuntu"
  memory = "512"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_id = libvirt_network.ansible_network.id
    hostname = "ansible-slave-ubuntu"
    addresses = ["192.168.123.3"]
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
    volume_id = libvirt_volume.ansible-slave-ubuntu-qcow2.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ansible-slave-ubuntu",
      "sudo apt update",
      "sudo apt install python3 python3-pip -y",
      "python3 --version",
    ]
    connection {
      type = "ssh"
      user = "robert"
      host = "192.168.123.3"
      port = 22
      agent = false
      timeout = "1m"
      private_key = file("/home/robert/.ssh/id_rsa")
    } 
  }
}

######ANSIBLE SLAVE DEFINITION END UBUNTU
