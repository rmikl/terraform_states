######ANSIBLE MASTER DEFINITION BEGIN 
resource "libvirt_pool" "ansible_master" {
  name = "ansble_master"
  type = "dir"
  path = "/data/terraform/volume-pools/ansible-master-pool"
}


resource "libvirt_volume" "ansible-master-qcow2" {
  name   = "ansible-master-qcow2"
  pool   = libvirt_pool.ansible_master.name
  source = "/data/kvm/iso/ubuntu-20.10-server-cloudimg-amd64-disk-kvm.img"
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
  name   = var.hostnames["ansible_master"]
  memory = var.memory
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_id = libvirt_network.ansible_network.id
    hostname = var.hostnames["ansible_master"]
    addresses = [var.ips["ansible_master"]]
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
      type = var.ssh_type
      user = var.ssh_user
      host = var.ips["ansible_master"]
      port = var.ssh_port
      agent = var.ssh_agent
      timeout = var.ssh_timeout
      private_key = file(var.ssh_priv_key_location)
    } 
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ansible-master",
      "sudo apt update",
      "sudo apt install python3 python3-pip git ansible cifs-utils -y",
      "python3 --version",
      "ansible --version",
      "sudo chmod 600 /root/.ssh/id_rsa",
      "sudo echo -e 'Host 192.168.123.*\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile=/dev/null' | sudo tee /etc/ssh/ssh_config",
      "sudo mkdir -p /samba_share",
      "echo '//192.168.123.1/KVM /samba_share cifs guest,uid=1000,iocharset=utf8,vers=3.0 0 0' | sudo tee -a /etc/fstab",
      "sudo mount -a",
      "timedatectl set-ntp yes"
    ]
    connection {
      type = var.ssh_type
      user = var.ssh_user
      host = var.ips["ansible_master"]
      port = var.ssh_port
      agent = var.ssh_agent
      timeout = var.ssh_timeout
      private_key = file(var.ssh_priv_key_location)
    } 
  }

}
#####ANSIBLE MASTER DEFINITION END 
