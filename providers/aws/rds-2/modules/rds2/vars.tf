variable "db_username" {
    type = string
}

variable "db_password" {
    type = string
}

variable "vpc_id" { 
    type = string
    default = "vpc-0efe235925cc8fce0"
}

variable zone {
  type        = string
  default     = "eu-central-1a"
}

variable "ec2_ami" {
  type        = string
  default     = "ami-0c956e207f9d113d5"
  description = "default ami is ami of Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type"
}

variable "aws_instance" {
    type = string
    default = "t2.micro"
}

variable "rds_creds" {
  default = {
    username = var.db_username
    password = var.db_password
  }
  type = map(string)
}
