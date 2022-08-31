resource "aws_instance" "base" { 
  ami = var.ec2_ami
  instance_type = var.aws_instance
  key_name = aws_key_pair.pub_key_jump.id
  vpc_security_group_ids = [ aws_security_group.traffic_to_infra.id ]
  availability_zone = var.source_az
}

resource "null_resource" "base_script" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("~/.ssh/id_rsa")}"
    host        = aws_instance.base.public_ip
  }

  provisioner "file" {
      source      = "modules/creation_of_ebs/scripts/mount_ebs_non_formatted.sh"
      destination = "/home/ec2-user/mount_ebs_non_formatted.sh"
    }
  provisioner "remote-exec" {
      inline = [
          "chmod +x /home/ec2-user/mount_ebs_non_formatted.sh",
          "sh /home/ec2-user/mount_ebs_non_formatted.sh"
      ]
  }
  depends_on = [ aws_volume_attachment.sorce_attachemnt ]
}