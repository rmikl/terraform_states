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

module "creation_of_ebs"{
  source = "./modules/creation_of_ebs"
}

//module "copying_of_ebs_to_different_az"{
//  source = "./modules/copying_of_ebs_to_different_az"
//  sg_traffic_to_infra_id =   module.creation_of_ebs.sg_traffic_to_infra_id
//  source_ebs_volume_id = module.creation_of_ebs.source_ebs_volume_id
//  key_pair_id = module.creation_of_ebs.pub_key_id
//  source_instance_id = module.creation_of_ebs.source_instance_id
//  depends_on = [ module.creation_of_ebs ]
//}

module "creation_of_multi_attach_volume" {
  source = "./modules/creation_of_multi_attach_volume"
  key_pair_id = module.creation_of_ebs.pub_key_id
  depends_on = [ module.creation_of_ebs ]
  sg_traffic_to_infra_id =  module.creation_of_ebs.sg_traffic_to_infra_id
  source_ebs_volume_id = module.creation_of_ebs.source_ebs_volume_id
}