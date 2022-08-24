data "aws_kms_key" "key_enabling_hibernation" {
  key_id = "<YOUR_KMS_KEY_ID>"
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