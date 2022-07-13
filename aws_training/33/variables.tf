variable "key_name" {
  type = string
  default = "ssk_key"
}

variable "aws_region" { 
  type = string
  default = "eu-central-1"
}

variable "aws_instance" {
    type = string
    default = "t2.micro"
}

data "aws_ami" "latest_ubuntu" {
  most_recent      = true
  owners           = ["099720109477"]

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}

variable "env_types" {
  type = list(string)
  default = ["prod","qa","test"]
}

variable "instance_name" {
  type = string
  default = "ubuntu"
}