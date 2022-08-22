resource "aws_instance" "jump_host" { 
  ami = var.ec2_ami
  instance_type = var.aws_instance
  user_data = var.input_script_jump_host
  key_name = aws_key_pair.pub_key_jump.id
  vpc_security_group_ids = [ aws_security_group.traffic_to_jump_host.id, aws_security_group.traffic_outbound_full.id ]


connection {
  type        = "ssh"
  user        = "ec2-user"
  private_key = "${file("~/.ssh/id_rsa")}"
  host        = "${self.public_dns}"
}

provisioner "remote-exec" {
    inline = [
        "mkdir -p ~/.ssh"
    ]
}
provisioner "file" {
    source      = "generated_files/id_rsa_local_machine"
    destination = "/home/ec2-user/.ssh/id_rsa"
  }
provisioner "remote-exec" {
    inline = [
        "chmod 600 ~/.ssh/id_rsa"
    ]
}

  tags = {
    module_used = "true"
    terraform_instance = "true"
    name = var.instance_name_jump
  }
  depends_on = [
   local_sensitive_file.local_machine_private_key,
  ]
}

resource "aws_instance" "infra" { 
  ami = var.ec2_ami
  instance_type = var.aws_instance
  user_data = var.input_script_infra
  key_name = aws_key_pair.pub_key_infra.id
  vpc_security_group_ids = [ aws_security_group.traffic_to_infra.id, aws_security_group.traffic_outbound_full.id ]
  iam_instance_profile = "${aws_iam_instance_profile.iam_instance_profile_infra.name}"
  tags = {
    module_used = "true"
    terraform_instance = "true"
    name = var.instance_name_infra
  }
}