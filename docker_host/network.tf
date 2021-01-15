######NETWORK DEFINITION BEGIN
resource "libvirt_network" "docker_network"{
  name = "dc_net"
  mode = "nat"
  domain = "docker.local"
  addresses = ["192.168.123.0/24"]
  dns{
    enabled = true
  }
}
######NETWORK DEFINITION END
