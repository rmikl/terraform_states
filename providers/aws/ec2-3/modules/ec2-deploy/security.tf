resource "aws_security_group" "traffic_to_jump_host" {
  name        = "traffic_to_jump_host"
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

resource "aws_security_group" "traffic_to_infra" {
  name        = "traffic_to_infra"
  description = "Allow ssh inbound traffic"

  ingress {
    description      = "ssh from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${aws_instance.jump_host.private_ip}/32"]
  }

  tags = {
    name = "allow_ssh"
  }
}

resource "aws_security_group" "traffic_outbound_full" {
  name        = "traffic_outbound_full"
  description = "allow all outboumd traffic"


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    name = "allow_outbound"
  }
}


resource "tls_private_key" "private_key_jump"{
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "local_machine_private_key" {
  content = tls_private_key.private_key_jump.private_key_pem
  filename = "generated_files/id_rsa_local_machine"
  file_permission = "0600"
}

resource "aws_key_pair" "pub_key_infra" {
  key_name   = "pub_key_infra"
  public_key = tls_private_key.private_key_jump.public_key_openssh
}

resource "aws_key_pair" "pub_key_jump" {
  key_name   = "pub_key_jump"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIxAN5kuLqNfJMqMtbbLKJqV2eJgPNi+ai4uQ1BHtrWQsm7y72FyqsWfUk7vKdd0nmC+0GNflVUlJzK2Hp5oYNIhxCme38joNOMAQAzFk22KJZgsVYbtJOERySLLl9LsZQC+dmVjjIMZs8SNmM0Brw0xXExzVRbyyFDLZk5J+g18y1DprzU/S6E4iLoH/S63Bf37oR+pqJz16X4DBG0WVTiCPYj9vT6lq0Ljt6rOzrF+03cvI7mzNmMappi8X49TrwVUuBTTWBgf9k/Sir1SquhQO3vB8k9jASiyeBl0ON+/N3RaJ7C7oTWCRpEhck80ODfPOvmoyONtnpDjegAfVDHCQNeEo/n4Z77zxu4r6JbZXs4/ZjE1Q1ieXpKTQy7ESSbsJUCB6uUVpECyGWoMa/s8QIh8DlRdwtEiyeAZY4ZuWQlnt0eSj7jdTKJTY9rMAvw7yyzxJfT3p34FJ/MUqrnFnojQs9VQbhQyVwvwrp9GCSsssWH9rtNxvtDI5YgiU="
}

resource "aws_iam_role" "iam_role_for_infra" {
  name = "iam_role_for_infra"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "iam_instance_profile_infra" {
  name = "iam_instance_profile_infra"
  role = "${aws_iam_role.iam_role_for_infra.name}"
}

resource "aws_iam_role_policy" "access_to_iam" {
  name = "access_to_ec2"
  role = "${aws_iam_role.iam_role_for_infra.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:GenerateCredentialReport",
                "iam:GenerateServiceLastAccessedDetails",
                "iam:Get*",
                "iam:List*",
                "iam:SimulateCustomPolicy",
                "iam:SimulatePrincipalPolicy"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


