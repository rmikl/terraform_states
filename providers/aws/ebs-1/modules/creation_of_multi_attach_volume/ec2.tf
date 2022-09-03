resource "aws_instance" "ec2_for_multiattach_1" { 
  ami = var.ec2_ami
  instance_type = var.aws_instance
  key_name = var.key_pair_id
  vpc_security_group_ids = [ var.sg_traffic_to_infra_id ]
  availability_zone = var.az
}

resource "aws_instance" "ec2_for_multiattach_2" { 
  ami = var.ec2_ami
  instance_type = var.aws_instance
  key_name = var.key_pair_id
  vpc_security_group_ids = [ var.sg_traffic_to_infra_id ]
  availability_zone = var.az
}



