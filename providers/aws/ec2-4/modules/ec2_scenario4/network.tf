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

resource "aws_eip" "for_speed_instance" {
    instance = aws_instance.speed.id
}

resource "aws_key_pair" "pub_key_jump" {
  key_name   = "pub_key_jump"
  public_key = "<YOUR_PUB_KEY>"
}