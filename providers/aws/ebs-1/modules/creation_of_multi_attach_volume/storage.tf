resource "aws_ebs_snapshot" "snapshot_from_volume" {
  volume_id = var.source_ebs_volume_id
}

resource "aws_ebs_volume" "multi" {
  availability_zone = var.az
  size              = 4
  snapshot_id = aws_ebs_snapshot.snapshot_from_volume.id
  type = "io1"
  iops = 200
  multi_attach_enabled = true
}

resource "aws_volume_attachment" "dest_attachemnt1" {
  device_name = "/dev/sdd"
  volume_id   = aws_ebs_volume.multi.id
  instance_id = aws_instance.ec2_for_multiattach_1.id
  force_detach = true
}

resource "aws_volume_attachment" "dest_attachemnt2" {
  device_name = "/dev/sdd"
  volume_id   = aws_ebs_volume.multi.id
  instance_id = aws_instance.ec2_for_multiattach_1.id
  force_detach = true
}
