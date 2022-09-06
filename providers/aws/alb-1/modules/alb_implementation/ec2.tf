resource "aws_instance" "root1" { 
  ami = var.ec2_ami
  instance_type = var.aws_instance
  tags = {
    module_used = "true"
    terraform_instance = "true"
  }
  user_data = file("modules/alb_implementation/scripts/install_script_t1.sh")
  availability_zone = var.zone1
  vpc_security_group_ids = [  aws_security_group.traffic_to_ec2.id ]
}

resource "aws_instance" "root2" { 
  ami = var.ec2_ami
  instance_type = var.aws_instance
  tags = {
    module_used = "true"
    terraform_instance = "true"
  }
  user_data = file("modules/alb_implementation/scripts/install_script_t2.sh")
  availability_zone = var.zone1
  vpc_security_group_ids = [ aws_security_group.traffic_to_ec2.id ]
}
