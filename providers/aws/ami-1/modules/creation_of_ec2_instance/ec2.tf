resource "aws_instance" "root" { 
  ami = var.ec2_ami
  instance_type = var.aws_instance
  key_name = aws_key_pair.pub_key_jump.id
  tags = {
    module_used = "true"
    terraform_instance = "true"
  }
  user_data = file("modules/creation_of_ec2_instance/scripts/install_script.sh")
  availability_zone = var.zone
  vpc_security_group_ids = [ aws_security_group.traffic_to_infra.id, aws_security_group.allow_tls.id ]
}

output instance_id {
  value = aws_instance.root.id
}
