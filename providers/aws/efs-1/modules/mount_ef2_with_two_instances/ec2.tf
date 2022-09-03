resource "aws_instance" "host1" { 
  ami = var.ec2_ami
  instance_type = var.aws_instance
  key_name = aws_key_pair.pub_key_jump.id
  tags = {
    module_used = "true"
    terraform_instance = "true"
  }
  availability_zone = var.zone
  vpc_security_group_ids = [ aws_security_group.traffic_to_infra.id, aws_security_group.traffic_to_efs.id ]
}

resource "aws_instance" "host2" { 
  ami = var.ec2_ami
  instance_type = var.aws_instance
  key_name = aws_key_pair.pub_key_jump.id
  tags = {
    module_used = "true"
    terraform_instance = "true"
  }
  availability_zone = var.zone
  vpc_security_group_ids = [ aws_security_group.traffic_to_infra.id, aws_security_group.traffic_to_efs.id ]
}

resource "null_resource" "host1_efs_mount" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("~/.ssh/id_rsa")}"
    host        = aws_instance.host1.public_ip
  }
  provisioner "remote-exec" {
      inline = [
          "sudo mkdir -p /mount/efs",
          "sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_mount_target.alpha.ip_address}:/  /mount/efs"]
  }
  depends_on = [ aws_efs_mount_target.alpha ]
}

resource "null_resource" "host2_efs_mount" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("~/.ssh/id_rsa")}"
    host        = aws_instance.host2.public_ip
  }
  provisioner "remote-exec" {
      inline = [
          "sudo mkdir -p /mount/efs",
          "sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_mount_target.alpha.ip_address}:/  /mount/efs"]
  }
  depends_on = [ aws_efs_mount_target.alpha ]
}