resource "aws_instance" "example-instance" { 

  //loop over different env names
  count = length(var.env_types) 

  ami = data.aws_ami.latest_ubuntu.id
  instance_type = var.aws_instance
  user_data = file("scripts/sample_script.sh")
  key_name = aws_key_pair.ssh_key.id
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id ]
  tags = {
    prod_type = var.env_types[count.index]
    name = "${var.env_types[count.index]}_${var.instance_name}"
  }
}