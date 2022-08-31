resource "aws_instance" "base" { 
  ami = var.ec2_ami
  instance_type = var.aws_instance
  key_name = aws_key_pair.pub_key_jump.id
  user_data = file("scripts/install_k8s_toolset.sh")

  tags = {
    module_used = "true"
    terraform_instance = "true"
    name = "base"
  }
  availability_zone = var.source_az
  vpc_security_group_ids = [ aws_security_group.traffic_to_infra.id ]
}