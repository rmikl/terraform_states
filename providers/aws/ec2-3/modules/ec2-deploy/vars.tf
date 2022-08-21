variable "ec2_ami" {
  type        = string
  default     = "ami-0c956e207f9d113d5"
  description = "default ami is ami of Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type"
}

variable "aws_instance" {
    type = string
    default = "t2.micro"
}

variable "input_script_jump_host" {
  type        = string
  default     =  <<EOF
    #!/bin/bash
    mkdir -p ~/.ssh
    EOF
  description = "this variable is being used to specify input script that will be used during deployment of ec2"
}

variable "input_script_infra" {
  type        = string
  default     =  <<EOF
    #!/bin/bash
    mkdir -p ~/.ssh
    EOF
    description = "this variable is being used to specify input script that will be used during deployment of ec2"
}

variable "instance_name_infra" {
  type = string
  default = "infra"
}

variable "instance_name_jump" {
  type = string
  default = "jump"
}

