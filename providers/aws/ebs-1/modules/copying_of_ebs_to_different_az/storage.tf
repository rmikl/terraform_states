resource "aws_ebs_snapshot" "snapshot_from_volume" {
  volume_id = var.source_ebs_volume_id
  depends_on = [ aws_instance.target ] 
}


data "aws_kms_alias" "kms_key"{
  name = "alias/aws/ebs"
}

resource "aws_ebs_volume" "dest" {
  availability_zone = var.dest_az
  size              = 2
  snapshot_id = aws_ebs_snapshot.snapshot_from_volume.id
  kms_key_id        = data.aws_kms_alias.kms_key.id
  encrypted = true
}

resource "aws_volume_attachment" "dest_attachemnt" {
  device_name = "/dev/sdd"
  volume_id   = aws_ebs_volume.dest.id
  instance_id = aws_instance.target.id
  force_detach = true
}
