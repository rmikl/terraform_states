resource "aws_security_group" "traffic_to_infra" {
  name        = "traffic_to_infra"
  description = "Allow ssh inbound traffic"

  ingress {
    description      = "ssh from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    name = "allow_ssh"
  }
}

resource "aws_vpc" "internal_lab" {
    cidr_block = "10.0.0.0/24"
}

resource "aws_subnet" "internal_lab_subnet" {
  vpc_id     = aws_vpc.internal_lab.id
  cidr_block = "10.0.0.128/25"
  availability_zone = var.zone
}

resource "aws_network_interface" "for_speed_instance" {
    subnet_id       = aws_subnet.internal_lab_subnet.id
    security_groups = [ aws_security_group.traffic_to_infra.id ]
}

resource "aws_eip" "redundant_elastic"{
    network_interface = aws_network_interface.for_speed_instance.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.internal_lab.id
}