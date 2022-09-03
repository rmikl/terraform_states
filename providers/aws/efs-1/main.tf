terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "mount_ef2_with_two_instances"{
  source = "./modules/mount_ef2_with_two_instances"
}
