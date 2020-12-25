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

## Create the machine
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
      "sudo hostnamectl set-hostname ansible-master",
      "sudo apt update",
      "sudo apt install python3 python3-pip git ansible -y",
      "python3 --version",
      "ansible --version",
      "sudo chmod 600 /root/.ssh/id_rsa",
      "sudo echo -e 'Host 192.168.123.*\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile=/dev/null' | sudo tee /etc/ssh/ssh_config", 
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
#####ANSIBLE MASTER DEFINITION END 

######ANSIBLE SLAVE DEFINITION BEGIN UBUNTU
resource "libvirt_pool" "ubuntu" {
  name = "ansble_slave_ubuntu"
  type = "dir"
  path = "/data/terraform/volume-pools/ansible-slave-ubuntu-pool"
}

resource "libvirt_volume" "ansible-slave-ubuntu-qcow2" {
  name   = "ansible-slave-ubuntu-qcow2"
  pool   = libvirt_pool.ubuntu.name
  source = "https://cloud-images.ubuntu.com/releases/groovy/release/ubuntu-20.10-server-cloudimg-amd64-disk-kvm.img"
  format = "qcow2"
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


#####ANSIBLE SLAVE DEFINITION BEGIN CENTOS
resource "libvirt_pool" "centos" {
  name = "ansble_slave_centos"
  type = "dir"
  path = "/data/terraform/volume-pools/ansible-slave-centos-pool"
}

resource "libvirt_volume" "ansible-slave-centos-qcow2" {
  name   = "ansible-slave-centos-qcow2"
  pool   = libvirt_pool.centos.name
  source = "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-ec2-8.3.2011-20201204.2.x86_64.qcow2"
  format = "qcow2"
}

# Create the machine
resource "libvirt_domain" "domain-ansible-centos-slave" {
  name   = "ansible-slave-centos"
  memory = "512"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_id = libvirt_network.ansible_network.id
    hostname = "ansible-slave-centos"
    addresses = ["192.168.123.4"]
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
      type = "ssh"
      user = "robert"
      host = "192.168.123.4"
      port = 22
      agent = false
      timeout = "1m"
      private_key = file("/home/robert/.ssh/id_rsa")
    } 
  }
}

######ANSIBLE SLAVE DEFINITION BEGIN DEBIAN
resource "libvirt_pool" "debian" {
  name = "ansble_slave_debian"
  type = "dir"
  path = "/data/terraform/volume-pools/ansible-slave-debian-pool"
}

resource "libvirt_volume" "ansible-slave-debian-qcow2" {
  name   = "ansible-slave-debian-qcow2"
  pool   = libvirt_pool.debian.name
  source = "https://cloud.debian.org/images/cloud/OpenStack/current/debian-10-openstack-amd64.qcow2"
  format = "qcow2"
}

# Create the machine
resource "libvirt_domain" "domain-ansible-debian-slave" {
  name   = "ansible-slave-debian"
  memory = "512"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_id = libvirt_network.ansible_network.id
    hostname = "ansible-slave-debian"
    addresses = ["192.168.123.5"]
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
      type = "ssh"
      user = "robert"
      host = "192.168.123.5"
      port = 22
      agent = false
      timeout = "1m"
      private_key = file("/home/robert/.ssh/id_rsa")
    } 
  }
}

########ANSIBLE SLAVE DEFINITION END DEBIAN

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
  name   = "ansible-slave-rhel"
  memory = "512"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_id = libvirt_network.ansible_network.id
    hostname = "ansible-slave-rhel"
    addresses = ["192.168.123.6"]
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
      type = "ssh"
      user = "root"
      host = "192.168.123.6"
      port = 22
      agent = false
      timeout = "1m"
      private_key = file("/home/robert/.ssh/id_rsa")
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
      type = "ssh"
      user = "robert"
      host = "192.168.123.6"
      port = 22
      agent = false
      timeout = "1m"
      private_key = file("/home/robert/.ssh/id_rsa")
    } 
  }
}