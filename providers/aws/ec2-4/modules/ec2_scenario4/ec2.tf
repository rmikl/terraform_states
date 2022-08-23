resource "aws_instance" "speed" { 
  ami = var.ec2_ami
  instance_type = var.aws_instance
  key_name = aws_key_pair.pub_key_jump.id
  vpc_security_group_ids = [ aws_security_group.traffic_to_infra.id ]
  tags = {
    module_used = "true"
    terraform_instance = "true"
    name = "speed"
  }

  availability_zone = var.zone

  network_interface { 
    network_interface_id = aws_network_interface.for_speed_instance.id
    device_index = 1 
  }
}

resource "aws_instance" "redundant" { 
  ami = var.ec2_ami
  instance_type = var.aws_instance
  key_name = aws_key_pair.pub_key_jump.id
  vpc_security_group_ids = [ aws_security_group.traffic_to_infra.id ]
  tags = {
    module_used = "true"
    terraform_instance = "true"
    name = "redundant"
  }
  availability_zone = var.zone
}