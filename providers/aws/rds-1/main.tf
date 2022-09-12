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

module "rds_implementation"{
  source = "./modules/rds_implementation"
  db_password = var.db_password
  db_username = var.db_username
}
