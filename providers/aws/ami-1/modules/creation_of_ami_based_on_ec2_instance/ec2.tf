resource "aws_ami_from_instance" "ami_with_k8s" {
  name               = "ami_from_instance"
  source_instance_id = var.root_instance_id
}

resource "aws_instance" "target" { 
  ami = aws_ami_from_instance.ami_with_k8s.id
  instance_type = var.aws_instance
  key_name = var.key_pair
  tags = {
    module_used = "true"
    terraform_instance = "true"
  }
  availability_zone = var.zone
  vpc_security_group_ids = [ var.sc_for_target ]
}
