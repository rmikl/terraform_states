resource "aws_instance" "speed" { 
  ami = var.ec2_ami
  instance_type = var.aws_instance
  key_name = aws_key_pair.pub_key_jump.id
  tags = {
    module_used = "true"
    terraform_instance = "true"
    name = "speed"
  }
  availability_zone = var.zone
  placement_group = aws_placement_group.speed.id
  vpc_security_group_ids = [ aws_security_group.traffic_to_infra.id ]
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
  placement_group = aws_placement_group.redundant.id
  availability_zone = var.zone
}