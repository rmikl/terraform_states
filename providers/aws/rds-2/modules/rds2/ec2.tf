resource "aws_instance" "my_sql_client" { 
  ami = var.ec2_ami
  instance_type = var.aws_instance
  user_data = file("modules/rds2/scripts/install_mysql_client.sh")
  availability_zone = var.zone
  vpc_security_group_ids = [  aws_security_group.traffic_ec2.id ]
}

