output "sg_traffic_to_infra_id" {
  value = aws_security_group.traffic_to_infra.id
}

output "source_ebs_volume_id"{
  value = aws_ebs_volume.source.id
}

output "pub_key_id" { 
  value = aws_key_pair.pub_key_jump.id
}

output "source_instance_id" {
  value = aws_instance.base.id
}