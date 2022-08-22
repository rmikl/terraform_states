resource "aws_vpc" "vpc_speed" {
}

resource "aws_subnet" "subnet_speed" {
  vpc_id     = aws_vpc.vpc_speed.id
}

resource "aws_network_interface" "eni_speed_instance" {
  subnet_id   = aws_subnet.subnet_speed.id
}

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.eni_speed_instance.id
}


