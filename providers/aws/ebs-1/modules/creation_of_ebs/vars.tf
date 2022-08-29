variable zone {
  type        = string
  default     = "eu-central-1a"
  description = "storage region"
}

variable "aws_instance" {
    type = string
    default = "t2.micro"
}