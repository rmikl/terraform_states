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

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"

  egress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_key_pair" "pub_key_jump" {
  key_name   = "pub_key_jump"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIxAN5kuLqNfJMqMtbbLKJqV2eJgPNi+ai4uQ1BHtrWQsm7y72FyqsWfUk7vKdd0nmC+0GNflVUlJzK2Hp5oYNIhxCme38joNOMAQAzFk22KJZgsVYbtJOERySLLl9LsZQC+dmVjjIMZs8SNmM0Brw0xXExzVRbyyFDLZk5J+g18y1DprzU/S6E4iLoH/S63Bf37oR+pqJz16X4DBG0WVTiCPYj9vT6lq0Ljt6rOzrF+03cvI7mzNmMappi8X49TrwVUuBTTWBgf9k/Sir1SquhQO3vB8k9jASiyeBl0ON+/N3RaJ7C7oTWCRpEhck80ODfPOvmoyONtnpDjegAfVDHCQNeEo/n4Z77zxu4r6JbZXs4/ZjE1Q1ieXpKTQy7ESSbsJUCB6uUVpECyGWoMa/s8QIh8DlRdwtEiyeAZY4ZuWQlnt0eSj7jdTKJTY9rMAvw7yyzxJfT3p34FJ/MUqrnFnojQs9VQbhQyVwvwrp9GCSsssWH9rtNxvtDI5YgiU="
}