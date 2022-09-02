resource "aws_instance" "target" { 
  ami = var.ec2_ami
  instance_type = var.aws_instance
  key_name = var.key_pair_id
  vpc_security_group_ids = [ var.sg_traffic_to_infra_id ]
  availability_zone = var.dest_az
}

data "aws_instance" "source_instance"{
    instance_id = var.source_instance_id
}

resource "null_resource" "dest_script" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("~/.ssh/id_rsa")}"
    host        = aws_instance.target.public_ip
  }

  provisioner "file" {
      source      = "modules/copying_of_ebs_to_different_az/scripts/mount_ebs_formatted.sh"
      destination = "/home/ec2-user/mount_ebs_formatted.sh"
    }
  provisioner "remote-exec" {
      inline = [
          "chmod +x /home/ec2-user/mount_ebs_formatted.sh",
          "sh /home/ec2-user/mount_ebs_formatted.sh"
      ]
  }
  depends_on = [ aws_volume_attachment.dest_attachemnt ]
}