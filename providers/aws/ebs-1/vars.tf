variable "aws_region" { 
  type = string
  default = "eu-central-1"
}

//variable sg_traffic_to_infra_id {
//  type = number
//  default = module.creation_of_ebs.sg_traffic_to_infra_id
//}

//variable source_ebs_volume_id {
//  type = number
//  default = module.creation_of_ebs.source_ebs_volume_id
//}
//
//variable "pub_key_id" {
//  type = number
//  default = module.creation_of_ebs.pub_key_id
//}