resource "aws_instance" "jump_host" { 
  ami = var.ec2_ami
  instance_type = var.aws_instance
  user_data = var.input_script_jump_host
  key_name = aws_key_pair.pub_key_jump.id
  vpc_security_group_ids = [ aws_security_group.traffic_to_jump_host.id ]

provisioner "remote-exec" {
    inline = [
        "mkdir -p /.ssh"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("~/.ssh/id_rsa")}"
      host        = "${self.public_dns}"
    }
  }

provisioner "file" {
    source      = "generated_files/id_rsa_local_machine"
    destination = "~/.ssh/id_rsa"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("~/.ssh/id_rsa")}"
      host        = "${self.public_dns}"
    }
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
  vpc_security_group_ids = [ aws_security_group.traffic_to_infra.id ]
  
  tags = {
    module_used = "true"
    terraform_instance = "true"
    name = var.instance_name_infra
  }
}