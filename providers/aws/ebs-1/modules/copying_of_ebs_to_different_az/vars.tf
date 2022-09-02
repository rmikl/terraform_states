variable dest_az {
  type        = string
  default     = "eu-central-1b"
  description = "storage region"
}

variable "aws_instance" {
    type = string
    default = "t2.micro"
}

variable "ec2_ami" {
  type        = string
  default     = "ami-0c956e207f9d113d5"
  description = "default ami is ami of Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type"
}

variable "sg_traffic_to_infra_id"{
  type = string
}

variable "source_ebs_volume_id" { 
  type = string
}

variable "key_pair_id" {
  type = string
}

variable source_instance_id {
  type        = string
}
