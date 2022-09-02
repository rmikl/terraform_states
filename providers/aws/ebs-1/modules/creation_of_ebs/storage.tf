resource "aws_ebs_volume" "source" {
  availability_zone = var.source_az
  size              = 2
}

resource "aws_volume_attachment" "sorce_attachemnt" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.source.id
  instance_id = aws_instance.base.id
  force_detach = true
}