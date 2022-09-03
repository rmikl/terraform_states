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

module "creation_of_ec2_instance"{
  source = "./modules/creation_of_ec2_instance"
}

module "creation_of_ami_based_on_ec2_instance"{
  source = "./modules/creation_of_ami_based_on_ec2_instance"
  key_pair = module.creation_of_ec2_instance.key_pair_id
  sc_for_target = module.creation_of_ec2_instance.sc_traffic_to_infra
  root_instance_id = module.creation_of_ec2_instance.instance_id
  depends_on = [ module.creation_of_ec2_instance ]
}