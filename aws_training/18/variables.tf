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


variable "ami" {
  type = string
  default = "ami-065deacbcaac64cf2"
}