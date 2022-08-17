resource "aws_instance" "example-instance" {  
  ami = data.aws_ami.latest_ubuntu.id
  instance_type = var.aws_instance
  user_data = file("scripts/sample_script.sh")
  key_name = aws_key_pair.ssh_key.id
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id ]
  tags = {
    name = "instance_runned_by_terraform"
  }
}