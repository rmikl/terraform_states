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
