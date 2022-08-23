variable zone {
  type        = string
  default     = "eu-central-1a"
  description = "storage region"
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

resource "aws_key_pair" "pub_key_jump" {
  key_name   = "pub_key_jump"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIxAN5kuLqNfJMqMtbbLKJqV2eJgPNi+ai4uQ1BHtrWQsm7y72FyqsWfUk7vKdd0nmC+0GNflVUlJzK2Hp5oYNIhxCme38joNOMAQAzFk22KJZgsVYbtJOERySLLl9LsZQC+dmVjjIMZs8SNmM0Brw0xXExzVRbyyFDLZk5J+g18y1DprzU/S6E4iLoH/S63Bf37oR+pqJz16X4DBG0WVTiCPYj9vT6lq0Ljt6rOzrF+03cvI7mzNmMappi8X49TrwVUuBTTWBgf9k/Sir1SquhQO3vB8k9jASiyeBl0ON+/N3RaJ7C7oTWCRpEhck80ODfPOvmoyONtnpDjegAfVDHCQNeEo/n4Z77zxu4r6JbZXs4/ZjE1Q1ieXpKTQy7ESSbsJUCB6uUVpECyGWoMa/s8QIh8DlRdwtEiyeAZY4ZuWQlnt0eSj7jdTKJTY9rMAvw7yyzxJfT3p34FJ/MUqrnFnojQs9VQbhQyVwvwrp9GCSsssWH9rtNxvtDI5YgiU="
}

