data "aws_kms_key" "key_enabling_hibernation" {
  key_id = "2dc2d93a-3a5d-4d01-a28a-3e0c65873728"
}

#resource "aws_ebs_encryption_by_default" "default_key" {
#  enabled = true
#}

resource "aws_ebs_volume" "ebs_for_hibernate" {
  availability_zone = var.zone
  size              = 8
  encrypted         = true
  type              = "gp2"
  kms_key_id        = data.aws_kms_key.key_enabling_hibernation.arn
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs_for_hibernate.id
  instance_id = aws_instance.speed.id
}