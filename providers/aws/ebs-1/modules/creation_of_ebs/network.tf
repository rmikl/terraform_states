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