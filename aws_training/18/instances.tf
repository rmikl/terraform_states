resource "aws_instance" "example-instance" {  
  ami = "ami-065deacbcaac64cf2"
  instance_type = aws_instance
  user_data = file("scripts/sample_script.sh")
  tags = {
    name = "instance_runned_by_terraform"
  }
}