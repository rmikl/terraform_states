# instance the provider
provider "libvirt" {
  uri = "qemu:///system"
}

######NETWORK DEFINITION BEGIN
resource "libvirt_network" "ansible_network"{
  name = "an_net"
  mode = "nat"
  domain = "ansible.local"
  addresses = ["192.168.123.0/24"]
  dns{
    enabled = true
  }
}
######NETWORK DEFINITION END

######ANSIBLE MASTER DEFINITION BEGIN 
resource "libvirt_pool" "ansible_master" {
  name = "ansble_master"
  type = "dir"
  path = "/data/terraform/volume-pools/ansible-master-pool"
}

resource "libvirt_volume" "ansible-master-qcow2" {
  name   = "ansible-master-qcow2"
  pool   = libvirt_pool.ansible_master.name
  source = "https://cloud-images.ubuntu.com/releases/groovy/release/ubuntu-20.10-server-cloudimg-amd64-disk-kvm.img"
  format = "qcow2"
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config.cfg")
}

# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_pool.ansible_master.name
}

# Create the machine
resource "libvirt_domain" "domain-ansible-master" {
  name   = "ansible-master"
  memory = "512"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_id = libvirt_network.ansible_network.id
    hostname = "ansible-master"
    addresses = ["192.168.123.2"]
    wait_for_lease = true
  }

  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # we need to pass it
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
    volume_id = libvirt_volume.ansible-master-qcow2.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  provisioner "file" {
    source      = "/home/robert/.ssh/id_rsa_ansible"
    destination = "/root/.ssh/id_rsa"
    
    connection {
      type = "ssh"
      user = "root"
      host = "192.168.123.2"
      port = 22
      agent = false
      timeout = "1m"
      private_key = file("/home/robert/.ssh/id_rsa")
    } 
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ansible_master",
      "sudo apt update",
      "sudo apt install python3 python3-pip -y",
      "sudo apt install ansible -y",
      "python3 --version",
      "ansible --version",
      "sudo chmod 600 /root/.ssh/id_rsa"  
    ]
    connection {
      type = "ssh"
      user = "robert"
      host = "192.168.123.2"
      port = 22
      agent = false
      timeout = "1m"
      private_key = file("/home/robert/.ssh/id_rsa")
    }
  }

}
######ANSIBLE MASTER DEFINITION END 

######ANSIBLE SLAVE DEFINITION BEGIN 
resource "libvirt_pool" "ubuntu" {
  name = "ansble_slave"
  type = "dir"
  path = "/data/terraform/volume-pools/ansible-slave-pool"
}

resource "libvirt_volume" "ansible-slave-qcow2" {
  name   = "ansible-slave-qcow2"
  pool   = libvirt_pool.ubuntu.name
  source = "https://cloud-images.ubuntu.com/releases/groovy/release/ubuntu-20.10-server-cloudimg-amd64-disk-kvm.img"
  format = "qcow2"
}

# Create the machine
resource "libvirt_domain" "domain-ansible-slave" {
  name   = "ansible-slave"
  memory = "512"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_id = libvirt_network.ansible_network.id
    hostname = "ansible-slave"
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
    volume_id = libvirt_volume.ansible-slave-qcow2.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ansible_slave",
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