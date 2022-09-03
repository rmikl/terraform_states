variable "root_instance_id" {
    type = string
}

variable zone {
  type        = string
  default     = "eu-central-1a"
  description = "storage region"
}

variable "aws_instance" {
    type = string
    default = "t2.micro"
}

variable "key_pair"{
    type = string
}

variable sc_for_target {
    type = string
}
